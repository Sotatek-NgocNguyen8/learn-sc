const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20", function () {
  it("Should return the new greeting once it's changed", async function () {
    const ERC20 = await ethers.getContractFactory("ERC20");
    const erc20 = await ERC20.deploy("Hello, world!", "NG", 18);
    await erc20.deployed();

    expect(await erc20.greet()).to.equal("Hello, world!");

    const setGreetingTx = await erc20.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await erc20.greet()).to.equal("Hola, mundo!");
  });
});
