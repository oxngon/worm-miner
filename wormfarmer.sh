#!/bin/bash

# Auto-compounding WORM farming script (hardcoded values)
# WARNING: Hardcoding your private key is insecure! Keep this script safe and do not share it!
PRIVATE_KEY="your_private_key_here"  # Replace with your actual private key (e.g., 0x_my_private_key_here)
NETWORK="sepolia"                    # Network (e.g., sepolia)
BETH_PER_EPOCH="0.002"               # BETH committed per epoch
EPOCHS_PER_CYCLE="3"                 # Number of epochs per cycle

if [ -z "$PRIVATE_KEY" ] || [ -z "$NETWORK" ] || [ -z "$BETH_PER_EPOCH" ] || [ -z "$EPOCHS_PER_CYCLE" ]; then
  echo "Error: One or more variables are not set correctly."
  echo "Usage: Ensure PRIVATE_KEY, NETWORK, BETH_PER_EPOCH, and EPOCHS_PER_CYCLE are defined."
  echo "Example values: PRIVATE_KEY=0xabc123..., NETWORK=sepolia, BETH_PER_EPOCH=0.002, EPOCHS_PER_CYCLE=3"
  exit 1
fi

echo "Starting Auto-WORM Farmer"
echo "Private key: **${PRIVATE_KEY: -6}"
echo "Network: $NETWORK"
echo "BETH per epoch: $BETH_PER_EPOCH"
echo "Epochs per cycle: $EPOCHS_PER_CYCLE"
echo

while true; do
  echo "Checking balances at $(date)..."
  if ! worm-miner info --network "$NETWORK" --private-key "$PRIVATE_KEY"; then
    echo "Balance check failed. Exiting."
    exit 1
  fi

  echo "Participating in $EPOCHS_PER_CYCLE epochs..."
  if ! worm-miner participate \
    --network "$NETWORK" \
    --private-key "$PRIVATE_KEY" \
    --amount-per-epoch "$BETH_PER_EPOCH" \
    --num-epochs "$EPOCHS_PER_CYCLE"
  then
    echo "Participation failed. Exiting."
    exit 1
  fi

  echo "Waiting for epochs to finish (~30 minutes each)..."
  sleep $((EPOCHS_PER_CYCLE * 1800 + 60))  # Wait for epochs + 1-minute buffer

  echo "Claiming rewards..."
  CURRENT_EPOCH=$(worm-miner info --network "$NETWORK" --private-key "$PRIVATE_KEY" | grep "Current epoch" | awk '{print $3}')
  FROM_EPOCH=$((CURRENT_EPOCH - EPOCHS_PER_CYCLE))
  if ! worm-miner claim \
    --network "$NETWORK" \
    --private-key "$PRIVATE_KEY" \
    --from-epoch "$FROM_EPOCH" \
    --num-epochs "$EPOCHS_PER_CYCLE"
  then
    echo "Claim failed. Exiting."
    exit 1
  fi

  echo "Taking a 5-minute break..."
  sleep 300  # 5-minute break

  echo "Cycle complete! Restarting..."
  echo
done
