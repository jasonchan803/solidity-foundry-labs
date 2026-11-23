// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// delegatecall是一个类似于call的低级函数
/* 当合约A执行delegatecall调用合约B时，会用合约A的所有状态变量和上下文变量执行合约B的代码,
你可以理解为借用合约B的函数在A合约里面执行*/

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
