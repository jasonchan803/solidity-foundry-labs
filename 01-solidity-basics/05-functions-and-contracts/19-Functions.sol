// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Function {
    //函数可以返回多个值
    function returnMany() public pure returns (uint256, bool, uint256) {
        return (1, true, 2);
    }

    //可以按顺序重命名返回值
    function named() public pure returns (uint256 x, bool b, uint256 y) {
        return (1, true, 2);
    }

    //可以指定返回值的名字
    //在这种情况下，可以省略return
    function assigned() public pure returns (uint256 x, bool b, uint256 y) {
        x = 1;
        b = false;
        y = 3;
    }
    //当你调用其他函数时需要返回多个值的时候可以使用解构赋值
    function destructuringAssignments()
        public 
        pure
        returns (uint256, bool, uint256, uint256, uint256)
    {
        (uint256 i, bool b, uint256 j) = returnMany();

        //使用“，”可以省略不需要的赋值
        (uint256 x,,uint256 y) = (4, 5, 6);

        return (i, b, j, x, y); 
    }

    //不可以使用映射类型作为函数的参数和返回值

    //可以使用数组作为参数传入函数，参数要使用memory传入
    function arrayInput(uint256[] memory _arr) public {}

    //可以使用数组作为返回值从函数中返回，同样返回值也要使用memory返回
    uint256[] public arr;

    function arrayOutput() public view returns (uint256[] memory) {
        return arr;
    }
}

//通过传统顺序传入参数
contract XYZ {
    function someFuncWithManyInputs(
        uint256 x,
        uint256 y,
        uint256 z,
        address a,
        bool b,
        string memory c
    ) public pure returns (uint256) {}

    function callFunc() external pure  returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "c");
    }

//通过键值对传入参数
    function callFuncWithKeyValue() external pure returns (uint256) {
        return someFuncWithManyInputs({
            a: address(0),
            b: true,
            c: "c",
            x: 1,
            y: 2,
            z: 3
        });
    }
}
