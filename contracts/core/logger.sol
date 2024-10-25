// First file: logger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlexibleLogger {
    // Events for different types
    event LogUint(string message, uint256 value);
    event LogInt(string message, int256 value);
    event LogAddress(string message, address value);
    event LogBool(string message, bool value);
    event LogString(string message, string value);
    event LogBytes(string message, bytes value);
    event LogBytes32(string message, bytes32 value);
    
    function log(string memory message, uint256 value) public {
        emit LogUint(message, value);
    }
    
    function log(string memory message, int256 value) public {
        emit LogInt(message, value);
    }
    
    function log(string memory message, address value) public {
        emit LogAddress(message, value);
    }
    
    function log(string memory message, bool value) public {
        emit LogBool(message, value);
    }
    
    function log(string memory message, string memory value) public {
        emit LogString(message, value);
    }
    
    function log(string memory message, bytes memory value) public {
        emit LogBytes(message, value);
    }
    
    function log(string memory message, bytes32 value) public {
        emit LogBytes32(message, value);
    }

    function log(string memory message) public {
        emit LogBytes32(message, "");
    }
}