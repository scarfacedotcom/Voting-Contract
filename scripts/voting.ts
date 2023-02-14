import { ethers } from "hardhat";

async function main() {
    
    const VoteContestContract = await ethers.getContractFactory("voteContest");


const voteContestContract = await VoteContestContract.deploy("SCARFACETOKEN", "SFT", 100);

let DC = await voteContestContract.deployed();
console.log(DC.address)

// let tokenName = await voteContestContract.name();
// console.log(tokenName);

// let tokenSymbol = await voteContestContract.symbol();
// console.log(tokenSymbol);

// let registerContestant = await voteContestContract.registerContestants(["0xe5d4C9798b5352Ce2e83c39D6b5f0059eD5052d2", "0x788bcf8Dc910F436deE33f0ccE5Dddb0eeCE7cB5", "0xE1d627A7fa1176AC7d024e68570c173b249e88Bb"]);
// console.log(registerContestant);

// let votes = await voteContestContract.vote(["0xe5d4C9798b5352Ce2e83c39D6b5f0059eD5052d2", "0x788bcf8Dc910F436deE33f0ccE5Dddb0eeCE7cB5", "0xE1d627A7fa1176AC7d024e68570c173b249e88Bb"]);
// console.log(votes);

// console.log(await voteContestContract.getVoteResults())
// console.log(await voteContestContract.getWinner())
// console.log(await voteContestContract.startVoting())



}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
