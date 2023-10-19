// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenTokenGame is ERC20, Ownable {
    mapping(uint256 => uint256) public itemPrices; // Maps item IDs to their prices

    constructor(address initialOwner) Ownable(initialOwner) ERC20("DegenTokenGame", "DGN") {
        _mint(msg.sender, 1000000 * 10 ** uint(decimals())); // Mint initial tokens to the contract deployer (owner)
    }
    // Generate new tokens, only callable by the contract owner
    function generateTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transfer tokens to another address
    function sendTokens(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid address");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, recipient, amount);
    }

    // Exchange tokens for items in the in-game store
    function purchaseItem(uint256 itemId) public {
        require(itemPrices[itemId] > 0, "Invalid item ID"); // Check if the item exists
        uint256 price = itemPrices[itemId];
        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        // Implement logic to deliver the item to the player here.
        // For this example, we'll simply deduct the tokens from the player's balance.
        _burn(msg.sender, price);
    }

    // Add an item with a specific price to the in-game store
    function addItemToStore(uint256 itemId, uint256 price) public onlyOwner {
        itemPrices[itemId] = price;
    }

    // Check token balance of an address
    function checkTokenBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Destroy tokens that are no longer needed
    function destroyTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }
}
