// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Solidity 0.8.0 及以后版本，整数运算默认会检查溢出和下溢
// 使用 unchecked 可以关闭该范围内的溢出检查，运算会按照固定宽度整数规则回绕
// 忽视溢出和下溢的检查可以节省gas

contract UncheckedMath {
    function add(uint x, uint y) external  pure returns (uint256) {
        // return x + y;

        unchecked {
            return x + y;
        }
    }

    function sub(uint256 x , uint256 y) external pure returns (uint256) {
        // return x - y;

        unchecked {
            return x - y;
        }
    }

    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {
        // 把复杂的数学逻辑放在unchecked里面，可以节省gas
        unchecked {
            // unchecked 内的乘法和加法均不检查溢出
            // 需要确保数学运算的输入范围足够安全，否则结果可能发生回绕
            return (x * x * x) + (y * y * y);
        }
    }

}
