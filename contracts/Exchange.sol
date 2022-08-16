//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import	"./Token.sol";

contract Exchange {
	address public feeAccount;
	uint256	public	feePercent;
	mapping(address => mapping(address => uint256)) public tokens;
	mapping(uint256 => _Order) public orders;
	uint256 public ordersCount;

	event Deposit(
		address token, 
		address user, 
		uint256 amount, 
		uint256 balance
	);
	event Withdraw(
		address token, 
		address user, 
		uint256 amount, 
		uint256 balance
	);

	struct _Order { // attributrs of order
		uint256 id; // unique identifier for the order
		address user; // user who made order
		address tokenGet; // Address of tokens they receive
		uint256	amountGet; // amount they receive
		address tokenGive; // Address of tokens they give
		uint256 amountGive; // Address of tokens they give
		uint256 timestamp; // when order was created
	}

	constructor(address _feeAccount, uint256 _feePercent) {
		feeAccount = _feeAccount;
		feePercent = _feePercent;
	}

	// Deposit and Withdraw Tokens

	function depositToken(
		address _token, 
		uint256 _amount
	) public {

		require(Token(_token).transferFrom(msg.sender, address(this), _amount)); // transfer tokens to exchange
		tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount; // update user balance
		emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]); // Emit event
  }

  function withdrawToken(
  	address _token, 
  	uint256 _amount
  ) public {

  	require(tokens[_token][msg.sender] >= _amount); // Ensure user has enough tokens to withdraw
	 	Token(_token).transfer(msg.sender, _amount); // transfer tokens to user
  	tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount; // Update user balance
  	emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]); // Emit event

  }

	function balanceOf(address _token, address _user) // Check Balances
			public
			view
			returns (uint256)
	{

	return tokens[_token][_user];

	}

	// Make and Cancel Orders

	function makeOrder(
		address _tokenGet, 
		uint256 _amountGet,
		address _tokenGive,
		uint256 _amountGive
	) public {

		ordersCount = ordersCount + 1;
	// Token Give (the token they want to spend) - which token and how much?
	// Token Get (the token they want to receive) - which token and how much?
		orders[orderCount] = _Order(
			ordersCount, // id
			msg.sender, // user
			_tokenGet, // token get
			_amountGet, // amount get
			_tokenGive, //token give
			_amountGive, // amound give
			block.timestamp // timestamp
		);
	}
	// Fill Orders
	// Charge Fees
	// Track Fee Account
}
