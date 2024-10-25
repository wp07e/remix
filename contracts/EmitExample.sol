// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/core/logger.sol";

/**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script scripts/deploy_with_ethers.ts
   */
contract EmitExample {

    // Storage variable we can query
    uint256 public lastValue;

    // Logger
    FlexibleLogger private logger;
    
    // Function that modifies state - requires transaction
    function setValueAndEmit(uint256 _value) public returns (uint256) {
        lastValue = _value;
        logger.log("value changed:", _value);
        return _value;  // Return value only visible in etherscan
    }
    
    // View function - no transaction needed
    function getValue() public view returns (uint256) {
        return lastValue;  // Value directly visible in Remix
    }
    
    // Pure function - no transaction needed
    function double(uint256 _value) public pure returns (uint256) {
        return _value * 2;  // Value directly visible in Remix
    }
}