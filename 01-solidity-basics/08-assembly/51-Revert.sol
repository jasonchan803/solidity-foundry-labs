// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//例子展示汇编的错误处理

contract AssemblyError {
    function yul_revert(uint256 x) public pure {
        assembly {
            /*
                revert(p, s) - 终止执行
                             - 回滚所有状态变更
                             - 返回内存中从位置p开始，长度为s的数据
                                p(position)：内存中的起始位置（字节偏移量）
                                s(size)：要返回的数据长度（字节数）
                */
            // 如果 x > 10，回滚交易，因为是(0, 0)所以不返回任何数据
            if gt(x, 10) { revert(0, 32)}
        }
    }
}
/*
    revert(p, s)只能返回内存数据
    存储数据：必须先通过 sload+ mstore转换
    栈数据：必须先通过 mstore写入内存
    内存是桥梁：所有要返回的数据都必须经过内存
*/
