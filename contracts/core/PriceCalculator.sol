// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@uniswap/v3-core/contracts/libraries/FullMath.sol";

contract PriceCalculator {

    function calculatePriceRange(uint160 sqrtPriceX96, uint256 widthBps) external pure returns (uint160 lowerPrice, uint160 upperPrice) {
        require(widthBps < 10000, "widthBps too large");

        uint256 upper = FullMath.mulDiv(sqrtPriceX96, 10000 + widthBps, 10000);
        uint256 lower = FullMath.mulDiv(sqrtPriceX96, 10000 - widthBps, 10000);

        require(upper <= type(uint160).max && lower <= type(uint160).max, "Overflow");
        return (uint160(lower), uint160(upper));
    }
}