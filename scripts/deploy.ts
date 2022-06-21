import { ethers } from "hardhat";

async function main() {
  const Election = await ethers.getContractFactory("Election");
  const election = await Election.deploy("Pemira HMTI", [1, 2]);
  await election.deployed();

  console.log("Election deployed to:", election.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
