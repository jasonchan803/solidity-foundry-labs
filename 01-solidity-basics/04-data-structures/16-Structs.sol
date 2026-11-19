// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//通过创造一个结构体来定义你的类型
//可以把不同类型的变量组合成一个自定义的复合类型
//结构体可以在合约之外声明，也可以从其他合约中导入
contract Todos {
    struct Todo {
        string text;
        bool completed; // 默认值为 false
    }

    // 声明一个名为Todo结构体类型的动态数组
    Todo[] public todos;

    function create(string calldata _text) public {
    // calldata 是数据位置，表示参数存储在调用数据区，对不可变的外部参数最有效
    // 3种方式去初始化一个结构体
        // 第一种：像调用函数一样初始化结构体
        // _text 作为第一个参数传入，false 作为第二个参数传入
        todos.push(Todo(_text, false));

        // 第二种：键值映射
        todos.push(Todo({text: _text, completed: false}));

        // 第三种：初始化一个空的结构体然后对其进行修改
        Todo memory todo;
        todo.text = _text;
        // todo.completed 初始化为 false

        todos.push(todo);
    }

    // Solidity 会自动为 “todos” 创建一个 getter 函数
    // 所以实际你不需要以下的函数
    function get(uint256 _index)
        public
        view
        returns (string memory text, bool completed)
    {
        // 这里使用memory也可以，但这样会先将结构体复制到memory，再从内存中读取，所以这里使用storage直接引用是合理的且节省了不必要的复制
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // 修改 text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // 修改 completed
    function toggleCompleted(uint256 _index) public {
        // 通过storage引用修改字段会直接更新区块链状态
        Todo storage todo = todos[_index];
        // ！运算符是逻辑非操作，将布尔值反转（true变false，false变true）
        todo.completed = !todo.completed;
    }
}
//从外部导入结构体
import "./StructDeclaration.sol";

contract Todos2 {
    Todo2[] public todos2;
}
