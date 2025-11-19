#!/bin/bash

# install.sh
# Installs the NvidiaPowerManager service and desktop shortcuts with dynamic paths.

set -e

# Get the absolute path of the directory where this script is located
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPT_PATH="$INSTALL_DIR/gpu-manager.sh"
SERVICE_NAME="gpu-mode-med.service"

echo "📂 Installation Directory: $INSTALL_DIR"
echo "📜 Script Path: $SCRIPT_PATH"

# Ensure gpu-manager.sh is executable
chmod +x "$SCRIPT_PATH"

# --- 1. Configure and Install Systemd Service ---
echo "⚙️  Configuring Systemd Service..."

# Create a temporary service file with the correct path
cat > "$INSTALL_DIR/$SERVICE_NAME" <<EOF
[Unit]
Description=Set GPU to Medium Performance Mode at Startup
After=multi-user.target

[Service]
Type=oneshot
WorkingDirectory=$INSTALL_DIR
Environment="LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/cuda/lib64:/usr/local/cuda-13.0/targets/x86_64-linux/lib/stubs:/usr/local/cuda-12.9/targets/x86_64-linux/lib/stubs"
ExecStart=$SCRIPT_PATH med

[Install]
WantedBy=multi-user.target
EOF

echo "   Copying service file to /etc/systemd/system/..."
sudo cp "$INSTALL_DIR/$SERVICE_NAME" "/etc/systemd/system/$SERVICE_NAME"

echo "   Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "   Enabling and starting $SERVICE_NAME..."
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"
echo "✅ Service installed and active."

# --- 2. Configure and Install Desktop Shortcuts ---
echo "🖥️  Configuring Desktop Shortcuts..."

APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"

# Function to create desktop file
create_desktop_file() {
    local mode=$1
    local name=$2
    local icon=$3
    local filename="gpu-$mode.desktop"
    
    cat > "$INSTALL_DIR/$filename" <<EOF
[Desktop Entry]
Version=1.0
Name=$name
Comment=Activate $name Mode
Exec=pkexec "$SCRIPT_PATH" $mode
Icon=$icon
Path=$INSTALL_DIR
Terminal=false
Type=Application
Categories=Utility;System;
EOF

    echo "   Installing $filename to $APPS_DIR..."
    cp "$INSTALL_DIR/$filename" "$APPS_DIR/"
    chmod +x "$APPS_DIR/$filename"
}

create_desktop_file "eco" "GPU Eco Mode" "battery-good"
create_desktop_file "med" "GPU Medium Mode" "battery-caution"
create_desktop_file "perf" "GPU Performance Mode" "battery-missing"

echo "✅ Desktop shortcuts installed."
echo "🎉 Installation Complete!"
