// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//常量是无法修改的变量。
//它们的值是硬编码的，使用常量可以节省 gas 成本。
contract Constants {
    //编码规范，使用大写设置常量变量
    address public constant MY_ADDRESS = 
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint256 public constant MY_UINT = 123;
}
