# ❓ About This Project

![App Icon](https://user-images.githubusercontent.com/3322862/117534104-50f24a80-aff0-11eb-836b-2a3fe03d6779.png)

SKTetris is an educational project for developers learning how to use Apple's SpriteKit 2D framework.

This is a partial recreation of the [Tetris](https://en.wikipedia.org/wiki/Tetris) game.

## Conventions

This project uses [gitmoji](https://gitmoji.dev) for its commit messages.

# 🖥 Supported Platforms

SpriteKit being a proprietary framework from Apple, the game will only be avaiable on the following Apple platforms:

- macOS 10.15+
- iOS / iPadOS 13+
- tvOS 13+

## iOS / iPadOS / tvOS Availability

Due to obvious potential copyright infringements, SKTetris is not available directly from the App Store.
If you want to play on your iPhone, iPad or Apple TV, please clone this repository, open the project directly in Xcode and run the game directly on your device.

# 🎮 Controls

## Keyboard

### During Gameplay

| Key         | Command                                     |
| ----------- | ------------------------------------------- |
| F           | Rotates the current piece counter clockwise |
| G           | Rotates the current piece clockwise         |
| P           | Pauses / Unpauses the game                  |
| Down arrow  | Speeds up the descent of the current piece  |
| Left arrow  | Moves the current piece to the left         |
| Right arrow | Moves the current piece to the right        |
| Escape      | Opens / Closes options                      |

### In the Menus

| Key        | Command                                                  |
| ---------- | -------------------------------------------------------- |
| Arrow keys | Moves to the next control in the corresponding direction |
| Space      | Triggers the selected control                            |

## Game Controller

The game uses the Game Controller framework, so only [natively supported controllers](https://support.apple.com/en-us/HT210414) will work.

### During Gameplay

| Control                                                                                                                | Command                                     |
| ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| X / ![ps-square](https://user-images.githubusercontent.com/3322862/118397226-50daf600-b653-11eb-8d4c-9c8d9834cedc.png) | Rotates the current piece counter clockwise |
| A / ![ps-x](https://user-images.githubusercontent.com/3322862/118397164-fa6db780-b652-11eb-967c-9e6fd7a51703.png)      | Rotates the current piece clockwise         |
| D-pad Down                                                                                                             | Speeds up the descent of the current piece  |
| D-pad Left                                                                                                             | Moves the current piece to the left         |
| D-pad Right                                                                                                            | Moves the current piece to the right        |
| Menu / Options                                                                                                         | Toggles options + pause                     |

### In the Menus

| Control                                                                                                           | Command                                                  |
| ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| D-pad                                                                                                             | Moves to the next control in the corresponding direction |
| A / ![ps-x](https://user-images.githubusercontent.com/3322862/118397164-fa6db780-b652-11eb-967c-9e6fd7a51703.png) | Triggers the selected control                            |

## Siri Remote

### During Gameplay

| Control                                  | Command                                    |
| ---------------------------------------- | ------------------------------------------ |
| Press the touch area (top of the remote) | Rotates the current piece clockwise        |
| Swipe downwards                          | Speeds up the descent of the current piece |
| Swipe to the Left                        | Moves the current piece to the left        |
| Swipe to the Right                       | Moves the current piece to the right       |
| Play / Pause button                      | Toggles options + pause                    |

### In the Menus

| Control                                  | Command                                                  |
| ---------------------------------------- | -------------------------------------------------------- |
| Swipe on the touch area                  | Moves to the next control in the corresponding direction |
| Press the touch area (top of the remote) | Triggers the selected control                            |

# ⚖️ License

To the exception of those mentioned below, all source code and assets are distributed under the [MIT License](LICENSE).

## Londrina Solid Font

Designed by [Marcelo Magalhães](https://github.com/marcelommp/Londrina-Typeface/) and distributed under the [Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL) on [Google Fonts](https://fonts.google.com/specimen/Londrina+Solid).

## Sound Effects

Distributed under [CC-BY 3.0 Licence](https://creativecommons.org/licenses/by/3.0/) by [Little Robot Sound Factory](http://www.littlerobotsoundfactory.com) on [Open Game Art](https://opengameart.org/content/8-bit-sound-effects-library).

## Background Music

Distributed under [CC0 Public Domain](https://creativecommons.org/publicdomain/zero/1.0/) by **Joth** on [Open Game Art](https://opengameart.org/content/next-to-you).
