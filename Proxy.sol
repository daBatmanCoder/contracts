// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;


// Proxy Contract
contract Proxy {
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function upgrade(address _newImplementation) public {
        // Add authorization checks
        implementation = _newImplementation;
    }

    fallback() external payable {
        address impl = implementation;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    receive() external payable {
        // Custom logic for receiving ether can be put here
        // For now, it's just a plain receive function.
    }
}
