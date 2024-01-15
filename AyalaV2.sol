// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./Ayala.sol";

contract  AyalaV2 is abstract Ayala {

    mapping(uint256 => uint256) public IDToVP;

    constructor(){}
    
    function updateVideoProvider(uint256 _identityNumber, uint256 _videoProviderId) public {
        require(msg.sender == identityContractInstance.ownerOf(_identityNumber), "no permission");
        IDToVP[_identityNumber] = _videoProviderId;
    }

    function getVideoProvider(uint256 _identityNumber) public view returns (uint256) {
        return IDToVP[_identityNumber];
    }
}



