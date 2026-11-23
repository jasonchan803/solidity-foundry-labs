/*函数可以被声明为
public - 任何合约和外部账户都可以调用
private - 只能在合约内部定义函数，不可以外部调用和继承
internal - 只能在内部调用和继承
external - 可以被外部账户或其他合约调用，也可以被继承，但不能通过普通内部调用方式直接调用，不能使用 super 进行内部调用，
可以通过 this.func() 发起外部消息调用
*/
//状态变量可以被声明为public、private或者internal，但external不行

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Base {
    //private函数只能在合约内部被调用
    //通过继承这个父合约的子合约不可以调用此函数
    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }

    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }

    //internal函数可以在合约内部被调用
    //也可通过继承父合约内部的子合约调用
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }

    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc();
    }

    //Public函数可以被合约内部调用，也可以被其他合约和外部账户调用，还可以继承
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }

    //external函数可以被其他合约或者外部账户调用，继承调用需要用特殊方法
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    //除非我们在外部调用这个函数，否则这个函数会无法编译
    /*
    function testexternalFunc() public pure returns (string memory) {
        return externalFunc();
    }
    */

    //可以使用this.externalFunc()调用，但是会产生外部调用开销
    function called_externalFunc() external view returns (string memory) {
        return this.externalFunc();
    }
    /*原理如下
        调用 this.externalFunc()
    │
    ├── 创建一个新的消息调用（message call）
    ├── 产生额外的 gas 开销
    ├── 切换执行上下文
    ├── 参数通过 calldata 传递
    └── 返回值通过内存返回
    */


    //不同的修饰符声明状态变量
    string private privateVar = "my private variable";
    string internal internalVar = "my internal variable";
    string public publicVar = "my public variable";
    //状态变量不可以在合约内部使用external声明，否则会无法编译
    //string external externalVar = "my external varialbe";
}

contract Child is Base {
    
    //父合约的internal函数可以在子合约中调用
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc();
    }

    //继承合约无法直接访问private的函数和状态变量
    /*访问以下函数会导致无法编译
     function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    } 
    */

    //但可以通过public接口来暴露private函数和internal函数
    //从而实现在外部合约调用内部的private函数和internal函数
    function Child_testPrivateFunc() public pure returns (string memory) {
        // 通过public返回private函数
        return testPrivateFunc();
    }

    function Child_testInternalFunc() public pure returns (string memory) {
        // 通过public返回internal函数
        return testInternalFunc();
    }

    function Child_testexternalFunc() public view returns (string memory) {
        return this.externalFunc(); 
    }
//最后这三个函数完全没有必要，是冗余的函数，因为在父合约已经有实现返回private函数、internal函数的public接口和external函数的external接口
//因为继承的时候就会自动继承父合约的public和external函数接口，所以在这里重新写一次这个函数就是多此一举
}
