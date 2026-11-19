// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
/*
Solidity 中有 3 种类型的变量
    local   局部变量
        在函数中声明
        不存储在区块链上
    state   状态变量
        在函数外部声明
        存储在区块链上
    global  全局变量 
        （提供有关区块链的信息）
*/
contract Variables {
    //state 状态变量储存在区块链中
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething()public view {
        //local 局部变量不储存在区块链中
        uint256 time = 456;

        //下面是一些global  全局变量
        uint256 timestamp = block.timestamp;// 记录当前时间
        //block.timestamp​​ 是 Solidity 的一个全局变量，表示​​当前区块的时间戳​​（Unix 时间戳，即自 1970-01-01 以来的秒数）
        address sender = msg.sender;// 记录调用者地址
        //​​msg.sender​​ 是 Solidity 的另一个全局变量，表示​​当前调用者（或合约）的地址
        timestamp = time;
        sender = address(0);
    }
}
