pragma solidity ^0.7.0;

contract KYC {
    
    address payable KYC_body;
    
    constructor() public {
        KYC_body = msg.sender;
        // kyc_contract_address = msg.value;
    }
    
    struct Citizen {
        string name;
        uint256 adhaar_id;
        string postal_address;
        bool isKYCCompleted;
        uint mobile_no;
        uint bankaccount;
        }
    
    mapping(uint256 => Citizen) CitizenProfile;

    
    modifier OnlyKYCAuthority{
        require(KYC_body == msg.sender, "Unaauthorized user ...");
        _;
    }
 
    function registerCitizenForKYC(string memory _name, uint256 adhaarId, uint mobileNo, string memory _postal_address) external{
        Citizen memory cp1 = Citizen({name:_name, adhaar_id:adhaarId, mobile_no:mobileNo, 
        postal_address:_postal_address, isKYCCompleted:false, bankaccount:0});
        CitizenProfile[adhaarId] = cp1;
    }
    
    function isKYCCompletedSuccessfully(uint adhaarCardId) public view returns (bool){
        return CitizenProfile[adhaarCardId].isKYCCompleted;
    }
    
    function completeKYC(uint adhaarCardId) public OnlyKYCAuthority {
        // require(CitizenProfile[adhaarCardId].mobile_no == mobileNo, "KYC details not matching during the registration");
        CitizenProfile[adhaarCardId].isKYCCompleted = true;
    }
    
    
}

contract Bank {
 
    KYC kycObject;
    address BankOfficial;
    struct BankPorfolio {
        uint Bank_id;
        string Bank_name;
   }
    
    mapping(uint => BankPorfolio) BankMapping;
    
    constructor(address KYCAddress) public{
           BankOfficial = msg.sender;
           kycObject = KYC(KYCAddress);
    }
    
    modifier OnlyBankOffficials() {
        require(BankOfficial == msg.sender);
        _;
    }
    
    // function createBank(string memory _name, uint _bank_id) public OnlyKYCAuthority{
    //     BankPorfolio memory bank = BankPorfolio({Bank_id:_bank_id, Bank_name:_name});
    //     BankMapping[_bank_id] = bank;
    // }
    
    function initiateKYC(string memory _name, uint256 adhaarId, uint mobileNo, string memory _postal_address) public OnlyBankOffficials{
        require(kycObject.isKYCCompletedSuccessfully(adhaarId) == false, "Citizen is already done with KYC");
        kycObject.registerCitizenForKYC(_name, adhaarId, mobileNo, _postal_address);
    }
    
    function getKYCStatus(uint256 adhaarId) public view returns(string memory) {
        if (kycObject.isKYCCompletedSuccessfully(adhaarId)) {
            return "KYC is Complete";
        } else {
            return "KYC not yet Complete....";
        }
    }
    
    
    // function random() private view returns(bytes32) {
    //     return keccak256(block.timestamp);
    // } 
    
    // function CreateBankAccount(string memory _name, uint256 adhaarId, uint mobileNo, string memory _postal_address, uint bankId) public{
    //     require(KYC.isKYCCompletedSuccessfully(adhaarId), "Citizen is not done with KYC");
    //     BankMapping[bankId].cz[adhaarId].BankAccountDetails.push();
        
    // }
    
    
}
