pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../contracts/core/ProvideLiquidity.sol";
import "../contracts/core/PriceCalculator.sol";
import "../contracts/interfaces/IERC20Minimal.sol";
import "../contracts/interfaces/IERC721Minimal.sol";
import "../contracts/interfaces/INonfungiblePositionManager.sol";
import "../contracts/libs/TickUtils.sol";
import "../contracts/libs/TransferHelper.sol";
import "../contracts/libs/SimpleERC20.sol";
import "../contracts/mocks/MockPositionManager.sol";
import "../contracts/mocks/MockUniswapV3pool.sol";

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
 
contract ProvideLiquidityTest is Test {
    MockTokenA public token0;
    MockTokenB public token1;

    PriceCalculator public calculator;
    ProvideLiquidity public provider;

    address public mockPool;
    address public mockManager;

    address public user;

    function setUp() public {
        user = vm.addr(1);

        token0 = new MockTokenA();
        token1 = new MockTokenB();

        mockPool = address(new MockUniswapV3Pool(79228162514264337593543950336, 60, address(token0), address(token1), 3000));
        mockManager = address(new MockPositionManager());

        calculator = new PriceCalculator();
        provider = new ProvideLiquidity(mockManager, address(calculator));

        token0.mint(user, 1_000_1000 ether);
        token1.mint(user, 1_000_1000 ether);

        vm.prank(user);
        token0.approve(address(provider), type(uint256).max);

        vm.prank(user);
        token1.approve(address(provider), type(uint256).max);
    }

        function testPriceRangeCalculation() public {
        uint160 sqrtPriceX96 = 79228162514264337593543950336; // 1.0 가격 (Q96) = 2**96
        uint256 widthBps = 100; 
        
        (uint160 lower, uint160 upper) = calculator.calculatePriceRange(sqrtPriceX96, widthBps);

        assertGt(uint256(upper), uint256(sqrtPriceX96));
        assertLt(uint256(lower), uint256(sqrtPriceX96));

        uint256 width = (uint256(upper) - uint256(lower)) * 10000 / (uint256(upper) + uint256(lower));
        assertApproxEqAbs(width, widthBps, 1);
    }

    function testProvideLiquidity() public {
        uint256 amount0 = 1000 ether;
        uint256 amount1 = 1000 ether;
        uint256 widthBps = 100; // 1%

        vm.prank(user);
        provider.provideLiquidityToPool(address(mockPool) ,amount0, amount1, widthBps);

        uint256 remaining0 = token0.balanceOf(user);
        uint256 remaining1 = token1.balanceOf(user);

        assertLt(remaining0, 1_000_1000 ether);
        assertGt(remaining0, 0);
        assertLt(remaining1, 1_000_1000 ether);
        assertGt(remaining1, 0);
    }

}
