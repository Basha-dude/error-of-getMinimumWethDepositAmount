// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.20;

// import { Test, console2 } from "forge-std/Test.sol";
// import { TSwapPool } from "../../src/TSwapPool.sol";
// import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

// contract TSwapPoolHandler is Test {
//     ERC20Mock weth;
//     ERC20Mock PoolToken;
//     address LiquidiyProvider;
//     TSwapPool pool;
//     int256 startingX;
//     int256 startingY;
//     uint256 ExpectedDeltaY;
//     uint256 ExpectedDeltaX;

//     constructor(ERC20Mock _weth, ERC20Mock _PoolToken, address _liquidityProvider, TSwapPool _tswapPool) {
//         weth = _weth;
//         PoolToken = _PoolToken;
//         LiquidiyProvider = _liquidityProvider;
//         pool = _tswapPool;
//     }

//     function testdeposit(uint256 outputWeth) public {
//         outputWeth = bound(outputWeth, 0, pool.getMinimumWethDepositAmount());
//         vm.startPrank(LiquidiyProvider);
//         pool.deposit(outputWeth, 0, pool.getPoolTokensToDepositBasedOnWeth(outputWeth), uint64(block.timestamp));
//         startingY  = int256(weth.balanceOf(address(pool)));
//          startingX = int256(PoolToken.balanceOf(address(pool)));

//          console2.log("startingY", startingY);
//         console2.log("startingX", startingX);

//          ExpectedDeltaY = outputWeth;
//          ExpectedDeltaX = pool.getPoolTokensToDepositBasedOnWeth(outputWeth);   

//              console2.log("ExpectedDeltaY", ExpectedDeltaY);
//             console2.log("ExpectedDeltaX", ExpectedDeltaX);  


//     }
// }


pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract TSwapPoolHandler is Test {
    ERC20Mock weth;
    ERC20Mock PoolToken;
    address LiquidiyProvider;
    TSwapPool pool;
    int256 startingX;
    int256 startingY;
    uint256 ExpectedDeltaY;
    uint256 ExpectedDeltaX;

    constructor(ERC20Mock _weth, ERC20Mock _PoolToken, address _liquidityProvider, TSwapPool _tswapPool) {
        weth = _weth;
        PoolToken = _PoolToken;
        LiquidiyProvider = _liquidityProvider;
        pool = _tswapPool;
    }

    function deposit(uint256 outputWeth) public {
         uint256 amountPoolTokensToDepositBasedOnWeth = pool.getPoolTokensToDepositBasedOnWeth(outputWeth);
        outputWeth = bound(outputWeth, 0, pool.getMinimumWethDepositAmount());
        vm.startPrank(LiquidiyProvider);
        weth.mint(LiquidiyProvider, outputWeth);
        PoolToken.mint(LiquidiyProvider, amountPoolTokensToDepositBasedOnWeth);

        weth.approve(address(pool), outputWeth);
        PoolToken.approve(address(pool), amountPoolTokensToDepositBasedOnWeth);

        pool.deposit(outputWeth, 0, amountPoolTokensToDepositBasedOnWeth, uint64(block.timestamp));
                vm.stopPrank();

        startingY  = int256(weth.balanceOf(address(pool)));
        startingX = int256(PoolToken.balanceOf(address(pool)));

        console.log("startingY", startingY);
        console.log("startingX", startingX);

        ExpectedDeltaY = outputWeth;
        ExpectedDeltaX = pool.getPoolTokensToDepositBasedOnWeth(outputWeth);   

        console.log("ExpectedDeltaY", ExpectedDeltaY);
        console.log("ExpectedDeltaX", ExpectedDeltaX);  

         console.log("deposit function ended"); // Added for debugging
    }
}
