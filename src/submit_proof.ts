import * as ethers from "ethers";
import { CrossChainMessenger, MessageStatus } from "@eth-optimism/sdk";

function asEthereumPrivateKey(key: string): string {
  if (key.startsWith("0x")) {
    return key;
  }
  return "0x" + key;
}

const submit = async () => {
  try {
    const GOERLI_URL = process.env.GOERLI_URL;
    if (!GOERLI_URL) {
      throw new Error("GOERLI_URL not set");
    }

    const OP_GOERLI_URL = process.env.OPG_URL;
    if (!OP_GOERLI_URL) {
      throw new Error("OP_GOERLI_URL not set");
    }

    const privateKey = process.env.PRIVATE_KEY;
    if (!privateKey) {
      throw new Error("PRIVATE_KEY not set");
    }

    const l2TxHash = process.env.L2_TX_HASH;
    if (!l2TxHash) {
      throw new Error("L2_TX_HASH not set");
    }

    const wallet = new ethers.Wallet(asEthereumPrivateKey(privateKey));

    const l1Provider = new ethers.providers.JsonRpcProvider(GOERLI_URL);
    const l1Signer = wallet.connect(l1Provider);
    const l2Provider = new ethers.providers.JsonRpcProvider(OP_GOERLI_URL);

    const crossChainMessenger = new CrossChainMessenger({
      l1ChainId: 5,
      l2ChainId: 420,
      l1SignerOrProvider: l1Signer,
      l2SignerOrProvider: l2Provider,
    });

    var status = await crossChainMessenger.getMessageStatus(l2TxHash);
    if (status === MessageStatus.READY_TO_PROVE) {
      console.log("Submitting proof");
      await crossChainMessenger.proveMessage(l2TxHash);
    }

    status = await crossChainMessenger.getMessageStatus(l2TxHash);
    while (status !== MessageStatus.READY_FOR_RELAY) {
      console.log("Waiting for proof to be ready for relay");
      await new Promise((r) => setTimeout(r, 10000));
      status = await crossChainMessenger.getMessageStatus(l2TxHash);
    }
    console.log("Proof is ready for relay");
    const tx = await crossChainMessenger.finalizeMessage(l2TxHash);
    console.log("tx");
    const receipt = await tx.wait();
    console.log(receipt);
  } catch (error) {
    console.log(error);
    throw new Error("Error submitting proof");
  }
};

submit()
  .then(() => {
    console.log("done");
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
