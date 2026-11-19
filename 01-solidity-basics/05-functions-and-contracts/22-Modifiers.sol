/*函数修饰器可用于：
1、限制访问权限
2、验证传入的参数
3、防范重入漏洞攻击
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FunctionModifier {
    //我们会用下面这些变量去证明如何使用修饰器
    address public owner;
    uint256 x = 10;
    bool public locked;

    constructor() {
        //设置交易发起者为合约的所有者
        owner = msg.sender;
    }

    //修饰器会检查调用者是否是这个合约的所有者
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        //下划线只能用用于修饰器的内部
        //如果所有者是调用者，则继续执行函数主体剩余的代码
        _; 
    }
    
    //修饰器可以传入参数
    //修饰器可以检查传入的地址参数是否为全0地址（空地址）
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(address _newOwner)
        public
        //使用修饰器，可以同时使用多个修饰器
        onlyOwner
        validAddress(_newOwner)
        {
            owner = _newOwner;
        }

    //修饰器可以在函数调用之前或者之后被调用
    //下面这个修饰器可以防止函数在执行期间被再次调用
    modifier noReentrancy() {
        require(!locked, "No reentrancy"); //检查是否有锁);
        //如果已经上锁，则函数不能被调用
        locked = true; //上锁
        _; //执行函数主体
        locked = false; //解锁
    }

    function decrement(uint256 i) public noReentrancy {
        x -= i;
        
        if (i > 1) {
            //再次调用函数，实现递归调用自己
            decrement(i - 1);
            // 该递归调用会再次经过 noReentrancy 修饰器
            // 因为第一次调用已经上锁，所以第二次调用会 revert
            // 这里是演示锁的效果，不是一个能够成功执行的递归示例
        }
    }
}
