require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
module.exports = {
  defaultNetwork: "rinkeby",
  networks: {
    hardhat: {},
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/d74013b41a8f456ca1bcdbdc548be079",
      accounts: [
        "a1efbe9b745a81bcb6a5beab92476169b54b182a7b2b393b9bd262dbca5e3d8a",
      ],
      gas: 2100000,
      gasPrice: 8000000000,
      saveDeployments: true,
    },
  },
  solidity: {
    version: "0.8.0",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 40000,
  },
};
