// SPDX-License-Identifier: GLP-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./bank.sol";

contract Index {
    Bank b = new Bank("Xiang");

    function Deposit(uint256 value) public {
        b.AddBalance(payable(msg.sender), value);
    }

    function CheckBalance() public view returns(uint256) {
        return b.CheckBalance(payable(msg.sender));
    }
}
