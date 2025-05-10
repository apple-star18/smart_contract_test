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
        // 단순 mock 로직: 공급된 유동성 일부만 소비했다고 가정
        lastTokenId += 1;
        tokenId = lastTokenId;
        liquidity = 1000;
        amount0 = params.amount0Desired / 2;
        amount1 = params.amount1Desired / 2;

        // 토큰 전송 시뮬레이션: 아무것도 하지 않음 (TransferHelper가 mock 환경에서는 미사용)

        return (tokenId, liquidity, amount0, amount1);
    }

    // 그 외 필요 없는 함수들은 구현 생략 가능
}
