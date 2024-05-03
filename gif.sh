#!/bin/zsh

# Script to create a GIF from PNG files using FFmpeg

# Set the directory containing PNG files
directory="temp"
output_gif="output.gif"
# output_gif="decoherence.gif"
palette="palette.png"

# Check if FFmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
    echo "FFmpeg is not installed. Please install FFmpeg to continue."
    exit 1
fi

# Check if the directory exists and has PNG files
if [ ! -d "$directory" ] || ! ls "$directory"/*.png 1> /dev/null 2>&1; then
    echo "Directory does not exist or contains no PNG files: $directory"
    exit 1
fi

# Generate a color palette tailored for the set of images
echo "Generating color palette..."
ffmpeg -framerate 10 -pattern_type glob -i "$directory/bloch_*.png" \
-vf "scale=320:-1:flags=lanczos,palettegen" -y "$palette"

# Create the GIF using the generated palette
echo "Creating GIF..."
ffmpeg -framerate 10 -pattern_type glob -i "$directory/bloch_*.png" -i "$palette" \
-filter_complex "scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "$output_gif"

echo "GIF created successfully: $output_gif"

echo "Cleaning up..."
rm -rf "$palette"
rm -rf temp
