// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//枚举类和一般基本类型不一样，必须先定义，后使用
contract Enum {
    //定义一个Status的枚举类型，定义了以下4个固定的状态选项
    enum Status {
        Pending,//=0
        Shipped,//=1
        Accepted,//=2
        Canceled//=3
    }

    //使用status变量声明为Status枚举类，默认值为第一个状态选项，也就是Pending=0
    Status public status;
    //获取当前状态的值，并返回Pending（不是返回0）
    function get() public view returns (Status) {
        return status;
    }

    //通过传入枚举对应的索引修改状态
    //Pending = 0, Shipped = 1, Accepted = 2, Canceled = 3
    //输入超出枚举有效范围的索引会导致调用失败
    function set(Status _status) public {
        status = _status;
    }

    //可以声明一个方法修改为指定的值
    function cancel() public {
        status = Status.Canceled;
    }

    //delete会重置当前的状态值为默认值
    function reset() public {
        delete status;
    }
}
/*
枚举的声明和导入
从外部声明一个枚举，文件名为EnumDeclaration.sol
*/
import "./EnumDeclaration.sol";

contract Enum2 {
    Status2 public status2;

    function get2() public view returns (Status2) {
        return status2;
    }
}
