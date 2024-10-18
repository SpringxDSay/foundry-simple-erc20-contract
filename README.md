# Description

This is a simple ERC20 token contract

## Documentation

https://book.getfoundry.sh/

## SetUp

```
git clone https://github.com/SpringxDSay/foundry-simple-erc20-contract.git
```

### Installing OpenZeppelin Contracts Package

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### Deploy

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```
make deploy
```

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

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
