// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Election is Ownable {
  string[] public candidates;
  mapping(string => uint) public votes;
  mapping(address => bool) public hasVoted;
  event Vote(string, address);
  bool public isStarted;
  bool public isEnded;
  uint256[] public voterWeight;

  constructor(uint256[] memory weight_) {
    voterWeight = weight_;
  }

  modifier onlyOnce() {
    require(hasVoted[msg.sender] == false, "already vote");
    _;
  }

  function startElection() external onlyOwner {
    isStarted = true;
  }

  function endElection() external onlyOwner {
    isEnded = true;
  }

  function vote(uint256 weight, uint256 id) external onlyOnce {
    require(isStarted == true, "not started");
    require(isEnded == false, "ended");

    votes[candidates[id]] = voterWeight[weight];
    hasVoted[msg.sender] = true;
    emit Vote(candidates[id], msg.sender);
  }

  function getCandidate(uint256 id) external view returns (string memory, uint256) {
    string memory _candidate = candidates[id];
    uint256 _votes = votes[_candidate];

    return (_candidate, _votes);
  } 
}