// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/*
您需要为交易支付多少费用？ether
总费用 = gas spent（实际消耗的gas） × gas price（每gas的价格）​
费用以以太币（ETH）支付。

​​Gas​​：以太坊中计算工作的基本单位。每笔交易或智能合约操作都会消耗一定量的gas（例如：转账消耗21,000 gas，复杂合约操作可能消耗更多）。
​​Gas Spent​​：交易实际消耗的gas量（≤ gas limit）。
​​Gas Price​​：用户愿意为每单位gas支付的ETH价格（单位：Gwei，1 Gwei = 0.000000001 ETH）。

Gas Limit 的两层上限​​
​​(1) 用户设置的 Gas Limit​​
    你为交易设定的​​最大gas用量​​（例如：发送ETH通常设21,000，合约交互可能设200,000）。
    ​​作用​​：防止因代码错误或计算复杂导致gas无限消耗。
    ​​实际费用​​：按min(gas spent, gas limit)计算。如果gas spent < gas limit，剩余gas会退款。
​​(2) 区块的 Gas Limit​​
    整个区块允许的​​最大gas总量​​（由网络动态调整，例如当前约3000万gas/区块）。
    ​​作用​​：限制区块大小，确保网络稳定。矿工会优先打包​​gas price高​​的交易。

Gas 退款规则​​
如果交易未用完设置的gas limit（例如：设50,000 gas但只用了30,000），剩余的20,000 gas会按原gas price退还。
​​例外​​：如果交易因gas不足失败（gas spent > gas limit），已消耗的gas​​不退款​​（防止恶意攻击）。
*/
contract Gas {
    uint256 public i = 0;

    //无限循环修改i变量，每次修改都会消耗gas，最终会导致所有gas耗尽
    //i的状态变量也因为交易失败而回滚，最终i的变量也没有修改成功
    //已消耗的gas不予返还
    function forever()public {
        while (true){
            //i += 1 是一个 ​​SSTORE​​ 操作（修改存储变量），每次执行大约消耗：
            //​​20,000 gas​​（如果从零值变为非零值）。
            //​5,000 gas​​（如果只是修改已存在的值）。
            i += 1;
            //第一次写入i变量消耗20000gas，后续每次修改消耗500gas
        }
    }
}
