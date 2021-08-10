// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v3.3-solc-0.7/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 20000 * 10 ** decimals());
    }
}