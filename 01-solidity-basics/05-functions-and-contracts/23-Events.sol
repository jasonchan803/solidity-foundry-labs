//事件允许将数据记录到以太坊区块链中，包含以下的一些场景
//监听事件和更新用户界面
//一种更便宜的存储数据的方式
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Event {
    //声明一个事件
    //最多可以对3个参数进行indexed（可索引），注意只可索引值类型，其他类型不可以
    //indexed可以帮助你在日志中快速的筛选出indexed后的参数
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}
