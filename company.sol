// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Company {
    constructor(string memory name) {
        boss_name = name;
        boss_address = payable(msg.sender);
    }

    string public boss_name;
    address payable public boss_address;
    struct Sales {
        string name;
        address payable sales_address;
        uint256 performance;
        uint256 salary;
        uint256 withdrawn;
    }
    address[] all_address;
    mapping(address => string) address_name;
    mapping(string => Sales) name_sales;

    function AddPerformance(string memory Salesman, uint256 Profit) public {
        name_sales[Salesman].performance += Profit;
        name_sales[Salesman].salary += Profit / 10;
    }

    function AddSales(string memory Salesman, address payable SalesAddress)
        public
    {
        all_address.push(SalesAddress);
        address_name[SalesAddress] = Salesman;
        name_sales[Salesman].name = Salesman;
        name_sales[Salesman].sales_address = SalesAddress;
        name_sales[Salesman].performance = 0;
        name_sales[Salesman].salary = 0;
        name_sales[Salesman].withdrawn = 0;
    }

    function CheckBalance(address payable SalesAddress)
        public
        view
        returns (uint256)
    {
        Sales memory s = name_sales[address_name[SalesAddress]];
        return s.salary - s.withdrawn;
    }

    function MyBalance() external view returns (uint256) {
        Sales memory s = name_sales[address_name[msg.sender]];
        return s.salary - s.withdrawn;
    }

    function GetAllPerformance() public view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < all_address.length; i++) {
            address temp = all_address[i];
            string memory name = address_name[temp];
            sum += name_sales[name].performance;
        }
        return sum;
    }

    function Withdraw() external returns (uint256) {
        address payable user = payable(msg.sender);
        uint256 balance = CheckBalance(user);
        user.transfer(balance);
        string memory name = address_name[msg.sender];
        name_sales[name].withdrawn += balance;
        return balance;
    }

    fallback() external payable {}

    receive() external payable {}

    function Destroy() external {
        selfdestruct(boss_address);
    }
}
