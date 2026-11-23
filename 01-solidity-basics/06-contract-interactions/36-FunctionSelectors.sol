// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
当一个函数被调用，它的calldata（调用的数据包）前4个字节会指定要调用的函数
这4个字节就被称为函数选择器
看下面的例子，它使用call去执行一个指定的合约地址上的transfer函数

addr.call(abi.encodeWithSignature("transfer(address,uint256)", 0xSomeAddress,123)
abi.encodeWithSignature(....)这个参数返回的前4个字节就是函数选择器
函数签名由函数名和参数类型组成，不包含返回值类型、参数名或空格

可能你会节省小量的Gas费，如果你预计算并且将函数选择器内嵌在你的代码中
下面展示的是函数选择器是怎么计算出来的
*/

contract FunctionSelector {
    /*假设传入以下 _func
    "transfer(address,uint256)"                 返回0xa9059cbb
    "transferFrom(address,address,uint256)"     返回0x23b872dd
    */
    function getSelector(string calldata _func) 
    external 
    pure 
    returns (bytes4 selector) {
        // keccak256("transfer(address,uint256)")的前四个字节
        return bytes4(keccak256(bytes(_func)));
        //返回的4字节十六进制数据就是函数选择器
    }
}
