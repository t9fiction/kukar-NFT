//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract DDUnion is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MAX_SUPPLY = 100;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant MAX_PER_MINT = 5;

    string public baseTokenURI;

    // Constructor
    constructor(string memory baseURI) ERC721("DADDU UNION", "DDN") {
        setBaseURI(baseURI);
    }

    // Overwriting _baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    // Setting function to b used in contructor also can be changed baseurl later
    function setBaseURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    // Function to reserver NFT by the owner
    function reserveDDU(uint _reserve) public payable onlyOwner {
        uint256 totalMinted = _tokenIds.current();
        require(totalMinted.add(_reserve) <= MAX_SUPPLY, "Not Enough NFTs available");
        for (uint256 i = 0; i < _reserve; i++) {
            _mint(msg.sender, totalMinted);
            totalMinted = totalMinted++;
            _tokenIds.increment();
            // _mintSingleNFT();
        }
    }

    // Function to mint NFT
    function _mintNFTs(uint256 _count) public payable {
        uint256 totalMinted = _tokenIds.current();
        require(totalMinted.add(_count) <= MAX_SUPPLY, "Not Enough NFTs");
        require(_count > 0 && _count <= 5,"Minted NFTs shud be greater then 0 and less then 5");
        require(msg.value >= PRICE.mul(_count),"Not enough Ether");

        for (uint256 i = 0; i < _count; i++) {
            _mint(msg.sender, totalMinted);
            totalMinted = totalMinted++;
            _tokenIds.increment();
            // _mintSingleNFT();
        }

    }

    // Getting all tokens owned by a particular account
    // If you plan on giving any sort of utility to your NFT holders,
    // you would want to know which NFTs from your collection each user holds.
    function ownerOfTokens(address _tokenOwner) external view returns(uint[] memory) {
        uint _tokenCount = balanceOf(_tokenOwner);
        uint[] memory tokenId = new uint256[](_tokenCount);
        for (uint256 i = 0; i <_tokenCount; i++){
            tokenId[i] = tokenOfOwnerByIndex(_tokenOwner, i);
        }
        return tokenId;
    }

    // Withdrawing ether to wallet of owner
    function withdraw(address payable _to) external payable onlyOwner{
        uint balance = address(this).balance;
        require(balance > 0, "No ethers available");
        // _to.transfer(balance); Became obsolete now after May 2021
        (bool success, ) = (_to).call{value: balance}("");
        require(success, "Transfer failed.");
    }

}
