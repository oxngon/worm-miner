# worm miner workflow

  - helps start with worm miner

## quick start

update and install dependencies:

```bash
apt update && apt upgrade -y
apt install -y htop sudo tmux curl wget vim git make build-essential unzip
```

```bash
sudo apt install -y build-essential cmake libgmp-dev libsodium-dev nasm curl m4 git wget unzip nlohmann-json3-dev
```

Install rust and cargo

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
```

Verify

```bash
rustc --version
cargo --version
```

Install pkg-config

```bash
apt install -y pkg-config
```

Verify

```bash
which pkg-config  # Should output /usr/bin/pkg-config
echo $PATH        # Ensure /usr/bin is included
pkg-config --version  # Should output version (e.g., 1.8.1)
```

Install OpenSSL

```bash
apt install -y libssl-dev
```

Set env variables

```bash
export OPENSSL_DIR=/usr
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig
echo 'export OPENSSL_DIR=/usr' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig' >> ~/.bashrc
source ~/.bashrc
```

Verify

```bash
pkg-config --modversion openssl  # Should output ~3.0.13
echo $OPENSSL_DIR
echo $PKG_CONFIG_PATH
```

Install libclang and clang, ensure PATH

```bash
apt install -y clang libclang-dev
apt install -y libssl-dev
```

Set env variables

```bash
export LIBCLANG_PATH=/usr/lib/llvm-18/lib
echo 'export LIBCLANG_PATH=/usr/lib/llvm-18/lib' >> ~/.bashrc
source ~/.bashrc
```
Verify

```bash
clang --version  # Should output ~18.1.3
find / -name "libclang.so*" 2>/dev/null  # Should show /usr/lib/llvm-18/lib/libclang.so*
echo $LIBCLANG_PATH
```

Install additional dependencies for rapidsnark

```bash
apt install -y libgmp-dev libsodium-dev libomp-dev cmake nasm m4 nlohmann-json3-dev
```

Clone and set up worm

```bash
git clone https://github.com/worm-privacy/miner /miner
cd /miner
make download_params
```

Verify

```bash
ls -l /miner/rapidsnark-linux-x86_64-v0.0.7/{lib,include}  # Should show librapidsnark.so and prover.h
```


Build and install worm

```bash
cargo install --path .
```
