#!/bin/bash

# Build the project
swift build -c release

# Create app bundle structure
APP_NAME="ScreenSwapper.app"
CONTENTS_DIR="$APP_NAME/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Create directories
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
cp .build/release/ScreenSwapper "$MACOS_DIR/"

# Copy Info.plist
cp Info.plist "$CONTENTS_DIR/"

# Create icns file if you have one
# cp AppIcon.icns "$RESOURCES_DIR/"

# Make the script executable
chmod +x "$MACOS_DIR/ScreenSwapper"

echo "App bundle created at $APP_NAME" 