// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Library 类似于合约，用于封装可复用的功能。
Library 不能像普通合约一样拥有自己的常规状态变量或独立的 Ether 接收功能。

如果 Library 的函数是 internal，通常会以内联方式编译进调用合约。
如果 Library 包含需要外部调用的函数，则可能需要部署并链接 Library。
*/

library Math {
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

contract TestMath {
    function testSquareRoot(uint256 x) public pure returns (uint256) {
        return Math.sqrt(x);
    }
}

import "./extra/Library.sol";

contract TestArray {
    using Array for uint256[];
    
    event LogArray(string message, uint256[] data);

    uint256[] public arr;

      // 新增函数：返回完整数组
    function getFullArray() public view returns (uint256[] memory) {
        return arr;
    }

    function testArrayRemove() public {
        
        for (uint256 i = 0; i < 3; i++) {
            arr.push(i);
        }

    emit LogArray("Before remove:", arr); // 记录初始数组
    arr.remove(1);
    emit LogArray("After remove:", arr);  // 记录结果数组

    assert(arr.length == 2);
    assert(arr[0] == 0);
    assert(arr[1] == 2);
    }
}
