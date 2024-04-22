// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./metadata.sol";
import "./interfaces.sol";
import "./structs.sol";


contract Products {

    mapping(uint256 => singleProduct) public productsList;


    IMetadata MetadataContract;


    constructor(
        IMetadata _metadataContract
    ) {
        MetadataContract = _metadataContract;
    }

    function _addProduct(
        uint256 _productID, 
        uint _setupFee, 
        uint _monthlyFee, 
        string memory _metaData, 
        uint _productType
    ) public payable {

        uint productIndexInMetadata = MetadataContract.safeMint{value: msg.value}(msg.sender, _metaData);
    
        uint256 productIDHash = uint256(keccak256(abi.encode(_productID)));
        singleProduct memory sp = singleProduct(_setupFee, _monthlyFee, productIndexInMetadata, _productType);
        productsList[productIDHash] = sp;
    }


    function _getProductMetaData(
        uint256 _productID
    ) external view returns(string memory){

        uint256 productIDHash = uint256(keccak256(abi.encode(_productID)));

        uint indexInMetadata = productsList[productIDHash].productIndexForMetaData;

        return MetadataContract.tokenURI(indexInMetadata);
    }


    // function _deleteProduct(uint256 _productID) external {
    //     uint256 productIDHash = uint256(keccak256(abi.encode(_productID)));

    //     uint indexInMetadata = productsList[productIDHash].productIndexForMetaData;

    //     MetadataContract._burn(indexInMetadata);
    // }
    
}
