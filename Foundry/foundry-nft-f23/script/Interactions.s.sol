// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    string public constant gf1 = "ipfs://bafybeihs6njua4n6ikobowx7p7z6ahy7spy2z7refzp2vv7vcq4wyfkk5m/?filename=gf1.json";
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        "BasicNft", 
        block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(gf1);
        vm.stopBroadcast();
    }
}