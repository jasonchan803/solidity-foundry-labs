// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//映射的语法是  mapping(keyType（键） => valueType（值）)
//可以理解为Python的字典，存储结构同样以键值对的形式存在，映射后通过某个键查询某个值或者修改某个值
/*
一、键(Key)的类型限制
    允许使用的键类型：
        ​​基本类型​​：
        address (地址类型)
        uint/int (各种长度的整数类型)
        bytes/bytesN (字节类型，如bytes32)
        bool (布尔类型)
        string (字符串类型)
        ​​合约和枚举​​：
        合约类型(contract types)
        枚举类型(enums)
    不允许使用的键类型：
        ​​复杂类型​​：
        其他映射(mapping)
        结构体(struct)
        数组(array)
        动态长度的字节数组(bytes)
        ​​特殊类型​​：
        浮点数类型(floating point types)
        函数类型(function types)
二、值(Value)的类型
    值可以是​​任何类型​​，包括：
    ​​所有基本类型​​：
        uint/int (各种长度)
        address/address payable
        bool
        bytes/bytesN
        string
    ​复杂类型​​：
        结构体(struct)
        数组(array)
        其他映射(mapping) - 这就形成了嵌套映射
        合约实例
        ​​特殊类型​​：
        枚举(enums)
        函数类型(function types)
*/
contract Mapping {
    //从地址映射为无符号整数
    mapping (address => uint256) public myMap;
    
    function get(address _addr) public view returns (uint256) {
        //映射通常会返回一个值 也就是这个uint256
        //如果没有设置这个值，那么会返回默认值
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public {
        //通过地址设置（更新）映射的值
        myMap[_addr] = _i;
    }

    function remove(address _addr) public  {
        //重设该地址的映射的值为默认值
        delete myMap[_addr];
    }
}

contract Mapping2 {
    //从动态字节类型映射为无符号整数
    mapping (bytes => uint256) public myMap;
    
    function get(bytes memory _byte) public view returns (uint256) {
        //映射通常会返回一个值 也就是这个uint256
        //如果没有设置这个值，那么会返回默认值
        return myMap[_byte];
    }

    function set(bytes memory _byte, uint256 _i) public {
        //通过动态字节类型 Key 设置（更新）映射的值
        myMap[_byte] = _i;
    }

    function remove(bytes memory _byte) public  {
        //重设该 Key 的映射的值为默认值
        delete myMap[_byte];
    }
}

//嵌套映射，就是在映射的值中再添加一个映射
contract NestedMapping {
    mapping (address => mapping (uint256 => bool)) public nested;
    //从地址映射为另一个映射体
    function get(address _addr1, uint256 _i) public view returns (bool) {
        //从可以从值中获取另一个映射体
        //即使这个映射体还没有被初始化
        return nested[_addr1][_i];
    }

    function set(address _addr1, uint256 _i, bool _bool) public {
        nested[_addr1][_i] = _bool;
    }

    function remove(address _addr1, uint256 _i) public {
        delete nested[_addr1][_i];
    }
}
