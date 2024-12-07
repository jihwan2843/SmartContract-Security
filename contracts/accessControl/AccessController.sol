// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessController is Ownable, AccessControl {
    // Role-based로 관리하기
    bytes32 public constant ACCESS1 = keccak256(abi.encodePacked("ACCESS1"));
    bytes32 public constant ACCESS2 = keccak256(abi.encodePacked("ACCESS2"));

    // White list로 관리하기
    mapping(address => bool) whiteList;

    // Secret
    uint private immutable PASSWORD;

    constructor(uint _password) Ownable(msg.sender) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        PASSWORD = _password;
    }

    function isWhiteList(address account) external view returns(bool){
        return whiteList[account];
    }

    function isLevel1(address account) external view returns(bool){
        return hasRole(ACCESS1, account);
    }

    function isLevel2(address account) external view returns(bool){
        return hasRole(ACCESS2, account);
    }

    function getPassword() external view onlyRole(ACCESS2) returns(uint){
        return PASSWORD;
    }

    // 특정 주소를 화이트리스트로 설정
    function setWhiteList(address account, bool state) external onlyOwner{
        whiteList[account] = state;
    }

    // 특정 주소에 level 1 권한 부여
    function grantLevel1(address account) external onlyOwner{
        grantRole(ACCESS1, account);    
    }

    // 특정 주소에 level 2 권한 부여
    function grantLevel2(address account) external onlyOwner{
        grantRole(ACCESS1, account);    
        grantRole(ACCESS2, account);    
    }

    // 특정 주소에 level 1 권한 해제
    function revokeLevel1(address account) external onlyOwner{
        revokeRole(ACCESS1, account);
    }

     // 특정 주소에 level 2 권한 해제
    function revokeLevel2(address account) external onlyOwner{
        revokeRole(ACCESS1, account);
        revokeRole(ACCESS2, account);
    }
}
