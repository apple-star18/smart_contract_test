// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
//import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "../interfaces/INonfungiblePositionManager.sol";
import "./PriceCalculator.sol";
import "../libs/TransferHelper.sol";
import "../libs/TickUtils.sol";

contract ProvideLiquidity {
    INonfungiblePositionManager public positionManager;
    PriceCalculator public priceCalculator;

    constructor(address _positionManager, address _priceCalculator) {
        positionManager = INonfungiblePositionManager(_positionManager);
        priceCalculator = PriceCalculator(_priceCalculator);
    }

    function provideLiquidityToPool(
        address poolAddress,
        uint256 amount0,
        uint256 amount1,
        uint256 widthBps
    ) external {
        // current sqrtPriceX96 query
        IUniswapV3Pool pool = IUniswapV3Pool(poolAddress);

        (uint160 sqrtPriceX96, , , , , , ) = pool.slot0();
        
        // calculate price range
        (uint160 lowerSqrtPrice, uint160 upperSqrtPrice) = priceCalculator.calculatePriceRange(sqrtPriceX96, widthBps);

        // asset transfer
        TransferHelper.safeTransferFrom(IERC20(pool.token0()), msg.sender, address(this), amount0);
        TransferHelper.safeTransferFrom(IERC20(pool.token1()), msg.sender, address(this), amount1);

        // approve Uniswap
        TransferHelper.safeApprove(IERC20(pool.token0()), address(positionManager), amount0);
        TransferHelper.safeApprove(IERC20(pool.token1()), address(positionManager), amount1);

        //convert price to ticks
        int24 lowerTick = TickUtils.getTickAtSqrtRatio(lowerSqrtPrice);
        int24 upperTick = TickUtils.getTickAtSqrtRatio(upperSqrtPrice);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: pool.token0(),
            token1: pool.token1(),
            fee: pool.fee(),
            tickLower: lowerTick,
            tickUpper: upperTick,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: msg.sender,
            deadline: block.timestamp
        });

        (uint256 tokenId, uint256 liquidity, uint256 amount0Used, uint256 amount1Used) = positionManager.mint(params);
    
        // return surplus assets
        if (amount0Used < amount0) {
            TransferHelper.safeTransfer(IERC20(pool.token0()), msg.sender, amount0 - amount0Used);
        }
        if (amount1Used < amount1) {
            TransferHelper.safeTransfer(IERC20(pool.token1()), msg.sender, amount1 - amount1Used);
        }
    }
}
