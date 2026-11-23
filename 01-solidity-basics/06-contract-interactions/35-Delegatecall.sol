// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// delegatecall是一个类似于call的低级函数
// delegatecall 会执行目标合约的代码，但保留调用者的执行上下文
// 包括调用者的存储、地址上下文、msg.sender 和 msg.value
// 因此目标代码对状态变量的读写会作用于调用者的存储空间

// 先部署这个合约B
contract B {
    // 状态变量的类型和顺序必须和合约A一致，变量名可以不一致
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    event DelegateResponse(bool success, bytes data);
    event CallResponse(bool success, bytes data);

    function setVarsDelegateCall(address _contract, uint256 _num)
        public 
        payable 
    {
        //这里只会修改合约A的变量，合约B的变量不会被修改
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        emit DelegateResponse(success, data);
    }
    // 实际使用时必须检查 delegatecall 的成功状态
    // 不同合约的 Storage Layout 不匹配可能导致状态被错误修改
    // delegatecall 执行的代码拥有调用合约存储上下文的访问能力，需谨慎使用

    function setVarsCall(address _contract, uint256 _num)
        public 
        payable 
    {
        //这里只会修改合约B的变量，合约A的变量不会被修改
        (bool success, bytes memory data) = _contract.call{value: msg.value}(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        emit CallResponse(success, data);
    }
}
