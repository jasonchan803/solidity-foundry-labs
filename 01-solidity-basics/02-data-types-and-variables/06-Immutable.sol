// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/*
​​immutable 变量​​
    用 immutable 声明的变量只能在 ​​构造函数（constructor）​​ 中初始化一次，之后无法修改。
    存储在合约代码中（而非存储插槽 storage），​​读取时 Gas 成本低​​（类似 constant，但值可在构造函数中设置）。
    适用于部署时确定且后续不变的变量（如合约创建者地址、固定参数）。    
​​初始化规则​​
    myAddr 赋值为 msg.sender（部署者的地址）。
    myUint 通过构造函数参数 _myUint 初始化。
​​public 关键字​​
    自动生成 getter 函数，允许外部读取 myAddr 和 myUint。
*/
contract Immutable {
    address public immutable myAddr;
    uint256 public immutable myUint;

    //构造函数
    constructor(uint256 _myUint){
        myAddr = msg.sender;
        myUint = _myUint;
    }
}
/*
总结​​:
    ​​immutable​​ 适用于部署时确定且后续不变的变量，兼顾灵活性和 Gas 效率。
    比 constant 更灵活，比常规 storage 变量更节省 Gas。
    常用于记录合约创建者、固定参数或外部依赖地址。
*/
