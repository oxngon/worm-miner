#!/bin/bash

# WARNING: Hardcoding your private key is insecure! Keep this script safe and do not share it!
PRIVATE_KEY="your_private_key_here"  # Replace with your actual private key (e.g., 0x_my_private_key_here)

# Number of burns (interpreted as ETH to burn, adjust manually)
TOTAL=5  # Set the number of 1 ETH burns you want to perform

echo "Performing $TOTAL burns of 1 ETH each..."

# Loop for the specified number of burns with error handling
for ((i=1; i<=TOTAL; i++))
do
  echo "Burn #$i of $TOTAL..."
  if ! worm-miner burn \
    --network sepolia \
    --private-key "$PRIVATE_KEY" \
    --amount 1 \
    --spend 0.998 \
    --fee 0.002
  then
    echo "Burn #$i failed, check balance or network. Exiting."
    exit 1
  fi

  # Short buffer delay
  echo "Waiting 5 seconds before next burn..."
  sleep 5
done

echo "All $TOTAL burns completed successfully!"
