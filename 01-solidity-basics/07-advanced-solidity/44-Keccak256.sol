// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Keccak256哈希算法特点
    1、输入任意长度的数据，都会生成一个固定长度为32字节的哈希值。
    2、相同的输入只会生成相同的哈希值，不同的输入会生成不同的哈希值，但理论上可能存在哈希碰撞
    3、哈希函数具有单向性，无法通过哈希值在计算上有效地还原原始输入
    4、哈希用于密码学中的签名认证，由于原数据过于冗长，并且每个哈希值只对应一个数据，
    所以只需要签名哈希就可以通过认证，因为只要原数据有一点修改，哈希值就会不一样，通过签名哈希可以节省很多资源

abi.encode和abi.encodepacked总结
    abi.encode
        1、编码成字节数据并且自动补零
        2、保护所有的数据信息
        3、当你处理动态类型的数据的时候会更安全
        4、因为自动补零，所以输出更长的数据，相当gas费也会消耗更多
    abi.encodepacked
        1、进行压缩编码，不会补零
        2、相比abi.encode会输出更短的数据
        3、Packed 编码通常生成更短的编码结果，但实际 Gas 优势取决于输入类型与使用场景
        4、使用相同的动态数据类型有可能会出现哈希碰撞的风险
*/

contract HashFunction {
    function hash(string memory _text, uint256 _num, address _addr)
        public
        pure
        returns (bytes32 hash1, bytes32 hash2)
    {
        //将数据编码为字节数据并自动补零
        hash1 = keccak256(abi.encode(_text, _num, _addr));
        //进行压缩编码，不会补零
        hash2 = keccak256(abi.encodePacked(_text, _num, _addr));
        return (hash1, hash2);
    }


//  哈希碰撞例子
//  哈希碰撞发生在你传入多个相同动态类型的数据时去使用abi.encodepacked，这种情况下应该使用abi.encode
    function collision(string memory _text, string memory _text2) 
        public
        pure
        returns(bytes32)
    {
        //  encodepacked(AAA, BBB) -> AAABBB
        //  encodepacked(AA, ABBB) -> AAABBB
        // 多个动态类型使用 abi.encodePacked 编码时，如果边界无法明确区分，
        // 可能出现不同参数组合编码成相同字节序列的情况，进而产生哈希碰撞
        return keccak256(abi.encodePacked(_text, _text2));
    }
}

contract GuessTheMagicWord {
    bytes32 public answer = 
        0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;
    
    // 上面的字节数据是“Solidity”编码后的数据
    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
