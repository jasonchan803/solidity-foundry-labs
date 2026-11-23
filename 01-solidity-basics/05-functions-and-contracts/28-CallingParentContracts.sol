// 父合约函数可以通过合约名直接调用，也可以通过 super 调用
// 直接通过合约名调用会指定调用该合约的实现
// super 会根据 Solidity 的继承线性化顺序调用下一个实现
// 使用 super 链式调用可以避免菱形继承中公共祖先函数被重复调用

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract A {
    //这是一个事件，你可以通过函数发出一个事件，它会把信息记录在交易日志当中
    //在我们看来，事件可以用来追踪被调用的函数
    event Log(string message);

    function foo() public virtual {
        emit Log("A.foo called");
    }

    function bar() public virtual {
        emit Log("A.bar called");
    }
}

contract B is A {
    function foo() public override virtual {
        emit Log("B.foo called");
        A.foo();
    }

    function bar() public override virtual {
        emit Log("B.bar called");
        super.bar();
    }
}

contract C is A {
    function foo() public override virtual {
        emit Log("C.foo called");
        A.foo();
    }

    function bar() public override virtual {
        emit Log("C.bar called");
        super.bar();
    }
}

contract D is B, C {
    /*尝试
    调用 D.foo 然后检查它的交易日志，通过 D 继承 A 、B 和 C ，但它只调用 C 然后 A
    调用 D.bar 然后检查它的交易日志，通过 D 调用 C 然后 B ，最后 A
    */
    function foo() public override(B, C) {
        super.foo();
    }

    function bar() public override(B, C) {
        super.bar();
    }
}
/*
D.bar() 调用一次 super → 进入 C.bar()
C.bar() 再调用一次 super → 进入 B.bar()
B.bar() 再调用一次 super → 进入 A.bar()
A.bar() 没有再调用 super → 调用链结束
使用 super 调用父合约函数时，会按照 Solidity 的 C3 线性化顺序解析下一个实现。

如果当前函数没有继续调用 super，则调用链会在当前实现结束；
如果每一层都继续调用 super，则会沿线性化继承链逐层执行。

在菱形继承中，通过 super 链式调用可以使公共祖先的函数在这条调用链中只执行一次，
避免因分别调用不同继承分支而导致公共祖先函数被重复执行。
*/
