// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 从当前文件夹中导入
import "./Foo.sol";

// improt {特定符号的名字} from "./文件名"
/*特定符号举例
    名字                    类型
    User,                  结构体
    MyContract,            合约
    IMyInterface,          接口  
    MathLib,               库
    helperFunction,        自由函数
    MAX_VALUE,             常量
    InsufficientBalance,   错误类型
    UserRegistered,        事件
    Status                 枚举
*/
import {Unauthorized, add as func, Point} from "./extra/Foo.sol";

contract Import {
    //初始化 Foo.sol
    Foo public foo = (new Foo)();

    // 测试获取Foo.sol的name
    function getFooName() public view returns (string memory) {
        return foo.name();
    }
}
