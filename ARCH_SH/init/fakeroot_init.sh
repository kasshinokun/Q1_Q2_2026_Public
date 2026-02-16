analise: echo "Starting script ....."
while True; do
    echo "====================================== Permissions Folder Changer ==================================="
    read -p "Please, type the path folder: ----->" FOLDER_PATH
    if [ -d "$FOLDER_PATH" ]; then
        echo "The Folder Path on: $FOLDER_PATH exists."
        su
        echo "Everything done. Root access activated."
        chmod 7777 $FOLDER_PATH
        echo "Closing Root Access ...."
        exit
        echo "Closing Terminal ...."
        echo "Thanks."
        False
    else
        echo "=============================================== ERROR ==============================================="
        echo "Error: PATH_NOT_FOUND"
        echo "The Folder Path on: $FOLDER_PATH not exists."
        echo "========================================= Restarting Process ========================================"
    fi
done
