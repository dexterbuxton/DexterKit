# CustomColors

Color models, conversions, SwiftUI bridges, and a `Palette` type for building and storing curated color sets.

- **Dependencies:** `Extensions`
- **Platforms:** iOS 26, macOS 26

## Color Models

`RGB`, `Hex`, `HSL`, and `HSB` are value types that convert between one another. Each is `Hashable` and `Sendable`.

```swift
import CustomColors

let red = RGB(r: 244, g: 67, b: 54)
let hex = Hex("F44336")

red.toHSL()          // HSL
hex.rgb              // RGB
hex.isLight          // false  (perceptual lightness)
RGB(hex: "2196F3")   // from a hex string
```

## SwiftUI Bridges

`Color+Extensions` adds a `.color` property to every model.

```swift
Hex("FF9800").color          // SwiftUI Color
RGB(r: 0, g: 122, b: 255).color
```

## Adaptive Colors

`Color+Adaptive` adds a code-only light/dark color — no asset catalog required.

```swift
Color(light: .white, dark: .black)   // resolves per color scheme
```

## Palette

`Palette` is a named, ordered collection of `Palette.Element`s. Each element is a color in any representation (`Hex`/`RGB`/`HSB`), optionally named, optionally carrying a dark-mode variant. Selection-friendly: every element has a stable `id`.

```swift
var palette = Palette(name: "Brand")
palette.add(Hex("FF3B30"), name: "Red")
palette.add(Hex("FFFFFF"), name: "Background", dark: Hex("000000"))  // adaptive

palette.entries.first?.color       // SwiftUI Color (adapts if a dark variant exists)
palette.entries.first?.hexValue    // Hex (light / default)
```

Ready-made palettes live in `PaletteExamples`:

```swift
Palette.material   // 16 named Material swatches
Palette.standard   // built from RGB.colors (unnamed)
```

## Notes

`Palette.Element.Value` carries the per-representation conversions, so both the light value and an optional dark override convert uniformly (`element.hexValue`, `element.dark?.hexValue`).
