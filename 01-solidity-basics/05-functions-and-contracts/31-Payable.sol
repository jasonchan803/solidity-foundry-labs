// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//函数和地址声明为payable可以将ether存入到合约中

contract Payable {
    // 可以通过transfer或者send发送ether到Payable类型的地址
    address payable public owner;

    // 声明为Payable的构造函数可以接收ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // 通过函数存入ether到本合约
    // 调用这个函数的时候可以附带一定数量ether
    // 合约的余额会自动更新
    function deposit() public payable {}

    // 调用这个函数的时候附带一定数量ether会导致这个函数抛出异常，由于这个函数没有被声明为Payable
    function notpayable() public {}

    // 通过这个函数就可以把这个合约全部的ether提现
    function withdraw() public {
        // 获取本合约的ether的余额
        uint256 amount = address(this).balance;

        // 发送所有ether到上面指定的owner地址
        (bool success,) = owner.call{value: amount}("");// 只返回交易是否成功，其他不返回
        // 要求必须是成功，否则交易回滚，宾返回以下字符串
        require(success, "Failed to send Ether");
    }

    // 通过函数把ether从本合约地址转到外部输入进来的地址
    function transfer(address payable _to, uint256 _amount) public {
        //把_to这个地址声明为payable才可以转出
        (bool success,) = _to.call{value: _amount}("");// 只返回交易是否成功，其他不返回
        // 要求必须是成功，否则交易回滚，宾返回以下字符串
        require(success, "Failed to send Ether");
    }
    // 注意：当前函数没有权限限制
    // 任何人都可以调用，并使用合约余额向指定地址转账
    // 实际合约需要根据业务需求添加访问控制
    // call 会触发接收方合约执行代码，实际合约中需要考虑重入风险
}
