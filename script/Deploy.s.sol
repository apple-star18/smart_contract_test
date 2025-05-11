// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Script.sol";
import "../contracts/core/ProvideLiquidity.sol";
import "../contracts/core/PriceCalculator.sol";
import "../contracts/mocks/MockUniswapV3Pool.sol";
import "../contracts/mocks/MockPositionManager.sol";
import "../contracts/libs/SimpleERC20.sol";

contract MockTokenA is ERC20 {
    constructor() ERC20("TokenA", "TKA") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract MockTokenB is ERC20 {
    constructor() ERC20("TokenB", "TKB") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract DeployScript is Script {
    MockTokenA public token0;
    MockTokenB public token1;
    function run() external {
        // 배포 계정 언락
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));
        vm.startBroadcast();

        // Mock Token 배포
        token0 = new MockTokenA();
        token1 = new MockTokenB();

        // mint 초기 토큰
        token0.mint(deployer, 1_000_000 ether);
        token1.mint(deployer, 1_000_000 ether);

        // Mock Pool, PositionManager, Calculator 배포
        MockUniswapV3Pool pool = new MockUniswapV3Pool(
            79228162514264337593543950336,
            60,
            address(token0),
            address(token1),
            3000
        );
        MockPositionManager manager = new MockPositionManager();
        PriceCalculator calculator = new PriceCalculator();

        // ProvideLiquidity 배포
        ProvideLiquidity provider = new ProvideLiquidity(
            address(pool),
            address(manager),
            address(calculator)
        );

        vm.stopBroadcast();
    }
}
