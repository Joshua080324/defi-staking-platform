const hre = require("hardhat");

async function main() {
  const stakingToken = "0x..."; // Ganti dengan alamat ERC20 di testnet
  const rewardToken = "0x...";  // Ganti dengan alamat ERC20 untuk reward

  const Staking = await hre.ethers.getContractFactory("StakingContract");
  const staking = await Staking.deploy(stakingToken, rewardToken);

  await staking.deployed();

  console.log(`StakingContract deployed to: ${staking.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
