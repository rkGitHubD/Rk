pragma solidity ^0.4.16;
	// Small project number 2 - Remittance 
	
contract Remittance{
	address public owner;// Alice is owner who deploys this Contract
	uint public limit;
	uint public amount;
	bytes32 hashPass = keccak256("ABC" , "123");
	uint public comms;
	address public intermed;
	
	event fundsSent(address from, address to, uint howmuch);
	event fundsReclaimed (address who, uint howmuch);	

	function Remittance()
		payable
		{
			limit = 10;
			owner = msg.sender;
			amount = msg.value;
		}

	function isStillgoing() public constant returns(bool)
		{
		if(block.number <= limit)
			{
				return true;
			} 
		}
	// Carol as an intermediary calls TxFunds after taking pwd from receiver. 
		
	function TxFunds(address receiver,bytes32 recrPass, bytes32 InterPass) 
		public
		payable
		returns (bool success) 
		{
			if(owner != msg.sender) throw;
			if (msg.sender == receiver) throw;
			if (msg.value ==0) throw;
			if (!isStillgoing()) throw;
			intermed = msg.sender;
			bytes32 bothpasswords;
			bothpasswords = keccak256(recrPass, InterPass);
			if (bothpasswords != hashPass) throw;
			amount = msg.value;
			comms = amount/10; 
			intermed.transfer(comms);
			receiver.transfer(amount - comms);
			fundsSent(msg.sender, receiver, amount - comms);
			amount =0;
			return true;
		}
	function reclaimfunds() 
	    public 
	    payable 
	    {
		   if (!isStillgoing()) 
		    {  if (amount > 0)
		     { if(owner == msg.sender)
			    {
				    owner.transfer(amount);
				    fundsReclaimed(msg.sender, amount);
				    amount =0;
			    }
		    }
	       }
	    }
	function killSwitch() public 
	{
		if(owner ==msg.sender) {
		    suicide(owner);
		}
    }
}