pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract FraudValidator {
    struct Organization {
        address id;
        string name;
        string http;
    }
    mapping (string => Organization) public getOrganization;
    event RegisterOrganization(Organization organization);

    struct PaymentMethod {
        Organization organization;
        bytes32 paymetMethodHash;
        string http;
    }
    mapping (bytes32 => PaymentMethod) public getPaymentMethod;
    event RegisterPaymentMethod(PaymentMethod paymentMethod);

    function registerOrganization(string memory _name, string memory _http) public payable returns(Organization memory) {
        Organization memory organization = Organization(msg.sender, _name, _http);
        getOrganization[_name] = organization;

        emit RegisterOrganization(organization);
        return organization;
    }

    function registerPaymentMethod(string memory _name, string memory _description, string memory _reference, string memory _http) public payable returns(PaymentMethod memory) {
        bytes32 paymentMethodHash = keccak256(abi.encodePacked(_description, _reference));
        PaymentMethod memory paymentMethod = PaymentMethod(getOrganization[_name], paymentMethodHash, _http);
        getPaymentMethod[paymentMethodHash] = paymentMethod;

        emit RegisterPaymentMethod(paymentMethod);
        return paymentMethod;
    }

    function validatePaymentMethod(string memory _description, string memory _reference) public view returns(string memory, string memory, Organization memory) {
        bytes32 paymentMethodHash = keccak256(abi.encodePacked(_description, _reference));
        PaymentMethod memory paymentMethod = getPaymentMethod[paymentMethodHash];

        return (_description, _reference, paymentMethod.organization);
    }
}
