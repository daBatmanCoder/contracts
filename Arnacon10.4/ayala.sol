// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./merkleTree.sol";
import "./interfaces.sol";

contract Ayala is MerkleTreeWithHistory{

    mapping(bytes32 =>  bool)       public  nullifiersAyala;
    mapping(bytes32 =>  bool)       public  commitmentsAyala;
    mapping(address =>  bool)       private ApprovedServiceProviders;
    mapping(string =>   address)    private ProductToSP;

    IVerifierAyala public immutable verifierAyala;

    event Commit(
        bytes32 indexed commitment,
        uint32 leafIndex,
        uint256 timestamp
    );

    constructor(
        uint32          _levels,
        IHasher         _hasher,
        IVerifierAyala  _verifier
    ) MerkleTreeWithHistory(_levels, _hasher) {
        verifierAyala = _verifier;
    }

    function _createCommitmentToRegisterENS(
        bytes32 _commitmentDeposit
    ) public {

        require(
            !commitmentsAyala[_commitmentDeposit],
             "The commitment has been submitted"
        );

        commitmentsAyala[_commitmentDeposit] = true;
        
        uint32 insertedIndex = _insert(_commitmentDeposit);

        emit Commit(_commitmentDeposit, insertedIndex, block.number);
    } 

    // How to verify that the user that made the proof is the user of the ens?? ---> maybe such that the nullifierHash -> userProduct concat spAddress - 
    function _updateNewServiceProvider(
        uint[2] memory _proof_a,
        uint[2][2] memory _proof_b,
        uint[2] memory _proof_c,
        bytes32 _nullifierHash,
        bytes32 _root,
        string memory _userProduct, // ens
        address _spAddress
    ) public {

        require(
            !nullifiersAyala[_nullifierHash], 
            "Already used this proof"
        );

        require(
            isKnownRoot(_root),
        "Cannot find your merkle root");

        require(
            verifierAyala.verifyProof(
                _proof_a,
                _proof_b,
                _proof_c,
                [uint256(_nullifierHash), uint256(_root)]
            ),
            "Invalid proof"
        );

        ProductToSP[_userProduct] =  _spAddress;
        nullifiersAyala[_nullifierHash] = true;
    }

    function getProductServiceProvider(
        string memory _userProduct
    ) public view returns (address){
        
        return ProductToSP[_userProduct];
    }

}
