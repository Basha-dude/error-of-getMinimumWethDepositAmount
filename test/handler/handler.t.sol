
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { TSwapPool } from "../../src/TSwapPool.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Handler is Test {
    ERC20Mock i_weth;
    TSwapPool tSwapPool;
    PoolFactory poolFactory;
    ERC20Mock poolToken;
    address user;
    uint256 private constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;

    constructor (PoolFactory _poolFactory, address _user, TSwapPool _tswapPool) {
        tSwapPool = _tswapPool;
        poolFactory = _poolFactory;
        i_weth = ERC20Mock(tSwapPool.getWeth());
        poolToken = ERC20Mock(tSwapPool.getPoolToken());
        user = _user;
    }
 

    function testDeposit(uint256 _wethAmountDepositing) public  {
        int256 startingY = int256(poolToken.balanceOf(address(tSwapPool)));
        int256 startingX = int256(i_weth.balanceOf(address(tSwapPool)));  

       
        
     
        uint256 wethAmountDepositing = bound(_wethAmountDepositing, tSwapPool.getMinimumWethDepositAmount(), type(uint64).max);
        uint256 amountPoolTokensToDepositBasedOnWeth = tSwapPool.getPoolTokensToDepositBasedOnWeth(wethAmountDepositing);
             
    
        i_weth.approve(address(tSwapPool), type(uint256).max);
        poolToken.approve(address(tSwapPool), type(uint256).max);
        tSwapPool.deposit(wethAmountDepositing, 0, amountPoolTokensToDepositBasedOnWeth, uint64(block.timestamp));
        
    }

    function testlogging()  public view {
           console.log("int256(poolToken.balanceOf(address(tSwapPool)))", int256(poolToken.balanceOf(address(tSwapPool))));
        console.log("int256(poolToken.balanceOf(address(tSwapPool)))", int256(i_weth.balanceOf(address(tSwapPool))));
         
                
    }
}




