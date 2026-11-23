// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 溢出和下溢在Solidity 0.8以后会自动抛出错误，但你可以使用unchecked去忽视这个错误
//忽视溢出和下溢的检查可以节省gas

contract UncheckedMath {
    function add(uint x, uint y) external  pure returns (uint256) {
        // 22291 gas
        // return x + y;

        // 22103 gas
        unchecked {
            return x + y;
        }
    }

    function sub(uint256 x , uint256 y) external pure returns (uint256) {
        // 22329 gas
        // return x - y;

        // 22147 gas
        unchecked {
            return x - y;
        }
    }

    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {
        // 把复杂的数学逻辑放在unchecked里面，可以节省gas
        unchecked {
            return (x * x * x) + (y * y * y);
        }
    }

}
