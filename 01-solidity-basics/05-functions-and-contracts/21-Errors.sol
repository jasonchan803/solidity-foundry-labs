//你可以通过调用require、revert或者assert来引出错误
//require用来在合约执行前验证外部输入的数据和条件
//revert和require很类似，当你的检查涉及多个变量或者负责逻辑时，使用revert会提供更好的可读性
//assert用于验证内部逻辑和不变的条件，检查永远为真的条件，assert显示错误表示该代码有严重的bug

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Error {
    function testRequire(uint256 _i) public pure {
        // Require 应该用于验证条件，例如：
        // 输入数据
        // 执行前的条件
        //调用其他函数返回的值
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure{
        // Revert 当条件验证复杂的时候可以使用
        // 这个代码实际上和上面Require的用法一致
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }
    uint256 public num;
    
    function testAssert() public view {
        // Assert 应该只用于测试内部的错误和检查那些你认为是对的条件，或者说理论上符合你这个内部逻辑的条件
        // 这里我们的num初始化后应该等于0
        // 在此之前num都不可能被修改为其他的值
        assert(num == 0);
    }

    // 自定义错误
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }
}
// 下面是另一个例子
contract Account {
    uint256 public balance;
    uint256 public constant MAX_UINT = 2 ** 256 - 1;

    function deposit(uint256 _amount) public {
        uint256 oldBalance = balance;
        uint256 newBalance = balance + _amount;

        // balance + _amount 不应该溢出（因为溢出后金额从最小开始，就会小于初始余额）
        // 正常应该是 balance + _amount >= balance，存款后的余额大于或等于初始余额
        // 如果小于初始金额，就会显示错误信息"Overflow"
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;
        // 最后再检查一遍，存款后新的余额应该大于或者等于初始余额
        assert(balance >= oldBalance);
    }

    function withdraw(uint256 _amount) public {
        uint256 oldBalance = balance;

        // balance - _amount 不应该下溢（因为下溢后金额从最大开始，就会大于取款数量）
        // 正常应该是 balance >= _amount, 取款数量应该小于或者等于初始余额
        // 如果大于初始金额，就会显示错误信息"Underflow"
        require(balance >= _amount, "Underflow");

        if(balance < _amount) {
            revert("Underflow");
        }

        balance = balance - _amount;
        // 最后检查一遍，取款后新的余额应该小于或者等于老的余额
        assert(balance <= oldBalance);
        // assert 不应主要作为用户输入验证手段，而是用于内部不变量/逻辑假设检查。
    }
}
// Solidity 0.8.0+ 默认启用整数溢出和下溢检查
// balance + _amount 如果发生溢出，会在执行到 require 前自动 revert
// 因此这里的 require(newBalance >= oldBalance) 是旧版本 Solidity 中常见的防溢出检查
/*
虽然在Solidity 0.8.0+ 以后的版本都自带防溢出保护，溢出后会自动回滚交易，但并不代表就不需要require、rever和assert
它们仍然有很大用处，其次溢出后 revert 仍然会消耗 Gas，而且交易 revert 后并不会告诉你什么原因，这个时候就
可以使用require、revert来检查到底是哪个地方出现问题，并把错误信息反馈出来，而assert则是最后一道防线，让你知道你
的代码是否存在严重的bug，如果没有这些错误的信息，用户在交互的时候就不会知道是什么原因导致的 revert ，体验感会大
打折扣，所以防溢出只是保障了交易不受到损失，但是require、rever和assert则是可以提高用户在使用过程的体验
*/
