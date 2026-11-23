// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
简单来说：​​
用 call 发送ETH​​ → 推荐
​​用 call 触发fallback​​ → 可以
但直接调用已知合约函数通常优先使用高级调用方式
低级 call 可以用于动态调用、与未知合约交互、代理等特殊场景，但需要自行处理调用成功状态、返回数据解码及其他安全问题
​​因为低级 call 缺少：​​
1、自动异常处理
2、编译时类型检查
3、函数存在性验证
4、返回数据自动解码
*/

contract Receiver {
    event Received(address caller, uint256 amount, string message);
    
    //建议添的receive函数，不添加报黄
    receive() external payable { }

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }
    
    function foo(string memory _message, uint256 _x)
        public 
        payable 
        returns (uint256)
    {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract Caller {
    event Response(bool success, bytes data);

    //假设这个Caller合约没有Receiver合约的源代码，但我们知道Receiver合约的地址和调用函数名
    function testCallFoo(address payable _addr) public payable {
        // 你可以发送以太币和指定一个特定的gas费
        (bool success, bytes memory data) = _addr.call{
            value: msg.value, 
            gas: 50000
             // 这里是你想要调用的函数的签名和参数
        }(abi.encodeWithSignature("foo(string,uint256)", "Call foo", 123));

        emit Response(success, data);
    }

    // 调用一个不存在的函数会触发fallback函数
    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}

/*
🔍 高级调用 vs 低级调用详解
✅ 直接调用就是高级调用！
​​你的理解完全正确​​：在Solidity中，​​直接调用就是高级调用​​，而使用 call、delegatecall、staticcall等才是低级调用。
📊 两种调用方式的对比
特性                    高级调用（直接调用）                            低级调用（call）
​​语法                      ​​contract.function()                       contract.call(数据)
​类型安全​                  ​✅ 编译时检查                               ❌ 无编译时检查
​​异常处理                  ​​✅ 自动冒泡                                 ❌ 手动检查
​​函数验证​                  ​✅ 检查存在性                               ❌ 不检查存在性
​​返回值处理                ​​✅ 自动解码                                 ❌ 手动解码
​​Gas限制​                   ​✅ 自动传递                                 ✅ 可自定义
​​推荐程度​                  ​✅ 优先使用                                 ⚠️ 特殊情况使用
*/ 
