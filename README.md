# Solidity Bootcamp Project

A comprehensive Solidity smart contract development learning project featuring multiple practical contract examples and Foundry development environment setup.

## 📁 Project Structure

```
SolidityBootcamp/
├── Foundry/
│   └── FundMe/                    # Crowdfunding contract project
│       ├── src/                   # Smart contract source code
│       │   ├── FundMe.sol         # Main crowdfunding contract
│       │   └── PriceConverter.sol # Price conversion library
│       ├── script/                # Deployment scripts
│       │   ├── DeployFundMe.s.sol # Deployment script
│       │   ├── HelperConfig.s.sol # Configuration helper
│       │   └── Interactions.s.sol # Interaction script
│       ├── test/                  # Test files
│       │   ├── unit/              # Unit tests
│       │   ├── integration/       # Integration tests
│       │   └── mocks/             # Mock contracts
│       ├── lib/                   # Dependencies
│       ├── foundry.toml          # Foundry configuration
│       └── Makefile              # Build scripts
└── RemixSolidity/                # Remix IDE version
    ├── FundMe/                   # Crowdfunding contracts
    └── Storage/                  # Storage contracts
```

## 🚀 Main Features

### FundMe Crowdfunding Contract
- **Fundraising**: Allows users to send ETH for crowdfunding
- **Minimum Amount Limit**: Each donation requires at least 5 USD worth of ETH
- **Price Oracle**: Uses Chainlink price oracle to get ETH/USD exchange rate
- **Fund Withdrawal**: Only contract owner can withdraw all funds
- **Fallback Functions**: Supports direct ETH sending to contract

### Storage Contract
- **Simple Storage**: Basic data storage functionality
- **Struct Operations**: Demonstrates struct usage
- **Mapping Operations**: Shows mapping data structure
- **Factory Pattern**: StorageFactory contract demonstrates contract factory pattern

## 🛠️ Tech Stack

- **Solidity**: 0.8.19
- **Foundry**: Modern Ethereum development framework
- **Chainlink**: Decentralized oracle network
- **Forge**: Testing and deployment tools

## 📦 Dependencies

- `forge-std`: Foundry standard library
- `chainlink-brownie-contracts`: Chainlink contract library
- `foundry-devops`: DevOps tools library


### Compile Contracts

```bash
cd Foundry/FundMe
forge build
```

### Run Tests

```bash
forge test
```

### Deploy Contracts

1. Set up environment variables
```bash
cp .env.example .env
# Edit .env file and add your private key and RPC URL
```

2. Deploy to Sepolia testnet
```bash
make deploy-sepolia
```

Or deploy manually:
```bash
forge script script/DeployFundMe.s.sol:DeployFundMe \
    --rpc-url ${SEPOLIA_RPC_URL} \
    --private-key ${PRIVATE_KEY} \
    --broadcast \
    --verify \
    --etherscan-api-key ${ETHERSCAN_API_KEY}
```

## 🧪 Testing

The project includes a comprehensive test suite:

- **Unit Tests**: Test individual function functionality
- **Integration Tests**: Test contract interactions
- **Mock Tests**: Use mock contracts for testing

Run specific tests:
```bash
forge test --match-test testFund
```

## 📋 Contract Function Details

### FundMe.sol

Main functions:
- `fund()`: Send ETH for crowdfunding
- `withdraw()`: Withdraw all funds (owner only)
- `cheaperWithdraw()`: More cost-effective withdrawal method
- `getAddressToAmountFunded()`: Query address donation amount
- `getFunder()`: Get funder address
- `getOwner()`: Get contract owner
- `getPriceFeed()`: Get price oracle address

### PriceConverter.sol

Price conversion library:
- `getPrice()`: Get ETH/USD price
- `getConversionRate()`: Calculate USD equivalent of ETH amount

## 🔧 Configuration

### foundry.toml
- Solidity version: 0.8.19
- Remapping configuration: Chainlink contract paths
- Network configuration: Sepolia and zkSync local networks

### Environment Variables
- `PRIVATE_KEY`: Deployer private key
- `SEPOLIA_RPC_URL`: Sepolia testnet RPC URL
- `ETHERSCAN_API_KEY`: Etherscan API key

## 🌐 Supported Networks

- **Sepolia**: Testnet deployment
- **Anvil**: Local development network

## 📚 Learning Resources

This project covers the following Solidity concepts:

- Smart contract basics
- Function modifiers
- Error handling
- Events
- Libraries
- Inheritance
- Interfaces
- Test writing
- Deployment scripts
- Price oracle integration
