#!/bin/bash

# Step 1: Install AnyDesk (if not installed)
echo "✅ Checking if AnyDesk is installed..."
if ! command -v anydesk &> /dev/null; then
    echo "❌ AnyDesk is not installed. Installing..."
    # For Ubuntu/Debian-based systems
    sudo apt update
    sudo apt install -y wget
    wget -qO - https://download.anydesk.com/linux/anydesk-6.1.1-1_amd64.deb -O anydesk.deb
    sudo dpkg -i anydesk.deb
    sudo apt --fix-broken install -y
else
    echo "✅ AnyDesk is already installed."
fi

# Step 2: Create a script for AnyDesk to force X11
echo "✅ Creating script for AnyDesk to use X11..."
cat << 'EOF' | sudo tee /usr/local/bin/anydesk-x11
#!/bin/bash
export GDK_BACKEND=x11
export QT_QPA_PLATFORM=xcb
anydesk
EOF

# Step 3: Make the script executable
sudo chmod +x /usr/local/bin/anydesk-x11

# Step 4: Optionally disable Wayland (for GNOME users)
echo "✅ Checking if Wayland is enabled for GNOME..."
if grep -q "WaylandEnable=true" /etc/gdm3/custom.conf 2>/dev/null; then
    echo "🚫 Disabling Wayland in GDM (GNOME Display Manager)..."
    sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
    sudo systemctl restart gdm3 || echo "Please reboot your system for changes to take effect."
fi

# Step 5: Check current session type
SESSION_TYPE=$(echo $XDG_SESSION_TYPE)

if [[ "$SESSION_TYPE" == "wayland" ]]; then
    echo "You are using Wayland. Switching to Xorg..."
    # Switch to Xorg (assuming you are on the login screen)
    echo "Please log out and select 'Ubuntu on Xorg' on the login screen."
    echo "After logging in again, you can rerun this script to continue."
    exit 0
else
    echo "You are using Xorg. No need to switch."
fi

# Step 6: Modify AnyDesk configuration to force X11
echo "✅ Modifying AnyDesk configuration for X11..."
sudo sed -i 's/#X11DisplayServer=true/X11DisplayServer=true/' /etc/anydesk/anydesk.conf

# Step 7: Restart AnyDesk service
echo "✅ Restarting AnyDesk service..."
sudo systemctl restart anydesk

# Step 8: Reboot the system to apply changes
echo "✅ Rebooting your system for changes to take effect..."
sudo reboot

echo "🎯 After reboot, you can run AnyDesk with X11 using: anydesk-x11"
