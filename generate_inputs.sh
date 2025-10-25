#!/bin/bash

# Extract values from inputs.txt
EXPECTED_ADDRESS=$(grep "expected_address" inputs.txt | cut -d'"' -f2)
HASHED_MESSAGE=$(grep "hashed_message" inputs.txt | cut -d'"' -f2)
PUB_KEY_X=$(grep "pub_key_x" inputs.txt | cut -d'"' -f2)
PUB_KEY_Y=$(grep "pub_key_y" inputs.txt | cut -d'"' -f2)
SIGNATURE=$(grep "signature" inputs.txt | cut -d'"' -f2)

# Function to convert hex string to array of decimal bytes
hex_to_bytes() {
    local hex=$1
    local skip_last=$2  # If true, skip the last byte
    
    # Remove 0x prefix if present
    hex=${hex#0x}
    
    # If skip_last is true, remove last 2 hex characters (1 byte)
    if [ "$skip_last" = true ]; then
        hex=${hex%??}
    fi
    
    local bytes=()
    # Split into pairs of characters and convert to decimal
    for i in $(seq 0 2 $((${#hex} - 1))); do
        byte_hex=${hex:$i:2}
        # Convert hex to decimal
        decimal=$((16#$byte_hex))
        bytes+=("$decimal")
    done
    
    # Output as TOML array format
    printf '['
    printf '%s' "${bytes[0]}"
    for ((i=1; i<${#bytes[@]}; i++)); do
        printf ', %s' "${bytes[$i]}"
    done
    printf ']'
}

# Generate Prover.toml content
cat > Prover.toml << EOF
expected_address = "$EXPECTED_ADDRESS"
hashed_message = $(hex_to_bytes "$HASHED_MESSAGE" false)
pub_key_x = $(hex_to_bytes "$PUB_KEY_X" false)
pub_key_y = $(hex_to_bytes "$PUB_KEY_Y" false)
signature = $(hex_to_bytes "$SIGNATURE" true)
EOF

echo "✅ Prover.toml generated successfully!"
