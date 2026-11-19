// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//数组包含静态（固定）数组和动态数组
contract Array {
    //多种初始化数组的方法
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    //静态数组,会将所有元素初始化为0
    uint256[10] public myFixedSizeArr;
    //返回数组中某个元素
    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }
    //solidity可以返回整个数组
    //对于可能无限增长的数组，应谨慎返回整个数组，避免消耗过多 Gas
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public  {
        //在数组的末尾追加元素
        //这会使数组长度增加1
        arr.push(i);
    }

    function pop() public {
        //删除最后一个元素
        //这会使数组长度减1
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        //返回数组的长度
        return arr.length;
    }

    function remove(uint256 index) public {
        //移除数组中指定元素
        //删除并不会改变数组的长度
        //被删除的元素会被重置为默认值，也就是0
        delete arr[index];
    }

    function examples() external pure {
        //在内存中创建一个临时的数组，只可以创建静态数组
        //(5)代表创建了一个长度为5的数组（1个内层数组，一维数组）
        uint256[] memory a = new uint256[](5);
        //a = [1, 2, 3, 4, 5]
        a[0] = 1;
        a[1] = 2;
        a[2] = 3;
        a[3] = 4;
        a[4] = 5;

        //在内存中创建一个嵌套的数组
        //b = [[1, 2, 3], [4, 5, 6]]
        uint256[][] memory b = new uint256[][](2);
        //(2)代表创建了长度为2的外层数组（包含2个内层数组，二维数组）
        //但还没确定每个内层数组的长度，也就确定了2层，但是还没确定有多少列
        for (uint256 i = 0; i < b.length; i++) {
            b[i] = new uint256[](3);
            //通过for循环在外层数组元素中创建长度为3的内层数组，也就是每一层有3列的元素，默认元素都为0
            //结果结构：[[0,0,0], [0,0,0]]
        }
        b[0][0] = 1;
        b[0][1] = 2;
        b[0][2] = 3;
        b[1][0] = 4;
        b[1][1] = 5;
        b[1][2] = 6;
    }
}
