pragma solidity ^0.4.25;

contract Lend {

    import "./Bor.sol";
    import "./LoanProcess.sol";

    event NewLender(uint lenderHashId, uint totAmAv, uint maxLoanAmAv, string rep);

    uint hashDigits = 16;
    uint hashModulus = 10 ** hashDigits;

    struct Lender {
        string[] PII;

        address lAddress;
        uint lenderHashId;
        uint totAmAv;
        uint maxLoanAmAv;
        string rep;
    }

    struct LoanOffer {
        uint lLoanId;
        uint loanAmount;
        uint interestRate;
        uint loanPeriod;
        uint minPayment;
    }

    Lender[] public lenders;
    LoanOffer[] public loanOffers;

    mapping (uint => address) lenderToOwner;
    mapping (address => uint) ownerLenderCount;

    modifier ownerOfL(uint _lenderHashId) {
      require(msg.sender == lenderToOwner[_lenderHashId]);
      _;
    }

    function _createLender(string[] _PII, uint _lenderHashId, uint _totAmAv, uint _maxLoanAmAv, string _rep) public returns(uint) {
      require(ownerLenderCount[msg.sender] == 0);
      address _lAddress = msg.sender;
      uint index =  lenders.length;
      lenders.push(Lender(_PII, _lAddress, _lenderHashId, _totAmAv, _maxLoanAmAv, _rep));
      ownerLenderCount[msg.sender]++;
      lenders[index].lAddress = _lAddress;
      lenders[index].lenderHashId = _lenderHashId;
      lenders[index].totAmAv = _totAmAv;
      lenders[index].maxLoanAmAv = _maxLoanAmAv;
      lenders[index].rep = _rep;
      emit NewLender(_lenderHashId, _totAmAv, _maxLoanAmAv, _rep);
      return lenders.length - 1;
    }

    function offerLoan(uint _lIndex, uint _lrIndex, uint _interestRate, uint _loanPeriod, uint _minPayment) ownerofL(lenders[_lIndex].lenderHashId) public returns(uint) {
      uint _lLoanId = loanOffers.length;
      loanOffers.push(LoanOffer(_lLoanId, loanRequests[_lrIndex]._loanAmount, _interestRate, _loanPeriod, _minPayment));
      loanOffers[_lLoanId].interestRate = _interestRate;
      loanOffers[_lLoanId].loanPeriod = _loanPeriod;
      loanOffers[_lLoanId].minPayment = _minPayment;
      return loanOffers.length - 1;
    }

    function getLendersCount() public constant returns(uint) {
      return lenders.length;
    }

    function getLenderInfo(uint index) public constant returns(address, uint, uint, uint, string) {
      return (lenders[index].lAddress, lenders[index].lenderHashId, lenders[index].totAmAv, lenders[index].maxLoanAmAv, lenders[index].rep);
    }
}
