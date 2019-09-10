pragma solidity ^0.4.25;

contract Bor {

    import "./Lend.sol";
    import "./LoanProcess.sol";

    event NewBorrower(uint borrowerHashId, uint creditScore, uint cashFlow, uint assets, string rep);

    uint hashDigits = 16;
    uint hashModulus = 10 ** hashDigits;

    struct Borrower {
        string[] PII;

        address bAddress;
        uint borrowerHashId;
        uint creditScore;
        uint cashFlow;
        uint assets;
        string rep;
    }

    struct LoanRequest {
        uint bLoanId;
        uint bCreditScore;
        uint bLoanAmount;
    }

    Borrower[] public borrowers;
    LoanRequest[] public loanRequests;

    mapping (uint => address) borrowerToOwner;
    mapping (address => uint) ownerBorrowerCount;

    modifier ownerOfB(uint _borrowerHashId) {
      require(msg.sender == borrowerToOwner[_borrowerHashId]);
      _;
    }

    function _createBorrower(string[] _PII, uint _borrowerHashId, uint _creditScore, uint _cashFlow, uint _assets, string _rep) public returns(uint) {
      require(ownerBorrowerCount[msg.sender] == 0);
      address _bAddress = msg.sender;
      uint index = borrowers.length;
      borrowers.push(Borrower(_PII, _bAddress, _borrowerHashId, _creditScore, _cashFlow, _assets, _rep);
      ownerBorrowerCount[msg.sender]++;
      borrowers[index].bAddress = _bAddress;
      borrowers[index].borrowerHashId = _borrowerHashId;
      borrowers[index].creditScore = _creditScore;
      borrowers[index].cashFlow = _cashFlow;
      borrowers[index].assets = _assets;
      borrowers[index].rep = _rep;
      emit NewBorrower(_borrowerHashId, _creditScore, _cashFlow, _assets, _rep);
      return borrowers.length - 1;
    }

    function requestLoan(uint _bIndex, uint _bLoanAmount) ownerOfB(borrowers[_bIndex].borrowerHashId) public returns(uint) {
      uint _bLoanId = loanRequests.length;
      uint _bCreditScore = borrowers[_bIndex].creditScore;
      loanRequests.push(loanRequest(_bLoanId, _bCreditScore, _bloanAmount));
      loanRequests[_bLoanId].bLoanId = _bLoanId;
      loanRequests[_bLoanId].bCreditScore = _bCreditScore;
      loanRequests[_bLoanId].bLoanAmount = _bLoanAmount;
      return loanRequests.length - 1;
    }

    function acceptLoan(uint _bIndex, uint _lIndex, uint _loIndex, uint _lrIndex) ownerOfB(borrowers[_bIndex].borrowerHashId) ownerOfB(borrowers[_bIndex].borrowerHashId) public returns(uint) {
      uint _loanId = loans.length;
      loans.push(Loan(_loanId, borrowers[_bIndex].bAddress, lenders[_lrIndex].lAddress, loanOffers[_loIndex].loanAmount, loanOffers[_loIndex].interestRate, loanOffers[_loIndex].loanPeriod, loanOffers[_loIndex].minPayment));
      loans[_loanId].loanId =  _loanId;
      loans[_loanId].borAddress =  borrowers[_bIndex].bAddress;
      loans[_loanId].lendAddress =  lenders[_lrIndex].lAddress;
      loans[_loanId].loanAmount =  loanOffers[_loIndex].loanAmount;
      loans[_loanId].interestRate =  loanOffers[_loIndex].interestRate;
      loans[_loanId].loanPeriod =  loanOffers[_loIndex].loanPeriod;
      loans[_loanId].minPayment =  loanOffers[_loIndex].minPayment;
      return loans.length - 1;
    }

    function payment(uint _lIndex, uint amount) {
      
    }

    function getBorrowersCount() public constant returns(uint) {
      return borrowers.length;
    }

    function getBorrowerInfo(uint index) public constant returns(address, uint, uint, uint, uint, string) {
      return (borrowers[index].bAddress, borrowers[index].borrowerhashId, borrowers[index].creditScore, borrowers[index].cashFlow, borrowers[index].assets, borrowers[index].rep);
    }
}
