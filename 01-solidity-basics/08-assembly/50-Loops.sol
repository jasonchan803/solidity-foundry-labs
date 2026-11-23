// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//例子展示汇编的循环

contract AssemblyLoop {
    function yul_for_loop() public pure returns (uint256 z) {
        assembly {
            // 初始化部分为   i = 0,
            // 条件部分为     i < 10
            // 迭代部分为     i++
            // 循环体部分为   z += 1
            for { let i := 0 } lt(i, 10) { i := add(i, 1) } { z := add(z, 1) }
        }
    }

    function yul_while_loop() public pure returns (uint256 z) {
        assembly {
            let i := 0
            // 初始化部分为空{},没有初始化语句
            // 条件部分为 i < 5
            // 迭代部分为空{},没有迭代语句
            // 循环体部分为     i++     z += 1     
            for {} lt(i, 5) {} {
                i := add(i, 1)
                z := add(z, 1)
            }
        }
    }

    //  在 Solidity 函数作用域中声明的变量（参数、返回参数、局部变量）在 Yul 汇编块中自动可用且已适当初始化，无需在汇编中重新声明。
    //  类似于上述例子中的 z ，已在Solidity函数中声明为返回参数，所以 z 会被隐式声明为默认值0
}
