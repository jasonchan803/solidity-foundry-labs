// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Primitives {
    bool public boo = true;
       
    uint8 public u8 = 1;            //uint8   ranges from 0 to 2 ** 8 - 1
    uint16 public u16 = 456;        //uint16  ranges from 0 to 2 ** 16 - 1
    uint256 public u256 = 123;      //uint256 ranges from 0 to 2 ** 256 - 1

    int8 public i8 = -1;
    int128 public i128 = 456;       //int128 ranges from -2 ** 127 to 2 ** 127 - 1
    int256 public  i256 = -123;     //int256 ranges from -2 ** 255 to 2 ** 255 - 1

    // int这个类型中最小的数和最大的数
    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    bytes1 a = 0xb5;    //  [10110101]
    bytes1 b = 0x56;    //  [01010110]

    //未赋值的变量具有默认值，分别是
    bool public defaultBoo;         //default = false
    uint256 public defaultUint;     //0
    int256 public defaultInt;       //0
    address public defaultAddr;     //0x0000000000000000000000000000000000000000
}
