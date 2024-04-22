// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

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

        // function createSubscription(bytes32 _commitmentDeposit, bytes32 _productIDHash) external;
    function _createCommitmentToRegisterENS(
        bytes32 _commitmentDeposit
    ) external;

    function _updateNewServiceProvider(
        uint[2] memory      _proof_a, 
        uint[2][2] memory   _proof_b, 
        uint[2] memory      _proof_c, 
        bytes32             _nullifierHash, 
        bytes32             _root, 
        string memory       _userProduct, 
        address             _spAddress
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

// Difference between the public signals

interface IVerifierAyala {

    function verifyProof(
        uint[2] memory      a,
        uint[2][2] memory   b,
        uint[2] memory      c,
        uint[2] memory      input
    ) external pure returns (bool r);

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

}

interface ISubscription{

    function calculateMoneyToBePaid() external returns(uint,uint);
    function advancePaidIndex(uint _newIndex) external;
}