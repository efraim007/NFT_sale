// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

    import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
    import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

    contract Example is ERC721, Ownable {
        
        using Strings for uint256;
        
        // Optional mapping for token URIs
        mapping (uint256 => string) private _tokenURIs;

        // Base URI
        string private _baseURIextended;
        bool public _allowedMintAll=false;
        
       
         struct author{
            
            uint orgNftId;
            address orgAddress;
        }
        
        author[] public authorLists;


        constructor(string memory _name, string memory _symbol)
            ERC721(_name, _symbol)
        {}
        
        function setBaseURI(string memory baseURI_) external onlyOwner() {
            _baseURIextended = baseURI_;
        }
        
        function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
            require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
            _tokenURIs[tokenId] = _tokenURI;
        }
        
        function _baseURI() internal view virtual override returns (string memory) {
            return _baseURIextended;
        }
        
        function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

            string memory _tokenURI = _tokenURIs[tokenId];
            string memory base = _baseURI();
            
            // If there is no base URI, return the token URI.
            if (bytes(base).length == 0) {
                return _tokenURI;
            }
            // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
            if (bytes(_tokenURI).length > 0) {
                return string(abi.encodePacked(base, _tokenURI));
            }
            // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
            return string(abi.encodePacked(base, tokenId.toString()));
        }
        

        function mint(
            address _to,
            uint256 _tokenId,
            string memory tokenURI_
        ) external onlyOwner() {
            _mint(_to, _tokenId);
            _setTokenURI(_tokenId, tokenURI_);
        }
        
        function mintWithAuthor(
            address _to,
            uint256 _tokenId,
            string memory tokenURI_,
            address authorAddress
        ) external onlyOwner() {
            _mint(_to, _tokenId);
            _setTokenURI(_tokenId, tokenURI_);
             authorLists.push(author({orgNftId: _tokenId,orgAddress:authorAddress}));
            
        }
        
        
        function setPublicMint(bool publicMintSet) external onlyOwner() {
            _allowedMintAll= publicMintSet;
        }
        
        
        function mintWithAuthorPublic(
            
            
            address _to,
            uint256 _tokenId,
            string memory tokenURI_,
            address authorAddress
        ) public {
            require(_allowedMintAll==false, "A public mint is not allowed!");
            _mint(_to, _tokenId);
            _setTokenURI(_tokenId, tokenURI_);
             authorLists.push(author({orgNftId: _tokenId,orgAddress:authorAddress}));
            
        }
        
        
        //function getAuthorAddres(uint256 _tokenId) public {
        function getAuthorAddres(uint256 _tokenId) public view returns (address) {
            uint maxLength=authorLists.length;
            address returnAddres; 
            
            for (uint i = 0; i < maxLength; i++) {
              author storage author1 = authorLists[i];
              if(author1.orgNftId==_tokenId)
                returnAddres = author1.orgAddress;
            }
             return returnAddres;
        }
        
        
        
    }
