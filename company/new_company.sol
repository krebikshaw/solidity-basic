// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./company.sol";

contract NewCompany is Company("Xiang") {
    mapping(string => string) manager;

    function buy(string memory Salesman) external payable {
        name_sales[Salesman].performance = msg.value;
        name_sales[Salesman].salary = msg.value / 10;
        emit event_performance(name_sales[Salesman].sales_address, msg.value);
    }

    function add_manager(string memory Salesman) public IsBoss {
        manager[Salesman] = "Manager";
    }
}
