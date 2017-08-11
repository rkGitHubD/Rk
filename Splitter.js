var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {
  
  it("should split ether between bob and carol correctly", function() {
    var split;
    var alice = accounts[0];
    var bob = accounts[1];
    var carol = accounts[2];
    //var amount = web3.toWei(4, "ether");

    var bob_starting_balance;
    var carol_starting_balance;
    var bob_ending_balance;
    var carol_ending_balance;

    return Splitter.deployed().then(function(instance) {
      split = instance;
      return split.getBalance.call(bob);
    }).then(function(balance) {
      bob_starting_balance = balance.toNumber();
      return split.getBalance.call(carol);
    }).then(function(balance) {
      carol_starting_balance = balance.toNumber();
      return split.splitEth.call();
    }).then(function() {
      return split.getBalance.call(bob);
    }).then(function(balance) {
      bob_ending_balance = balance.toNumber();
      return split.getBalance.call(carol);
    }).then(function(balance) {
      carol_ending_balance = balance.toNumber();

      assert.equal(bob_ending_balance, bob_starting_balance  , " Bob's amount was correctly taken from the sender");
      assert.equal(carol_ending_balance, carol_starting_balance , "Carol's amount was correctly sent to the receiver");
    });
});
});

