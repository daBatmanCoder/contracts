// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./structs.sol";

interface IENS {

    function getAddress(
        string memory _ens
    ) external view returns(address); // without the .web3
}

interface IServiceProviders {

    function safeMint(
        string memory _serviceProviderName,
        address addressOfContract
    ) external payable;
}

interface IAyala {

    function updateUserRegistery(
        bytes   memory _signature, 
        string  memory _messageSigned, 
        string  memory _ENS 
    ) external;
}

interface IMetadata {

    function tokenURI(
        uint256 tokenId
    ) external view returns (string memory);

    function safeMint(
        address         _to, 
        string memory   _metadata
    ) external payable returns(uint);

    function _burn(
        uint256 tokenId
    ) external;
}

interface IVerifier {

    function verifyProof(
        uint[2] memory      a,
        uint[2][2] memory   b,
        uint[2] memory      c,
        uint[3] memory      input
    ) external pure returns (bool r);

}

interface IVerifierSignature {

    function verifySignature(
        address         user, 
        string memory   message,
        bytes memory    signature
    ) external pure returns (bool);

}

interface IPalo {

    function directTransfer(
        address recipient, 
        uint256 amount
    ) external;

    function directTransferFContract(
        address recipient, 
        uint256 amount
    ) external;

    function balanceOf(
        address account
    ) external view returns(uint256);

} 

interface ISubscription{

    function calculateMoneyToBePaid() external returns(uint,uint);
    function advancePaidIndex(uint _newIndex) external;
}

interface IProducts {
    function getSingleProduct(uint256 _productID) external view returns(singleProduct memory);
}