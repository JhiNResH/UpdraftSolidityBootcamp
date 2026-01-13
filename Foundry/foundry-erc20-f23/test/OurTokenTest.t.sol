// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    // deployer: 部署腳本合約實例

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        // setUp() 的特殊性:
        // 會在每個測試函數執行之前自動運行
        // 確保每個測試都從相同的初始狀態開始
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        // vm.prank(address) 的作用:
        // 使下一次調用的 msg.sender 變成指定的地址
        // 只影響下一次調用,之後恢復正常
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
        // 檢查 Bob 的餘額是否等於 STARTING_BALANCE (100 ether)
        // assertEq(expected, actual): 斷言兩個值相等
        // 如果不相等,測試失敗
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
