// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import { TSwapPool } from "../../src/TSwapPool.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";
import {Test,console} from "forge-std/Test.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";




contract Invariant is Test {
ERC20Mock i_weth;
    TSwapPool tSwapPool;
    PoolFactory poolFactory;
    ERC20Mock poolToken;
    address user = makeAddr("user");                  
    uint256 private constant MINIMUM_WETH_LIQUIDITY = 1_000_000_000;
                                                      

    function setUp()  public {
        vm.startPrank(user);
        i_weth = new ERC20Mock();
        poolToken = new ERC20Mock();
        i_weth.mint(user,MINIMUM_WETH_LIQUIDITY);
        poolToken.mint(user,MINIMUM_WETH_LIQUIDITY);
              
        vm.stopPrank();
       poolFactory = new PoolFactory(address(i_weth));
       tSwapPool = TSwapPool(poolFactory.createPool(address(poolToken)));

    }
    
}