// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//solidity提供for、while和do while循环
//千万不要编写无限循环，因为这样会导致超出Gas的限制，从而导致交易失败
//也正是因为上面这个原因，while和do while循环很少被使用
contract Loop {
    function loop() public pure {
        /*for循环
        语法结构：
        for (初始化; 条件; 迭代) {
        循环体
        }
        */
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                //跳到下一个循环
                continue;
            }
            if (i == 5) {
                //退出当前循环
                break;
            }
        }
        /*while循环
        语法结构​​：
        while (条件) {
        循环体
        }
        */
        uint256 j;
        while (j < 10){
            j++;
        }
    }
    
    function findFirstEven(uint[] memory nums) public pure returns (uint) {
        uint i = 0;
        /*do-while 循环
        语法结构​​：
        do {
        循环体
        } while (条件);
        */
        do {
            if (nums[i] % 2 == 0) {
                return nums[i];
            }
            i++;
        } while (i < nums.length);
        revert("No even number found");
    }
    // do-while 至少执行一次，因此空数组会在访问 nums[0] 时发生越界
    /*当单独作为一条完整语句时，两者效果相同：
    i++ (后缀递增);         增加1
    i = i + 1(显式加法);   同样增加1    消耗更多的Gas，比 i++ 略高
    ​​循环条件限制​​：i < nums.length
    ​​数组长度限制​​：Solidity中数组长度最大为2^256 - 1
    ​​uint256范围​​：i作为uint256，与数组长度类型相同*/

    //真正需要担心溢出的场景
    function overflow() public pure {
        for (uint8 i = 0; i < 300; i++) { // 当i=255时，i++会溢出
            if(i == 256){
                break;
            }        
        }
    }
}

/*
三者的主要区别
特性	    for 循环	            while 循环	        do-while 循环
​​语法结构​​	初始化;条件;迭代	    只有条件	        先执行后判断条件
​​执行次数​​	0次或多次	            0次或多次	        至少1次
​​适用场景​​	循环次数已知	        循环次数未知	    必须执行至少一次
​​可读性​​	    高（循环控制集中）	    中等	            较低（条件在最后）
​​Gas消耗​​	    通常可预测	           可能不可预测	        可能不可预测
*/
