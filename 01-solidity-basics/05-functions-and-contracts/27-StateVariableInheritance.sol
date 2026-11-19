//不像函数，子合约不可以通过重新声明去重写覆盖父合约的状态变量

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract A {
    string public name = "Contract A";

    function getname() public view returns (string memory) {
        return name;
    }
}

// 在 Solidity 0.6以后的版本，遮蔽操作（重新声明继承变量）是不允许的
// 这会导致无法编译，如下
/*
contract B is A {
    string public name = "Contract B";
}
*/

//下面是正确重写父合约状态变量的方法
contract C is A {
    //通过构造函数重写父合约的状态变量
    constructor() {
        name = "Contract C";
    }
    //C.getName returns "Contract C"
}
