//父合约可以直接被调用，也可以通过关键词“super”调用
//通过使用关键词“super”，所有直接的父合约会被调用

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
    虽然super调用 B 和 C ，但是只会调用一次A.foo
    */
    function foo() public override(B, C) {
        super.foo();
    }

    function bar() public override(B, C) {
        super.bar();
    }
}
/* 根据super的特性，相同的函数不会被多次调用，因为B.foo和C.foo都有相同函数A.foo()，按顺序从右往左检查，super只会
调用第一个找到的父合约，也就是只调用的了C.foo(),而不会调用B.foo()，它不会继续往上解析继承链
但bar()中使用的是super.bar，相当于super嵌套，这会向上继续解析继承链，所以它会理解整个继承链是一个菱形的继承链，
也因为super中特性，避免一个函数被多次调用，所以最后D.bar()​: 调用 C.bar() → B.bar() → A.bar() (因为使用 super 链式调用)
*/
