//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract ERC20 {
    string public _name;
    string public _symbol;
    uint8 public _decimals = 18;
    
    mapping(address => uint256) private _balances;
    mapping(address=>bool) isBlacklisted;

    uint256 private _totalSupply;
    address private _owner = 0x88C12420D8c3930b40130f206602605E51EB7A34;
    address private _treasury = 0xD9c31e60EA57159D1732Ddd4744e34c291Cdc566;
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(string memory name, string memory symbol, uint8 decimals) {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _balances[_treasury] = 0;
    }

    modifier onlyOwner {
        require(msg.sender == _owner,"Is not owner");
        _;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function blackList(address _user) public onlyOwner {
        require(!isBlacklisted[_user], "user already blacklisted");
        isBlacklisted[_user] = true;
    }
    
    function removeFromBlacklist(address _user) public onlyOwner {
        require(isBlacklisted[_user], "user already whitelisted");
        isBlacklisted[_user] = false;
    }

    function mint(address account, uint256 amount) public onlyOwner{
        require(account != address(0), "mint to the zero address");
        // _totalSupply = _totalSupply.add(amount);
        // _balances[account] = _balances[account].add(amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public onlyOwner{
        require(account != address(0), "burn from the zero address");
        // _balances[account] = _balances[account].sub(amount, "burn amount exceeds balance");
        // _totalSupply = _totalSupply.sub(amount);
        require(_balances[account] >= amount,"burn amount exceeds balance");
        // _balances[account] = _balances[account].sub(amount, "burn amount exceeds balance");
        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function transfer(address recipient, uint256 amount) public {
        require(_balances[msg.sender] >= amount,"transfer amount exceeds balance");
        require(recipient != address(0), "transfer to the zero address");
        require(!isBlacklisted[recipient], "recipient is backlisted");
        require(!isBlacklisted[msg.sender], "sender is backlisted");
        uint256 fee = (amount / 100) * 5;
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount - fee;
        _balances[_treasury] += fee;
        emit Transfer(msg.sender, recipient, amount);
    }

    function greet() public view returns (string memory) {
        return _name;
    }

    function setGreeting(string memory _greeting) public {
        _name = _greeting;
    }
}
