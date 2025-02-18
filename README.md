# ScreenSwapper

A macOS menu bar app for saving and switching between different screen configurations.

## Why I Built This

I created ScreenSwapper to solve a frustration with my dual-monitor setup. I have two monitors of the exact same model, but I position my laptop differently when I'm working from home versus at the office. Every time I would switch locations, I had to manually reconfigure my screen layout in System Settings.

ScreenSwapper allows me to save these different configurations and quickly switch between them with just a click from the menu bar. No more diving into System Settings every time I change locations - just click and get back to work.

I built this for myself, but please let me know if you find it useful.

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

MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
