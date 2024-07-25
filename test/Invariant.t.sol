// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, StdInvariant, console2 } from "forge-std/Test.sol";
import { PoolFactory } from "../src/PoolFactory.sol";
import { TSwapPool } from "../src/TSwapPool.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { TSwapPoolHandler } from "./TSwapPoolHandler.t.sol";

contract Invariant is StdInvariant, Test {
    PoolFactory poolFactory;
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock PoolToken;
    TSwapPoolHandler handler;
    address liquidityProvider = makeAddr("liquidityProvider");
    address swapper = makeAddr("swapper");

    function setUp() public {
        weth = new ERC20Mock();
        PoolToken = new ERC20Mock();
        poolFactory = new PoolFactory(address(weth));
        pool = TSwapPool(poolFactory.createPool(address(PoolToken)));

        weth.mint(liquidityProvider, pool.getMinimumWethDepositAmount());
        PoolToken.mint(liquidityProvider, pool.getMinimumWethDepositAmount());

        weth.approve(address(pool), type(uint256).max);
        PoolToken.approve(address(pool), type(uint256).max);

        handler = new TSwapPoolHandler(weth, PoolToken, liquidityProvider, pool);
    }

    function testBalance() public {
        console2.log("balance of weth", weth.balanceOf(liquidityProvider));
        console2.log("balance of PoolToken", PoolToken.balanceOf(liquidityProvider));
         console2.log("balance of weth", weth.balanceOf(address(pool)));
        console2.log("balance of PoolToken", PoolToken.balanceOf(address(pool)));
    }

     function testDeposit() public {
    
        handler.deposit(1_000_000_000);
        // Add more assertions here if needed to verify the deposit
    }
}
