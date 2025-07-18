# FundMe - Smart Contract Crowdfunding Platform

A decentralized crowdfunding platform built on Ethereum using Chainlink price oracles to ensure transparent and secure fundraising.

## 🎯 Project Overview

FundMe is a smart contract that allows users to send ETH for crowdfunding. The contract uses Chainlink price oracles to ensure each donation meets a minimum of 5 USD worth of ETH and provides secure fund withdrawal mechanisms.

## 🏗️ Architecture Design

### Core Components

1. **FundMe.sol** - Main crowdfunding contract
2. **PriceConverter.sol** - Price conversion library
3. **HelperConfig.s.sol** - Multi-chain configuration management
4. **DeployFundMe.s.sol** - Deployment script

### Technical Features

- ✅ **Price Oracle Integration**: Uses Chainlink to get real-time ETH/USD prices
- ✅ **Multi-chain Support**: Supports Sepolia, zkSync, and local test networks
- ✅ **Gas Optimization**: Implements more cost-effective withdrawal methods
- ✅ **Security Mechanisms**: Only contract owner can withdraw funds
- ✅ **Complete Testing**: Includes unit tests and integration tests

## 📋 Contract Functions

### Main Functions

| Function | Description | Permission |
|----------|-------------|------------|
| `fund()` | Send ETH for crowdfunding | Anyone |
| `withdraw()` | Withdraw all funds | Owner only |
| `cheaperWithdraw()` | More cost-effective withdrawal method | Owner only |
| `getAddressToAmountFunded()` | Query address donation amount | Anyone |
| `getFunder()` | Get funder address | Anyone |
| `getOwner()` | Get contract owner | Anyone |
| `getPriceFeed()` | Get price oracle address | Anyone |

### Special Functions

- **`receive()`**: Allows direct ETH sending to contract
- **`fallback()`**: Handles unknown function calls

## 🚀 Quick Start

### 1. Environment Setup

```bash
# Install dependencies
forge install

# Compile contracts
forge build
```

### 2. Run Tests

```bash
# Run all tests
forge test

# Run specific tests
forge test --match-test testFund

# Run tests with detailed logs
forge test -vvv
```

### 3. Local Deployment

```bash
# Start local node
anvil

# Deploy in another terminal
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
```

### 4. Testnet Deployment

```bash
# Set environment variables
export PRIVATE_KEY="your_private_key"
export SEPOLIA_RPC_URL="your_sepolia_rpc_url"
export ETHERSCAN_API_KEY="your_etherscan_api_key"

# Deploy to Sepolia
make deploy-sepolia
```

## 🧪 Test Suite

### Unit Tests (`test/unit/`)

- **FundMeTest.t.sol**: Core functionality tests
  - Fundraising tests
  - Withdrawal function tests
  - Permission control tests
  - Price oracle tests

### Integration Tests (`test/integration/`)

- **InteractionsTest.t.sol**: Contract interaction tests
  - End-to-end funding flow tests
  - Multi-user scenario tests

### Deployment Tests (`test/unit/`)

- **FundMeDeployTest.t.sol**: Deployment flow tests

## 🔧 Configuration Management

### HelperConfig.s.sol

Supports multi-chain configuration:

```solidity
// Supported networks
uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
uint256 public constant LOCAL_CHAIN_ID = 31337;
```

### Price Oracle Addresses

- **Sepolia**: `0x694AA1769357215DE4FAC081bf1f309aDC325306`
- **zkSync Sepolia**: `0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF`

## 📊 Gas Optimization

### cheaperWithdraw() vs withdraw()

| Method | Gas Consumption | Optimization |
|--------|----------------|--------------|
| `withdraw()` | Higher | Direct storage access |
| `cheaperWithdraw()` | Lower | Uses memory variables |

### Optimization Techniques

1. **Use memory variables**: Avoid repeated storage reads
2. **Batch operations**: Process multiple operations at once
3. **Gas limits**: Set reasonable gas limits

## 🔒 Security Considerations

### Implemented Security Mechanisms

- ✅ Minimum donation amount limits
- ✅ Owner permission controls
- ✅ Price oracle validation
- ✅ Reentrancy attack protection
- ✅ Overflow checks

### Best Practices

- Use `require()` for condition checks
- Implement `onlyOwner` modifiers
- Use `call()` for ETH transfers
- Avoid using `transfer()` and `send()`

## 🌐 Multi-chain Support

### Supported Networks

| Network | Chain ID | Status | Price Oracle |
|---------|----------|--------|--------------|
| Sepolia | 11155111 | ✅ Test | ETH/USD |
| zkSync Sepolia | 300 | ✅ Test | ETH/USD |
| Anvil (Local) | 31337 | ✅ Development | Mock |

### Network Configuration

```solidity
// Automatically detect network and use appropriate configuration
NetworkConfig memory config = helperConfig.getConfigByChainId(block.chainid);
```

## 📈 Performance Metrics

### Gas Consumption (Estimated)

| Operation | Gas Consumption |
|-----------|----------------|
| Contract Deployment | ~500,000 |
| Donation (5 USD) | ~80,000 |
| Fund Withdrawal | ~100,000 |
| Balance Query | ~25,000 |

## 🛠️ Development Tools

### Common Commands

```bash
# Format code
forge fmt

# Check code
forge check

# Generate gas report
forge snapshot

# Run specific tests
forge test --match-contract FundMeTest

# Deploy and verify
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### Debugging Tips

```bash
# Show detailed logs
forge test -vvvv

# Run specific test with trace
forge test --match-test testFund -vvvv

# Check contract size
forge build --sizes
```

## 📚 Learning Resources

### Related Concepts

- [Solidity Basics](https://docs.soliditylang.org/)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Ethereum Development](https://ethereum.org/developers/)

### Advanced Topics

- Price oracle integration
- Multi-chain deployment strategies
- Gas optimization techniques
- Security best practices

## 🤝 Contributing Guidelines

1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## ⚠️ Disclaimer

This is a learning project for educational purposes only. Please conduct thorough audits and testing before using in production environments.

---

**Developer**: Patrick Collins  
**Framework**: Foundry  
**Version**: 1.0.0
