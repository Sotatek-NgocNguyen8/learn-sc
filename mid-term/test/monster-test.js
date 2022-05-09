const { ethers } = require("hardhat");

describe("MonsterToken", function () {
  it("Should create token", async function () {
    const [_, buyer] = await ethers.getSigners()
    const MonsterToken = await ethers.getContractFactory("MonsterToken")
    const monsterToken = await MonsterToken.deploy()
    await monsterToken.deployed()
    await monsterToken.createToken(buyer.address,"https://www.mytokenlocation.com")
  });
});
