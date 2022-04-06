async function main() {
  var Web3 = require("web3");
  var web3 = new Web3();
  const provider =
    "wss://rinkeby.infura.io/ws/v3/710b741fe9924cc8a5fa4fa20a89e620";
  web3.setProvider(new web3.providers.WebsocketProvider(provider));

  const nonce = await web3.eth.getTransactionCount(
    "0x88C12420D8c3930b40130f206602605E51EB7A34"
  );

  const transaction = {
    to: "0x1BaB8030249382A887F967FcAa7FE0be7B390728",
    value: 100,
    gas: 30000,
  };

  const signedTx = await web3.eth.accounts.signTransaction(
    transaction,
    "a1efbe9b745a81bcb6a5beab92476169b54b182a7b2b393b9bd262dbca5e3d8a"
  );

  web3.eth.sendSignedTransaction(
    signedTx.rawTransaction,
    function (error, hash) {
      if (!error) {
        console.log(` the hash is : ${hash}`);
      } else {
        console.log(`Something went wrong: ${error}`);
      }
    }
  );
}
main();