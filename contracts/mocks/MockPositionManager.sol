// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "../interfaces/INonfungiblePositionManager.sol";
import "../interfaces/IERC20Minimal.sol";

contract MockPositionManager is INonfungiblePositionManager {
    uint256 public lastTokenId;

    function mint(MintParams calldata params)
        external
        payable
        override
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        )
    {
        lastTokenId += 1;
        tokenId = lastTokenId;
        liquidity = 1000;
        amount0 = params.amount0Desired / 2;
        amount1 = params.amount1Desired / 2;

        return (tokenId, liquidity, amount0, amount1);
    }

}
