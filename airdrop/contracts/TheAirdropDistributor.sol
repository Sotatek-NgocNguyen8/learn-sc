// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./MerkelProof.sol";

contract TheAirdropDistributor {

  bytes32 public rootHash = 0x673a79ecaed9ed602a27ce885b1da73cf54e07a9f9980a7af1cf7e8bdd941eac;
  mapping(address => bool) claimMarker;

  event Claimed(address _address);

  constructor() {
  }

  function claim(bytes32[] calldata _path) external {
    require(!claimMarker[msg.sender], 'AirdropDistributor: Drop already claimed.');
    bytes32 hash = keccak256(abi.encodePacked(msg.sender));
    require(MerkleProof.verify(_path, rootHash, hash), 'AirdropDistributor: 400');
    claimMarker[msg.sender] = true;
    // TODO: distribute the airdrop to user
    emit Claimed(msg.sender);
  }
}