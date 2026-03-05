# Godot Remove Comments Plugin

A simple and lightweight Godot 4 plugin to quickly remove all comments and clean up empty lines from your selected code.

## Features
* **One-Click Clean Up:** Adds a "Hapus Komentar" button to the Godot Editor Toolbar.
* **Shortcut Support:** Simply select your code and press `Ctrl + Shift + K`.
* **Smart Formatting:** Automatically removes empty lines left behind by deleted comments, keeping your code tight and clean.
* **Safe:** Ignores `#` symbols inside strings.

## Installation
1. Download this repository or install via Godot Asset Library.
2. Extract the `addons/remove_comments` folder into your project's `addons/` directory.
3. Go to **Project > Project Settings > Plugins**.
4. Check the **Enable** box next to "Remove Comments".

## Usage
1. Open any script in the Godot Script Editor.
2. Select (highlight) the lines of code containing the comments you want to remove.
3. Click the "Hapus Komentar" button on the top right toolbar, or press `Ctrl + Shift + K`.