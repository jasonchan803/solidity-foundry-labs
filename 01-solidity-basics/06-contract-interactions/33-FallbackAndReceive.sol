// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
fallback是一个特殊的函数，它会在以下其中一种情况出现时被执行
1、调用一个不存在的函数的时候
2、直接向合约发送Ether但该合约不存在receive函数或者msg.data不为空
*/
//当使用transfer或者send触发fallback函数时，fallback函数的gas费限制在2300以下，所以一般应该使用call触发，call没有gas限制

contract Fallback {
    event Log(string func, uint256 gas);

    //fallback函数必须声明为外部函数
    fallback() external payable {
        // send / transfer （只会传递2300gas去调用fallback函数，超过这个gas就会调用失败）
        // call （会传递剩余所有的gas去调用fallback函数）
        emit Log("fallback", gasleft());
    }

    // receive是fallback函数的一种变体，当msg.data为空时它会被触发
    receive() external payable {
        emit Log("receive", gasleft());
    }

    // 下面的辅助函数用来检查这个合约的余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendToFallback {

    // 实际会调用receive函数
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    // 因为msg.data为空，所以实际还是会调用receive函数
    function callToFallback(address payable  _to) public payable {
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

// fallback可以接受字节作为输入或者输入（但不是必要）

//TestFallbackInput -> FallbackInputOutput -> Counter
contract FallbackInputOutput {
    //使用immutable声明的变量在构造函数定义后不能改变
    address immutable target;

    constructor(address _target) {
        target = _target;
    }

    //通过fallback函数传入参数，并且返回输出的参数
    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call Failed");
        return res;
    }
}

contract Counter {
    uint256 public count;

    function get() external view returns(uint256) {
        return count;
    }

    function inc() external returns (uint256) {
        count += 1;
        return count;
    }
}

contract TestFallbackInputOutput {
    event Log(bytes res);

    function test(address _fallback, bytes calldata data) external {
        (bool ok, bytes memory res) = _fallback.call(data);
        require(ok, "call failed");
        emit Log(res);
    }
    
    function getTestData() external pure returns (bytes memory, bytes memory) {
        return 
            (abi.encodeCall(Counter.get,()), abi.encodeCall(Counter.inc,()));
    }
}
