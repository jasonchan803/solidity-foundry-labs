// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// ABI编码就是将我们的语言编码成机器听得懂的语言，所有函数调用的底层的逻辑都是通过ABI编码后执行的，ABI编码已成为一种标准

interface IERC20 {
    function transfer(address, uint256) external;
}

//  隐式声明为IERC20接口，并没有实现函数功能

contract Token {
    function transfer(address _to, uint256 _amount) payable external {
        //  实现函数功能
    }
}


// abi.encodeWithSignature：通过手动提供的函数签名字符串和参数编码调用数据
// abi.encodeWithSelector：通过手动提供的函数选择器和参数编码调用数据
// abi.encodeCall：引用函数并根据函数原型编码参数，具有编译时类型检查优势
// 以上方法都只负责编码调用数据，不会验证目标地址是否真正实现该函数
contract AbiEncode {

    function test(address _contract, bytes calldata data) external {
        (bool ok,) = _contract.call(data);
        require(ok, "call failed");
    }

    function encodeWithSignature(address to, uint256 amount)
        external
        pure returns (bytes memory) 
    {
        //  不会对输入进行任何检查
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function encodeWithSelector(address to, uint256 amuont)
        external 
        pure 
        returns (bytes memory)
    {   
        //  隐式声明为IERC20接口,通过IERC20.transfer.selector直接引用接口中的函数选择器
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amuont);
    }

    function encodeCall(address to, uint256 amount)
        external 
        pure
        returns (bytes memory)
    {
        //  显示声明为IERC20接口,通过IERC20.transfer直接引用接口中的函数
        //  检查selector和参数
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}

/*「显式」与「隐式」​​在Solidity中，接口关联方式应分为三个层级
    1. ​​合约继承层面的显式声明​​（最强关联）

        contract MyToken is IERC20 { // 显式继承
            function transfer(address, uint) external override {...}
        }
        使用is语法明确声明实现接口
        必须实现所有接口函数（除非标记abstract）
        合约类型会被识别为该接口类型


    2. ​​函数调用层面的显式依赖​​（中等关联）

        abi.encodeCall(IERC20.transfer, (to, amount));
        直接引用接口中的函数原型
        ​​不算隐式​​，因为明确指定了IERC20.transfer
        编译器会验证参数类型匹配性


    3. ​​二进制层面的隐式匹配​​（最弱关联）

        contract Token {
            function transfer(address, uint) external {} // 签名匹配但无声明
        }
        仅函数签名与接口匹配
        无编译时类型关联
        不能被当作IERC20类型使用
*/
