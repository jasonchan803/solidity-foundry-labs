// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Gas 和 Gas Price

交易需要支付多少费用？
    交易费用使用 ETH 支付。

交易费用的基本计算方式：
    Gas Used × Effective Gas Price

Gas
    Gas 是衡量以太坊计算工作量的单位。
    交易和智能合约操作都会消耗 Gas。

Gas Used
    交易实际消耗的 Gas 数量。

Gas Price
    每单位 Gas 的价格。
    通常使用 Gwei 作为计价单位。
    1 Gwei = 10^9 Wei。

Gas Limit
    交易允许消耗的最大 Gas 数量。
    不同交易和合约操作需要的 Gas Limit 不同。

Gas Limit 的两个概念：

(1) Transaction Gas Limit（交易 Gas Limit）
    单笔交易允许消耗的最大 Gas 数量。
    用于限制交易可以执行的计算量。

    如果交易实际消耗的 Gas 小于 Gas Limit，
    未使用的 Gas 会退还给发送者。

    如果交易执行过程中 Gas 耗尽，
    交易会失败，状态修改会回滚。
    已消耗的 Gas 不会退还。

(2) Block Gas Limit（区块 Gas Limit）
    一个区块中所有交易能够消耗的 Gas 总量上限。
    用于限制区块内交易的总计算资源消耗。

Gas Refund（Gas 退款）
    交易未使用的 Gas 会退还给发送者。

    某些操作也可能产生 Gas Refund，
    例如清除存储数据。
    但这类退款受以太坊协议规则和退款上限限制。

Gas Fee Mechanism（Gas 费用机制）
    现代 Ethereum 交易费用主要包含 Base Fee 和 Priority Fee。

    Base Fee（基础费用）
        由协议根据网络状况动态调整。
        这部分费用会被销毁。

    Priority Fee（优先费用 / Tip）
        用户额外支付给验证者的费用，
        用于激励验证者优先打包交易。

    Effective Gas Price（实际 Gas 单价）
        实际支付的每单位 Gas 价格，
        取决于交易设置的费用参数
        以及交易被打包时所在区块的 Base Fee。

注意：
    Gas 消耗会受到 EVM 规则、执行的操作
    以及合约当前状态等因素影响。
    不应将某个 Gas 数值视为所有情况下的固定消耗。
*/

contract Gas {
    uint256 public i = 0;

    // 无限循环修改状态变量 i
    // 每次循环都会消耗 Gas
    // 最终交易会因为 Gas 耗尽而失败
    // 交易失败后，i 的状态修改也会回滚
    // 已消耗的 Gas 不会退还
    function forever() public {
        while (true) {
            // 修改状态变量会消耗 Gas
            // SSTORE 的实际 Gas 消耗取决于存储槽的状态
            i += 1;
        }
    }
}
