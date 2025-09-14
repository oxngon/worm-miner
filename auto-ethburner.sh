#!/bin/bash

# performs automatic ETH burns on the Sepolia network for worm-miner

# Validate numeric input
validate_number() {
  local input=$1
  local name=$2
  if ! [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: $name must be a valid number (e.g., 1 or 1.5)."
    exit 1
  fi
}

# Print security warning
echo "WARNING: This script will prompt for your private key. Ensure this script is run in a secure environment."

# Prompt for private key
read -sp "Enter your Ethereum private key (input is hidden): " PRIVATE_KEY
echo ""
if [ -z "$PRIVATE_KEY" ]; then
  echo "Error: Private key cannot be empty."
  exit 1
fi

# Prompt for ETH per burn
read -p "Enter the amount of ETH to burn per transaction (e.g., 1): " ETH_PER_BURN
validate_number "$ETH_PER_BURN" "ETH per burn"

# Prompt for number of burns
read -p "Enter the number of burns to perform: " TOTAL_LOOPS
if ! [[ "$TOTAL_LOOPS" =~ ^[0-9]+$ ]]; then
  echo "Error: Number of burns must be a positive integer."
  exit 1
fi
if [ "$TOTAL_LOOPS" -lt 1 ]; then
  echo "Error: Number of burns must be at least 1."
  exit 1
fi

# Calculate spend and fee (spend = 99.8% of ETH_PER_BURN, fee = 0.2%)
SPEND=$(echo "$ETH_PER_BURN * 0.998" | bc)
FEE=$(echo "$ETH_PER_BURN * 0.002" | bc)

echo "Performing $TOTAL_LOOPS burns of $ETH_PER_BURN ETH each (spend: $SPEND ETH, fee: $FEE ETH per burn)..."

# Loop for the specified number of burns with error handling
for ((i=1; i<=TOTAL_LOOPS; i++))
do
  echo "Burn #$i of $TOTAL_LOOPS..."
  if ! worm-miner burn \
    --network sepolia \
    --private-key "$PRIVATE_KEY" \
    --amount "$ETH_PER_BURN" \
    --spend "$SPEND" \
    --fee "$FEE"
  then
    echo "Burn #$i failed, check balance or network. Exiting."
    exit 1
  fi

  # Short buffer delay
  echo "Waiting 15 seconds before next burn..."
  sleep 15
done

echo "All $TOTAL_LOOPS burns completed successfully!"
