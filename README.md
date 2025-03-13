# RetroArch Edge Replicate Shader

A GLSL fragment shader for RetroArch that fills empty horizontal space (black bars) on a display by replicating the leftmost and rightmost columns of pixels from a retro game's rendered output. This shader was designed for the Retroid Pocket Classic handheld (1240x1080 AMOLED display) to display Game Boy games (160x144 resolution) without distorting the original image.

## Features
- Detects black bars on the left and right sides of the screen.
- Replicates the leftmost column of game pixels to fill the left black bar.
- Replicates the rightmost column of game pixels to fill the right black bar.
- Preserves pixel-perfect rendering of the original game content in the center.
- Compatible with RetroArch's shader pipeline.

## Requirements
- RetroArch with GLSL shader support.
- Tested on the Retroid Pocket Classic (1240x1080 resolution), but should work on other devices with adjustments.
- Designed for games with a 10:9 aspect ratio (e.g., Game Boy) displayed on a screen with a wider aspect ratio.

## Installation
1. Clone or download this repository:
