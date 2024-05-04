## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

Coin = 0x5a124F04B2E81223E1bD91503154805afeD71ff6
RegistryMerchant = 0xf03B6d96277abbA8827e2742737cD8b8036aF208
Router = 0x02BFea4739B4Fe601C431259739F4f18d8310c86
Governance = 0x8BaED19B9b62A7c4eBbf8732C1fb57F8D45d3e6C

Base Sepolia
Coin = 0x695e1923C6245cb26424b12f9BFb61456Fd6184e
RegistryMerchant = 0x466e360E2E04DD1F3c539B53e01bCB10Cb4a73AE
Router = 0x73Bf6f9353Cfd4D450CEed7497d8c58f2f8a3b0A
Governance = 0xF945EB0Ff08646d8322A37e0FffFC6Dc3d41CD3D

Polygon ZKVM
Coin = 0x6fBEDE87375028d663141259f7c83203d25f1156
RegistryMerchant = 0x695e1923C6245cb26424b12f9BFb61456Fd6184e
Router = 0x466e360E2E04DD1F3c539B53e01bCB10Cb4a73AE
Governance = 0x73Bf6f9353Cfd4D450CEed7497d8c58f2f8a3b0A