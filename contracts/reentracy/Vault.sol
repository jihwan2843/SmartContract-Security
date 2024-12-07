// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard {
    mapping(address => uint) balances;

    // bool locked;

    // modifier nonRenetrancy() {
    //     require(!locked, "locked");
    //     locked = true;
    //     _;
    //     locked = false;
    // }

    constructor() {}

    receive() external payable {}

    function depositETH() external payable {
        require(msg.value > 0, "deposit zero amount");

        uint amount = msg.value;
        balances[msg.sender] += amount;
    }

    function withdrawETH(uint amount) external {
        require(balances[msg.sender] >= amount, "not enough balance"); // check

        // already checked in require
        unchecked {
            balances[msg.sender] -= amount; // effect
        }

        (bool success, ) = payable(msg.sender).call{value: amount}( // interaction
            new bytes(0)
        );
    }

    /*
    재진입 공격을 막는 방법 3가지
    1. openzeppelin에서 제공하는 ReentrancyGuard 라이브러리 사용
    2. ReentrancyGuard를 직접 코드로 구현
    3. check-effect-interaction 패턴을 사용
    */
}
