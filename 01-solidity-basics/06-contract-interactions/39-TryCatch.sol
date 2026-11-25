// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// try/catch 用于捕获外部合约调用或合约创建过程中的异常
// 不能直接用于捕获普通内部函数调用的异常

contract Foo {
    address public owner;

    constructor(address _owner) {
        require(_owner !=address(0), "invalid address");
        assert(_owner != 0x0000000000000000000000000000000000000001);
        owner = _owner;
    }

    function myFunc(uint256 x) public pure returns (string memory) {
        require(x != 0, "require failed");
        return "my func was called";
    }
}

contract Bar {
    event Log(string message);
    event LogBytes(bytes data);
    event Logaddr(address addr);

    Foo public foo;
    constructor() {
        // 这个 Foo 合约被作为例子展示 try catch 在外部的调用
        foo = (new Foo)(msg.sender);  // 调用者成为owner
    }

    // tryCatchExternalFoo(0)
    //   myFunc 内 require(x != 0, "require failed") 触发 revert
    //   被 catch Error(string memory reason) 捕获
    //   依次触发：Log("require failed")、Log("external call failed")
    // tryCatchExternalFoo(1)
    //   调用成功，进入 try 分支
    //   触发：Log("my func was called")
    function tryCatchExternalFoo(uint256 _i) public {
        try foo.myFunc(_i) returns (string memory result) {
            emit Log(result);
        } catch Error(string memory reason){
            // 此 catch 分支用于捕获 Error(string) 类型的 revert
            // 其他类型的异常如果没有对应的 catch 分支，仍可能向上传播
            emit Log(reason);
            emit Log("external call failed");
        }
    }

    // tryCatchNewContract(address(0))
    //   构造函数 require(_owner != address(0), "invalid address") 失败
    //   被 catch Error(string memory reason) 捕获
    //   触发：Log("invalid address")
    // tryCatchNewContract(address(1))
    //   构造函数 assert 失败，产生 Panic(uint256)
    //   不是 Error(string)，被 catch (bytes memory reason) 捕获
    //   触发：LogBytes(Panic 的编码数据)
    // tryCatchNewContract(其他有效地址)
    //   创建成功，触发：Log("Foo created")、Logaddr(新合约地址)
    function tryCatchNewContract(address _owner) public {
        try new Foo(_owner) returns (Foo Newfoo) {
            // 如果成功，try会触发事件"Foo created"，并且返回新创建的合约foo
            emit Log("Foo created");
            emit Logaddr(address(Newfoo));


        } catch Error(string memory reason) {
            // 如果失败，catch 会抓住 revert() 或者 require() 的错误
            emit Log(reason);

        } catch (bytes memory reason) {
            // 捕获其他类型的异常数据，例如 Panic(uint256) 产生的错误数据
            emit LogBytes(reason);
        }
    }
}
