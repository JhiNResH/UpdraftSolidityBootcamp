// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

// constant 是一開始就定死的數值
// immutable 是部署時才設定一次的值

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    // Track the funder address
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    // 合約的建構函式，只在部署時執行一次，初始化的概念
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent $5
        // 1. How do we send ETH to this contract
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH"); // 1e18 = 1ETH = 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

        // What is a revert?
        // Undo any action that have been done, and send the remaining gas back
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Must be owner!");

        // for loop
        // [1, 2, 3, 4] elements
        // 0, 1, 2, 3 indexes
        // for (/* starting index, ending index, step amount */ )
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

            // funders：是一個 address[] 類型的陣列，通常用來存放所有捐款過的使用者錢包地址。
            // funders.length：代表 funders 陣列目前有幾個地址，也就是贊助者的數量。
	        // funderIndex：是一個索引值，從 0 開始，一直到 funders.length - 1。
	        // addressToAmountFunded[funder] = 0;：這行的意思是將每一位贊助者對應的捐款金額設為 0，通常是為了「重置狀態」。
        }
        // reset the array
        funders = new address[](0);
        // actyally withdraw the funds

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();


        // transfer
                // msg.sender = address
                // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).
        
        /************************
        // 嘗試將合約中的所有 ETH 餘額傳送給呼叫者（msg.sender）
        // .send() 會傳回 true 或 false，表示是否成功傳送
        // .send() 只提供 2300 gas，如果對方是合約且 receive() 或 fallback() 耗費太多 gas，會導致傳送失敗
        bool sendSuccess = payable(msg.sender).send(address(this).balance);

        // require 檢查 send 是否成功
        // 如果 sendSuccess 為 false，整個交易會回退並顯示錯誤訊息
        require(sendSuccess, "Send failed");

        // 📌 備註：
        // - .send() 傳送 ETH 時有 gas 限制，較容易失敗
        // - Solidity 現在建議使用 .call{value: amount}("") 來替代 .send()
        // - bool 預設值為 false，必須手動設定或由函式回傳值決定
        ****************************/
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) {
            revert NotOwner();
        }
        // _; 指的是執行其他式子裡的方程式
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function?

    // 單純接受正確調用的錢
    receive() external payable {
        fund();
    }
    // 放止亂被調用，捕捉不合法或未知的呼叫
    // 記錄是誰呼叫了什麼奇怪的東西，方便日後分析或排查攻擊行為。
    // 實作 Proxy 合約
    // 創造可玩性: Easter Egg 合約
    fallback() external payable {
        fund(); 
    }
}