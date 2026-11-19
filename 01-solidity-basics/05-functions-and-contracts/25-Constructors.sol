//构造函数是一个可选函数，它会在合约创建的时候自动执行
//下面是一些例子介绍如何传递实参给构造函数

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//基础合约X
contract X {
    string public name;

    constructor ( string memory _name ) {
        name = _name;
    }
}

//基础合约Y
contract Y {
    string public text;

    constructor ( string memory _text ) {
        text = _text;
    }
}

//下面是两种方法去初始化带形参的父合约

//1、在继承的后面直接传入形参
contract B is X("Input to X"),Y("Input to Y") {}

//2、通过constructor传入形参
contract C is X, Y {
    //通过调用父合约的constructor函数传入形参，类似于修饰器
    constructor ( string memory _name, string memory _text )
        X(_name)
        Y(_text) {} //注意父合约的函数代码需写在{}外，而子合约函数的代码则写在{}内
     //这里的顺序和父合约的顺序一致
}

//不管子合约中调用父合约函数的顺序如何，父合约通常是按照继承顺序去调用,就是is后面的顺序

//下面构造函数的调用顺序
//1、X
//2、Y
//3、D
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

//下面构造函数的调用顺序
//1、X
//2、Y
//3、E
contract E is X, Y {
    constructor()Y("Y was called") X("X was called") {}
}
