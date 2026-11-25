// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
合约有两种方法去调用其他合约
1、最简单的方法就是直接调用，像A.foo(x, y, z)
2、另一种调用方法就是使用低级调用，像call、delegatecall，staticcall等，这种方法接近更底层操作，可操作性更高，
但可读性和安全性更低，非必要不推荐使用这种方法
*/

contract Callee {
    uint256 public x;
    uint256 public value;

    function setX(uint256 _x) public returns (uint256) {
        x = _x;
        return _x;
    }

    function setXandSendEther(uint256 _x)
        public 
        payable 
        returns (uint256, uint256)
    {
        x = _x;
        value = msg.value;

        return (_x, value);
    }
}

contract Caller {
    function setX(Callee _callee, uint256 _x) public returns (uint256){
        //通过Callee _callee将_callee合约类定义为Callee合约
        uint256 x = _callee.setX(_x);

        return x;
    }
    
    function setXFromAddress(address _addr, uint256 _x) public {
        //通过Callee(_addr)将地址直接显示声明为Callee合约类型
        Callee callee = Callee(_addr);
        callee.setX(_x);
    }

    function setXandSendEther(Callee _callee, uint256 _x) public payable returns (uint256, uint256){
        //和上面一样，定义后可以直接调用该合约类型的函数，并返回该函数的数据
        (uint256 x, uint256 value) =
            _callee.setXandSendEther{value: msg.value}(_x);
        
        return (x, value);
    }
}
/*
可以把这个调用其他合约的方法类别成Python类实例化对象
Python需要实例化一个对象需要先有图纸，也就是先有类，再造对象，同样Solidity需要调用另一个合约的函数，同样需要图纸，
需要先定义这个合约，你可以通过定义类的方式，去把这个合约包装成这个合约类型，或者通过显示声明地址为该合约类型，或者你也
可以不包装，可以使用原有的合约直接通过new去新建一个合约调用，可以将合约类型理解为调用其他合约时使用的接口或类型描述。

通过合约类型声明地址后，可以调用该合约公开的函数。
但 Solidity 的调用属于链上交互，会产生 Gas 成本，并可能改变链上状态；
与普通 Python 对象调用有不同的执行环境和生命周期。
*/
