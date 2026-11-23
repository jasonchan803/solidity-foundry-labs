// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//abi.encode 编码data为bytes
//abi.decode 解码bytes为data

contract AbiDecode {
    struct MyStruct {
        string name;
        uint256[2] nums;
    
    }

    function endcode(
        uint256 x,
        address adrr,
        uint256[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns (bytes memory) {
        return abi.encode(x, adrr, arr, myStruct);
    }


    function decode(bytes calldata data)
        external 
        pure
        returns (
            uint256 x,
            address addr,
            uint256[] memory arr,
            MyStruct memory mySturct
        )
    {
        // 解码data
        ( x, addr, arr, mySturct) = abi.decode(data, (uint256, address, uint256[], MyStruct));
    }
}
