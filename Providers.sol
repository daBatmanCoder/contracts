// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.3/utils/Counters.sol";

contract Providers is ERC721, ERC721URIStorage, ERC721Burnable, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 _valueToSendForRegister;
    
    constructor(uint256 _valueForRegisterInNetwork) ERC721("Providers", "PRD") { _valueToSendForRegister = _valueForRegisterInNetwork; }

    function safeMint(address to, string memory _providerDomain) public payable {
        require(msg.value >= _valueToSendForRegister, "Not enough money sent");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId); 
        _setTokenURI(tokenId, _providerDomain);
    }

    // The following functions are overrides required by Solidity.
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

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
    
    // changes the amount to be send when registering as a new provider to the network
    function changeAmountOfSender(uint _newAmountToChange) public onlyOwner {
        _valueToSendForRegister = _newAmountToChange;
    }
}
