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
        // 上面的 require 已经完成余额检查，下面的 if/revert 属于重复检查
        // 这里只是演示 revert 的另一种使用形式

        balance = balance - _amount;
        // 最后检查一遍，取款后新的余额应该小于或者等于老的余额
        assert(balance <= oldBalance);
        // assert 不应主要作为用户输入验证手段，而是用于内部不变量/逻辑假设检查。
    }
}
// Solidity 0.8.0 以前通常需要手动检查整数溢出
// 0.8.0 及以后版本默认会检查溢出，发生溢出时自动 revert
// 因此这里的 require 属于旧版本常见的防溢出写法
/*
虽然 Solidity 0.8.0 及以后版本默认提供整数溢出和下溢检查，
但并不意味着 require、revert 和 assert 就不再重要。

require 和 revert 仍然可以用于业务条件检查，并提供更明确的错误信息，
帮助调用者理解交易失败的原因。

assert 则主要用于验证内部逻辑和不变量，
如果触发，通常意味着代码中存在不符合预期的逻辑错误。

需要注意，交易发生 revert 时，已消耗的 Gas 并不会退还。
*/
