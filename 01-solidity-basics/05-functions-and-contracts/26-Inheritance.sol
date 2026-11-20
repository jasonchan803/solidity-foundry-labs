//Solidity支撑多重继承，合约通过“is”关键词去继承另一个合约
//父合约的函数如果需要被子合约重写必须声明virtual
//子合约的函数如果需要重写父合约的函数必须声明override
//继承的顺序非常重要
//你需要按照从最基础到最派生的的顺序列出父合约
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

//一个合约继承另一个合约使用“is”
contract B is A {
    //重写 A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    //重写 A.foo()
    function foo() public  pure virtual override returns (string memory) {
        return "C";
    }
}

// 合约可以继承多个合约
// 多重继承时，Solidity 使用 C3 线性化规则确定继承关系和函数解析顺序
// super 会按照线性化后的继承链调用下一个实现
// 简单来说 继承声明：左到右；super 解析：右到左。

contract D is B,C {
    //D.foo() returns "C"
    //由于 C 是最右侧的父合约并且带有foo()函数
    function foo() public pure override (B,C) returns (string memory) {
        return super.foo();
    }
}

contract E is C,B {
    //E.foo() returns "B"
    //由于 B 是最右侧的父合约并且带有foo()函数
    function foo() public  pure override (C,B) returns (string memory) {
        return super.foo();
    }
}

//继承必须按照最基础到最派生的顺序
//如果调转A和B的顺序会抛出编译错误
contract F is A,B {
    function foo() public pure override (A,B) returns (string memory) {
        return super.foo();
    }
}
