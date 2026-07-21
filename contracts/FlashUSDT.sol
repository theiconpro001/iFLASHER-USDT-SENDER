// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
  @title FlashUSDT
  @dev A mock USDT‑like TRC‑20 token with 6 decimals. Only the contract owner
       (your admin wallet) may mint new tokens.
 /
contract FlashUSDT is TRC20, Ownable {
    // USDT uses six decimal places
    uint8 private constant DECIMALS = 6;

    constructor() ERC20("Flash USDT", "fUSDT") {}

    // Override OpenZeppelin's default (18) to match USDT
    function decimals() public view virtual override returns (uint8) {
        return DECIMALS;
    }

    /
      @notice Mint new tokens to to.
      @dev Only the owner (admin) can call this.
      @param to     Recipient address
      @param amount Amount in raw units (already multiplied by 10⁶)
     /
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
