/*事件是一个强大的工具，能够实现多种高级的功能和框架，下面是一些事件的高级用法：
1、事件的筛选和监控能够实现实时的更新和分析功能
2、事件的日志分析和解码用于数据的提取和处理
3、事件驱动框架用于去中心化应用程序的研发
4、事件的订阅用于实时的通知和更新
*/

// 事件驱动框架
// 事件驱动框架合约展示了事件是如何协调和触发程序的不同阶段，例如转账开始和确认转账

// 事件订阅和实时更新
// EventSubscription 合约展示了如何实现事件的订阅功能，允许外部合约或者用户订阅并在事件发出时实时接收更新，
// 这同样展示了如何去处理事件的订阅和管理订阅的生命周期

// Solidity Event 本身不会自动触发其他合约的函数调用
// 链下程序可以监听 Event 并处理通知
// 下面的 EventSubscription 是通过链上订阅者列表和主动函数调用实现的回调机制

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//事件驱动框架
contract EventDrivenArchitecture {
    // 声明一个记录转账开始阶段的事件
    event TransferInitiated (address indexed from, address indexed to, uint256 value);
    // 声明一个记录转账确认阶段的事件
    event TransferConfirmed (address indexed from, address indexed to, uint256 value);

    mapping (bytes32 => bool) public transferConfirmations;

    function initiateTransfer(address to, uint256 value) public {
        // 触发转账开始事件
        emit TransferInitiated(msg.sender, to, value);
        // 这里可以添加转账的逻辑
        // 当前仅演示事件记录流程，并未真正执行转账
    }

    function confirmTransfer(bytes32 transferId) public {
        require(!transferConformations[transferId], "Transfer already confirmed");
        transferConformations[transferId] = true;
        // 触发转账确认事件
        emit TransferConfirmed(msg.sender, address(this), 0);
    }
}

// 事件订阅和实时更新
interface IEventSubscriber {
    // 定义一个外部接口
    function handleTransferEvent(address from, address to, uint256 value) external;
}

contract EventSubscription {
    // 声明一个记录转账的事件
    event LogTransfer(address indexed from, address indexed to, uint256 value);

    mapping(address => bool) public subscribers;
    address[] public subscriberList;

    //订阅函数
    function subscribe() public {
        require(!subscribers[msg.sender], "Already subscribed");
        subscribers[msg.sender] = true;
        //把地址添加到订阅者列表中
        subscriberList.push(msg.sender);
    }

    //取消订阅函数
    function unsubscribe() public {
        require(subscribers[msg.sender], "Not subscribed");
        subscribers[msg.sender] = false;
        // 从订阅者列表中移除
        for (uint i = 0; i < subscriberList.length; i++) {
            //这里使用了交换并弹出的方式移除地址
            if (subscriberList[i] == msg.sender) {
                //首先通过遍历找到该地址，然后将最后一个地址把该地址替换掉
                subscriberList[i] = subscriberList[subscriberList.length - 1];
                //然后把最后的地址删掉
                subscriberList.pop();
                break;
            }
        }
    }

    //转账时触发事件
    function transfer(address to, uint256 value) public {
        //发出通知
        emit LogTransfer(msg.sender, to, value);
        //遍历所有订阅者，调用他们的handleTransferEvent方法通知他们
        for (uint i = 0; i < subscriberList.length; i++) {
            //具体的handleTransferEvent函数需要在订阅者自身实现
            IEventSubscriber(subscriberList[i]).handleTransferEvent(
                msg.sender, to, value
            );
        }
    }
}
/*最佳实践和建议
1、索引正确的事件参数可以实现高效的筛选和搜索，地址通常需要被索引，而交易金额普遍一般不需要
2、为了避免冗余事件发生，不要发出那些已经被底层库或者合约覆盖的事件
3、事件中不可以使用view和pure函数，因为他们通过存储日志来改变区块链的状态
4、要注意和发出事件相关的Gas费，尤其是当使用索引参数时，这可能会对你合约整体的Gas费的消耗产生影响
*/
