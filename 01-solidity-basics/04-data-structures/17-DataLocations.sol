// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//storage - 变量是一个状态变量（存储在区块链中）
//          在函数引用后，会把存储指针指向该变量，修改该变量（等同于修改状态变量）,会直接修改链上数据
//memory - 变量是一个临时变量，存储在内存中，并且在函数调用期间始终存在，函数调用结束后会自动销毁
//         在函数引用后，等于把状态变量、参数或者返回值复制了一个临时的副本赋值给该变量，用于各种复杂的运算，
//         在函数执行过程中使用，函数调用结束后不再保留，修改 memory 副本不会直接修改原始 storage 数据
//         Memory 操作仍然会消耗 Gas，但通常比 Storage 写入便宜
//calldata - 一种特殊的数据存储位置，专门用于存储外部函数调用时传入的参数数据，只能读取不能修改

contract DataLocations {
    uint256[] public arr;

    mapping(uint256 => address) map;

    struct MyStruct {
        uint256 foo;
    } 

    mapping(uint256 => MyStruct) myStructs;

    function f() public {
        // 把状态变量当作参数传入函数 _f
        _f(arr, map, myStructs[1]);

        //把myStructs[1]状态变量的存储指针指向myStructs，通过修改myStructs直接修改状态变量myStructs[1]
        MyStruct storage myStructRef = myStructs[1];

        //通过MyStruct结构体，在内存中复制一个临时的副本myMemStruct，且初始化为0
        MyStruct memory myMemStruct = MyStruct(0); 
        
        //修改临时副本myMemStruct
        myMemStruct.foo = 100;
        
        //把临时副本myMemStruct.foo赋值给myStructRef.foo，这会直接修改变量
        myStructRef.foo = myMemStruct.foo;
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        //使用状态变量做一些事情

        //修改数组
        _arr.push(100); // 这会修改原始的arr数组

        //修改映射
        _map[1] = msg.sender; // 这会修改原始的map映射
        //        msg.sender是一个全局变量，用于表示当前调用合约的地址即直接发起本次函数调用的账户或合约地址
        //                  ​​类型​​：address（以太坊地址类型）
        //                  ​​动态性​​：在合约调用链中，msg.sender的值会随调用层级变化。例如：用户A → 合约B → 合约C：在合约C中，msg.sender是合约B的地址，而非用户A
        //                  底层原理​​：​交易上下文​​：msg.sender由 EVM 在运行时自动填充，反映调用栈的当前层级。
        //                  ​Gas 消耗​​：读取 msg.sender仅消耗少量 Gas
        //修改结构体
        _myStruct.foo = 100;

    }

    //你可以返回临时的内存变量
    function g(uint256[] memory _arr) public pure returns (uint256[] memory) {
        //使用临时变量做一些事情
        _arr[0] = 100;  //这不会修改原始的arr数组
        return _arr;
    }

    function h(uint256[] calldata _arr) external {
        // 使用calldata变量做一些事情
        // 只能读取calldata数组，不能修改
        uint sum = 0;
        for (uint i = 0; i < _arr.length; i++ ) {
            sum += _arr[i];
        }

        // 将结果存入Storage
        myStructs[sum].foo = sum;
    }
}
/*关键区别：

​​storage引用​​：
在_f函数中，所有参数都是storage引用
对这些参数的修改会直接修改合约状态
适用于需要在函数内部修改状态变量的场景

​​memory副本​​：
在g函数中，数组是memory类型
操作的是原始数据的独立副本，不影响storage
适用于需要临时处理数据但不改变状态的场景

​​calldata只读​​：
在函数中，数组是calldata类型
只能读取不能修改，最节省gas
适用于外部调用传递大量数据的场景

*/
