# CustomControls

Buttons, an icon system, and a palette picker — the UI control layer of DexterKit.

- **Dependencies:** `Extensions`, `CustomColors`
- **Platforms:** iOS 26, macOS 26

## Button Foundation (`Helpers/`)

| Type | Purpose |
| --- | --- |
| `CustomButtonStyle` | Shape of a button background: `.circle` / `.rectangle` |
| `CustomButtonConfiguration` | Single source of truth for sizes, ratios, corner radii, and animation constants |
| `CustomButtonPressStyle` | Standard press animation (scale + opacity) for standalone buttons |
| `CustomContentButton` | Applies the standard press feel to arbitrary content |

## Icon System (`Icon Components/`)

| Type | Purpose |
| --- | --- |
| `IconRepresentable` | Symbol identity (`symbolName` + `accessibilityLabel`) — the extension seam |
| `IconType` | Built-in SF Symbol catalog (32 cases), conforms to `IconRepresentable` |
| `EmptyIcon` / `FilledDotIcon` | A symbol that renders nothing; a filled-circle symobl |
| `Icon` / `IconView` | A resolved icon value and its renderer |
| `IconButton` | A tappable icon in a styled background |
| `IconButtonGroup` | A row of icons sharing one background container (`@IconButtonItemBuilder`) |
| `IconToggleButton` | A standalone two-symbol cross-fade toggle driven by a `Bool` binding |

### Symbols are extensible

`IconType` is the batteries-included catalog, but any type can conform to
`IconRepresentable` to supply its own symbols and flow through the same buttons.
Identity only — color, size, and weight are never carried on the symbol.

```swift
enum AppIcon: IconRepresentable {
  case sparkle
  var symbolName: String? { "sparkles" }
  var accessibilityLabel: String { "Sparkle" }
}

IconButton(AppIcon.sparkle, action: {})
```

`symbolName` is optional: `nil` renders nothing, which is how `EmptyIcon`
expresses an empty slot (e.g. the "off" state of a toggle).

### Theming

Colors and weight come from the `IconButtonTheme` in the environment. The
default reproduces the historical look (`.primary` icon on an adaptive neutral),
so buttons work with zero setup. Set a theme once to restyle everything beneath;
per-call arguments still override.

```swift
ContentView()
  .iconButtonTheme(IconButtonTheme(iconColor: .accentColor, backgroundColor: .secondary.opacity(0.12)))

IconButton(.undo, action: undo)                  // themed
IconButton(.delete, color: .red, action: delete) // per-call override
```

### Groups

```swift
HStack(spacing: 8) {
  IconButtonGroup(style: .rectangle(spacing: 8)) {
    IconButtonItem(.undo, action: undo)
    IconButtonItem(.redo, action: redo)
  }
  IconButton(.delete, style: .rectangle, color: .red, action: delete)
}
```

### Toggle

`IconToggleButton` cross-fades between two sombols, keyed on the binding's value —
so an external change animates exactly like a tap. The press feel matches
`IconButton`. An `EmptyIcon` "off" symbol fades a single icon in and out, which is
the basis for the indicator replacement.

```swift
IconToggleButton(isOn: $isPlaying, on: .toggleOn, off: .toggleOff)
IconToggleButton(isOn: $showGrid, on: .gridOn, off: .gridOff, style: .rectangle)

// Swatch indicator: a filled dot fades in over a colored background.
IconToggleButton.indicator(isOn: $isSelected, color: .blue, dotColor: .white)
```

## PalettePicker

A simple fill-width grid of square swatches over a `Palette`. Equal flexible
columns plus square cells mean the grid fills the available width and derives its
own height — no geometry measurement. Selection is by `Palette.Element.ID`.

```swift
@State private var selection: Palette.Element.ID?

PalettePicker(palette: .material, selection: $selection)                  // 2×8 rounded squares
PalettePicker(palette: .material, columns: 8, style: .circle, selection: $selection)
```

## Notes

- The icon `accessibilityLabel`s and `previewGroups` are covered by tests, as are
  the symbol seam, `Icon` emptiness, and `IconButtonTheme`; `CustomButtonConfiguration`
  math is too.
- `IconButtonViewModel` and `CustomGroupButtonPressStyle` are internal plumbing for
  `IconButtonGroup` and are not part of the public API.
