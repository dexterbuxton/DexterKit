# DexterKit

A small, focused suite of SwiftUI building blocks — color models, custom sliders, and tappable controls — packaged as a single Swift Package. DexterKit consolidates several older standalone libraries into one well-tested, modular target set.

**Platforms:** iOS 26+ · macOS 26+  ·  **Swift:** 6.2  ·  **Tests:** Swift Testing

## Modules

DexterKit ships four independent library products. Import only what you need.

| Product | What it gives you |
| --- | --- |
| `Extensions` | Lightweight standard-library helpers: `Int` (gcd/lcm), `Array` (`chunked(into:)`, `removingDuplicates()`, `toJoinedString`), value `normalized()`/`clamp`, and `BinaryFloatingPoint.shortened`. |
| `CustomColors` | Value-type color models — `RGB`, `HSB`, `HSL`, `Hex` — with conversions between them, a `Palette` type with ready-made palettes, and `Color` bridges. |
| `CustomSliders` | `BasicSlider` and `GradientSlider`, plus their composable `ThumbView` / `TrackView` building blocks. |
| `CustomControls` | Tappable controls with a consistent press feel: `CustomContentButton`, an icon-button system (`IconButton`, `IconButtonGroup`, `IconToggleButton`, `TextButton`), and a grid `PalettePicker`. |

`CustomColors`, `CustomSliders`, and `CustomControls` build on `Extensions` internally; you don't need to import it unless you want its helpers directly.

## Installation

DexterKit is distributed with Swift Package Manager.

### Xcode

1. **File → Add Package Dependencies…**
2. Enter the repository URL:
   ```
   https://github.com/DexterBuxton/DexterKit.git
   ```
3. Choose the **Up to Next Major Version** rule from `1.0.0`.
4. Add the products you need to your target.

### Package.swift

```swift
dependencies: [
  .package(url: "https://github.com/DexterBuxton/DexterKit.git", from: "1.0.0")
],
targets: [
  .target(
    name: "YourTarget",
    dependencies: [
      .product(name: "CustomColors", package: "DexterKit"),
      .product(name: "CustomSliders", package: "DexterKit")
    ]
  )
]
```

## Usage

### CustomColors

```swift
import SwiftUI
import CustomColors

let blue = RGB(hex: "4D9BE6")
let swatch = RoundedRectangle(cornerRadius: 10)
  .foregroundStyle(blue.color)

// Convert freely between models.
let hsb = blue.toHSB()
let hex = hsb.toHex()        // Hex("4D9BE6")
```

### CustomSliders

```swift
import SwiftUI
import CustomSliders

struct Demo: View {
  @State private var value = 0.5

  var body: some View {
    BasicSlider(value: $value, step: 0.1)
      .trackForeground(.blue)

    GradientSlider(value: $value, colorLeading: .pink, colorTrailing: .cyan)
  }
}
```

### CustomControls

```swift
import SwiftUI
import CustomColors
import CustomControls

struct PaletteDemo: View {
  @State private var selection: Palette.Element.ID?

  var body: some View {
    PalettePicker(palette: .material, selection: $selection)
  }
}
```

### Extensions

```swift
import Extensions

[1, 2, 3, 4, 5].chunked(into: 2)   // [[1, 2], [3, 4], [5]]
(0.5).shortened                    // "0.50"
```

## Testing

The package is covered by [Swift Testing](https://developer.apple.com/documentation/testing). Run the full suite with:

```bash
swift test
```

## License

DexterKit is available under the MIT License. See [LICENSE](LICENSE) for details.
