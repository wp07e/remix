// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

/**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script scripts/deploy_with_ethers.ts
   */
contract ArbitrageBot is FlashLoanSimpleReceiverBase, Ownable {
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    
    // DEX Router addresses
    address private constant UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant SUSHISWAP_ROUTER = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;

    // // Logger
    // // ------------------------------ DEBUGGING ------------------------------------------------
    // // *********************************** This 'logger' code cannot be in a seperate "contract"
    // // Events for different types
    event LogUint(string message, uint256 value);
    // event LogInt(string message, int256 value);
    // event LogAddress(string message, address value);
    event LogBool(string message, bool value);
    // event LogString(string message, string value);
    // event LogBytes(string message, bytes value);
    // event LogBytes32(string message, bytes32 value);
    
    // function log(string memory message, uint256 value) public {
    //     emit LogUint(message, value);
    // }
    
    // function log(string memory message, int256 value) public {
    //     emit LogInt(message, value);
    // }
    
    // function log(string memory message, address value) public {
    //     emit LogAddress(message, value);
    // }
    
    // function log(string memory message, bool value) public {
    //     emit LogBool(message, value);
    // }
    
    // function log(string memory message, string memory value) public {
    //     emit LogString(message, value);
    // }
    
    // function log(string memory message, bytes memory value) public {
    //     emit LogBytes(message, value);
    // }
    
    // function log(string memory message, bytes32 value) public {
    //     emit LogBytes32(message, value);
    // }

    // function log(string memory message) public {
    //     emit LogBytes32(message, "");
    // }
    // // ***********************************
    // // ------------------------------ DEBUGGING ------------------------------------------------

        // Storage variable we can query
    uint256 public lastValue;

    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
        Ownable(msg.sender)
    {
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        emit LogUint("premium: ", premium);

        // Decode parameters
        (address tokenBorrow, address tokenTrade) = abi.decode(params, (address, address));
        
        // Calculate repayment amount
        uint256 amountToRepay = amount + premium;
        
        // Approve spending
        IERC20(asset).approve(UNISWAP_ROUTER, amount);
        IERC20(asset).approve(SUSHISWAP_ROUTER, amount);
        
        // Execute trades
        uint256 uniswapAmount = checkUniswapPrice(tokenBorrow, tokenTrade, amount);
        uint256 sushiswapAmount = checkSushiswapPrice(tokenBorrow, tokenTrade, amount);

        emit LogUint("uniswapAmount: ", uniswapAmount);
        emit LogUint("sushiswapAmount: ", sushiswapAmount);
        
        // Execute arbitrage if profitable
        if (uniswapAmount > sushiswapAmount) {
            // Buy on Sushiswap, sell on Uniswap
            swapExactTokensForTokens(
                SUSHISWAP_ROUTER,
                amount,
                tokenBorrow,
                tokenTrade
            );
            
            swapExactTokensForTokens(
                UNISWAP_ROUTER,
                IERC20(tokenTrade).balanceOf(address(this)),
                tokenTrade,
                tokenBorrow
            );
        } else {
            // Buy on Uniswap, sell on Sushiswap
            swapExactTokensForTokens(
                UNISWAP_ROUTER,
                amount,
                tokenBorrow,
                tokenTrade
            );
            
            swapExactTokensForTokens(
                SUSHISWAP_ROUTER,
                IERC20(tokenTrade).balanceOf(address(this)),
                tokenTrade,
                tokenBorrow
            );
        }
        
        // Approve repayment
        IERC20(asset).approve(address(POOL), amountToRepay);
        
        return true;
    }

    function swapExactTokensForTokens(
        address router,
        uint256 amountIn,
        address tokenIn,
        address tokenOut
    ) private {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        
        IUniswapV2Router02(router).swapExactTokensForTokens(
            amountIn,
            0, // Accept any amount of tokenOut
            path,
            address(this),
            block.timestamp
        );
    }

    /*
        Currently Call With
        _token: 0xdac17f958d2ee523a2206206994597c13d831ec7 (USDC)
        amount: 1000000000000000000 (1 WETH)
        _tradeToken:  0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 (WETH)
    */
    function requestFlashLoan(
        address _token,
        uint256 _amount,
        address _tokenTrade
    ) external onlyOwner{
        bytes memory params = abi.encode(_token, _tokenTrade);
        POOL.flashLoanSimple(
            address(this),
            _token,
            _amount,
            params,
            0
        );
    }

    // Function to withdraw profits
    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        // log("********* withdrawTokens ************");
        // log("Token:", token);
        // log("Amount:", amount);
        IERC20(token).transfer(owner(), amount);
    }
    



    // /**
    //  * @dev Gets the flash loan premium (fee) from Aave for a specific amount
    //  * @param asset The address of the asset being borrowed
    //  * @param amount The amount being borrowed
    //  * @return The total fee amount in wei
    //  */
    function calculateFlashLoanFee(address asset, uint256 amount) public view returns (uint256) {
        // Get the premium percentage from Aave's pool
        uint256 premiumTotal = POOL.FLASHLOAN_PREMIUM_TOTAL();
        
        // Calculate the actual fee amount
        uint256 feeAmount = (amount * premiumTotal) / 10000;
        
        return feeAmount;
    }

    // // Function that modifies state - requires transaction
    // function setValueAndEmit(uint256 _value) public returns (uint256) {
    //     lastValue = _value;
    //     // log("value changed:", _value);
    //     return _value;  // Return value only visible in etherscan
    // }

    function checkUniswapPrice(address tokenIn, address tokenOut, uint256 amount) 
        private view returns (uint256)
    {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        
        uint256[] memory amounts = IUniswapV2Router02(UNISWAP_ROUTER)
            .getAmountsOut(amount, path);
            
        return amounts[1];
    }
    
    function checkSushiswapPrice(address tokenIn, address tokenOut, uint256 amount) 
        private view returns (uint256)
    {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        
        uint256[] memory amounts = IUniswapV2Router02(SUSHISWAP_ROUTER)
            .getAmountsOut(amount, path);
            
        return amounts[1];
    }

    function abs(uint256 x) private pure returns (uint256) {
        return x >= 0 ? x : negate(x);
    }

    function negate(uint256 value) public pure returns (uint256) {
        if (value == 0) {
            return 0;
        }
        int256 negativeValue = int256(value) - int256(type(uint256).max) - 1;
        return uint256(negativeValue) + uint256(type(uint256).max) + 1;
    }

    /*
        Currently Call With
        asset: 0xdac17f958d2ee523a2206206994597c13d831ec7 (USDC)
        amount: 1000000000000000000 (1 WETH)
        dexRouters: ["0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F"]
    */
    function checkArbitrageProfitability(
        address asset,
        uint256 amount,
        address[] calldata dexRouters
    ) external view returns (bool, uint256, uint256, uint256, uint256, uint256) {
        // log("********* checkArbitrageProfitability ************");
        // log("Asset:", asset);
        // log("Amount:", amount);
        // log("Number of DEXes:", dexRouters.length);

        uint256 uniswapAmount = checkUniswapPrice(WETH, asset, amount);
        uint256 sushiswapAmount = checkSushiswapPrice(WETH, asset, amount);
        uint256 difference = abs(uniswapAmount - sushiswapAmount);

        uint256 flashLoanPremium = calculateFlashLoanFee(asset, amount);
        // log("Flash loan premium:", flashLoanPremium);
        // uint256 flashLoanPremium = (amount * 9) / 10000; // 0.09% flash loan fee

        // log("Estimated return:", estimatedReturn);
        // emit LogUint("flashLoanPremium: ", flashLoanPremium);
        // emit LogUint("estimatedReturn: ", estimatedReturn);
        // emit LogBool("Profitable? : ", estimatedReturn > amount + flashLoanPremium);
        return (sushiswapAmount != uniswapAmount, amount, flashLoanPremium, uniswapAmount, sushiswapAmount, difference);
    }
    // function executeFlashLoan(
    //     address asset,
    //     uint256 amount,
    //     address[] calldata dexRouters
    // ) external onlyOwner {
    //     // log("********* executeFlashLoan ************");
    //     // log("Asset:", asset);
    //     // log("Amount:", amount);
    //     // log("Number of DEXes:", dexRouters.length);
    //     bytes memory params = abi.encode(dexRouters);
    //     POOL.flashLoanSimple(address(this), asset, amount, params, 0);
    // }
}