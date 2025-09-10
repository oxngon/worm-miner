# worm miner workflow

  - helps start with worm miner

## quick start

update and install dependencies:

```bash
apt update && apt upgrade -y
apt install -y htop sudo tmux curl wget vim git make build-essential unzip cmake
```

required for rapidsnark later:


```bash
sudo apt install -y libgmp-dev libomp-dev libsodium-dev nasm m4 nlohmann-json3-dev
```

Verify

```bash
dpkg -l | grep libomp-dev
pkg-config --modversion gmp      # e.g., 6.3.0
pkg-config --modversion libsodium  # e.g., 1.0.18
pkg-config --modversion libomp   # e.g., 18.1.3
```

Install rust and cargo

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
echo 'source $HOME/.cargo/env' >> ~/.bashrc
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
pkg-config --version  # e.g., 1.8.1
```

Install OpenSSL libraries (with headers)

```bash
apt install -y libssl-dev

```

Set correct headers & env variables

```bash
export OPENSSL_DIR=/usr
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig
export OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
export OPENSSL_INCLUDE_DIR=/usr/include/x86_64-linux-gnu/openssl
echo 'export OPENSSL_DIR=/usr' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig' >> ~/.bashrc
echo 'export OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu' >> ~/.bashrc
echo 'export OPENSSL_INCLUDE_DIR=/usr/include/x86_64-linux-gnu/openssl' >> ~/.bashrc
source ~/.bashrc
```

Verify

```bash
pkg-config --modversion openssl  # e.g., 3.0.13
pkg-config --libs openssl        # e.g., -lssl -lcrypto
pkg-config --cflags openssl      # e.g., -I/usr/include/x86_64-linux-gnu/openssl
ls $OPENSSL_INCLUDE_DIR/openssl.h  # Should exist
ls $OPENSSL_LIB_DIR/libssl.so     # Should exist
```

Install libclang and clang, ensure PATH

```bash
apt install -y clang libclang-dev
```

Set env variables

```bash
export LIBCLANG_PATH=/usr/lib/llvm-18/lib
export CLANG_PATH=/usr/bin/clang-18
echo 'export LIBCLANG_PATH=/usr/lib/llvm-18/lib' >> ~/.bashrc
echo 'export CLANG_PATH=/usr/bin/clang-18' >> ~/.bashrc
source ~/.bashrc
```

Verify

```bash
clang --version  # e.g., Ubuntu clang version 18.1.3
ls $LIBCLANG_PATH/libclang.so  # Should exist
which $CLANG_PATH  # Should output /usr/bin/clang-18
```

Clone and set up worm

```bash
git clone https://github.com/worm-privacy/miner /miner
cd /miner
make download_params
```

Verify (optional)

```bash
ls -l /miner/rapidsnark-linux-x86_64-v0.0.7/{lib,include}  # Should show librapidsnark.so and prover.h
```


Build and install worm

```bash
cargo install --path .
```
