// SPDX-License-Identifier: GLP-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./bank.sol";

contract NewBank is Bank("Xiang") {
    struct Kyc {
        string name;
        string job;
        uint256 annual_salary;
        uint256 credit_point;
    }

    mapping(address => Kyc) address_kyc;

    function registerKyc(
        address CustomerAddress,
        string memory CustomerName,
        string memory CustomerJob,
        uint256 CustomerAnnualSalary
    ) public {
        address_kyc[CustomerAddress].name = CustomerName;
        address_kyc[CustomerAddress].job = CustomerJob;
        address_kyc[CustomerAddress].annual_salary = CustomerAnnualSalary;
        address_kyc[CustomerAddress].credit_point = 0;
    }
}
