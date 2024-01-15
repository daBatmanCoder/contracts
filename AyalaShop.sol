// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";


contract AyalaShop is Ownable {

    constructor() {}

    mapping(address => string) public addressToID; // shopAddress ---> ID

    function createShop(address _addressOfShop, string memory _userID) public {

        string memory addressPart = substring(_userID, 0, 42);
        string memory tokenIdPart = substring(_userID, 42, bytes(_userID).length);
        address nftAddress = parseAddr(addressPart);
        uint256 tokenId = stringToUint(tokenIdPart);
        address owner = IERC721(nftAddress).ownerOf(tokenId);

        require(owner == msg.sender, "only the identity owner can  ");

        addressToID[_addressOfShop] = toLowerCase(_userID);
    }

    function substring(string memory str, uint startIndex, uint endIndex) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
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