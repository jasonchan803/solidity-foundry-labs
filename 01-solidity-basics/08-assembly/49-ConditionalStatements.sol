// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//例子展示汇编的条件语句

contract AssemblyIf {
    function yul_if(uint256 x) public pure returns (uint256 z) {
        assembly {
            // if 条件 { code }
            // if条件为真，则执行code语句，没有else否则
            // lt：less than 小于       gt：greater than 大于      et: equal than 等于
            if lt(x, 10) { z := 99 }
            // 如果x<10,将返回值z设为99
        }
    }

    function yul_switch(uint256 x) public pure returns (uint256 z) {
        assembly {
            // switch语句，基于变量 x 的值进行多路分支判断
            switch x
            // 如果 x 等于 1，将 z 设置为 10
            case 1 { z := 10 }
            // 如果 x 等于 2，将 z 设置为 20
            case 2 { z := 20 }
            // 如果 x 不等于 1 或 2，将 z 默认设置为 0
            default { z := 0 }

            // 有点类似于Python中的if....elif....else
        }
    }
}
