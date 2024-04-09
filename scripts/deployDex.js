const hre = require("hardhat");

async function main() {
    console.log('Deploying contract Dex...')
    const dexContract = await hre.ethers.getContractFactory("Dex");
    const dex = await dexContract.deploy();
    await dex.deployed();
    console.log('Dex deployed to:', dex.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
    }
);