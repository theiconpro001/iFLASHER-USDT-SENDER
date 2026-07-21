// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
  @title SimpleVault
  @dev Minimal lock‑and‑release contract that mimics a bridge vault.
       Only the owner (the Relayer contract) may call withdraw.
 /
contract SimpleVault {
    address public owner;

    constructor() {
        owner = msg.sender;               // the deployer becomes the owner (the Relayer)
    }

    /
      @dev Transfer amount of token from this vault to to.
           Caller must be the owner (the Relayer).
     /
    function withdraw(address token, address to, uint256 amount) external {
        require(msg.sender == owner, "SimpleVault: only owner can withdraw");
        IERC20(token).transfer(to, amount);
    }
}
