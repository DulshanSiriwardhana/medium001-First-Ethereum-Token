// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SaltCoinToken {
    string public name = "Salt Coin Token";
    string public symbol = "SCT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier sufficientBalance(uint256 _value) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        _;
    }

    modifier validAllowance(address _from, uint256 _value) {
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        _;
    }

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address _to, uint256 _value) public sufficientBalance(_value) returns (bool success) {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public sufficientBalance(_value) validAllowance(_from, _value) returns (bool success) {
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}