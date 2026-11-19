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

//合约可以继承多个合约
//当一个被不同合约多次定义的函数被调用时，父合约会以深度优先的方式从右往左调用

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
