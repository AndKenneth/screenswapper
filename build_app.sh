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

# Create DMG
DMG_NAME="ScreenSwapper.dmg"
TMP_DMG="pack.temp.dmg"
VOLUME_NAME="ScreenSwapper"

# Create temporary DMG
hdiutil create -size 32m -volname "$VOLUME_NAME" -srcfolder "$APP_NAME" -ov -format UDRW "$TMP_DMG"

# Mount the temporary DMG
MOUNT_DIR="/Volumes/$VOLUME_NAME"
hdiutil attach "$TMP_DMG" -mountpoint "$MOUNT_DIR"

# Create Applications symlink
ln -s /Applications "$MOUNT_DIR/Applications"

# Set volume icon position and background (optional)
echo '
   tell application "Finder"
     tell disk "'$VOLUME_NAME'"
           open
           set current view of container window to icon view
           set toolbar visible of container window to false
           set statusbar visible of container window to false
           set the bounds of container window to {400, 100, 885, 430}
           set theViewOptions to the icon view options of container window
           set arrangement of theViewOptions to not arranged
           set icon size of theViewOptions to 128
           set position of item "'$APP_NAME'" of container window to {120, 150}
           set position of item "Applications" of container window to {365, 150}
           close
           open
           update without registering applications
           delay 5
           close
     end tell
   end tell
' | osascript

# Finalize the DMG
sync
hdiutil detach "$MOUNT_DIR"
hdiutil convert "$TMP_DMG" -format UDZO -o "$DMG_NAME"
rm -f "$TMP_DMG"

echo "DMG installer created at $DMG_NAME" 