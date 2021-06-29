# Armory Bet

This is the on-chain coin-flip chaincode for practical test.

Due to blockchain's deterministic characteristic, true random cannot be implemented on chain.
So, Verifiable Random Function (VRF) is applied to create random number for this chaincode.

Unfortunately, VRF is the asset of Chainlink and implemented on-chain. 
Therefore, this chaincode must be deployed to live testnet or mainnet instead of private-local network. [VRF Network config](https://docs.chain.link/docs/vrf-contracts/)

To deploy this chaincode, follows these steps:

## Step to deploy ArmoryBet

[Ref](https://docs.binance.org/smart-chain/developer/deploy/hardhat.html)

### 1. Create `secret.json`
Enter your mnemonic words to this file in the root project dir.

### 2. Install libs
```
npm install
```

### 3. Compile contract

```
npx hardhat compile
```

### 3. Deploy to BSC

```bash
npx hardhat run --network testnet scripts/deploy.js
```

## To test ArmoryBet in Binance Smart Chain Testnet

### 1. Request BNB and LINK from these faucet.

https://linkfaucet.protofire.io/


### 2. Send LINK token to the contract address 

### 3. Invoke contract by 

```bash
npx hardhat run --network testnet scripts/bet.js
```

### 4. Check the event log in the bsc scan

https://testnet.bscscan.com/address/"{CONTRACT_ADDRESS}"#events 

or simply using my contracts

https://testnet.bscscan.com/address/0xE4083e8e2fA38C8C18c5c8854d87266b06b48a2c#events 

The event is in the format.

```solidity
// Event: invoker flip the coin, bet the tail or head (0, 1), then the coin is flipped, and he is winner or loser, proveable by a Chainlink requestId. 
event FlipCoin(address invoker, CoinFace bet, CoinFace result, bool isWin, uint256 prob, bytes32 requestId);
```

