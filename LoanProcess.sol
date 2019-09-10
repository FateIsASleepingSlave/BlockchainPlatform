pragma solidity ^0.4.25;

contract LoanProcess {

  import "./Bor.sol";
  import "./Lend.sol";

  struct Loan {
    uint loanId;
    address borAddress;
    address lendAddress;
    uint loanAmount;
    uint interestRate;
    uint loanPeriod;
    uint minPayment;
  }

  Loan[] public loans;

  function _generateRandomHash(string _str) public view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % hashModulus;
  }

}
