record_all() {
    if [ $# -eq 0 ]; then
        echo "Usage: record_all <name>"
        return 1
    fi
    
    local name="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local dest_dir="/home/ros/bags"

    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"
    
    # Copy the file/directory
    ros2 bag record --all --exclude-regex "(scanend|theora|compressedDepth|depth_.*/image_raw/compressed|image_rect_raw/compressed)" -o "${dest_dir}/${timestamp}_${name}"
    return 0
}



record_compressed() {
    if [ $# -eq 0 ]; then
        echo "Usage: record_all <name>"
        return 1
    fi
    
    local name="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local dest_dir="/home/ros/bags"

    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_dir"
    
    # Copy the file/directory
    ros2 bag record --all --exclude-regex "(scanend|theora|compressedDepth|depth_.*/image_raw/compressed|image_rect_raw/compressed|/image_raw$|/image_rect_raw$)" -o "${dest_dir}/${timestamp}_${name}"
    return 0
}