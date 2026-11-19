// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//数据会存储在临时存储中，并且在交易后自动销毁
//确保EVM（以太坊虚拟机）版本和VM（虚拟机）版本设置为Cancun（坎昆）

//Storage - 数据存储在区块链上
//Memory - 数据在函数调用结束后会自动销毁
//Transient storage - 数据在交易结束后自动销毁

interface ITest {
    function val() external view returns (uint256);
    function test() external;
}
/*接口（Interface）的实现方式有两种形式:
​​显式继承实现​​（is关键字）：这种方式通过继承明确声明合约与接口的关系，并使用 override标记重写
        contract Example is IExample {
            function foo() external override { ... }
        }
        
​​隐式匹配实现​​：只要合约中的函数与接口定义的函数签名完全一致（包括可见性、参数、返回值等），即使未显式继承接口，也可通过接口类型调用。
        contract Example {
            function foo() external { ... } // 隐式匹配 IExample 的 foo() 函数
        }
*/

// 用于测试testing TestStorage和TestTransienStorage的合约
// 用于展示Storage（传统存储）和Transient storage（瞬态储存）之间的不同
contract Callback {
    uint256 public val;

    fallback() external {
        //因为是TestStorage或者TestTransienStorage调用这个fallback函数的，所以下面的msg.sender指TestStorage或者TestTransienStorage的地址
        //相当于再一次调用ITest接口的指定地址的val函数，所以最后返回的值是TestStorage或者TestTransienStorage中val的值
        val = ITest(msg.sender).val();
    }

    function test(address target) external {
        //初次调用接口函数，target为实现接口的合约地址，这里指TestStorage或者TestTransienStorage的地址
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val;

    function test() public {
        val = 123;
        bytes memory b = "";
        //因为是Callback函数调用的，所以msg.sender为Callback函数的地址，但Callback函数中没有用b函数，所以回触发Callback合约的fallback函数
        msg.sender.call(b);
    }
}

contract TestTransienStorage {
    bytes32 constant SLOT = 0;
    
    function test() public {
        assembly {
            tstore(SLOT, 321)
        }
        bytes memory b = "";
        msg.sender.call(b);
    }

    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
    }
}
// 测试恶意回调的合约
contract MaliciousCallback {
    uint256 public count = 0;

    //测试多次重新进入目标合约
    fallback() external {
        ITest(msg.sender).test();
    }

    //测试函数，用于发起重入攻击
    function attack(address _target) external {
        // 第一次调用测试
        ITest(_target).test();
    }
} 

// 测试重入保护的合约（普通储存带锁）
contract ReentrancyGuard {
    //locked默认是false（默认是无锁的）
    bool private locked;

    //modifier是修饰器，是 Solidity 的​​代码复用工具​​，用于在函数执行前后插入通用逻辑（如权限检查、状态验证）
    modifier lock() {
        //检查是否上锁了，如果没锁就继续往下执行，锁了就回滚交易
        require((!locked));
        //上锁
        locked = true;
        //被插入该locked修饰符的代码，这里指整个嵌套调用链完成才进行下一步，所以fallback的回调调用不会结束该函数，需等待回调完全返回
        _;
        //解锁
        locked = false;
    }
}
// 测试重入保护的合约（瞬态存储带锁）
contract ReentrancyGuardTransient {
    bytes32 constant SLOT = 0;

    modifier lock() {
        assembly {
            //检查SLOT是否为0，如果是就继续往下执行，如果不是，就回滚交易
            if tload(SLOT) { revert(0,0) }
            //上锁
            tstore(SLOT, 1)
        }
        //被插入该lock修饰符的代码
        _;
        assembly {
            //解锁
            tstore(SLOT, 0)
        }
    }

    function test() external lock {
        //忽略调用错误
        bytes memory b = "";
        msg.sender.call(b);
    }
}
