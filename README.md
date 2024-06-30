# DegenToken ERC20 Contract

This project implements an ERC20 token named DegenToken (DGN) with additional functionalities like transfer fees, rewards for holding tokens, and in-game item redemption.

## Prerequisites

- Solidity compiler version ^0.8.13
- [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) library

## Contract Overview

The contract is an implementation of the ERC20 standard, inheriting from OpenZeppelin's ERC20 contract. It includes functionalities for minting and burning tokens, transferring tokens with fees, rewarding token holders, and redeeming tokens for in-game items.

### Usage
- Deploy the contract using Remix IDE or your preferred Solidity development environment.
- Once deployed, the contract owner can mint new tokens to any address.
- Token holders can transfer tokens to other addresses with a 3% transfer fee.
- Token holders receive a 2% reward for holding tokens every 30 days.
- Token holders can redeem tokens for in-game items.
- The owner can add or update in-game items.

### Functions
- `constructor(address _treasury)`: Initializes the contract with the token name "DegenToken" and symbol "DGN", and sets the treasury address.
- `mintToken(address to, uint256 amount)`: Mints amount tokens to the to address. Can only be called by the contract owner.
- `redeem(uint256 itemId, uint256 quantity)`: Redeems quantity of the specified item by itemId using tokens.
- `burnToken(uint256 amount)`: Burns amount tokens from the caller's balance.
- `transfer(address recipient, uint256 amount)`: Transfers amount tokens to the recipient, including a 3% transfer fee and rewarding the sender with 2% of their balance if the reward period has elapsed.
- `addItem(string memory name, uint256 cost)`: Adds a new item to the inventory. Can only be called by the contract owner.
- `updateItemCost(uint256 itemId, uint256 newCost)`: Updates the cost of an existing item by itemId. Can only be called by the contract owner.
- `getItemsCount()`: Returns the number of items available in the inventory.

### Lisence 
This project is licensed under the MIT License
