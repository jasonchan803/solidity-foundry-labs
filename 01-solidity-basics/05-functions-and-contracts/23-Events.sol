//事件允许将数据记录到以太坊区块链中，包含以下的一些场景
//监听事件和更新用户界面
//一种更便宜的存储数据的方式
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Event {
    // 声明一个事件
    // 一个事件最多可以有3个 indexed 参数
    // indexed 参数可以用于筛选日志，帮助你在日志中快速的筛选出 indexed 后的参数
    // 动态类型（如 string、bytes、数组）被 indexed 后，日志中存储的是其哈希值
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}
