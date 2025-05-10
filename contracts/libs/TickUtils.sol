//SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@uniswap/v3-core/contracts/libraries/TickMath.sol";

library TickUtils {
    //convert sqrtPrice to tick
    function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24) {
        return TickMath.getTickAtSqrtRatio(sqrtPriceX96);
    }

    //convert tick to sqrtPrice
    function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160) {
        return TickMath.getSqrtRatioAtTick(tick);
    }

}