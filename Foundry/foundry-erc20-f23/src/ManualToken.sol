// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract ManualToken {
    mapping(address => uint256) s_balances;
    // 定義了一個映射 (mapping),用於記錄每個地址的代幣餘額

    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    // string public name = "Manual Token";

    function totalSupply() public pure returns (uint256) {
        return 100 ether; // 1000000000000000000
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _value) public {
        uint256 previousBalance = s_balances[msg.sender] + s_balances[_to];
        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;
        require(s_balances[msg.sender] + s_balances[_to] == previousBalance);
    }
}
