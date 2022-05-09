const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MarketplaceV1", function () {
  it("Should create and match order in marketplace ", async function () {
    const mintValue = ethers.utils.parseUnits('100', 'ether')
    const auctionPrice = ethers.utils.parseUnits('1', 'ether')
    const [owner, buyer] = await ethers.getSigners()
    const MarketplaceV1 = await ethers.getContractFactory("MarketplaceV1")
    const marketplaceV1 = await MarketplaceV1.deploy()
    await marketplaceV1.deployed()
    
    const MonsterToken = await ethers.getContractFactory("MonsterToken")
    const monsterToken = await MonsterToken.deploy()
    await monsterToken.deployed()
    console.log("buyer : ",buyer.address);
    console.log("owner : ",owner.address);
    await monsterToken.createToken(owner.address,"https://www.mytokenlocation.com")

    const Token = await ethers.getContractFactory("ERC20")
		const token = await Token.deploy("MONSTER","MONX")
		await token.deployed()
    await token._mint(buyer.address, mintValue)
    await marketplaceV1.createOrder(1,monsterToken.address,token.address,auctionPrice)
    await marketplaceV1.matchOrder(1,monsterToken.address,token.address)
  });
});
