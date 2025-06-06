// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Script.sol";
import "../contracts/core/ProvideLiquidity.sol";
import "../contracts/core/PriceCalculator.sol";
import "../contracts/mocks/MockUniswapV3Pool.sol";
import "../contracts/mocks/MockPositionManager.sol";
import "../contracts/mocks/MockToken.sol";
import "../contracts/libs/TransferHelper.sol";
import "../contracts/libs/SimpleERC20.sol";

contract DeployAndProvideLiquidity is Script {
    MockTokenA public token0;
    MockTokenB public token1;
    ProvideLiquidity public provider;
    MockUniswapV3Pool public pool;
    MockPositionManager public manager;
    PriceCalculator public calculator;

    address public user;

    function run() external {
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        token0 = new MockTokenA();
        token1 = new MockTokenB();

        token0.mint(deployer, 1_000_000 ether);
        token1.mint(deployer, 1_000_000 ether);

        uint256 balanceA = token0.balanceOf(deployer);
        uint256 balanceB = token1.balanceOf(deployer);

        console.log("Token A Balance: ", balanceA);
        console.log("Token B Balance: ", balanceB);

        pool = new MockUniswapV3Pool(79228162514264337593543950336, 60, address(token0), address(token1), 3000);
        manager = new MockPositionManager();
        calculator = new PriceCalculator();

        provider = new ProvideLiquidity(address(manager), address(calculator));
        user = deployer;

        token0.approve(address(provider), type(uint256).max);
        token1.approve(address(provider), type(uint256).max);

        uint256 amount0 = 500 ether;
        uint256 amount1 = 500 ether;
        uint256 widthBps = 100; // 1%

        provider.provideLiquidityToPool(address(pool), amount0, amount1, widthBps);

        vm.stopBroadcast();
    }
}
