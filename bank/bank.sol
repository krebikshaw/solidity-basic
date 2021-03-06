// SPDX-License-Identifier: GLP-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../openzeppelin-contracts/Ownable.sol";

library Calculate_bank {
    function Interest(
        uint256 Rate,
        uint256 Amount,
        uint256 Days
    ) public pure returns (uint256) {
        return (Amount * Rate * Days) / 1000 / 365;
    }
}

contract Bank is Ownable {
    event event_add_balance(address Customer, uint256 Value);
    event event_add_loan(address Customer, uint256 Value);
    event event_withdraw(address Customer, uint256 Value);
    event event_receive(address Donor, uint256 Value);

    constructor(string memory bankName) {
        bank_name = bankName;
    }

    string public bank_name;
    address[] all_customer_address;
    uint256 customer_count = 0;
    uint8 deposit_rate;
    uint8 borrowing_rate;
    struct Customer {
        uint256 serial_number;
        string name;
        uint256 balance;
        uint256 loan;
    }
    mapping(address => Customer) address_customer;

    modifier ValidateBalance(address CustomerAddress, uint256 Value) {
        require(
            address_customer[CustomerAddress].balance > Value,
            "Insufficient balance"
        );
        _;
    }

    function AddCustomer(
        string memory CustomerName,
        address payable CustomerAddress
    ) public {
        all_customer_address.push(CustomerAddress);
        address_customer[CustomerAddress].serial_number = ++customer_count;
        address_customer[CustomerAddress].name = CustomerName;
        address_customer[CustomerAddress].balance = 0;
        address_customer[CustomerAddress].loan = 0;
    }

    function AddBalance(address payable CustomerAddress, uint256 Value) public {
        address_customer[CustomerAddress].balance += Value;
        emit event_add_balance(CustomerAddress, Value);
    }

    function AddLoan(address payable CustomerAddress, uint256 Value) public {
        address_customer[CustomerAddress].loan += Value;
        emit event_add_loan(CustomerAddress, Value);
    }

    function CheckContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function CheckBalance(address payable CustomerAddress)
        public
        view
        returns (uint256)
    {
        return address_customer[CustomerAddress].balance;
    }

    function CheckLoan(address payable CustomerAddress)
        public
        view
        returns (uint256)
    {
        return address_customer[CustomerAddress].loan;
    }

    function MyBalance() external view returns (uint256) {
        Customer memory c = address_customer[msg.sender];
        return c.balance - c.loan;
    }

    function GetAllBalance() public view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < customer_count; i++) {
            address temp = all_customer_address[i];
            sum += address_customer[temp].balance;
        }
        return sum;
    }

    function Withdraw(uint256 Value)
        external
        ValidateBalance(msg.sender, Value)
        returns (string memory)
    {
        address payable customer_address = payable(msg.sender);
        customer_address.transfer(Value);
        address_customer[msg.sender].balance -= Value;
        emit event_withdraw(msg.sender, Value);
        return "Success";
    }

    receive() external payable {
        emit event_receive(msg.sender, msg.value);
    }

    fallback() external payable {}

    function Destroy() external onlyOwner {
        selfdestruct(payable(owner()));
    }
}
