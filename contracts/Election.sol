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
  uint256 public voteCount;
  uint256 public abstainCount;
  string public name;

  constructor(string memory name_, uint256[] memory weight_) {
    name = name_;
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

  function addCandidate(string memory id) external onlyOwner {
    candidates.push(id);
  }

  function vote(uint256 voterType, uint256 id) external onlyOnce {
    require(isStarted == true, "not started");
    require(isEnded == false, "ended");

    votes[candidates[id]] += voterWeight[voterType];
    hasVoted[msg.sender] = true;
    voteCount++;
    emit Vote(candidates[id], msg.sender);
  }

  function abstain() external onlyOnce {
    require(isStarted == true, "not started");
    require(isEnded == false, "ended");

    hasVoted[msg.sender] = true;
    abstainCount++;
  }

  function getCandidate(uint256 id) external view returns (string memory, uint256) {
    string memory _candidate = candidates[id];
    uint256 _votes = votes[_candidate];

    return (_candidate, _votes);
  } 
}