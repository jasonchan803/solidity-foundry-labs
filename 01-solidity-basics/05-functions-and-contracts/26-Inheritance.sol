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
// 对于这里的多重继承结构，可以理解为继承声明从左到右排列，super 的解析顺序从右侧分支开始
// 实际的函数解析顺序由 Solidity 的 C3 线性化规则决定

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

// 多重继承的顺序需要符合 Solidity 的继承线性化规则
// 基础合约与派生合约的排列不正确可能导致编译错误
// 如果调转A和B的顺序会抛出编译错误
contract F is A,B {
    function foo() public pure override (A,B) returns (string memory) {
        return super.foo();
    }
}
