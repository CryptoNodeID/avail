#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

AVAIL_DATA_DIR="$SCRIPT_DIR/data"
VALIDATOR_NAME_FILE="$AVAIL_DATA_DIR/validator_name"

if [ ! -d "$AVAIL_DATA_DIR" ]; then
    echo "Creating $AVAIL_DATA_DIR directory..."
    mkdir -p "$AVAIL_DATA_DIR"
fi
# Check if validator name was previously stored
if [ ! -f "$VALIDATOR_NAME_FILE" ]; then
    read -p "Enter validator name: " VALIDATOR_NAME
    if [ -z "$VALIDATOR_NAME" ]; then
        echo "Error: No validator name provided."
        exit 1
    fi
    # Save the validator name for future use
    echo "$VALIDATOR_NAME" > "$VALIDATOR_NAME_FILE"
else
    # Read the validator name from the file
    VALIDATOR_NAME=$(cat "$VALIDATOR_NAME_FILE")
fi

docker run --name=avail-node --restart=on-failure \
        -d -v "$AVAIL_DATA_DIR":/da/node-data:z \
        -p 9944:9944 \
        -p 30333:30333 \
        docker.io/availj/avail:v1.11.0.0 \
        --chain goldberg \
        -d /da/node-data \
        --validator --name "$VALIDATOR_NAME"

