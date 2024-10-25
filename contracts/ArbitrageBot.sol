// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
//
import "contracts/core/logger.sol";

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

    // Logger
    FlexibleLogger private logger;

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
        logger.log("********* executeOperation ************");
        logger.log("Asset:", asset);
        logger.log("Amount:", amount);
        logger.log("premium:", premium);
        // Decode parameters
        (address[] memory dexRouters) = abi.decode(params, (address[]));
        logger.log("Number of DEXes:", dexRouters.length);
        
        // Ensure we have approval to spend the borrowed tokens
        IERC20(asset).approve(address(POOL), amount + premium);
        
        // Execute arbitrage logic
        uint256 amountReceived = executeArbitrage(asset, amount, dexRouters);
        
        // Ensure we have enough to repay the flash loan
        require(amountReceived >= amount + premium, "Insufficient funds to repay flash loan");
        
        logger.log("amountReceived:", premium);
        return true;
    }

    function executeArbitrage(
        address asset,
        uint256 amount,
        address[] memory dexRouters
    ) internal returns (uint256) {
        logger.log("********* executeArbitrage ************");
        // Current balance before trades
        uint256 startBalance = IERC20(asset).balanceOf(address(this));
        
        logger.log("StartBalance:", startBalance);
        // Execute trades across DEXes
        for (uint i = 0; i < dexRouters.length - 1; i++) {
            uint256 currentBalance = IERC20(asset).balanceOf(address(this));
            
            // Approve router to spend tokens
            IERC20(asset).approve(dexRouters[i], currentBalance);
            
            // Execute trade
            address[] memory path = new address[](2);
            path[0] = asset;
            path[1] = WETH;
            
            IUniswapV2Router02(dexRouters[i]).swapExactTokensForTokens(
                currentBalance,
                0, // Accept any amount of tokens
                path,
                address(this),
                block.timestamp
            );
        }
        
        // Return final balance
        uint256 finalBalance = IERC20(asset).balanceOf(address(this));
        logger.log("Final Balance:", finalBalance);
        return finalBalance;
    }

    /**
     * @dev Gets the flash loan premium (fee) from Aave for a specific amount
     * @param asset The address of the asset being borrowed
     * @param amount The amount being borrowed
     * @return The total fee amount in wei
     */
    function calculateFlashLoanFee(address asset, uint256 amount) public view returns (uint256) {
        // Get the premium percentage from Aave's pool
        uint256 premiumTotal = POOL.FLASHLOAN_PREMIUM_TOTAL();
        
        // Calculate the actual fee amount
        uint256 feeAmount = (amount * premiumTotal) / 10000;
        
        return feeAmount;
    }

    // Function that modifies state - requires transaction
    function setValueAndEmit(uint256 _value) public returns (uint256) {
        lastValue = _value;
        logger.log("value changed:", _value);
        return _value;  // Return value only visible in etherscan
    }

    function checkArbitrageProfitability(
        address asset,
        uint256 amount,
        address[] calldata dexRouters
    ) external returns (bool, uint256) {
        logger.log("********* checkArbitrageProfitability ************");
        logger.log("Asset:", asset);
        logger.log("Amount:", amount);
        logger.log("Number of DEXes:", dexRouters.length);

        uint256 estimatedReturn = simulateArbitrage(asset, amount, dexRouters);
        uint256 flashLoanPremium = calculateFlashLoanFee(asset, amount);
        logger.log("Flash loan premium:", flashLoanPremium);
        // uint256 flashLoanPremium = (amount * 9) / 10000; // 0.09% flash loan fee

        logger.log("Estimated return:", estimatedReturn);
        
        return (estimatedReturn > amount + flashLoanPremium, estimatedReturn);
    }

    function simulateArbitrage(
        address asset,
        uint256 amount,
        address[] calldata dexRouters
    ) internal returns (uint256) {
        logger.log("********* simulateArbitrage ************");
        logger.log("Asset:", asset);
        logger.log("Amount:", amount);
        logger.log("Number of DEXes:", dexRouters.length);
        uint256 currentAmount = amount;
        
        for (uint i = 0; i < dexRouters.length; i++) {
            address[] memory path = new address[](2);
            path[0] = asset;
            path[1] = WETH;
            
            uint256[] memory amounts = IUniswapV2Router02(dexRouters[i])
                .getAmountsOut(currentAmount, path);
                
            currentAmount = amounts[1];
        }
        logger.log("Current Amount:", currentAmount);
        
        return currentAmount;
    }

    function executeFlashLoan(
        address asset,
        uint256 amount,
        address[] calldata dexRouters
    ) external onlyOwner {
        logger.log("********* executeFlashLoan ************");
        logger.log("Asset:", asset);
        logger.log("Amount:", amount);
        logger.log("Number of DEXes:", dexRouters.length);
        bytes memory params = abi.encode(dexRouters);
        POOL.flashLoanSimple(address(this), asset, amount, params, 0);
    }

    // Function to withdraw profits
    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        logger.log("********* withdrawTokens ************");
        logger.log("Token:", token);
        logger.log("Amount:", amount);
        IERC20(token).transfer(owner(), amount);
    }
}