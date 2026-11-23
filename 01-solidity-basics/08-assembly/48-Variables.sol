// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//例子展示如何在汇编的内部声明变量

contract AssemblyVariable {
    function yul_let() public pure returns (uint256 z) {
        assembly {
            //  在汇编内部声明局部变量
            let x := 123
            // 可以直接返回给声明的返回值变量z，不需要return
            z := 456
        }
    }
}
