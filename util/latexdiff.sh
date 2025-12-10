#!/bin/bash

# latexdiff script for comparing two versions of main.tex using Git hashes
# Usage: ./util/latexdiff.sh <old_hash> <new_hash>

set -e

# Change to project root directory (where main.tex is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fixed output name and target file
OUTPUT_NAME="diff"
TARGET_FILE="main.tex"

# Check arguments
if [ $# -ne 2 ]; then
    echo -e "${YELLOW}Usage:${NC} $0 <old_hash> <new_hash>"
    echo ""
    echo "Example:"
    echo "  $0 abc1234 def5678"
    exit 1
fi

OLD_HASH="$1"
NEW_HASH="$2"

# Save original working directory
ORIG_DIR=$(pwd)

# Temporary directories
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

OLD_DIR="$TMP_DIR/old"
NEW_DIR="$TMP_DIR/new"
mkdir -p "$OLD_DIR" "$NEW_DIR"

# Function to extract files from a commit
extract_commit() {
    local hash="$1"
    local target_dir="$2"
    
    # Extract main.tex
    if ! git show "$hash:$TARGET_FILE" > "$target_dir/$TARGET_FILE" 2>/dev/null; then
        return 1
    fi
    
    # Extract chapters directory
    mkdir -p "$target_dir/chapters"
    for file in chapters/*.tex; do
        if git show "$hash:$file" > "$target_dir/$file" 2>/dev/null; then
            : # Success
        fi
    done
    
    return 0
}

# Extract old commit
echo -e "${YELLOW}Extracting old version from commit $OLD_HASH...${NC}"
if ! extract_commit "$OLD_HASH" "$OLD_DIR"; then
    echo -e "${RED}Error: Failed to extract files from commit '$OLD_HASH'.${NC}"
    exit 1
fi

# Extract new commit
echo -e "${YELLOW}Extracting new version from commit $NEW_HASH...${NC}"
if ! extract_commit "$NEW_HASH" "$NEW_DIR"; then
    echo -e "${RED}Error: Failed to extract files from commit '$NEW_HASH'.${NC}"
    exit 1
fi

echo -e "${GREEN}Creating diff between:${NC}"
echo "  Old: $OLD_HASH ($TARGET_FILE with includes)"
echo "  New: $NEW_HASH ($TARGET_FILE with includes)"
echo "  Output: ${OUTPUT_NAME}.pdf"
echo ""

# Create diff file with --flatten to include \include files
# Need to run from within the directories to resolve relative paths
echo -e "${YELLOW}Running latexdiff with --flatten...${NC}"
OLD_ABS=$(cd "$OLD_DIR" && pwd)/$TARGET_FILE
NEW_ABS=$(cd "$NEW_DIR" && pwd)/$TARGET_FILE

# Run latexdiff from a common directory to resolve relative paths correctly
cd "$TMP_DIR"
latexdiff --flatten "$OLD_ABS" "$NEW_ABS" > "$ORIG_DIR/${OUTPUT_NAME}.tex" || {
    echo -e "${RED}Error: latexdiff failed.${NC}"
    exit 1
}
cd "$ORIG_DIR"

echo -e "${GREEN}✓ Diff file created: ${OUTPUT_NAME}.tex${NC}"
echo ""
echo -e "${YELLOW}Compiling PDF...${NC}"

# Compile the diff file
# Use latexmk if available, otherwise pdflatex
if command -v latexmk &> /dev/null; then
    latexmk -pdf -interaction=nonstopmode "${OUTPUT_NAME}.tex"
else
    pdflatex -interaction=nonstopmode "${OUTPUT_NAME}.tex"
    # Run again for references
    pdflatex -interaction=nonstopmode "${OUTPUT_NAME}.tex"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ PDF created: ${OUTPUT_NAME}.pdf${NC}"
    echo ""
    echo -e "${GREEN}Done!${NC}"
    echo "  - Diff LaTeX: ${OUTPUT_NAME}.tex"
    echo "  - Diff PDF: ${OUTPUT_NAME}.pdf"
else
    echo -e "${RED}Error: PDF compilation failed.${NC}"
    echo "You can manually compile ${OUTPUT_NAME}.tex"
    exit 1
fi

