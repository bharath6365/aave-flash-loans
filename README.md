This simulates a flash loan using the AAVE Flash loan protocol

## Introduction to the Smart Contracts

FlashLoan Contract: The FlashLoan contract is designed to interact with the Aave lending protocol to execute flash loans. Flash loans allow users to borrow any available amount of assets from the protocol's liquidity pools without putting up collateral, as long as they return the borrowed amount within one transaction block.

Dex Contract: The Dex contract represents a simplified Decentralized Exchange (DEX) that allows users to deposit two specific tokens (USDC and DAI) and execute trades between them. This contract could be part of an arbitrage strategy, where the price difference of DAI and USDC across different exchanges is exploited for profit.

### Functionality

The FlashLoan contract borrows assets (like USDC) and then uses those assets to perform operations—typically, arbitrage.

The borrowed amount must be returned to the liquidity pool by the end of the transaction, with a fee.

The Dex contract simulates a DEX where users can deposit tokens and swap them, aiming to demonstrate how such a system might work in conjunction with flash loans for arbitrage opportunities.

### Technology Stack

Aave: Aave is a decentralized finance protocol that allows people to lend and borrow crypto. We're using Aave's lending pool to borrow assets for the flash loan.
https://docs.aave.com/developers/guides/flash-loans

Solidity: Solidity is an object-oriented programming language for writing smart contracts on various blockchain platforms, most notably Ethereum. Both contracts are written in Solidity.

ERC-20 Tokens (DAI and USDC): Both DAI and USDC are stablecoins that are pegged to the USD and follow the ERC-20 standard, which defines a common list of rules for Ethereum tokens to follow within the larger Ethereum ecosystem.

Hardhat: Hardhat is a development environment to compile, deploy, test, and debug your Ethereum software. It's designed to provide developers with a seamless experience when building smart contracts.

Overview

By using these two smart contracts, we're simulating a common DeFi scenario where a flash loan is used to borrow funds, which are then used to capitalize on arbitrage opportunities before repaying the loan within a single transaction. This operation utilizes the Ethereum blockchain, Aave's lending protocol, the Solidity programming language, and Hardhat as a development and testing framework. The ERC-20 standard allows for the smooth operation of token transfers within this context.

Here is the summary of operations that take place.

![Arbitrage] (https://a.storyblok.com/f/87634/1990x1430/cc095e94f1/flash-loan-sequence.png)

As you can see we have made a net profit of 
10 - 0.05 = 9.95 USDC per transaction.

### Randomness
To simulate randomness while buying/selling assets, we use this function. This generates
a number from 85-100
```
   function getDexARate() internal view returns (uint256) {
        return (uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 16) + 85; 
    }
```

The smart contract is deployed on Sepholia testnet and here are few transactions

https://sepolia.etherscan.io/tx/0xe04cf4ecc5780a1d09150bdd2666c3d061cc5d8c822c9df041ea170282829031
https://sepolia.etherscan.io/tx/0xa4db81ef289ccbbac6280732a8a9657d2b38a56d60f562b9b3d2399591a8fa8c
https://sepolia.etherscan.io/tx/0x8f9707a384b20f751f92adcbfd1ceb1262b98b96f18f57b9bcd04a7d27342540
https://sepolia.etherscan.io/tx/0x14fc6ccdf1147e45bd5436c15a92db4389f9352d48fabee689505c7aaff2aae9
