# HoverMagnifier

**A Flutter package that adds Amazon/Noon-style hover zoom magnification for web and desktop platforms.**

Hover over any widget (images, text, icons) to see a magnified view that tracks your cursor or stays fixed beside the target. Features smart edge detection that automatically flips the overlay when hitting screen boundaries, glass blur effect, and fully customizable decorations.


## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:  
  hover_magnifier: <version> 
```

Then, run:

```bash
flutter pub get
```

**Or** 
```bash
flutter pub add hover_magnifier
```


## Basic Usage

```dart
Container(
  padding: const EdgeInsets.all(10.0),
  width: screenWidth * .5,
  height: screenHeight * .75,
  child: HoverMagnifier(
    height: 200.0,
    width: 200.0,
    scale: scale2,
    overlayPosition: OverlayPosition.followMouse,
    followMouseDuration: Duration(milliseconds: 50),
    decoration: OverlayDecoration(
      backgroundColor: ExColors.surface.withOpacity(0.2),
      shape: BoxShape.circle,
      borderRadius: borderRadius(10, isCircle2),
      border: Border.all(color: ExColors.primary, width: 2.0),
    ),
    child: const Text(
      textEx,
      style: TextStyle(fontSize: 20.0),
    ),
  ),
)
```

 ## Examples && GIFs
> [!NOTE]
> If you got any compile time error, please check the full example.

### Example-1:
![hover_magnifier demo](https://raw.githubusercontent.com/Cisco0xf/hover_magnifier/main/example/assets/gif/mgnifier_1.gif)
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: borderRadius(10.0, false),
    color: ExColors.surface,
  ),
  width: screenWidth * 0.35,
  height: screenHeight * .75,
  child: HoverMagnifier(
    width: isCircle1 || followMouse1 ? 250 : 400,
    height: isCircle1 || followMouse1 ? 250.0 : 500,
    magnifierOffset: const Offset(20.0, 0.0),
    scale: scale1,
    overlayPosition: _position(followMouse1),
    decoration: OverlayDecoration(
      shape: _shape(isCircle1),
      backgroundColor: ExColors.surface.withOpacity(0.2),
      border: Border.all(color: ExColors.primary, width: 3.0),
      borderRadius: borderRadius(10.0, isCircle1),
    ),
    child: ClipRRect(
      borderRadius: borderRadius(10.0, false) ?? BorderRadius.zero,
      child: AvifImage.asset(
        images[index],
        fit: BoxFit.cover,
      ),
    ),
  ),
),
```
![hover_magnifier demo](https://raw.githubusercontent.com/Cisco0xf/hover_magnifier/main/example/assets/gif/magnifier_3.gif)

---------
### Example-2:
![hover_magnifier demo](https://raw.githubusercontent.com/Cisco0xf/hover_magnifier/main/example/assets/gif/magnifier_4.gif)
```dart
Container(
  padding: const EdgeInsets.all(10.0),
  width: screenWidth * .5,
  height: screenHeight * .75,
  child: HoverMagnifier(
    height: 200.0,
    width: 200.0,
    scale: scale2,
    overlayPosition: _position(followMouse2),
    followMouseDuration: Duration(milliseconds: duration2),
    decoration: OverlayDecoration(
      backgroundColor: ExColors.surface.withOpacity(0.2),
      shape: _shape(isCircle2),
      borderRadius: borderRadius(10, isCircle2),
      border: Border.all(color: ExColors.primary, width: 2.0),
    ),
    child: const Text(
      textEx,
      style: TextStyle(fontSize: 20.0),
    ),
  ),
)
```
---------
### Example-3:
![hover_magnifier demo](https://raw.githubusercontent.com/Cisco0xf/hover_magnifier/main/example/assets/gif/magnifier_5.gif)
```dart
SizedBox(
  height: screenHeight * .7,
  child: HoverMagnifier(
    height: 300,
    width: 300,
    scale: scale3,
    overlayPosition: _position(followMouse3),
    decoration: OverlayDecoration(
      border: Border.all(color: Colors.amber),
      shape: _shape(isCircle3),
      borderRadius: borderRadius(10, isCircle3),
    ),
    child: const Padding(
      padding: EdgeInsets.all(10.0),
      child: Icon(
        Icons.scale,
        size: 120.0,
      ),
    ),
  ),
)
```

---------
### Example-4:
![hover_magnifier demo](https://raw.githubusercontent.com/Cisco0xf/hover_magnifier/main/example/assets/gif/magnifier_2.gif)
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: borderRadius(10.0, false),
    color: ExColors.surface,
  ),
  width: screenWidth * 0.35,
  height: screenHeight * .7,
  child: HoverMagnifier(
    height: 400,
    width: isCircle4 ? 400 : 500,
    scale: scale4,
    overlayPosition: _position(followMouse4),
    magnifierOffset: const Offset(20.0, 0.0),
    followMouseDuration: Duration(milliseconds: duration4),
    decoration: OverlayDecoration(
      backgroundColor: ExColors.surface.withOpacity(0.2),
      border: Border.all(color: ExColors.primary),
      borderRadius: borderRadius(10.0, isCircle4),
      shape: _shape(isCircle4),
    ),
    child: ClipRRect(
      borderRadius: borderRadius(10.0, false) ?? BorderRadius.zero,
      child: AvifImage.asset(
        Assets.image2,
        fit: BoxFit.cover,
      ),
    ),
  ),
)
```

## Features

-  **Custom zoom scale** - 1.0x to 4.0x+
-  **Adjustable overlay size** - width & height independent
-  **Two positioning modes** - follow mouse or stay beside target
-  **Smart edge detection** - auto-flips overlay when hitting screen boundaries
-  **Fully customizable** - shape (rectangle/circle), border, radius, shadow, gradient
-  **Smooth animations** - configurable follow duration case `OverlayPosition.followMouse`

## hover_magnifier vs RawMagnifier

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | **required** | Widget to magnify |
| `width` | `double` | **required** | Width of magnifier overlay |
| `height` | `double` | **required** | Height of magnifier overlay |
| `scale` | `double` | **required** | Zoom scale (≥ 0) |
| `enabled` | `bool` | `true` | Enable/disable magnifier |
| `magnifierOffset` | `Offset` | `Offset.zero` | Offset from cursor position |
| `overlayPosition` | `OverlayPosition` | `stayAround` | `stayAround` or `followMouse` |
| `followMouseDuration` | `Duration` | `Duration.zero` | Animation duration when following mouse |
| `decoration` | `OverlayDecoration` | `OverlayDecoration()` | Visual styling (border, shape, blur, etc.) |

## `HoverMagnifier` vs `RawMagnifier`

**`RawMagnifier`** is Flutter's built-in magnifier, but it has key limitations for product zoom use cases:

- **Layout dependent** — relies on `Stack`, so it can only appear within the bounds of the parent widget. It cannot float outside the viewport of the original widget.
- **No fixed positioning** — cannot stay beside the target widget like a product zoom panel. It only follows the cursor.
- **No edge detection** — no awareness of screen boundaries globally.
- **No decoration control** — no border, background, glass effect, or shadow.

**`hover_magnifier`** was built specifically for the Amazon/Noon product zoom pattern — a magnified overlay that floats freely outside the original widget, stays beside it, detects screen edges globally, and is fully customizable.

## Contributing

Contributions are welcome! If you find a bug or want to add a feature, feel free to open an issue or submit a pull request on [GitHub](https://github.com/Cisco0xf/hover_magnifier).

## License

**MIT © Mahmoud Nagy** — see [LICENSE](https://github.com/Cisco0xf/hover_magnifier/blob/main/LICENSE) for details.

