// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./merkleTree.sol";
import "./interfaces.sol";

contract Ayala {

    // mapping(bytes32 =>  bool)       public  nullifiersAyala;
    // mapping(bytes32 =>  bool)       public  commitmentsAyala;

    mapping(bytes => bool)          private signautres;
    mapping(string =>   address)    private ENSToSP;


    IENS                public immutable ens;

    event Commit(
        bytes32 indexed commitment,
        uint32 leafIndex,
        uint256 timestamp
    );

    event showBytes(bytes data);
    event showSignature(uint8 v, bytes32 r, bytes32 s);
    event showString(string data);
    event showAddress(address data);
    event showBool(bool data); 

    constructor(
        IENS            _ens // Needs to change this to be a resolver contract that will solve anything we give him to
    ) {
        ens = _ens;
    }
    

    function updateUserRegistery(
        bytes   memory _signature, 
        string  memory _messageSigned, 
        string  memory _ENS // ENS
    ) external {

        require(
            !signautres[_signature],
            "Signature already used"
        );

        address userAddress = ens.getAddress(_ENS); 
 
        require(
            verifySignature(userAddress,_messageSigned, _signature),
            "The user didn't give you the permission to change his registry"
        );

        ENSToSP[_ENS] =  msg.sender; // Is the one the user gave that signature to
        signautres[_signature] = true;

    }

    // function _createCommitmentToRegisterENS(
    //     uint256 _commitmentDeposit
    // ) public {
    //     bytes32 commitAsBytes = bytes32(_commitmentDeposit);

    //     require(
    //         !commitmentsAyala[commitAsBytes],
    //          "The commitment has been submitted"
    //     );

    //     commitmentsAyala[commitAsBytes] = true;
        
    //     uint32 insertedIndex = _insert(commitAsBytes);

    //     emit Commit(commitAsBytes, insertedIndex, block.number);
    // } 

    // // How to verify that the user that made the proof is the user of the ens?? ---> maybe such that the nullifierHash -> userProduct concat spAddress - 
    // function _updateNewServiceProvider(
    //     uint[2] memory _proof_a,
    //     uint[2][2] memory _proof_b,
    //     uint[2] memory _proof_c,
    //     uint256 _nullifierHash,
    //     uint256 _root,
    //     bytes memory _signature,
    //     string memory _userProduct, // ens
    //     address _spAddress
    // ) public {

    //     require(
    //         !nullifiersAyala[bytes32(_nullifierHash)], 
    //         "Already used this proof"
    //     );

    //     require(
    //         isKnownRoot(bytes32(_root)),
    //     "Cannot find your merkle root");

    //     address userAddress = ens.getAddress(_userProduct);
    //     string memory nullifierHashAString = uint256ToDecimalString(_nullifierHash);

    //     require(
    //         verifySignature(userAddress,nullifierHashAString, _signature),
    //         "The user didn't give you the permission to change this registry"
    //     );

    //     require(
    //         verifierAyala.verifyProof(
    //             _proof_a,
    //             _proof_b,
    //             _proof_c,
    //             [_nullifierHash, _root]
    //         ),
    //         "Invalid proof"
    //     );

    //     ProductToSP[_userProduct] =  _spAddress;

    //     nullifiersAyala[bytes32(_nullifierHash)] = true;
    // }

    function getENSToServiceProvider(
        string memory _ENS
    ) public view returns (address){

        return ENSToSP[_ENS];
    }
    
    // function uint256ToDecimalString(uint256 value) 
    //     public 
    //     pure 
    //     returns (string memory) 
    // {
    //     // Special case for zero as we need to handle it separately
    //     if (value == 0) {
    //         return "0";
    //     }

    //     // Determine the length of the decimal string representation
    //     uint256 temp = value;
    //     uint256 digits;
    //     while (temp != 0) {
    //         digits++;
    //         temp /= 10;
    //     }

    //     // Allocate enough space to store the string representation
    //     bytes memory buffer = new bytes(digits);
        
    //     // Fill the buffer array from the end to the start
    //     while (value != 0) {
    //         digits -= 1;
    //         buffer[digits] = bytes1(uint8(48 + value % 10));
    //         value /= 10;
    //     }
        
    //     // Convert bytes array to string and return
    //     return string(buffer);
    // }

    function verifySignature(address user, string memory message, bytes memory signature)
        public
        pure
        returns (bool)
    {   
        bytes32 hashedMessage = computeHash(message);
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
        return ecrecover(hashedMessage, v, r, s) == user;
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function computeHash(string memory message)
        public 
        pure 
        returns
        (bytes32)
    {
        
        uint256 length = bytes(message).length;

        bytes memory prefix = "\x19Ethereum Signed Message:\n";
        bytes memory messageLength = uintToString(length);
        return keccak256((abi.encodePacked(prefix, messageLength, message)));
    }


    function uintToString(uint _i) 
        internal 
        pure 
        returns 
        (bytes memory) 
    {

        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }

        return bstr;
    }

}


// 20, 0x3542Cbdd6c0948A0f4f82F2a1ECb33FA4f55f242, 0xFc0dd5bD2e980ae3b4E51E39ce74667fc97ED28e, 0x1BdA40cc2F4967F594238b837C6adA89962C5B88


// ["0x2d54249889e15a161a285774810f004e133ee11a250e1a8391527f46275d0f6f", "0x2f5967a0e01680c42f40127fd50c5ccf865177164a5dcee7a3fc8c3d6589f094"],[["0x0bff60f5de5191c6d10a90d3bb4fa0af25603f722dc8e6f8ff4d82831d005721", "0x2b99bde6dcc3bbc134d73067981e393f930fcaf62a5dbe5931acb75b1f258769"],["0x27bf2c66168385b02dc5ba21718992a61d30f758e9469cbbfb0cfd004a5a8cdb", "0x11dabc5d0fd8fbe024b20bc29fef8b9ff559dbe6b991e75512212c7888762bf8"]],["0x1a00c33bb9775999672b3eaf66baa30062effedcc61429ca2d16547b0bd0afec", "0x2c3a63680ff3754c2e37817a5c4e2e92c4f2fbfbb089a409b9c9fef9061c102b"],["0x1a966822dd4de92c9ceb042e772b0bde97004b6c381f181cf41ae52d6bef5a8e","0x0c4386cb71dbf3909a8d99436d39b128bcd9ddf4ec44d0c8249e8930911a172a"]