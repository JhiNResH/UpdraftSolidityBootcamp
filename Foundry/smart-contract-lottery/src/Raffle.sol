// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title Raffle
 * @author @JhiNResH
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRF v2.5 for randomness
 */
contract Raffle is VRFConsumerBaseV2Plus {
    /** Errors */
    // 相較於 require（），自定義錯誤省 gas
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(
        uint256 balance,
        uint256 playersLength,
        uint256 raffleState
    );

    /** Type Declarations */
    // enum（列舉）類型，用來表示「抽獎的狀態」
    // 一種自訂型別，可以自己定義一組命名常數，代表某個狀態或選項
    // 通常用來表示合約狀態
    // ex. 流程控制, 條件判斷, 避免錯誤狀態傳入, 治理投票/提案, NFT 鑄造階段控制
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1
    }

    /** State Variables */
    uint256 private immutable i_entranceFee;
    // @dev The duration of the lottery in seconds
    // i_interval 表示間隔時間
    uint256 private immutable i_interval;

    // private 表示此變數能內部合約使用（只可以從內部寫入）
    // s_players 表示儲存在鏈上的參與者清單
    address[] private s_players;
    uint256 private s_lastTimestamp;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    /** Events */
    // 一種鏈上紀錄的機制，前端或區塊鏈瀏覽器可以根據事件用來快速監聽
    // 配合 emit 使用
    // indexed 表示此事件可以被索引，可以被用來快速搜尋

    // Solidity 標準語法結構
    // <資料型別> [indexed] <事件參數>
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);
    event RequestedRaffleWinner(uint256 indexed requestId);

    // 合約的建構函式，只在部署時執行一次，初始化的概念
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        // uint256 作為參數
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimestamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }

    // payable 表示允許呼叫者傳送 ETH 給合約（函式可以接收 ETH）
    // 如果沒有 payable 則會被 revert
    // 通常搭配 msg.value 使用 => 可以獲取傳入的金額
    function enterRaffle() external payable {
        // 偏低效高氣費寫法
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!");

        //  0.8.20 版本
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle());

        // 最高效最低氣費寫法（全版本適用）
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }
        // push 用來在動態陣列新增一個元素
        // 將 msg.sender 新增到 s_players 地址中
        s_players.push(msg.sender);
        // 1. Makes migration easier
        // 2. Makes frontend "indexing" easier

        // 發出事件
        emit RaffleEntered(msg.sender);
    }

    // When should the winner be picked?
    /**
     * @dev This is the function that Chainlink nodes will call to see
     * if the lottery is ready to have a winner picked.
     * The following should be true in order for upkeepNeeded to be true:
     * 1. The time interval has passed between raffle runs.
     * 2. The raffle is in the OPEN state.
     * 3. The contract has ETH.
     * 4. Implicitly, your subscription is funded with LINK.
     * @param - ignored
     * @return upkeepNeeded - trueif its time to restart the lottery
     * @return - ignored
     */

    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData*/) {
        bool timeHasPassed = (block.timestamp - s_lastTimestamp) >= i_interval;
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;

        upkeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0");
    }

    // 1. Get a random number
    // 2. Use random number tp pick a player

    // 3. Be automatically called
    function performUpkeep(bytes calldata /* performData */) external {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        // Check to see if enough time has passed

        s_raffleState = RaffleState.CALCULATING;
        // Get our random number 2.5
        // 1. Request RNG
        // 2. Get RNG

        // s_vrfCoordinator 是 VRFConsumerBaseV2Plus 的屬性
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });
        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);

        // a bit redundant
        emit RequestedRaffleWinner(requestId);
    }

    // CEI: Checks, Effects, Interactions Pattern

    function fulfillRandomWords(
        // Checks
        // conditional checks
        uint256 /*requestId */,
        uint256[] calldata randomWords
    ) internal override {
        // Effects(Internal Contract State)

        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = payable(s_players[indexOfWinner]);
        s_recentWinner = recentWinner;

        s_raffleState = RaffleState.OPEN;
        s_players = new address[](0);
        s_lastTimestamp = block.timestamp;

        // Interactions(External Contract Interactions)

        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
        emit WinnerPicked(s_recentWinner);
    }

    /**
     * Getter Functions
     */

    // external 表示此合約只能從外部呼叫
    // view 表示此函式不會修改狀態，只會讀取狀態
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns (address) {
        return s_players[indexOfPlayer];
    }

    function getLastTimestamp() external view returns (uint256) {
        return s_lastTimestamp;
    }

    function getRecentWinner() external view returns (address) {
        return s_recentWinner;
    }
}

/**
 * 用了大量的 external 因為合約內部本身不會主動參與抽獎或是選中獎者
 * 使用 public 較花費氣費且會被誤以為內外皆可以調用
 * External => 用 call data 的氣費更低，專門給前端來調用與呼叫
 * Ｐrivate/ Internal => 更像後台是內部處理流程
 */
