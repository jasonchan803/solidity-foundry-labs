// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//交易支付使用ether         默认单位为wei
//​​Gas价格通常以gwei计价​​     1 gwei = 10**9 wei
//类似于1美元等于100美分    1 ether = 10**18 wei    1 ether = 10**9 gwei

contract EtherUints {
    uint256 public oneWei = 1 wei;
    //1 wei = 1
    bool public isOneWei = (oneWei == 1);

    uint256 public oneGwei = 1 gwei;
    //1 gwei = 10**9 wei
    bool public isOneGwei = (oneGwei == 1e9);

    uint256 public oneEther = 1 ether;
    //1 ether = 10**18 wei
    bool public  isoneEther = (oneEther == 1e18);
}
