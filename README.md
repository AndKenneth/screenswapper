# ScreenSwapper

A macOS menu bar app for saving and switching between different screen configurations.

## Features

- Save current screen layout configurations
- Quick switching between saved configurations
- Start at login option
- Lives in your menu bar for easy access

## Requirements

- macOS 13.0 or later
- Xcode 14.0 or later (for building)

## Installation

### From Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/screenswapper.git
cd screenswapper
```

2. Build the app:
```bash
chmod +x build_app.sh
./build_app.sh
```

3. Move to Applications:
```bash
mv ScreenSwapper.app /Applications/
```

## Usage

1. Click the ScreenSwapper icon in the menu bar (rectangle icon)
2. To save a configuration:
   - Set up your screens as desired in System Settings
   - Click "Save Current Layout..." from the menu
   - Enter a name for the configuration
3. To apply a configuration:
   - Click the menu bar icon
   - Select the configuration name from the list
4. To remove a configuration:
   - Click the menu bar icon
   - Hover over "Remove Configuration"
   - Select the configuration to remove
5. To enable/disable start at login:
   - Click the menu bar icon
   - Toggle "Start at Login"

## Development

The project uses Swift Package Manager for dependencies. To work on the project:

1. Open the project in Xcode or VSCode
2. Build using `swift build`
3. Run using `swift run`

## License

[Your chosen license]
