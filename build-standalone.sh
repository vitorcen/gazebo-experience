#!/bin/bash

# Build all standalone examples with clean system environment (no conda interference)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Clean system PATH (remove conda)
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Get the script directory and standalone examples path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STANDALONE_DIR="$SCRIPT_DIR/gz-sim/examples/standalone"

# Check if standalone directory exists
if [ ! -d "$STANDALONE_DIR" ]; then
    echo -e "${RED}[!] Standalone directory not found: $STANDALONE_DIR${NC}"
    echo -e "${YELLOW}Make sure gz-sim submodule is initialized${NC}"
    exit 1
fi

cd "$STANDALONE_DIR"

# Find all directories with CMakeLists.txt
PROJECTS=(
    "acoustic_comms_demo"
    "comms"
    "custom_server"
    "each_performance"
    "entity_creation"
    "external_ecm"
    "gtest_setup"
    "joy_to_twist"
    "joystick"
    "keyboard"
    "light_control"
    "lrauv_control"
    "marker"
    "multi_lrauv_race"
    "scene_requester"
)

# Arrays to track results
SUCCESS=()
FAILED=()
SKIPPED=()

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}Building all standalone examples${NC}"
echo -e "${YELLOW}Using clean system PATH (no conda)${NC}"
echo -e "${YELLOW}======================================${NC}"
echo ""

# Build each project
for PROJECT in "${PROJECTS[@]}"; do
    echo -e "${YELLOW}[*] Building ${PROJECT}...${NC}"

    if [ ! -d "$PROJECT" ]; then
        echo -e "${RED}[!] Directory not found: ${PROJECT}${NC}"
        SKIPPED+=("$PROJECT")
        continue
    fi

    cd "$PROJECT"

    # Create build directory
    mkdir -p build
    cd build

    # Clean previous build
    rm -rf ./*

    # Configure with CMake
    if cmake .. > /dev/null 2>&1; then
        # Build with make
        if make -j$(nproc) > /dev/null 2>&1; then
            echo -e "${GREEN}[✓] ${PROJECT} built successfully${NC}"
            SUCCESS+=("$PROJECT")
        else
            echo -e "${RED}[✗] ${PROJECT} build failed (make)${NC}"
            FAILED+=("$PROJECT")
        fi
    else
        echo -e "${RED}[✗] ${PROJECT} build failed (cmake)${NC}"
        FAILED+=("$PROJECT")
    fi

    # Return to standalone directory
    cd "$STANDALONE_DIR"
    echo ""
done

# Print summary
echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}Build Summary${NC}"
echo -e "${YELLOW}======================================${NC}"
echo -e "${GREEN}Success: ${#SUCCESS[@]}${NC}"
for proj in "${SUCCESS[@]}"; do
    echo -e "  ${GREEN}✓${NC} $proj"
done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Failed: ${#FAILED[@]}${NC}"
    for proj in "${FAILED[@]}"; do
        echo -e "  ${RED}✗${NC} $proj"
    done
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Skipped: ${#SKIPPED[@]}${NC}"
    for proj in "${SKIPPED[@]}"; do
        echo -e "  ${YELLOW}-${NC} $proj"
    done
fi

echo ""
echo -e "${YELLOW}Total: ${#PROJECTS[@]} projects${NC}"

# Exit with error if any builds failed
if [ ${#FAILED[@]} -gt 0 ]; then
    exit 1
fi
