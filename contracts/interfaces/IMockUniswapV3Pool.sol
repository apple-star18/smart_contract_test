// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

interface IMockUniswapV3Pool {
    function liquidity() external view returns (uint128);
    function tickSpacing() external view returns (int24);
}
