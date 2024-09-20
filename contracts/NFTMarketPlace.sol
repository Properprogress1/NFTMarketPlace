// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    mapping(uint256 => uint256) public nftPrices;
    
    uint256 public constant MAX_PRICE = 7000 ether;
    uint256 public listingFee;
    address public feeRecipient;
    bool public paused;

    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
    event ListingFeeUpdated(uint256 newFee);
    event FeeRecipientUpdated(address newRecipient);
    event MarketplacePaused(bool isPaused);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialListingFee,
        address _initialFeeRecipient
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        require(_initialListingFee > 0, "Listing fee must be greater than 0");
        
        require(_initialFeeRecipient != address(0), "Fee recipient cannot be zero address");
        
        listingFee = _initialListingFee;
        feeRecipient = _initialFeeRecipient;
        paused = false;

        emit ListingFeeUpdated(_initialListingFee);
        emit FeeRecipientUpdated(_initialFeeRecipient);
    }

    modifier notPaused() {
        require(!paused, "Marketplace is paused");
        _;
    }

    function mintNFT(address to) public onlyOwner {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(to, newTokenId);
    }

    function listNFTForSale(uint256 tokenId, uint256 price) public payable notPaused {
        require(ownerOf(tokenId) == msg.sender, "Not the owner of the token");
        require(price > 0 && price <= MAX_PRICE, "Price must be within a valid range");
        require(msg.value == listingFee, "Incorrect listing fee");

        nftPrices[tokenId] = price;
        
        payable(feeRecipient).transfer(msg.value);

        emit NFTListed(tokenId, msg.sender, price);
    }

    function buyNFT(uint256 tokenId) public payable nonReentrant notPaused {
        uint256 price = nftPrices[tokenId];
        require(price > 0, "NFT not for sale");
        require(msg.value == price, "wrong price");

        address seller = ownerOf(tokenId);
        
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);

        nftPrices[tokenId] = 0; // Remove from sale

        emit NFTSold(tokenId, seller, msg.sender, price);
    }

    function setListingFee(uint256 _newFee) public onlyOwner {
        require(_newFee > 0, "Listing fee can not be less than 0");
        listingFee = _newFee;
        emit ListingFeeUpdated(_newFee);
    }

    function setFeeRecipient(address _newRecipient) public onlyOwner {
        require(_newRecipient != address(0), "Fee recipient cannot be zero address");
        feeRecipient = _newRecipient;
        emit FeeRecipientUpdated(_newRecipient);
    }

    function togglePause() public onlyOwner {
        paused = !paused;
        emit MarketplacePaused(paused);
    }
}