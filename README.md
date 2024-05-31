# NanoWallet

### Installation
1. Run in Docker
```
docker-compose up
docker-compose exec -it app bash
```

2. Run on local machine
```
bundle install
```

### Usage

Generate address.
```
$ ./bin/nanowallet generate
```

Show balance
```
$ ./bin/nanowallet show
```

Send funds
```
$ ./bin/nanowallet send <destination_address> <sum satoshi> <fee per byte satoshi>
```
