## Optimisim Merkle Tutorial

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

## Quick Start

### Submodules

First, init submodules from the project root

```bash
$ git submodule update --recursive --init -f
```

### Registry Development

This contract supports containerized development. From Visual Studio Code Remote Containers extension

`Reopen in Container`

or

Command line build using docker

```bash
$ docker build packages/did-eth-registry -t did-eth:1
```
