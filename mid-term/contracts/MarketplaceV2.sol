pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    // function allowance(address owner, address spender) external view returns (uint256);
}

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract MarketplaceV2{
  using Counters for Counters.Counter;
  Counters.Counter private orders;
  // uint256 listingPrice = 0.001 ether;
  mapping(uint256 => Order) private idToOrder;

  uint256 fee;
  address treasury;

  struct Order {
    uint256 tokenId;
    address tokenAddress;
    address seller;
    address owner;
    uint256 price;
    bool sold;
  }

  event OrderCreated (
    uint256 indexed tokenId,
    address tokenAddress,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

  function initialize(address _treasury, uint256 _fee) public {
    fee = _fee;
    treasury = _treasury;
  }

  // function updateListingPrice(uint _listingPrice) public {
  // //   require(owner == msg.sender, "Only marketplace owner can update listing price.");
  //   listingPrice = _listingPrice;
  // }

  // function getListingPrice() public view returns (uint256) {
  //   return listingPrice;
  // }

  function getFee() view public returns (uint256){
    return fee;
  }

  function getTreasury() view public returns (address){
    return treasury;
  }

  function ownerOf(address monsterAddress, uint256 tokenId) public view returns(address){
    return IERC721(monsterAddress).ownerOf(tokenId);
  }

  function createOrder(uint256 tokenId,address monsterAddress, address tokenAddress,  uint256 price) public {
    // require(msg.value == listingPrice, "Price must be equal to listing price");
    require(IERC721(monsterAddress).ownerOf(tokenId)  == msg.sender, "Is not owner");
    idToOrder[tokenId] =  Order(
      tokenId,
      tokenAddress,
      msg.sender,
      address(this),
      price,
      false
    );
    IERC721(monsterAddress).transferFrom(msg.sender, address(this), tokenId);
    emit OrderCreated(
      tokenId,
      tokenAddress,
      msg.sender,
      address(this),
      price,
      false
    );
  }

  function matchOrder(uint256 tokenId, address monsterAddress, address tokenAddress) public payable {   
    uint256 price = idToOrder[tokenId].price;
    uint256 buyerProfit = price * (1000 - fee*10) / 1000;
    address seller = idToOrder[tokenId].seller;
    require(msg.value >= (price * (1 + fee) / 100), "Is not enough balance");
    idToOrder[tokenId].owner = payable(msg.sender);
    idToOrder[tokenId].sold = true;
    idToOrder[tokenId].seller = payable(address(0));
    orders.increment();
    IERC721(monsterAddress).transferFrom(msg.sender,address(this), tokenId);
    IERC20(tokenAddress).transferFrom(msg.sender,seller,buyerProfit);
    IERC20(tokenAddress).transferFrom(msg.sender, treasury, price - buyerProfit);
  }
}