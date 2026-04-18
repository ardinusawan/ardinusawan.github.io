#!/bin/bash

# Generate PNG images from Mermaid diagrams
# Requires: npm install -g @mermaid-js/mermaid-cli

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIAGRAMS_DIR="$SCRIPT_DIR/mermaid-diagrams"
OUTPUT_DIR="$SCRIPT_DIR"

echo "🎨 Generating PNG images from Mermaid diagrams..."

# Check if mmdc is installed
if ! command -v mmdc &> /dev/null; then
    echo "❌ mmdc not found. Installing @mermaid-js/mermaid-cli..."
    npm install -g @mermaid-js/mermaid-cli
fi

# Generate each diagram
for mmd_file in "$DIAGRAMS_DIR"/*.mmd; do
    if [ -f "$mmd_file" ]; then
        filename=$(basename "$mmd_file" .mmd)
        output_file="$OUTPUT_DIR/${filename}.png"
        
        echo "📊 Generating $output_file..."
        mmdc -i "$mmd_file" -o "$output_file" -w 1200 -H 800
        
        if [ -f "$output_file" ]; then
            echo "✅ Successfully generated $output_file"
        else
            echo "❌ Failed to generate $output_file"
        fi
    fi
done

echo ""
echo "🎉 All images generated successfully!"
echo "📁 Output directory: $OUTPUT_DIR"
echo ""
echo "Generated images:"
ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null || echo "No PNG files found"
