import { ethers, run } from "hardhat";

async function main() {
    // Compile the contract
    await run("compile");

    // Get the contract factory
    const NFTMarketplace = await ethers.getContractFactory("NfTMarketplace");

    // Deploy the contract and wait for it to be mined
    const nftMarketplace = await NFTMarketplace.deploy();
    await nftMarketplace.deployed();

    console.log("NFTMarketplace deployed to:", nftMarketplace.address);
}

main()
    .then(() => process.exit(0))
    .catch((error: Error) => {
        console.error(error);
        process.exit(1);
    });