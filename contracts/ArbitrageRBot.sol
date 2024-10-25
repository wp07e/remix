// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/**
   * @title ContractName
   * @dev ContractDescription
   * @custom:dev-run-script scripts/deploy_with_web3.ts
   */
contract ArbitrageRBot {
    // Event declarations
    event LogValue(string message, uint256 value);
    event LogAddress(string message, address addr);
    event LogString(string message);
    
    uint256 private storedValue;
    
    constructor() {
        storedValue = 100;
        emit LogValue("Constructor called, initial value:", storedValue);
    }
    
    function setValue(uint256 _newValue) public {
        // Log before the change
        emit LogValue("Old value:", storedValue);
        
        storedValue = _newValue;
        
        // Log after the change
        emit LogValue("New value set to:", storedValue);
    }
    
    function getValue() public view returns(uint256) {
        return storedValue;
    }
    
    // Function that demonstrates different types of logging
    function debugExample(uint256 _input) public {
        // Log the input
        emit LogValue("Input received:", _input);
        
        // Log the sender's address
        emit LogAddress("Function called by:", msg.sender);
        
        // Log a calculation
        uint256 calculated = _input * 2;
        emit LogValue("Calculated value:", calculated);
        
        // Log a string message
        if (calculated > 100) {
            emit LogString("Calculated value is greater than 100");
        } else {
            emit LogString("Calculated value is less than or equal to 100");
        }
    }
}