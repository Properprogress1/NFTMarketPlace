// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";




contract jaricNFT is ERC721URIStorage, Ownable{
   uint private id;
   constructor() ERC721("jaricNFT", "JRNFT") Ownable(msg.sender) {}

   function mint(address _recipient, string memory _url ) public onlyOwner returns (uint){
    uint _tokenID = id++;

    _mint(_recipient, _tokenID);
    _setTokenURI(_tokenID, _url);
    return _tokenID;
   }
}

