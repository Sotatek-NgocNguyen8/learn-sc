async function main() {
    const MarketplaceV2 = await ethers.getContractFactory("MarketplaceV2")
    let marketplaceV2 = await upgrades.upgradeProxy("0xCE8916E22cb42c706B9642e40A9D45c5bC34b575", MarketplaceV2)
    console.log("Your upgraded proxy is done!", marketplaceV2.address)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
