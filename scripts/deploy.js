const hre = require("hardhat");

async function main() {
    // We get the contract to deploy
    const ArmoryBet = await hre.ethers.getContractFactory("ArmoryBet");
    const armoryBet = await ArmoryBet.deploy();
  
    console.log("ArmoryBet deployed to:", armoryBet.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
  