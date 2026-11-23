// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//消息可以在链下签名，然后可以通过智能合约在链上进行验证

/*如何签名和验证
#签名
    1、创建一个消息用作签名
    2、对个消息进行哈希
    3、对这个哈希进行签名（链下进行，保持你的私钥安全）

#验证
    1、通过原始的信息重新进行哈希
    2、从原来的签名和重新哈希值中恢复签名者的地址
    3、对比恢复的签名者地址和声称的签名者的地址是否一致
*/

contract VerifySignature {
    /*
    早期版本的Web3.js语法（2018年左右的写法（较老））
        1、解锁你的MetaMask钱包
            使用web3.personal.sign  ⚠️ 自动选择账户
                web3.personal.sign(hash, web3.eth.defaultAccount, console.log); 
            或者使用ethereum.enable()   ⚠️ 已弃用
                ethereum.enable();
        2、将消息进行哈希
        getMessageHash(
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
            123,
            "coffee and donuts",
            1
        )

        hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"

    现代ether.js语法
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);      请求账户访问
            这个调用会：
            弹出MetaMask/钱包窗口，显示账户列表让用户选择，用户需要手动点击要连接的账户，返回用户选择的账户地址
            而不是像web3.personal.sign自动选择账户
    
    特性对比    web3.personal.signethers                signer.signMessage
    账户选择    ✅ 自动选择（默认账户）                 ✅ 手动选择（用户明确选择）
    用户体验    ❌ 可能不清晰用户用哪个账户             ✅ 明确显示使用哪个账户
    安全性      ⚠️ 可能意外使用错误账户                 ✅ 更安全，用户明确确认
    现代标准    ❌ 传统方式                            ✅ 现代最佳实践
    */

    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce
    )
        public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /*
    3、签名消息的哈希值，链下签名时（钱包内部完成）：
    # 旧版：使用浏览器
    account = "copy and paste account of signer here"
    ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

    # 现代ethers.js（singer方式）
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    const accounts = await ethereum.request({method: 'eth_accounts'});
    const signer = provider.getSigner();

    # 旧版：web3.personal.sign（回调方式）使用web3库
    web3.personal.sign(hash, web3.eth.defaultAccount, console.log)

    # 现代：signer.signMessage（Promise方式）
    const signature = await signer.signMessage(ethers.utils.arrayify(messageHash));

    不同的账户会有不同的签名
    0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */
    function getEthSignedMessageHash(bytes32 _messageHash)
        public 
        pure 
        returns (bytes32)
    {
        /*签名通过对以下格式（以太坊的标准签名格式）进行keccak256哈希，然后签名产生的：
        \x19Ethereum Signed Message\n" + len(msg) + msg*/
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }
    
    /* 4、验证签名
        signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
        to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
        amount = 123
        message = "coffee and donuts"
        nonce = 1
        signature =
        0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b 
     */
     function verify(
        address _signer,
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 _nonce,
        bytes memory signature
     ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
        /* ecrecover的简化数学公式：
        恢复的公钥 = 椭圆曲线点恢复算法(消息哈希, r, s, v)
        具体算法：
        1. 从r和v确定椭圆曲线点R
        2. 使用s和消息哈希计算临时点 
        3. 通过椭圆曲线运算恢复公钥点
        4. 从公钥点推导出以太坊地址
        */
    }

    function splitSignature(bytes memory sig)
        public 
        pure 
        returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            前32个字节储存着签名的长度

            add(sig,32) = pointer of sig +32
            这里就是跳过前32个字节的数据

            mload(p)读取内存地址p后面32字节的数据
            */

            // 所以真正的第一个32字节数据应该从第33个字节开始（在长度前缀之后）
            r := mload(add(sig, 32))
            // 第二个32字节数据
            s := mload(add(sig, 64))
            // 最后的1个字节数据（第三个32字节数据的第1个字节）
            v := byte(0, mload(add(sig, 96)))

            // 汇编会间接返回数据，所以不需要写 return (r, s, v)
            
        }
    }
}
/*最后注意⚠️
使用以下Remix内置的签名进行签名，Remix会对messageHash进行二次哈希，
导致最终出来的ethSignedMessageHash和signature都是不同的，已验证过

Sign the messageHash:

In "Deploy & Run Transactions" tab (which you're supposed to be on already)
Select the first account
Click on the icon after the + which is to sign a message, it will open a popup
Paste the messageHash（进行二次哈希）
Click "Sign"
Remix returns:
A hash (ethSignedMessageHash)
A signature (you'll need this for verification)

所以尽量不要使用Remix的内置签名进行签名
*/
