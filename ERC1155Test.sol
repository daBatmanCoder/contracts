// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.3/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";


contract MyERC1155Token is ERC1155, Ownable {
    constructor() ERC1155("https://myapi.com/api/token/") {}

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function mintToken(address to, uint256 id, uint256 amount, string memory customAttribute) public onlyOwner {
        bytes memory data = abi.encode(customAttribute);
        _mint(to, id, amount, data);
    }

}