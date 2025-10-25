# ZK-ECDSA: Zero-Knowledge ECDSA Signature Verification

A Noir-based zero-knowledge proof circuit for ECDSA signature verification, enabling private authentication without revealing the signature or private keys on-chain.

## 📚 Prerequisites

Before diving into this project, we recommend familiarizing yourself with Noir circuits. Check out our starter project:
- **[simple-circuit](https://github.com/smilewithkhushi/simple-circuit)** - A beginner-friendly introduction to Noir

## 🎯 Overview

This project implements ECDSA signature verification in Noir, allowing you to prove knowledge of a valid signature for a given message and public key without revealing the actual signature. This is useful for:
- Private authentication mechanisms
- Confidential transaction signing
- Zero-knowledge identity proofs

## 🚀 Quick Start

### 1. Generate Credentials

First, create a new Ethereum account (or use an existing one):

```bash
# Create a new keystore
cast wallet new my_account

# Get the account address
cast wallet address --account my_account

# Get the public key
cast wallet public-key --account my_account
```

### 2. Generate Test Data

Hash your message and create a signature:

```bash
# Hash a message
cast keccak "hello"

# Sign the message (replace with your hash)
cast wallet sign --no-hash <hashed_message> --account my_account
```

### 3. Prepare Inputs

Update `inputs.txt` with your values:
```toml
expected_address = "0x..." # Your Ethereum address
hashed_message = "0x..."   # Keccak-256 hash of your message
pub_key_x = "0x..."        # X coordinate of public key (first 32 bytes)
pub_key_y = "0x..."        # Y coordinate of public key (last 32 bytes)
signature = "0x..."        # 64-byte signature (r || s, without recovery ID)
```

Then generate the Prover inputs:
```bash
./generate_inputs.sh
```

## 🔧 Workflow

### Step 1: Check Circuit Compilation

```bash
nargo check
```

### Step 2: Execute the Circuit (Generate Witness)

```bash
nargo execute
```

This generates `./target/zk_ecdsa.gz` (witness file).

### Step 3: Compile the Circuit

```bash
nargo compile
```

### Step 4: Generate Verification Key

```bash
bb write_vk -b ./target/zk_ecdsa.json -o ./target
```

### Step 5: Generate the Proof

```bash
bb prove -b ./target/zk_ecdsa.json -w ./target/zk_ecdsa.gz -o ./target
```

This generates `./target/proof`.

### Step 6: Verify Off-Chain

```bash
bb verify -k ./target/vk -p ./target/proof
```

## 🔐 On-Chain Verification

To deploy a verifier smart contract on-chain:

### Step 1: Generate Verification Key (with Keccak oracle)

```bash
bb write_vk --oracle_hash keccak -b ./target/zk_ecdsa.json -o ./target
```

### Step 2: Generate Solidity Verifier

```bash
bb write_solidity_verifier -k ./target/vk -o ./target/Verifier.sol
```

This creates `./target/Verifier.sol` - deploy this to your blockchain!

## 📁 Project Structure

```
zk_ecdsa/
├── src/
│   └── main.nr           # Noir circuit implementation
├── inputs.txt            # Test input values
├── Prover.toml           # Generated prover inputs (auto-generated)
├── generate_inputs.sh    # Script to generate Prover.toml
├── target/
│   ├── zk_ecdsa.json     # Compiled circuit artifact
│   ├── vk                # Verification key
│   ├── proof             # Generated proof
│   └── Verifier.sol      # Solidity smart contract
└── readme.md             # This file
```

## 🔗 Dependencies

- **[ecrecover-noir](https://github.com/colinnielsen/ecrecover-noir)** - ECDSA recovery implementation in Noir
- **Barretenberg (`bb`)** - Proof generation and verification
- **Foundry (`cast`)** - For generating test credentials

## 📝 Key Concepts

**ECDSA Signature Verification**: The circuit proves that given:
- A public key (x, y coordinates)
- A message hash
- A signature (r, s values)

...the signature is valid without revealing the actual values in the proof.

## 🐛 Troubleshooting

**Error: "Integers must have the same bit width"**
- Ensure all shift operations use matching bit widths (u64 << u64, not u64 << u8)
- Check that the ecrecover dependency is up to date

**Error: Signature length mismatch**
- Remove the recovery ID (last byte) from signatures
- Signature should be exactly 64 bytes (not 65)

## 📚 Resources

- [Noir Documentation](https://docs.noir-lang.org/)
- [Barretenberg Docs](https://github.com/AztecProtocol/barretenberg)
- [ECDSA Overview](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)

## 👤 Author

**Khushi Panwar** - [@smilewithkhushi](https://github.com/smilewithkhushi)

## 📄 License

This project is open source and available under the MIT License.