// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../interfaces/IMockUniswapV3Pool.sol";

contract MockUniswapV3Pool is IMockUniswapV3Pool {
    uint128 private _liquidity;
    int24 private _tickSpacing;

    uint160 public sqrtPriceX96;
    int24 public tick;
    uint16 public observationIndex;
    uint16 public observationCardinality;
    uint16 public observationCardinalityNext;
    uint8 public feeProtocol;
    bool public unlocked;
    address private _token0;
    address private _token1;
    uint24 private _fee;

    constructor(uint128 liquidity_, int24 tickSpacing_, address token0_, address token1_, uint24 fee_) {
        _liquidity = liquidity_;
        _tickSpacing = tickSpacing_;

        sqrtPriceX96 = 79228162514264337593543950336; // 1.0
        tick = 0;
        observationIndex = 0;
        observationCardinality = 0;
        observationCardinalityNext = 0;
        feeProtocol = 0;
        unlocked = true;

        _token0 = token0_;
        _token1 = token1_;
        _fee = fee_;
    }

    function liquidity() external view override returns (uint128) {
        return _liquidity;
    }

    function tickSpacing() external view override returns (int24) {
        return _tickSpacing;
    } 

    function slot0() external view returns (
        uint160, int24, uint16, uint16, uint16, uint8, bool
    ) {
        return (
            sqrtPriceX96,
            tick,
            observationIndex,
            observationCardinality,
            observationCardinalityNext,
            feeProtocol,
            unlocked
        );
    }

    function token0() external view  returns (address) {
        return _token0;
    }

    function token1() external view  returns (address) {
        return _token1;
    }

    function fee() external view  returns (uint24) {
        return _fee;
    }
}
