///SPDX_License_Identifier: MIT
pragma solidity ^0.7.6;

import "../interfaces/IERC20Minimal.sol";

library TransferHelper {
    //ERC20 transfer function
    function safeTransfer(IERC20 token, address to, uint256 amount) internal {
        require(token.transfer(to, amount), "Transfer failed");
    }

    //ERC20 transfer approve function
    function safeApprove(IERC20 token, address spender, uint256 amount) internal {
        require(token.approve(spender, amount), "Approve failed");
    }

    //ERC20 token transfer (from -> to)
    function safeTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
        require(token.transferFrom(from, to, amount), "TransferFrom failed");
    }

}