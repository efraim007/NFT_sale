// SPDX-License-Identifier: MIT
pragma solidity ^0.4.23;
//pragma solidity ^0.8.0;

//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Basic {
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _tokenId
  );
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 _tokenId
  );
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  function balanceOf(address _owner) public view returns (uint256 _balance);
  function ownerOf(uint256 _tokenId) public view returns (address _owner);
  function exists(uint256 _tokenId) public view returns (bool _exists);

  function approve(address _to, uint256 _tokenId) public;
  function getApproved(uint256 _tokenId)
    public view returns (address _operator);

  function setApprovalForAll(address _operator, bool _approved) public;
  function isApprovedForAll(address _owner, address _operator)
    public view returns (bool);

  function transferFrom(address _from, address _to, uint256 _tokenId) public;
  function safeTransferFrom(address _from, address _to, uint256 _tokenId)
    public;

  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes _data
  )
    public;
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Enumerable is ERC721Basic {
  function totalSupply() public view returns (uint256);
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    public
    view
    returns (uint256 _tokenId);

  function tokenByIndex(uint256 _index) public view returns (uint256);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721Metadata is ERC721Basic {
  function name() public view returns (string _name);
  function symbol() public view returns (string _symbol);
  function tokenURI(uint256 _tokenId) public view returns (string);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
 * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
     function getAuthorAddres(uint256 _tokenId) public view returns (address);
}



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {

  constructor() public payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}



/* a sales contract for CryptoArte non-fungible tokens 
 * corresponding to paintings from the www.cryptoarte.io collection
 */
contract nftSales is Ownable, Pausable, Destructible {

    event Sent(address indexed payee, uint256 amount, uint256 balance);
    event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);

    ERC721 public nftAddress; //minter contract address
    address public devWalletAddress;
    uint256 public currentPrice;
	//ERC20 public HVIContract= ERC20(0xDE619A9E0eEeAA9F8CD39522Ed788234837F3B26);
    
    struct salePrice{
            
            uint nftId;
            uint256 nftPrice;
			address nftOwnerAddress;
        }
        
    salePrice[] public salePrices;

/*
    function approveOtherContract(IERC20 token, address recipient, uint256 _approveValue) public {
        token.approve(recipient, _approveValue);
    }
*/    

    /**
    * @dev Contract Constructor
    * @param _nftAddress address non-fungible token contract 
    * @param _currentPrice initial sales price
    */
    constructor(address _nftAddress, uint256 _currentPrice) public { 
        require(_nftAddress != address(0) && _nftAddress != address(this));
        require(_currentPrice > 0);
        nftAddress = ERC721(_nftAddress);
        currentPrice = _currentPrice; 
    }

    /**
    * @dev Purchase _tokenId
    * @param _tokenId uint256 token ID (painting number)
    * ONLY BNB buy
	*/
    function purchaseToken(uint256 _tokenId) public payable whenNotPaused {
        uint256 realySalePrice;
		require(msg.sender != address(0) && msg.sender != address(this));
        //require(msg.value >= currentPrice);
		//require(msg.value >= getSalePrice(_tokenId);
		
		if(getSalePrice(_tokenId)==0){
			realySalePrice=currentPrice;
		}else{
			realySalePrice=getSalePrice(_tokenId);
		}
			
        if(msg.value >= realySalePrice){
		
			//require(nftAddress.exists(_tokenId));//need to test
			address tokenSeller = nftAddress.ownerOf(_tokenId);//need to test
			nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
			
			// calculate to dev and author fee and reduce from BNB
			uint256 devFee = msg.value / 10; // first adoption 10% fee to dev
		    //uint256 authorFee = salePrice * 0.03; // itt a többi az author-e ezert nincs authfee
			
			//BNB-10% change to HVI on Pancakeswap!!!!!
			
			//HVI (BNB) transfer for seller
			// if the contract can change BNB to HVI On Pancakeswap trasnfer the HVI to author
			address authAddress = nftAddress.getAuthorAddres(_tokenId);
			authAddress.transfer(msg.value-(msg.value/10));
			
			
			//BNB transfer for dev
			devWalletAddress.transfer(devFee);
			
			//remove NFT from salePrice[]
			
			//emit Received(msg.sender, _tokenId, msg.value, address(this).balance);
			
		}
    }
	
	
	/**
	*BUY only HVI tokens
	*
	*/
	function purchaseWithHVI(uint256 _salePrice, uint256 _tokenId) public whenNotPaused {
	
		require(_salePrice > 0, "You need to sell at least some tokens");
        uint256 allowance = IERC20(0xDE619A9E0eEeAA9F8CD39522Ed788234837F3B26).allowance(msg.sender, address(this));
        require(allowance >= _salePrice, "Check the token allowance");
		//transferFrom
		
		IERC20(0xDE619A9E0eEeAA9F8CD39522Ed788234837F3B26).transferFrom(msg.sender,address(this),_salePrice);
		
		//HVI reduce devfee & author fee
		uint256 devFee = _salePrice / 10; // first adoption 10% fee to dev
		//uint256 authorFee = salePrice * 0.03; // itt a többi az author-e ezert nincs authfee
	
		
		// send HVI to seller
		IERC20(0xDE619A9E0eEeAA9F8CD39522Ed788234837F3B26).transferFrom(address(this),msg.sender,_salePrice-(_salePrice/10));
		// send HVI to dev & author (Charity Org)
		IERC20(0xDE619A9E0eEeAA9F8CD39522Ed788234837F3B26).transferFrom(address(this),devWalletAddress,devFee);
		// send NFT to buyer
		address tokenSeller = nftAddress.ownerOf(_tokenId);
		nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
		
		//remove NFT from salePrice[]
		
		
		
		
	}
	
    /**
    * @dev send / withdraw _amount to _payee
    */
    function sendTo(address _payee, uint256 _amount) public onlyOwner {
        require(_payee != address(0) && _payee != address(this));
        require(_amount > 0 && _amount <= address(this).balance);
        _payee.transfer(_amount);
        emit Sent(_payee, _amount, address(this).balance);
    }    

    /**
    * @dev Updates _currentPrice
    * @dev Throws if _currentPrice is zero
	* NOT USING The NFTs has umique price, USE ONLY IF NOT set unique price
    */
    function setCurrentPrice(uint256 _currentPrice) public onlyOwner {
        require(_currentPrice > 0);
        currentPrice = _currentPrice;
    }    
    
    /*
	* IF the NFT owner give approve the NFT sale, need to set the unique price
	
	*/
	function setSalesPrice(uint256 _tokenId, uint256 nftSalePrice) public onlyOwner {
        require(msg.sender != nftAddress.ownerOf(_tokenId), 'YOU NOT the NFT owner');
		salePrices.push(salePrice({nftId: _tokenId,nftPrice:nftSalePrice, nftOwnerAddress:msg.sender}));
		
    }
    
	
	function getSalePrice(uint256 _tokenId) public view returns (uint256) {
            uint maxLength=salePrices.length;
            uint256 returnPrice; 
            
            for (uint i = 0; i < maxLength; i++) {
              salePrice storage salePrice1 = salePrices[i];
              if(salePrice1.nftId==_tokenId)
                returnPrice = salePrice1.nftPrice;
            }
             return returnPrice;
    }
    
    function setDevWallet(address _devWalletAddress) public onlyOwner {
        devWalletAddress =_devWalletAddress;
		
    }
	
    /*
    function delDonateList(address _doanteaddress, uint256 _tokenId) public onlyOwner {
        //donateAddress.remove(_doanteaddress);
        //donateIds.remove(_tokenId);
    }  
    */
    
   
   
   
       //PANCAKESWAP interface
       /*
       interface IUniswapV2Pair {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);
    
        function name() external pure returns (string memory);
        function symbol() external pure returns (string memory);
        function decimals() external pure returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);
    
        function approve(address spender, uint value) external returns (bool);
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);
    
        function DOMAIN_SEPARATOR() external view returns (bytes32);
        function PERMIT_TYPEHASH() external pure returns (bytes32);
        function nonces(address owner) external view returns (uint);
    
        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);
    
        function MINIMUM_LIQUIDITY() external pure returns (uint);
        function factory() external view returns (address);
        function token0() external view returns (address);
        function token1() external view returns (address);
        function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
        function price0CumulativeLast() external view returns (uint);
        function price1CumulativeLast() external view returns (uint);
        function kLast() external view returns (uint);
    
        function mint(address to) external returns (uint liquidity);
        function burn(address to) external returns (uint amount0, uint amount1);
        function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
        function skim(address to) external;
        function sync() external;
    
        function initialize(address, address) external;
    }
    
    // pragma solidity >=0.6.2;
    
    interface IUniswapV2Router01 {
        function factory() external pure returns (address);
        function WETH() external pure returns (address);
    
        function addLiquidity(
            address tokenA,
            address tokenB,
            uint amountADesired,
            uint amountBDesired,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline
        ) external returns (uint amountA, uint amountB, uint liquidity);
        function addLiquidityETH(
            address token,
            uint amountTokenDesired,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
        function removeLiquidity(
            address tokenA,
            address tokenB,
            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline
        ) external returns (uint amountA, uint amountB);
        function removeLiquidityETH(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external returns (uint amountToken, uint amountETH);
        function removeLiquidityWithPermit(
            address tokenA,
            address tokenB,
            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountA, uint amountB);
        function removeLiquidityETHWithPermit(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountToken, uint amountETH);
        function swapExactTokensForTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);
        function swapTokensForExactTokens(
            uint amountOut,
            uint amountInMax,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);
        function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);
        function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
        function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
        function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);
    
        function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
        function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
        function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
        function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
        function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
    }
    
    
    
    // pragma solidity >=0.6.2;
    
    interface IUniswapV2Router02 is IUniswapV2Router01 {
        function removeLiquidityETHSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external returns (uint amountETH);
        function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountETH);
    
        function swapExactTokensForTokensSupportingFeeOnTransferTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external;
        function swapExactETHForTokensSupportingFeeOnTransferTokens(
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external payable;
        function swapExactTokensForETHSupportingFeeOnTransferTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external;
    }*/

}
