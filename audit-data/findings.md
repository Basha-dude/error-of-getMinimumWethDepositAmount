


## HIGH
### [H-1] `TSwapPool::deposit` is missing deadline check causing transactions to complete even after the deadline

**Description:**  The `deposit` function accepts a deadline parameter,which according to the documentation is "The deadline for the transaction to be completed by
".However, this parameter is never used,As a consequence, operaions that add liquidity to the pool might be executed times,in market conditions where the deposit rate in unfavourable.

**Impact:** Transactions could be sent whem market conditions are unfavourable to deposit, even when adding a deadline parameter.

**Proof of Concept:** The `deadline` parameter is unused.

**Recommended Mitigation:** Consider making the following changes to the function

```diff
      function deposit(
        uint256 wethToDeposit,
        uint256 minimumLiquidityTokensToMint,
        uint256 maximumPoolTokensToDeposit,
        uint64 deadline
    )
        external
        revertIfZero(wethToDeposit)
+       revertIfDeadlinePassed(deadline)
        returns (uint256 liquidityTokensToMint)
       
    {
       
    }
```
### [H-2] Incorrect fee calculation in `TSwapPool::getInputAmountBasedOnOutput` causes protocol to take too many tokens, resulting in lost fee

**Description:** In this `getInputAmountBasedOnOutput` function when calculating the fee, it scales the amount by 10_000 instead of 1_000.

**Impact:** Protocol takes more fee than expected from users. 

**Recommended Mitigation:**

```diff
      function getInputAmountBasedOnOutput(
        uint256 outputAmount,
        uint256 inputReserves,
        uint256 outputReserves
    )
        public
        pure
        revertIfZero(outputAmount)
        revertIfZero(outputReserves)
        returns (uint256 inputAmount)
    {
-        return ((inputReserves * outputAmount) * 10000) / ((outputReserves - outputAmount) * 997);
+        return ((inputReserves * outputAmount) * 1000) / ((outputReserves - outputAmount) * 997);
    }

```

### [H-3] Lack of slippage protection in `TSwapPool::swapExactOutput` causes user to potential to receive way fewer tokens

**Description:** 

**Impact:** 

**Proof of Concept:**

**Recommended Mitigation:**

## LOW
### [L-1] `TSwapPool::LiquidityAdded` event has parameters out of order

**Description:** When `TSwapPool::liquidityAdded` event is emmitted in the `TSwapPool::_addLiquidityMintAndTransfer` function, it logs values in the incorrect order.The `poolTokensToDeposit` value should go in the third parameter position, whereas the `wethDeposit` value should go second.

**Impact:** Event emmission is incorrect, leading to off-chain functions potentially malfunctioning.

**Recommended Mitigation:**
```diff
-           emit LiquidityAdded(msg.sender, poolTokensToDeposit, wethToDeposit);
+          emit LiquidityAdded(msg.sender, wethToDeposit,poolTokensToDeposit);
```

### [L-2] Default value returned by `TSwapPool::swapExactInput` results in incorrected return value give

**Description:** The `swapExactInput` is expectd to the return the actual amount of tokens returned by the caller.

**Impact:** The return values will be always be zero. giving incorrect value the user


## INFORMATIONALS
### [I-1] `PoolFactory::PoolFactory__PoolDoesNotExist` is not used, should be removed

```diff
- error PoolFactory__PoolDoesNotExist(address tokenAddress);
```
### [I-2] Lacking zero address checks
 
 ```diff
   constructor(address wethToken) {
+   if(wethToken == address(0))
         {
            revert();
         }
        i_wethToken = wethToken;
    }

 ```

### [I-3] `PoolFactory::createPool` shoul use `.symbol()` instead of `.nam()`

```diff
+        string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).symbol());

-         string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).name());

```

### [I-4]  Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

<details><summary>4 Found Instances</summary>


- Found in src/PoolFactory.sol [Line: 35](src/PoolFactory.sol#L35)

	```solidity
	    event PoolCreated(address tokenAddress, address poolAddress);
	```

- Found in src/TSwapPool.sol [Line: 43](src/TSwapPool.sol#L43)

	```solidity
	    event LiquidityAdded(address indexed liquidityProvider, uint256 wethDeposited, uint256 poolTokensDeposited);
	```

- Found in src/TSwapPool.sol [Line: 44](src/TSwapPool.sol#L44)

	```solidity
	    event LiquidityRemoved(address indexed liquidityProvider, uint256 wethWithdrawn, uint256 poolTokensWithdrawn);
	```

- Found in src/TSwapPool.sol [Line: 45](src/TSwapPool.sol#L45)

	```solidity
	    event Swap(address indexed swapper, IERC20 tokenIn, uint256 amountTokenIn, IERC20 tokenOut, uint256 amountTokenOut);
	```

</details>