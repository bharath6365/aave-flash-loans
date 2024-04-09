const hre = require("hardhat");

async function main() {
    console.log('Deploying contract...')
    const flashLoanContract = await hre.ethers.getContractFactory("FlashLoan");
    const flashLoan = await flashLoanContract.deploy(
        "0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A" // Aave Pool Address provider.
    );
    await flashLoan.deployed();
    console.log('FlashLoan deployed to:', flashLoan.address);
}

main().catch((error) => {

    console.error(error);
    process.exit(1);
    }
);