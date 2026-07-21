// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/access/Ownable.sol";

/--------------------------------------------------------------
   Interfaces
--------------------------------------------------------------/
interface IVault {
    function withdraw(address token, address to, uint256 amount) external;
}

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

/--------------------------------------------------------------
   Relayer – pays gas for users and splits a 50 % fee
--------------------------------------------------------------/
contract Relayer is Ownable {
    IVault public vault;          // SimpleVault instance
    address public token;         // FlashUSDT token address
    address public feeWallet;     // address that receives the fee portion
    uint256 public constant FEEPERCENT = 50; // fixed 50 %

    /*
      @param vault      address of the SimpleVault contract
      @param token      address of the FlashUSDT token
      @param feeWallet  address that will receive half of the fee
     /
    constructor(address vault, address token, address feeWallet) {
        vault = IVault(vault);
        token = token;
        feeWallet = feeWallet;
    }

    /
      @notice Users call this to "bridge" their fUSDT.
      @dev   1️⃣ Pull tokens from caller
            2️⃣ Compute 50 % fee and split it 50/50
               – half goes to feeWallet
               – half stays in this contract as a gas reserve
            3️⃣ Approve the vault and forward the net amount (the other 50 %)
     /
    function bridge(address to, uint256 amount) external {
        // 1️⃣ Pull tokens from the user
        require(IERC20(token).allowance(msg.sender, address(this)) >= amount,
                "Relayer: allowance too low");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount),
                "Relayer: transferFrom failed");

        // 2️⃣ Compute and split the fee
        uint256 fee = (amount  FEE_PERCENT) / 100; // 50 % of total
        uint256 halfFee = fee / 2;                 // 25 % each side
        uint256 netAmount = amount - fee;          // 50 % that reaches the receiver

        // 3️⃣ Send first half of the fee to the fee wallet
        require(IERC20(token).transfer(feeWallet, halfFee), "Relayer: fee transfer failed");
        // second half stays in this contract as gas reserve

        // 4️⃣ Approve the vault and release the net amount
        require(IERC20(token).approve(address(vault), netAmount), "Relayer: approve failed");
        vault.withdraw(token, to, netAmount);
    }

    // ----------------------------------------------------------------
    // Admin helpers
    // ----------------------------------------------------------------
    receive() external payable {} // gas pool
    function setFeeWallet(address newWallet) external onlyOwner { feeWallet = newWallet; }
    function withdrawGas(uint256 amount) external onlyOwner { payable(owner()).transfer(amount); }
}
