// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Identity.sol";


contract IdentityV2 is Identity {
    uint256 public _valueToSendForRegisterV2;
    
    constructor(uint256 _valueForRegisterInNetwork) Identity(_valueForRegisterInNetwork) {
        _valueToSendForRegisterV2 = _valueForRegisterInNetwork;
    }

    mapping(uint256 => string) public customCharacteristics;

    function setCustomCharacteristics(uint256 tokenId, string memory characteristics) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        customCharacteristics[tokenId] = characteristics;
    }
}