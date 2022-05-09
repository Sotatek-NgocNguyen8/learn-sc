async function main() {
    const Marketplace = await ethers.getContractFactory("MarketplaceV1")
    console.log("Deploying MarketplaceV1, ProxyAdmin, and then Proxy...")
    const proxy = await upgrades.deployProxy(Marketplace)
    console.log("Proxy of Box deployed to:", proxy.address)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
