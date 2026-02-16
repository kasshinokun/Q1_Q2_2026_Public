# Secure Permissions Folder Changer
# Created to use on ARCHCRAFT AND SAME DISTROS BASED ON ARCH LINUX
echo "====================================== Permissions Folder Changer ==================================="

# Prompt for the folder path
read -p "Please, type the path to the folder: " FOLDER_PATH

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "=============================================== ERROR ==============================================="
    echo "Error: PATH_NOT_FOUND"
    echo "The folder path '$FOLDER_PATH' does not exist."
    echo "==================================================================================================="
    exit 1
fi

# Prompt for permissions
read -p "Please, enter the desired permissions in octal format (e.g., 755): " PERMISSIONS

# Validate the permissions format (simple regex for 3 or 4 octal digits)
if ! [[ "$PERMISSIONS" =~ ^[0-7]{3,4}$ ]]; then
    echo "=============================================== ERROR ==============================================="
    echo "Error: INVALID_PERMISSIONS"
    echo "The permissions format '$PERMISSIONS' is invalid. Please use a 3 or 4-digit octal number (e.g., 755, 0755)."
    echo "==================================================================================================="
    exit 1
fi

# Confirm before making changes
echo
read -p "You are about to change the permissions of '$FOLDER_PATH' to '$PERMISSIONS'. Are you sure? (y/N) " CONFIRMATION
echo

if [[ ! "$CONFIRMATION" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled by the user."
    exit 0
fi

# Use sudo to change permissions
echo "Attempting to change permissions with sudo..."
sudo chmod "$PERMISSIONS" "$FOLDER_PATH"

# Check the exit status of the chmod command
if [ $? -eq 0 ]; then
    echo "Successfully changed permissions for '$FOLDER_PATH' to '$PERMISSIONS'."
else
    echo "=============================================== ERROR ==============================================="
    echo "Error: PERMISSION_CHANGE_FAILED"
    echo "Failed to change permissions. Please check your sudo privileges and the path."
    echo "==================================================================================================="
    exit 1
fi

echo "Script finished."
