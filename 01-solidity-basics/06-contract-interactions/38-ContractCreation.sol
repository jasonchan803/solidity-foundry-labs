// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//合约可以通过new关键词创建其他合约，在0.8.0版本以后，new还支持通过create2设置指定的salt创建合约

contract Car {
    address public owner;
    string public model;
    address public carAddr;

    constructor(address _owner, string memory _model) payable {
        owner = _owner;
        model = _model;
        carAddr = address(this);
    }

    function initialize() external {}
}

//通过合约工厂批量创建合约
contract CarFactory {
    Car[] public cars;

    //普通创建合约
    function create(address _owner, string memory _model) public {
        Car car = (new Car)(_owner, _model);
        cars.push(car);
    }

    //普通带转账的创建合约
    function createAndSendEther(address _owner, string memory _model)
        public 
        payable 
    {
        Car car = (new Car){value: msg.value}(_owner, _model);
        cars.push(car);
    }

    //指定盐值可预计算的创建合约
    function create2(address _owner, string memory _model, bytes32 _salt)
        public 
    {
        Car car = (new Car){salt: _salt}(_owner, _model);
        cars.push(car);
    }

    //指定盐值可预计算带转账的创建合约
    function creare2AndSendEther(address _owner, string memory _model, bytes32 _salt)
        public 
        payable
    {
        Car car = (new Car){salt: _salt, value: msg.value}(_owner, _model);
        cars.push(car);
    }

    //获取指定合约的数据
    function getCar(uint _index)
        public
        view
        returns (
            address owner,
            string memory model,
            address carAddr,
            uint256 balance
            )
    {
        Car car = cars[_index];

        return (car.owner(), car.model(), car.carAddr(), address(car).balance);
    }
}

/*
1. 普通 CREATE 的地址生成
计算公式
地址 = keccak256(部署者地址 ++ nonce)[12:]

2. CREATE2 的地址生成
计算公式
地址 = keccak256(0xFF ++ 部署者地址 ++ salt ++ keccak256(init_code))[12:]
init_code：包含合约代码 + 构造函数参数（_owner和 _model）的完整字节码

3. 对比表格
特性                        CREATE                               CREATE2
地址决定因素                工厂地址 + nonce            0xFF + 工厂地址 + salt + bytecode哈希
可否预计算地址              ❌ 否                                 ✅ 是
参数是否影响地址            ❌ 否                                 ✅ 是
相同输入产出                每次不同                              永远相同
在CarFactory中的使用    new Car(_owner, _model)         (new Car){salt: _salt}(_owner, _model)

各要素影响验证表
修改部分                 影响层级                  地址变化幅度                    类比
修改Car合约代码      完全改变init_code                100%不同                 更换汽车生产线
修改_owner地址       改变参数编码部分                 局部不同                  同生产线换车主
修改_model字符串     改变参数编码部分                 局部不同                 同生产线换车型
修改salt值           改变主哈希输入                   100%不同                  换停车位编号
*/
