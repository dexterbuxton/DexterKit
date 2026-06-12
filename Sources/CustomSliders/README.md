# CustomSliders

Custom SwiftUI slider controls with configurable tracks and thumbs, including a gradient slider suited to color picking.

- **Dependencies:** `Extensions`
- **Platforms:** iOS 26, macOS 26

## Contents

| Type | Purpose |
| --- | --- |
| `SliderConfig` | Geometry/value configuration shared by the sliders (range, position, step math) |
| `BasicSlider` | A plain custom slider with a track and draggable thumb |
| `GradientSlider` | A slider whose track renders a gradient — ideal for hue/brightness selection |

`BasicSlider` and `GradientSlider` are each composed of small `TrackView` / `ThumbView` pieces.

## Usage

```swift
import CustomSliders

@State private var value = 0.5

BasicSlider(value: $value, in: 0...1)

GradientSlider(value: $hue, in: 0...360, colors: [.red, .yellow, .green, .cyan, .blue, .magenta, .red])
```

## Examples

The `Examples/` folder shows the sliders composed into color pickers:

- `RGBColorPicker` — three sliders driving an `RGB` value
- `HSLColorPicker` — hue/saturation/lightness selection

These pair naturally with the `CustomColors` models if you bring both targets into a view.

## Notes

`SliderConfig` centralizes the position ↔ value math (clamping, stepping, thumb placement), so both sliders share consistent behavior and it's the unit-testable core of the target.
