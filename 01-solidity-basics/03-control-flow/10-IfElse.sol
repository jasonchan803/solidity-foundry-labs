// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/*if - else if - else结构
    特点：
    支持多条件分支 (else if)
    可以包含复杂的逻辑块
    适合处理多个条件和复杂逻辑
    每个分支可以包含多条语句
*/
contract IfElse {
    function foo(uint256 x) public pure returns (uint256){
        if (x < 10) {
            //首先检查 x < 10，如果为真则返回 0
            return 0;
        } else if (x < 20) {
            //如果不满足，检查 x < 20，如果为真则返回 1
            return 1;
        } else {
            //如果以上都不满足，执行 else 块返回 2
            return 2;
        }
    }

/*三元运算符
    特点：
    语法：条件 ? 表达式1 : 表达式2
    如果条件为真，返回表达式1的值，否则返回表达式2的值
    简洁，适合简单的条件赋值
    只能处理两种结果的情况
    整个表达式必须在一行内完成
    */
    function ternary(uint256 _x) public pure returns (uint256) {
        /*等价于
        if (_x < 10) {
            return 1;
        } else {
            return 2;
        }
        */
        return  _x < 10 ? 1 : 2;
    }
}
/*注意事项
在 Solidity 中，条件表达式必须明确返回布尔值（true/false）
三元运算符的两个返回表达式类型必须兼容
复杂的嵌套三元运算符会降低代码可读性，应避免过度使用
这个合约很好地展示了 Solidity 中处理条件逻辑的两种主要方式，开发者可以根据具体情况选择最合适的写法。
*/
