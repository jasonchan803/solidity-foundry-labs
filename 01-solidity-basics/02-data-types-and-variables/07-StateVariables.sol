// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//要写入或更新状态变量，您需要发送交易。
//另一方面，您可以免费读取状态变量，无需任何交易费用。

contract SimpleStorage {
    //用于存储数字的状态变量
    uint256 public num;

    //更新状态变量的值，需要发送一个交易
    function set(uint256 _num)public {
        num = _num;
    }
    
    //免费读取状态变量，不需要任何交易费用
    function get()public view returns (uint256){
        return num;
    }
}
