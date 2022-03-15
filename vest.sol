

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;



abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IUnlockCondition{
  function unlockTokens() external returns(bool);

}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor ()  {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

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
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
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
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
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
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
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
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        // The {SafeMath} overflow check can be skipped here, see the comment at the top
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}


library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

}

contract TokenVesting is  ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter public lockId;

    
    struct TokenLock {
    uint256 lockId;
    address tokenAddress; // The token address
    uint256 sharesDeposited; // the total amount of shares deposited
    uint256 sharesWithdrawn; // amount of shares withdrawn
    uint256 startEmission; // date token emission begins
    uint256 endEmission; // the date the tokens can be withdrawn
    address owner; // the owner who can edit or withdraw the lock
    address condition; // address(0) = no condition, otherwise the condition contract must implement IUnlockCondition
    bool isActive;

  }

  mapping(address =>bool) public isAdmin;
  mapping(address =>bool) public isSuperAdmin;
  mapping(uint256 => TokenLock) public idToLock;
  mapping(uint256 => mapping(address => bool)) public isWithdrawer;
  mapping(uint256 => mapping(address => uint256)) public idToWithdrawableAmount;
  mapping(uint256 => mapping(address => uint256)) public idToClaimedAmount;
  mapping(address => mapping(uint256 => bool)) public isOwner;
  mapping(uint256 => address[]) public idToListOfWithdrawer;
  mapping(uint256 => bool) public isLockActive;
  mapping(address => bool) public isTokenBlacklisted;
  mapping(address => bool) public tokenLocked;
  mapping(address => uint256[]) public tokenToLockIds;
  mapping(address => bool) public tokenWhitelistedFromFee;
  address[] public allTokens;
  address payable treasury;
  uint256 public platformFee;
  uint256 public whiteListFeeAmount;
  address public whitelistFeeTokenAddress;


  event TreasuryWalletUpdated(address payable );
  event PlatformFeeUpdated(uint256 fees);
  event WhitelistFeeAmountUpdated(uint256 amount);
  event WhitelistFeeTokenUpdated(address token);
  event TokenWhitelisted(address token);
  event TokenLocked(address, uint256, uint256, uint256, address);
  event OwnershipTransfer(uint256, address);
  event LockIncremented(uint256, uint256);
  event Withdrawn(uint256, uint256, address);


    constructor(
        address _treasury, uint256 _fee, uint256 whitelistAmount, address whitelistTokenAdd
    )  {
        treasury = payable(_treasury);
         platformFee = _fee;
         whiteListFeeAmount = whitelistAmount;
         whitelistFeeTokenAddress = whitelistTokenAdd;
         isAdmin[msg.sender] = true;
         isSuperAdmin[msg.sender]= true;

      
    }

    function setTreasuryWallet(address _treasury) external{
        require(isAdmin[msg.sender] == true,"Access Denied");
        treasury = payable(_treasury);
        emit TreasuryWalletUpdated(treasury);

    }

    function setPlatformFee(uint256 _fee) external{
        require(isAdmin[msg.sender] == true,"Access Denied");
        platformFee =_fee;
        emit PlatformFeeUpdated(_fee);

    }

    function setWhitelistFeeAmount(uint256 _fee) external{
        require(isAdmin[msg.sender] == true,"Access Denied");
        whiteListFeeAmount =_fee;
        emit WhitelistFeeAmountUpdated(_fee);

    }

    function setwhitelistFeeToken(address token) external{
        require(isAdmin[msg.sender] == true,"Access Denied");
        whitelistFeeTokenAddress =token;
        emit WhitelistFeeTokenUpdated(token);

    }

    function whitelistToken(address token) external nonReentrant{
      require(token!= address(0),"Enter a valid address");
      require(IERC20(whitelistFeeTokenAddress).balanceOf(msg.sender)>whiteListFeeAmount,"Insufficient balance");
      require(IERC20(whitelistFeeTokenAddress).allowance(msg.sender, address(this))> whiteListFeeAmount,"Contract has not been approved");
      IERC20(whitelistFeeTokenAddress).transferFrom(msg.sender, treasury, whiteListFeeAmount);
      tokenWhitelistedFromFee[token] = true;
      emit TokenWhitelisted(token);

    }


    function lockToken(address token, uint256 shares, uint256 startTime, uint256 endTime, address[] memory listOfWithdrawer, 
    uint256[] memory listOfWithdrawableAmount, address conditionContract) external nonReentrant{
        uint256 fee = (platformFee*shares)/100;
        require(isTokenBlacklisted[token]==false,"Token is Blacklisted");
        require(listOfWithdrawer.length == listOfWithdrawableAmount.length,"Invalid input"); 
        if(startTime < block.timestamp){
        if(tokenWhitelistedFromFee[token]==false){
          IERC20(token).transferFrom(msg.sender, treasury, fee);
          IERC20(token).transferFrom(msg.sender, address(this), shares);
        }
        else{
          IERC20(token).transferFrom(msg.sender, address(this), shares);     
            }
        }
        require(endTime> block.timestamp&&startTime< endTime,"Enter a valid timestamp");
        uint256 _lockId = lockId.current();
        idToLock[_lockId].lockId = _lockId;
        idToLock[_lockId].tokenAddress = token;
        idToLock[_lockId].sharesDeposited = shares;
        idToLock[_lockId].sharesWithdrawn =0;
        idToLock[_lockId].startEmission = startTime;
        idToLock[_lockId].endEmission = endTime;
        idToLock[_lockId].owner= msg.sender;
        idToLock[_lockId].condition = conditionContract;
        if(startTime < block.timestamp){
        idToLock[_lockId].isActive=true;
        }
        else{
        idToLock[_lockId].isActive= false;    
        }
        isOwner[msg.sender][_lockId] = true;
        if(tokenLocked[token]==false){
            allTokens.push(token);
        }
        
        tokenToLockIds[token].push(_lockId);
        uint256 totalWithdrawer = listOfWithdrawer.length;
        uint256 totalAmount;
        for(uint256 i=0; i< totalWithdrawer;i++){
            isWithdrawer[_lockId][listOfWithdrawer[i]]=true; 
            idToWithdrawableAmount[_lockId][listOfWithdrawer[i]] = listOfWithdrawableAmount[i];
            totalAmount = totalAmount + listOfWithdrawableAmount[i];
        }
        require(shares == totalAmount,"Amount Mismatch");
        idToListOfWithdrawer[_lockId] = listOfWithdrawer;
        lockId.increment();
        emit TokenLocked(token, _lockId, startTime, endTime, msg.sender);
    }

    function triggerLock(uint256 _lockId) external{
        require(isAdmin[msg.sender]==true,"Access Denied");
        require(idToLock[_lockId].startEmission <= block.timestamp && idToLock[_lockId].isActive == false );
        address token = idToLock[_lockId].tokenAddress;
        uint256 fee = (platformFee*idToLock[_lockId].sharesDeposited)/100;
      if(tokenWhitelistedFromFee[token]==false){
          IERC20(token).transferFrom(idToLock[_lockId].owner, treasury, fee);
          IERC20(token).transferFrom(idToLock[_lockId].owner, address(this), idToLock[_lockId].sharesDeposited);
        }
        else{
          IERC20(token).transferFrom(idToLock[_lockId].owner, address(this), idToLock[_lockId].sharesDeposited);     
        }  

        idToLock[_lockId].isActive=true;
    }

    function triggerUnlock(uint256 _lockId) external{
        require(isAdmin[msg.sender]==true,"Access Denied");
        require(idToLock[_lockId].endEmission <= block.timestamp && idToLock[_lockId].isActive == true );
        address[] memory list = idToListOfWithdrawer[_lockId];
        for(uint256 i=0; i< list.length;i++){
        idToWithdrawableAmount[_lockId][msg.sender] = 0;
        idToClaimedAmount[_lockId][msg.sender]= idToClaimedAmount[_lockId][msg.sender]+amount;
        idToLock[_lockId].sharesWithdrawn = idToLock[_lockId].sharesWithdrawn+amount;
        address token = idToLock[_lockId].tokenAddress;
        IERC20(token).approve(address(this), amount);  
        IERC20(token).transferFrom(address(this), msg.sender, amount);
        //   idToWithdrawableAmount[_lockId][msg.sender]  
        }
    }

    function transferLockOwnership(uint256 _lockId, address newOwner) external nonReentrant{
        require(isOwner[msg.sender][_lockId] == true,"Only lockOwner could call");
        idToLock[_lockId].owner = newOwner;
        isOwner[msg.sender][_lockId] = false;
        isOwner[newOwner][_lockId] = true;
        emit OwnershipTransfer(_lockId, newOwner);
    }

    function incrementLock(uint256 _lockId, uint256 endTime) external nonReentrant{
        require(isOwner[msg.sender][_lockId] == true,"Only lockOwner could call");
        require(idToLock[_lockId].endEmission < endTime,"Enter a valid Input");
        idToLock[_lockId].endEmission = endTime;
        emit LockIncremented(_lockId, endTime);

    }


    
    function withdrawTokens(uint256 _lockId, uint256 amount) external nonReentrant{
        require(idToLock[_lockId].endEmission < block.timestamp,"Unlock period is not over");
        require(isWithdrawer[_lockId][msg.sender]== true, "Not a withdrawer for this lock ID");
        require(amount <= idToWithdrawableAmount[_lockId][msg.sender],"Enter a valid amount" );
        idToWithdrawableAmount[_lockId][msg.sender] = idToWithdrawableAmount[_lockId][msg.sender]-amount;
        idToClaimedAmount[_lockId][msg.sender]= idToClaimedAmount[_lockId][msg.sender]+amount;
        idToLock[_lockId].sharesWithdrawn = idToLock[_lockId].sharesWithdrawn+amount;
        address token = idToLock[_lockId].tokenAddress;
        IERC20(token).approve(address(this), amount);  
        IERC20(token).transferFrom(address(this), msg.sender, amount);
        
        emit Withdrawn(_lockId, amount, msg.sender);

    }

    function editWhitelistTokens(address token, bool isFree) external nonReentrant{
        require(isAdmin[msg.sender] == true, "Only admin can call");
        if(isFree == true){
        tokenWhitelistedFromFee[token] = true;
        }
        else{
            tokenWhitelistedFromFee[token] = false;
        }

    }

    function prematureUnlocking(uint256 _lockId) external nonReentrant{
        require(idToLock[_lockId].owner == msg.sender,"Only owner can call");
        require(idToLock[_lockId].endEmission > block.timestamp,"Unlock period reached");
        bool success = IUnlockCondition(idToLock[_lockId].condition).unlockTokens();
        if( success== true){
        IERC20(idToLock[_lockId].tokenAddress).transfer(msg.sender, idToLock[_lockId].sharesDeposited);
        IERC20(idToLock[_lockId].tokenAddress).transfer(msg.sender, idToLock[_lockId].sharesDeposited);
        }
    }

    function getAllVestedTokens() external view returns(address[] memory Tokens){
        return(allTokens);
    }

    function isOwnerOf(address user) external view returns(uint256[] memory ids){
        uint256 totalLocks = lockId.current();
        uint256 count ;
        for(uint256 i =0; i<totalLocks;i++){
            if(idToLock[i].owner==user){
                count++;
            }
        }
        uint256[] memory userLocks = new uint256[](count);
        uint256 number;
        for(uint256 i =0; i<totalLocks;i++){
            if(idToLock[i].owner==user){
                userLocks[number] = i;
                number++;
            }
        }
        return(userLocks);
    }

    function getAllLocksFromToken(address token) external view returns(uint256[] memory ids){
        uint256 totalLocks = lockId.current();
        uint256 count ;
        for(uint256 i =0; i<totalLocks;i++){
            if(idToLock[i].tokenAddress==token){
                count++;
            }
        }
        uint256[] memory userLocks = new uint256[](count);
        uint256 number;
        for(uint256 i =0; i<totalLocks;i++){
            if(idToLock[i].tokenAddress==token){
                userLocks[number] = i;
                number++;
            }
        }
        return(userLocks);
    }

    function getAllLocksForWithdrawer(address user) external view returns(uint256[] memory ids){
        uint256 totalLocks = lockId.current();
        uint256 count ;
        for(uint256 i =0; i<totalLocks;i++){
            if(isWithdrawer[i][user]==true){
                count++;
            }
        }
        uint256[] memory userLocks = new uint256[](count);
        uint256 number;
        for(uint256 i =0; i<totalLocks;i++){
            if(isWithdrawer[i][user]==true){
                userLocks[number] = i;
                number++;
            }
        }
        return(userLocks);
    }
    
}
