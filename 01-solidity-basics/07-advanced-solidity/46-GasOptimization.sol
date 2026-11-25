// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
节省gas费的方法
    1、使用calldata（只读取）代替memory（复制到内存，可读可写）
    2、使用memory复制状态变量到内存（函数）中使用
    3、提前将数组元素保存到内存中，减少读取
    4、短路评估，如果出现多个条件判断，可以使用&&操作符的短路特性，如果第一个判断为false就不会执行下一个判断，节省gas

实际 Gas 优化效果需要结合编译器版本、优化设置及执行场景进行测试
*/

contract GasGolf {
    uint256 public total;

    /* 没有优化gas的写法
    function sumIfEvenAndLessThan99(uint256[] memory nums) external {
        for (uint i = 0; i < nums.length; i +=1) {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if (isEven && isLessThan99) {
                total += nums[i];   
            }
        }
    }
    */

    // 优化gas的写法
    function sumIfEvenAndLessThan(uint256[] calldata nums) external {
        // 提前将状态变量复制到内存当中使用
        uint256 _total = total;
        // 提前calldata中需要的数据复制的到内存当中，减少读取
        uint256 len = nums.length;

        for (uint256 i = 0; i < len;) {
            // 将数组元素缓存到局部变量，避免重复读取
            uint256 num = nums[i];
            // 使用&&操作符的短路特性，减少一次判断
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
            // 当前循环通过 i < len 限制迭代次数
            // 在此循环条件下，i 不会达到 uint256 的溢出边界
            // 因此可以在确认边界安全后使用 unchecked 递增
            unchecked {
                ++i;
            }
        }
        // 纯运算过程中只使用memory，最后结果再复制给状态变量
        total = _total;
    }
}
