#!/bin/bash

# gpu-manager.sh
# Unified script to manage NVIDIA GPU performance modes (Power & Clocks)

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Determine script directory to find nvidia_oc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
NVIDIA_OC_CMD="$SCRIPT_DIR/nvidia_oc"

# Check dependencies
if ! command -v nvidia-smi &> /dev/null; then
    echo "Error: nvidia-smi could not be found."
    exit 1
fi

if [ ! -f "$NVIDIA_OC_CMD" ]; then
    echo "Error: nvidia_oc executable not found at $NVIDIA_OC_CMD"
    exit 1
fi

# Function to apply settings
apply_mode() {
    local mode=$1
    case "$mode" in
        eco)
            echo "🔋 Activating ECO Mode..."
            echo "   - Power Limit: 100W"
            echo "   - Overclock: None"
            echo "   - Clock Lock: 210 MHz"
            
            # Power & OC (from old gpu-tuning.sh)
            "$NVIDIA_OC_CMD" set -i 0 -p 100000
            
            # Clocks (from old gpuconfig.sh)
            nvidia-smi -pm 1
            nvidia-smi -lgc 210,210
            ;;
            
        med)
            echo "🌿 Activating MEDIUM Mode..."
            echo "   - Power Limit: 200W"
            echo "   - Overclock: +100 Core / +500 Mem"
            echo "   - Clock Limit: 1000-1200 MHz"
            
            # Power & OC
            "$NVIDIA_OC_CMD" set -i 0 -p 200000 -f 100 -m 500
            
            # Clocks
            nvidia-smi -pm 1
            nvidia-smi -lgc 1000,1200
            ;;
            
        perf)
            echo "🚀 Activating PERFORMANCE Mode..."
            echo "   - Power Limit: 300W"
            echo "   - Overclock: +200 Core / +1000 Mem"
            echo "   - Clock Lock: Reset (Default)"
            
            # Power & OC
            "$NVIDIA_OC_CMD" set -i 0 -p 300000 -f 200 -m 1000
            
            # Clocks
            nvidia-smi -rgc
            ;;
            
        *)
            echo "Usage: $0 [eco|med|perf]"
            exit 1
            ;;
    esac
}

apply_mode "$1"
