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

    //  tryCatchExternalCall(0) => Log("external call failed")  
    //      如果传入0   catch会抓住 require(_owner !=address(0), "invalid address") 这个错误
    //  tryCatchExternalCall(1) => Log("my func was called")
    //      如果传入1   try会通过   触发事件"my func was called"
    function tryCatchExternalFoo(uint256 _i) public {
        try foo.myFunc(_i) returns (string memory result) {
            emit Log(result);
        } catch Error(string memory reason){
            emit Log(reason);
            emit Log("external call failed");
        }
    }

    function tryCatchNewContract(address _owner) public {
        try new Foo(_owner) returns (Foo Newfoo) {
            // 如果成功，try会触发事件"Foo created"，并且返回新创建的合约foo
            emit Log("Foo created");
            emit Logaddr(address(Newfoo));


        } catch Error(string memory reason) {
            // 如果失败，catch 会抓住 revert() 或者 require() 的错误
            emit Log(reason);

        } catch (bytes memory reason) {
            // 如果失败，catch 会抓住 assert() 的错误
            emit LogBytes(reason);
        }
    }
}
