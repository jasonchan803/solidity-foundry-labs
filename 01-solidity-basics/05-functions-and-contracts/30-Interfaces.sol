// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//你可以通过声明一个接口来与其他合约进行交互
/*接口
    不可以在接口中实现任何函数功能
    可以从其他接口中继承（必须使用is，并且接口之间不可以实现重写，只有合约之间才可以实现重写）
    所有声明的函数必须都是external
    不可以声明构造函数
    不可以声明状态变量
*/

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

//这里没有使用is继承，而是使用了隐式匹配继承
//只要调用接口的时候接口有这个函数，然后实现接口的合约也有这个函数，就可以执行
//这样的好处在于可以先实现功能，后实现接口，接口和实现函数的合约之间没有直接关系，只要函数名匹配就可以调用

interface ICounter {
    function count() external view returns (uint256);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        //这里调用了接口，但是接口并没有实现任何功能，但是调用了接口的函数，只要传入的合约地址有匹配的函数，就可以执行实现了接口的合约的函数
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint256) {
        //只要传入的合约地址有这个状态变量并且声明为public，就可以执行，因为public会自动生成一个getter函数进行调用查看
        return ICounter(_counter).count();
    }
}

//  Uniswap 例子
interface UniswapV2Factory {
    //  获取交易对的接口，这里只给了接口，说明接口的函数已经在其他合约实现，但这里并没有写出来
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface UniswapV2Pair {
    //  获取交易对的储备量（流动性），和上面的接口一样，该接口函数已经在其他合约实现，直接调用即可
                                                       //  返回两个token的储备量和最后一次交易的时间戳
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract UniswapExample {
    //  下面都是真实的实现接口函数的地址和代币地址
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai =  0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function getTokenReserves() external view returns (uint256, uint256) {
        //  调用接口函数，传入两个Token参数并且将返回的交易对定义为pair
        address pair = UniswapV2Factory(factory).getPair(dai, weth); 
        //  调用接口函数，把pair以参数的形式传入接口，并返回两个token的储备量，因为这里不需要时间戳，所以可以不返回
        ( uint112 reserve0, uint112 reserve1, ) = UniswapV2Pair(pair).getReserves(); 
        return (reserve0, reserve1);
    }
}
