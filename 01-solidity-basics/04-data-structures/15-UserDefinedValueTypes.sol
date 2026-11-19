// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//表示时间间隔，基于uint64类型
type Duration is uint64;    //元数据：描述时间段的特性     
                            //元数据的描述性：说明数据的含义、格式、来源
                            //元数据的结构性：定义数据之间的关系
                            //元数据的管理性：帮助组织、检索数据
//表示时间戳，基于uint64类型
type Timestamp is uint64;   // 主数据：具体时间点
//表示一个组合的时间结构，基于uint128类型
type Clock is uint128;
//定义一个名为LiClock的库，库在Solidity中是可以重复使用的代码模块
library LibClock {
    //wrap函数，把Duration和Timestamp打包成一个Clock
    function wrap(Duration _duration, Timestamp _timestamp)
        internal    //只能在合约内部或者继承合约中调用
        //返回打包后的Clock
        pure returns (Clock clock_) //pure不读取也不修改区块链状态
    {
        //汇编的代码块
        //使用Yul汇编语言进行底层操作
        assembly {
            clock_ :=or(shl(0x40, _duration), _timestamp)
            //shl(0x40, _duration):将_duration左移64位（0x40是64的十六进制）
            //or（...）：将左移后的Duration和timestamp进行按位操作
            //把结果赋值给_clock
        }
    }

    function duration(Clock _clock)
        //从Clock中提取Duration，_clock：要解包的Clock
        internal
        pure
        returns (Duration duration_)
        //返回提出的Duration
    {
        //汇编
        assembly {
            duration_ := shr(0x40, _clock)
            //shr(0x40, _clock)：将_clock右移64位，获取高位的Duration
            //把结果赋值给Duration
        }
    }

    function timestamp(Clock _clock)
        //从Clock中提取Timestamp，_clock：要解包的Clock
        internal
        pure
        returns (Timestamp timestamp_)
        //返回提出的Timestamp
    {   
        //汇编
        assembly {
            timestamp_ := shr(0xC0, shl(0xC0, _clock))
            //shr(0xC0, _clock)：先左移192位，将64位移到高位
            //shr(0xC0, ...)：再右移192位，将数据移回原位，但只保留低64位
            //把结果赋值给timestamp_
        }
    }
}
/*
为什么使用Yul汇编而不使用Solidity
    内存效率​​：两个数据合并存储节省空间
    ​​操作效率​​：位运算比数学计算快10-100倍
    ​​原子性​​：确保两个时间数据总是同步处理
    ​​Gas节省​​：在区块链上每个操作都省钱

位运算的重点：
    EVM实际操作的是一个256位的寄存器，原始数据都在最右边，左边自动补0
    通过左移和右移把多余的数据推出数据边界，然后回移到原位，获得纯净的数据

已经把数据推出边界了，为什么还要回移呢？
    因为上面已经定义了数据为uint64类型，如果不右移回数据，系统也会自动截断超出部分，截取低256位中的低64位，导致取得结果是0，而不是timestamp
    所以得到结论：
    ​​必须​​进行右移操作来重新定位数据
    直接返回左移结果会导致数据错位
    这种"移位-回移"模式是EVM中的标准做法
    即使看起来多余，也是保证正确性的必要操作
*/
// Clock library without user defined value type
library LibClockBasic {
    function wrap(uint64 _duration, uint64 _timestamp)
        internal
        pure
        returns (uint128 clock)
    {
        assembly {
            clock := or(shl(0x40, _duration), _timestamp)
        }
    }
}

//使用和不使用用户定义值类型(User Defined Value Types, UDVT)的对比
contract Examples {
    function example_no_uvdt() external view {
        // 不使用用户定义值类型
        uint128 clock;
        uint64 d = 1;
        uint64 t = uint64(block.timestamp);
        clock = LibClockBasic.wrap(d, t);   // 正确顺序
        clock = LibClockBasic.wrap(t, d);   // 错误顺序但编译（没有报错）
    }

    function example_uvdt() external view {
        // 使用用户定义值类型
        Duration d = Duration.wrap(1);
        Timestamp t = Timestamp.wrap(uint64(block.timestamp));
        // 通过解包把用户定义值类型转换为基础数据类型
        uint64 d_u64 = Duration.unwrap(d);
        uint64 t_u64 = Timestamp.unwrap(t);

        // LibClock 例子
        Clock clock = Clock.wrap(0);    // 将UDVT实例的初始值设为0
        clock = LibClock.wrap(d, t);    // 正确顺序
        // clock = LibClock.wrap(t, d); // 错误顺序且不能编译（会报错）
        
    }
}
/*总结：
UDVT等于给一个类型再套上一件外衣，相当于wrap，但它内在还是基于uint类型，
通过这样在写入合约是可以更加准确的对应传入值的位置，避免出现顺序错误，但
使用时就必须多一步，必须把外衣脱掉才能把里面的值取出来，相当于unwrap
*/
