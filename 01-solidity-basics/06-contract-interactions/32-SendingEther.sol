// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
怎么去发送Ether呢？
你可以通过其他合约调用以下的方式来发送
1、transfer（固定2300 gas，失败时会自动回滚，但不会返回任何信息）
2、send（固定2300 gas，会返回布尔值，但失败时不会自动回滚）
3、call（可以指定需要的gas，可以返回布尔值和数据）

如何自动接收Ether呢？
一个合约如果想被动收到Ether必须至少有以下其中一个函数
1、receive() external payable
2、fallback() external payable
如果mag.data数据为空时，receive()会被调用，否则会调用fallback()

哪一种方式更加好呢？
call配合防重入保护机制是自从2019年12月后最推荐的方法
为了防止重入的情况发生
    在你调用其他合约前先完成所有状态变量的变更
    使用防重入的修饰符
*/

contract ReceiveEther {
    /*
    发送以太币
              |
        msg.data 是否为空?
             /  \
          是     否
          /        \
   receive() 是否存在?  执行 fallback()
         /  \
       是    否
       /       \
执行 receive()  执行 fallback()
    */
    // 函数通过receive接收Ether，msg.data必须为空
    receive() external payable {}

    // Fallback函数会在msg.data不为空时被调用
    fallback() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // 这个发送方法不再推荐
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // send会返回布尔值，告诉你转账成功还是失败
        // 这个发送方法不再推荐
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // call会返回布尔值告诉你转账成功还是失败，并且如果附带msg.value，可以一同返回
        // 这个发送方法是目前最推荐的
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
         // 实际使用返回数据，避免警告
        if (data.length > 0) {
            // 可以记录日志或处理返回数据
            emit CallReturnData(data);
            }
        }

event CallReturnData(bytes data);
    
}
