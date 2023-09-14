import { ethers } from "hardhat";

async function main() {
  const subscriptionId = "5261";

  const diceroll = await ethers.deployContract("DiceRoll", [subscriptionId]);

  await diceroll.waitForDeployment();
  const callCooordinator = await ethers.getContractAt(
    "VRFCoordinatorV2Interface",
    "0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625"
  );
  const tx = await callCooordinator.addConsumer(
    subscriptionId,
    diceroll.target
  );
  console.log(await tx.wait());

  console.log(`deployed to ${diceroll.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
