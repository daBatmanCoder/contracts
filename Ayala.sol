// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./Providers.sol";

contract Ayala is Ownable {

    mapping(string => string) public IDToSPID; // ID to Service Provider ID ( in the provider's contract ) 

    Providers public providerContractAddress;

    constructor(address payable _providerContractAddress) {
        providerContractAddress = Providers(_providerContractAddress);
    }

    // Need to check if to pass a flag of true or false if it gonna be more/same cost 
    function updateLocation(string memory _identityNumber, string memory _providerId) public{ // maybe here the provider need to update this and not the user?? of the user-provider registeration
        require(checkOwnership(_identityNumber) == msg.sender, "Not a valid owner");

        string memory lowerIdentity = toLowerCase(_identityNumber);
        string memory lowerProvider = toLowerCase(_providerId);

        IDToSPID[lowerIdentity] = toLowerCase(lowerProvider);
    }

    function getUserDomain(string memory _identityNumber) public view returns (string memory) {
        // Need to do the identity Number as lower case
        string memory providerIdentity = IDToSPID[toLowerCase(_identityNumber)];// returns the domain(token URI of the provider in the providers contract)
                        // ID(user (identity)) ==> ID(provider (identity)) ==> ID ( provider ( providers)) ==> Domain (TokenURI in providers)
        
        // If the user calls it
        if (bytes(providerIdentity).length > 42) {
            
            // Then continues the mapping
            string memory providerTokenId = IDToSPID[providerIdentity];
            
            // Now get the token URI using the token ID
            return providerContractAddress.tokenURI(stringToUint(providerTokenId));
        } else {
            // need to think of the default here.
            // It's not a concatenated string, so return the providerIdentity directly
            return providerContractAddress.tokenURI(stringToUint(providerIdentity));
        }
    }

    // Function to check if the msg.sender is the owner of a given NFT
    function checkOwnership(string memory concatenated) public view returns (address) {
        // Split the concatenated string into address and tokenID
        // Assuming the address is always 42 characters (0x + 40 hex characters)
        string memory addressPart = substring(concatenated, 0, 42);
        string memory tokenIdPart = substring(concatenated, 42, bytes(concatenated).length);
        
        // Convert string to address and uint256
        address nftAddress = parseAddr(addressPart);
        uint256 tokenId = stringToUint(tokenIdPart);

        // Fetch the owner of the NFT
        address owner = IERC721(nftAddress).ownerOf(tokenId);
        
        return owner;
    }
    
    // Helper function to convert string to address
    function parseAddr(string memory _a) public pure returns (address _parsedAddress) {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        return address(iaddr);
    }
    
    // Helper function to convert string to uint
    function stringToUint(string memory s) public pure returns (uint256 result) {
        bytes memory b = bytes(s);
        uint256 i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }
    
    // Helper function to get a substring
    function substring(string memory str, uint startIndex, uint endIndex) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function toLowerCase(string memory str) public pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
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

}

// 0x6742cB021F071fD5e151810b669555A00E793cB5 5 test.arnacon.com -- in providers ( 1 )
// 0x6742cB021F071fD5e151810b669555A00E793cB5 1 test2.arnacon.com -- in providers ( 2 )

// Identity - 0x6742cb021f071fd5e151810b669555a00e793cb5
// providers - 0x9e18F3d9Fd99217C165b740Df01Fc7fbaB3fdc74
// shop arnacon - 0xBfE29bD174beb807680937DE075e2532895c007d
// shop arnacon2 (test2) - 0x99b022C2961AD2F1313DC04Eb9E3ac74C29b51EB
// Ayala - 0xB80f7870a8cd2d5FEEd500da6e7CE8c6dB83406A
// AyalaENS - 0x0D6b179816faD168947c8db222271FDBFC59967b
// AyalaShop - 0xaC5bFD750D18386C2170a9ba8d442393a7003A7F


// New Set of contracts - 


// 0x30B9a25E4b88CF8A258CE1910827e3B7957b4ce2 1 test.cellact.nl -- in providers ( 1 )
// 0x30B9a25E4b88CF8A258CE1910827e3B7957b4ce2 2 test2.cellact.nl -- in providers ( 2 )
// 0x30B9a25E4b88CF8A258CE1910827e3B7957b4ce2 19 mvno.cellact.nl -- in providers ( 3 )


// Identity - 0x30B9a25E4b88CF8A258CE1910827e3B7957b4ce2
// providers - 0xcE493e721bab498F38f1Fd75e2055222aD267a10

// shop arnacon (test) - 0x001955387C07FEF0d3F370F69Ae4e0f85F33ad4d
// shop arnacon2 (test2) - 0x3DADa80ac28bf3e592b04Ca3288412642004937A
// shop arnacon3 (mvno) - 0x74110dcD0fD6abAC9E55340f974699Df72F79ED3

// Ayala - 0xd6Ea40D9873859bE522588BE772F6A7bA75EA9c3
// AyalaENS - 0x7C599960a515666C179b798F3F18c3C4f519DABB
// AyalaShop - 0x6e107B5d8592D59af5A0435c1d63eb7B89f86D71