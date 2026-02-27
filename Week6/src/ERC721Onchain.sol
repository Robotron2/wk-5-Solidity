// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol"; //used for encoding svg to base64
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RobotronNFT is ERC721, Ownable {
    using Strings for uint256;
    uint256 private _tokenIdCounter;
    error TokenNotFound();

    // modifier onlyOwner() override {
    //     require(owner() == msg.sender, "Caller is not the owner");
    //     _;
    // }
    constructor() ERC721("RobotronNFT", "RBNFT") Ownable(msg.sender) {}

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) revert TokenNotFound();
        string memory name = string(abi.encodePacked("RobotronNFT #", tokenId.toString()));
        string memory description = "This is an on-chain NFT";
        string memory image = generateBase64Image();
        string memory json = string(
            abi.encodePacked('{"name":"', name, '",', '"description":"', description, '",', '"image":"', image, '"}')
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }

    function generateBase64Image() internal pure returns (string memory) {
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">' "<defs>"
            '<linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">'
            '<stop offset="0%" stop-color="#12184e"/> <stop offset="60%" stop-color="#b21f1f"/> <stop offset="100%" stop-color="#fdbb2d"/> </linearGradient>'

            '<filter id="premiumGlow" x="-20%" y="-20%" width="140%" height="140%">'
            '  <feGaussianBlur stdDeviation="3" result="blur"/>'
            '  <feComposite in="SourceGraphic" in2="blur" operator="over"/>' "</filter>" "</defs>"
            '<rect width="100%" height="100%" rx="15" ry="15" fill="url(#bgGradient)"/>'
            '<path d="M100 50 L120 70 L100 90 L80 70 Z" fill="#ffcc00" stroke="#fdbb2d" stroke-width="2"/>'
            '<path d="M400 50 L420 70 L400 90 L380 70 Z" fill="#ffcc00" stroke="#fdbb2d" stroke-width="2"/>'
            '<rect x="150" y="50" width="200" height="40" rx="10" ry="10" fill="rgba(255,255,255,0.1)" stroke="#ffffff" stroke-width="1.5"/>'
            '<text x="250" y="77" font-family="Arial, sans-serif" font-size="20" text-anchor="middle" fill="#fdbb2d">Robotron NFT #001</text>'

            '<circle cx="250" cy="150" r="40" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<path d="M230 190 L220 300 L280 300 L270 190" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<path d="M230 200 L180 230 L190 250 L230 220" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<path d="M270 200 L330 180 L335 200 L270 220" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<path d="M230 300 L210 380 L240 380 L250 300" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<path d="M270 300 L290 380 L260 380 L250 300" fill="#000000" stroke="#ffffff" stroke-width="2.5"/>'
            '<circle cx="180" cy="230" r="15" fill="#e60000" stroke="#ffffff" stroke-width="2.5"/>'
            '<circle cx="335" cy="200" r="15" fill="#e60000" stroke="#ffffff" stroke-width="2.5"/>'
            '<text x="250" y="430" font-family="Impact, sans-serif" font-size="44" text-anchor="middle" fill="#ffffff" filter="url(#premiumGlow)">Robotron NFT</text>'

            "</svg>";
        // string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">' "<defs>"
        //     '<linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">'
        //     '<stop offset="0%" stop-color="#1a2a6c"/>' '<stop offset="50%" stop-color="#b21f1f"/>'
        //     '<stop offset="100%" stop-color="#fdbb2d"/>' "</linearGradient>"
        //     '<filter id="glow" x="-20%" y="-20%" width="140%" height="140%">'
        //     '<feGaussianBlur stdDeviation="5" result="blur"/>'
        //     '<feComposite in="SourceGraphic" in2="blur" operator="over"/>' "</filter>" "</defs>"
        //     '<rect width="100%" height="100%" rx="15" ry="15" fill="url(#bgGradient)"/>'
        //     '<circle cx="250" cy="150" r="40" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<path d="M230 190 L220 300 L280 300 L270 190" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<path d="M230 200 L180 230 L190 250 L230 220" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<path d="M270 200 L330 180 L335 200 L270 220" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<path d="M230 300 L210 380 L240 380 L250 300" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<path d="M270 300 L290 380 L260 380 L250 300" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
        //     '<circle cx="180" cy="230" r="15" fill="#ff0000" stroke="#ffffff" stroke-width="2"/>'
        //     '<circle cx="335" cy="200" r="15" fill="#ff0000" stroke="#ffffff" stroke-width="2"/>'
        //     '<text x="250" y="430" font-family="Impact, sans-serif" font-size="40" text-anchor="middle" fill="#ffffff" filter="url(#glow)">Robotron NFT</text>'
        //     '<path d="M100 50 L120 70 L100 90 L80 70 Z" fill="#ffcc00" stroke="#ffffff" stroke-width="1"/>'
        //     '<path d="M400 50 L420 70 L400 90 L380 70 Z" fill="#ffcc00" stroke="#ffffff" stroke-width="1"/>'
        //     '<rect x="150" y="50" width="200" height="40" rx="10" ry="10" fill="rgba(255,255,255,0.2)" stroke="#ffffff" stroke-width="1"/>'
        //     '<text x="250" y="77" font-family="Arial, sans-serif" font-size="20" text-anchor="middle" fill="#ffffff">Robotron NFT #001</text>'
        //     "</svg>";
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
    }

    function mint() public {
        _tokenIdCounter += 1;
        _safeMint(msg.sender, _tokenIdCounter);
    }

    function burn(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }
}
