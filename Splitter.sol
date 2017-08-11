pragma solidity ^0.4.4;

//import "~DAPPS/smallproject/ConvertLib.sol";

// This is a first attempt on small project
// Alice, Bob & Carol - Alice's ether will be split into half between B & C

contract Splitter {
	mapping (address => uint) balances;
	address public	owner;
	address public bob ;
	address public carol ;
	event logSplit(address sender, uint value, uint bob, uint carol);

    function Splitter(address receiver1,address receiver2){
		owner = msg.sender;
		bob= receiver1;
		carol = receiver2;
	}

	function splitEth () payable returns(bool sufficient) {
		 	
		if(owner != msg.sender) return false;
		//if (balances[msg.sender] < msg.value) return false;
		uint split =msg.value/2;
		balances[msg.sender] -= msg.value;
		balances[bob] += split;
		balances[carol] =msg.value - split;
		logSplit(msg.sender,msg.value,balances[bob],balances[carol]);
		return true;
	}

	//function getBalanceInEth(address addr) returns(uint){
	//	return ConvertLib.convert(getBalance(addr),2);
	//}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}
}