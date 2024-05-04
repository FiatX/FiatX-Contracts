## Deployment
### Sepolia
- Coin = 0x31a1714CDF991371b5140936d5Ee1C66F711B3D3
- RegistryMerchant = 0xAB917ADc0d708Fe8434c360D813Db6D7190547a8
- Router = 0x357E39c85AFafB7583044bC28eB9a79c51514d15
- Governance = 0x62Ae3C5cde6Fe43E7606E5Ea71fE69b3Baa3cA57

### Base Sepolia
- Coin = 0x592e66eC7073d2a71a01470daA9D5556AE284549
- RegistryMerchant = 0xb00E46C03Aa321499339C67dBc7F32D884ebC7eE
- Router = 0x76a17Ce5486Cf85581c3aaCb7E8a0a83F52e2102
- Governance = 0x50D61F478b15b72E32D564ce35D862c7b336AFA9

### Polygon ZKVM
- Coin = 0x6fBEDE87375028d663141259f7c83203d25f1156
- RegistryMerchant = 0x695e1923C6245cb26424b12f9BFb61456Fd6184e
- Router = 0x466e360E2E04DD1F3c539B53e01bCB10Cb4a73AE
- Governance = 0x73Bf6f9353Cfd4D450CEed7497d8c58f2f8a3b0A


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
