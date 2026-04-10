record_all() {
    if [ $# -eq 0 ]; then
        echo "Usage: record_all <name>"
        return 1
    fi
    
    local name="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local dest_dir="/bags"

    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"
    
    # Copy the file/directory
    ros2 bag record --all -o "${dest_dir}/${timestamp}_${name}"
    return 0
}