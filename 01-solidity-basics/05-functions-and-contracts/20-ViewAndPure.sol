// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//Getter函数可以声明为view和pure
//View函数会声明状态变量不会被修改
//Pure函数会声明状态变量不能被修改和读取

contract ViewAndPure {
    uint256 public x = 1;

    //承诺不会修改状态变量
    function addToX(uint256 y) public view returns (uint256) {
        return x + y;
    }

    //承诺不会修改或者读取状态变量
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }
}
// 总结：参数常量用pure，状态依赖必view。
