// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const { ethers, run, network } = require("hardhat");

async function main() {
  const MultiWalletFactory = await ethers.getContractFactory("MultiWallet");
  const MultiWallet = await MultiWalletFactory.deploy();
  await MultiWallet.deploymentTransaction().wait(6);
  console.log(`Deployed  to : ${MultiWallet.target}`);
  await run("verify:verify", {
    address: MultiWallet.target,
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
