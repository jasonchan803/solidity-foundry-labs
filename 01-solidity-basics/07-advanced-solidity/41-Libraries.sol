// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
库类似于合约，但是它不能声明任何状态变量，不能接收和发送Ether
如果这个库所有的函数都是internal，那么这个库就会被内嵌在合约中
否则，在合约部署前，先需要单独部署库和链接合约
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
