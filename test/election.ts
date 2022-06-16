import { expect } from "chai";
import { BigNumber, Contract, ContractFactory, Signer } from "ethers";
import { ethers } from "hardhat";

describe("Election", function () {
  let Election: ContractFactory;
  let election: Contract;
  // eslint-disable-next-line no-unused-vars
  let ea: Signer;
  let voter1: Signer;
  let voter2: Signer;
  let voter3: Signer;

  before(async () => {
    [ea, voter1, voter2, voter3] = await ethers.getSigners();
    Election = await ethers.getContractFactory("Election");
    election = await Election.deploy("Pemira HMTI", [1, 2]);
    await election.deployed();
    await election.addCandidate("dirga");
  });

  it("should start election", async () => {
    await election.startElection();
    expect(await election.isStarted()).to.equal(true);
  });

  it("should vote", async () => {
    await election.connect(voter1).vote(0, 0);
    await election.connect(voter2).vote(1, 0);
    await election.connect(voter3).abstain();
    await expect(election.connect(voter3).vote(0, 0)).to.be.revertedWith(
      "already vote"
    );
  });

  it("should end election", async () => {
    await election.endElection();
    expect(await election.isEnded()).to.equal(true);
    expect(await election.getCandidate(0)).to.be.eql([
      "dirga",
      BigNumber.from(3),
    ]);
    expect(await election.voteCount()).to.equal(2);
    expect(await election.abstainCount()).to.equal(1);
  });
});
