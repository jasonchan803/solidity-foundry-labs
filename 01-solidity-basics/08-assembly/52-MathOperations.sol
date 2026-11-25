// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 例子展示汇编的数学运算

contract AssemblyMath {
    function yul_add(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            // 加法运算
            z := add(x, y)
            // 检查 z 是否小于 x（溢出检查），如果发生溢出，执行 revert(0, 0) 回滚交易
            if lt(z, x) { revert(0, 0) }
        }
    }

    function yul_mul(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            // 多分支判断
            switch x
            // 如果 x 为 0，则 返回值z 也设为 0（0和任何数相乘都为0）
            case 0 { z := 0 }
            default {
                // 乘法运算
                z := mul(x, y)
                // 将 z 除以 x ，检查结果是否等于 y ，如果不等（乘法溢出），执行回滚
                /*
                    if iszero(condition) { 
                        // 当 condition 为 0/false 时执行
                        revert(0, 0) 
                    }
                */
                if iszero(eq(div(z, x), y)) { revert(0, 0) }
            }
        }
    }

    // 四舍五入到最接近 b 的倍数 
    function yul_fixed_point_round(uint256 x, uint256 b)
        public 
        pure 
        returns (uint256 z)
    {
        assembly {
            // 计算 b 的一半
            let half := div(b, 2)
            // 让 z 加上 b 的一半
            z := add(x, half)
            // 加上之后的 z 除以 b 后再乘以 b，得到四舍五入后的 x
            z :=mul(div(z, b), b)
            /*
                为什可以这样操作呢？因为再汇编中没有小数，除法会截断小数部分，
                如果通过直接相除后再乘，有一定的概率会把原有数据抹掉，这时候通过在除法前让数值增加半个基准，这样：
                    当小数部分 < 0.5 时，加上 0.5 后仍然不会进位
                    当小数部分 ≥ 0.5 时，加上 0.5 后就会进位
                然后让除法自动截断，就自然实现了四舍五入！"
            */
        }
    } 
}
