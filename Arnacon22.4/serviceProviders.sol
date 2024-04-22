// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts@4.9.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "./interfaces.sol";

contract serviceProviders is ERC721, ERC721URIStorage, ERC721Burnable, Ownable{

    uint256     ValueToSendForData;
    IENS        EnsContract;

    constructor(
        uint256 _valueToSendForData, 
        IENS _ensContract
    ) ERC721("serviceProviders", "SP") {

        ValueToSendForData =    _valueToSendForData;
        EnsContract =           _ensContract;
    }

    event showAddress (
        address showAddresss
    );

    // cellact.web3
    function safeMint(
        string memory _serviceProviderName,
        address _addressOfEns
    ) public payable{ 
        
        // problem with authentication... because from serviceProvider we need to call this function and it needs to be msg.sender.
        require(
            msg.value >= ValueToSendForData,
            "Not enough money was sent"
        );

        // address addressOfEns = EnsContract.getAddress(_serviceProviderName);
        // require(
        //     addressOfEns == msg.sender, 
        //     "Only the ENS owner can set this"
        // );                                                          // Remark here, if the ENS is not ours... what if it is from ethereum?

        string memory userENSNormalize = toLowerCaseNormalize(_serviceProviderName); // Better to hash  <service_provider_name> + .web3
        uint256 tokenId = uint256(keccak256(abi.encodePacked(userENSNormalize)));
        string memory addressAsString = addressToString(msg.sender);
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, addressAsString);
    }

    // The following functions are overrides required by Solidity:
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Function to withdraw the contract balance to the owner's address
    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // changes the amount to be send when registering a new identity
    function changeAmountOfSender(uint _newAmountToChange) public onlyOwner {
        ValueToSendForData = _newAmountToChange;
    }

    function toLowerCaseNormalize(string memory str) internal pure returns (string memory) {

        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);

        for (uint i = 0; i < bStr.length; i++) {

            if (bStr[i] == ".") {
                revert("Invalid name");
            }

            // Uppercase characters are between 65 ('A') and 90 ('Z')
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // Convert uppercase to lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                // Else, keep the character unchanged
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }

    function addressToString(address _addr) public pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory data = abi.encodePacked(_addr);
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}

