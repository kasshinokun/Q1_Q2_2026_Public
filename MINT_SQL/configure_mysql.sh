# =========================> IMPORTANT NOTE: <=================================
# Initially, this is in English, 
# but I will add Brazilian Portuguese (my native language) later.
# Thanks for reading
# =============================================================================
# =============================================================================
# Script Name: configure_mysql.sh
# Description: Installs and configures MySQL Server and Workbench on Ubuntu/Mint.
# Author: Gabriel da Silva Cassino
# Date: 2026-04-03 release 20260403 alpha 1e
# =============================================================================

# Stack-structured script like a normal program.
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print error messages
error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}

# Function to print success messages
success() {
    echo -e "${GREEN}[OK] $1${NC}"
}

# Function to install Snap
install_snap() {
    echo "Verifying operating system..."

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_ID=$ID
        OS_VERSION=$VERSION_ID
    else
        error "Error: File /etc/os-release not found."
        exit 1
    fi

    echo "------------------------------------"
    echo "Name: $PRETTY_NAME"
    echo "Version: $VERSION"
    echo "------------------------------------"

    if [[ "$OS_ID" == "linuxmint" ]]; then
        success "Linux Mint System detected!"
        if [ -f /etc/apt/preferences.d/nosnap.pref ]; then
            echo "Removing Snap restriction on Linux Mint..."
            mv /etc/apt/preferences.d/nosnap.pref /etc/apt/preferences.d/nosnap.bak
        fi
    fi

    echo "Updating package lists..."
    apt update -y

    # By default OS has GCC, G++ and Python
    # but Java its necessary to install
    # Without Java isnt possible run Snap
    
    echo "Checking GCC..."
    gcc --version
    echo "Checking G++..."
    g++ --version
    echo "Checking Python..."
    python3 --version
    echo "Checking Java..."
    java --version 
    echo "Installing Java..."
    apt install openjdk-25-jre-headless default-jre
    echo "Redo checking Java..."
    java --version 
    
    echo "Installing Snapd..."
    apt install -y snapd

    if command -v snap >/dev/null 2>&1; then
        snap --version
        success "Snap installed successfully."

        # Fix Desktop Path for ZSH/Wayland
        ln -s /var/lib/snapd/desktop/applications/*.desktop ~/.local/share/applications/
        
        # if necessary,add Path to Environment
        # export PATH=$PATH:/snap/bin
    else
        error "Failed to install Snap."
        exit 1
    fi
}    
install_mysql_workbench_snap() {
    echo "Installing MySQL Workbench via Snap..."
    install_snap
    
    # Use with the version suffixed "--classic" if necessary.
    # snap install mysql-workbench-community --classic

    # by default is without "--classic" suffix
    snap install mysql-workbench-community

    success "MySQL and Workbench installation complete."

    snap connect mysql-workbench-community:password-manager-service
    snap connect mysql-workbench-community:ssh-keys
    snap connect mysql-workbench-community:cups-control

    apt install dbus-x11
    
    xhost +local:root

    apt update 

    snap run mysql-workbench-community    
}    
install_mysql_workbench_deb() {
    
    snap remove mysql-workbench-community
    
    apt-get install libodbc2 libproj25
    
    VERSION_APP="8.0.46"
    ARCHITECTURE="ubuntu24.04_amd64"
    FILE_DEB="mysql-workbench-community_${VERSION_APP}-1${ARCHITECTURE}.deb"
    URL="https://dev.mysql.com/get/Downloads/MySQLGUITools/${FILE_DEB}"
    
    wget "$URL"

    apt update
    
    apt install ./"$FILE_DEB"

}    

# Function to install MySQL
install_mysql() {
    echo "Installing MySQL Server and dependencies..."
    apt install -y mysql-server libmysqlclient-dev

    echo "Starting MySQL service..."
    systemctl start mysql
    systemctl enable mysql

    echo "Checking MySQL service status..."
    systemctl is-active --quiet mysql && success "MySQL is running." || error "MySQL failed to start."

    # Note: mysql_secure_installation is interactive. 
    # For automation, manual setup is recommended or use debconf-set-selections.
    echo "------------------------------------------------------------"
    echo "IMPORTANT: Please run 'sudo mysql_secure_installation' manually"
    echo "after this script finishes to secure your MySQL instance."
    echo "------------------------------------------------------------"

    # install_mysql_workbench_snap

    install_mysql_workbench_deb
}
main() {
    echo "Updating and upgrading system packages..."
    apt update && apt upgrade -y
    success "System update complete."
    
    echo "====================================================================="
    echo "        MySQL Setup and Keyboard Configuration Script"
    echo "====================================================================="
    echo "1) Keyboard EN-US (English)"
    echo "2) Keyboard PT-BR (Brazilian Portuguese ABNT2)"
    echo "0) Exit"
    echo "---------------------------------------------------------------------"
    echo -n "Please choose your language [0-2]: "
    
    while true; do
        read -r option_choice
    
        if [[ ! "$option_choice" =~ ^[0-2]$ ]]; then
            error "Invalid input. Please enter 0, 1, or 2."
            continue
        fi
    
        case "$option_choice" in
            1)
                echo "Applying US Layout..."
                echo -n "Is your keyboard A) 104-keys or B) 105-keys? [A/B]: "
                read -r type_keyboard
                
                # Standardize input to uppercase
                type_keyboard=${type_keyboard^^}
    
                if [[ "$type_keyboard" == "A" ]]; then
                    sed -i 's/XKBMODEL=".*"/XKBMODEL="pc104"/' /etc/default/keyboard
                    sed -i 's/XKBVARIANT=".*"/XKBVARIANT=""/' /etc/default/keyboard
                else
                    sed -i 's/XKBMODEL=".*"/XKBMODEL="pc105"/' /etc/default/keyboard
                    sed -i 's/XKBVARIANT=".*"/XKBVARIANT="intl"/' /etc/default/keyboard
                fi
    
                sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="us"/' /etc/default/keyboard
                sed -i 's/XKBOPTIONS=".*"/XKBOPTIONS=""/' /etc/default/keyboard
                sed -i 's/BACKSPACE=".*"/BACKSPACE="guess"/' /etc/default/keyboard
    
                setupcon
                success "Keyboard layout updated to US."
                install_mysql
                break
                ;;
            2)
                echo "Applying ABNT2 Layout..."
                sed -i 's/XKBMODEL=".*"/XKBMODEL="abnt2"/' /etc/default/keyboard
                sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="br"/' /etc/default/keyboard
                sed -i 's/XKBVARIANT=".*"/XKBVARIANT="abnt2"/' /etc/default/keyboard
                sed -i 's/XKBOPTIONS=".*"/XKBOPTIONS="lv3:alt_switch,compose:rctrl"/' /etc/default/keyboard
                sed -i 's/BACKSPACE=".*"/BACKSPACE="guess"/' /etc/default/keyboard
    
                setupcon
                success "Keyboard layout updated to ABNT2."
                install_mysql
                break
                ;;
            0)
                echo "Exiting script..."
                exit 0
                ;;
        esac
    done
    
    success "Script execution finished. Thank you!"
    echo "====================================================================="
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root. Use: sudo $0"
    exit 1
fi

main # Call Main's Script Function like as Program


