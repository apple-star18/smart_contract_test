// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "../libs/SimpleERC20.sol";

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