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
| `CustomIndicatorButton` | A color swatch with an on/off dot indicator; colors passed in |
| `CustomContentButton` | Applies the standard press feel to arbitrary content |

```swift
CustomIndicatorButton(isOn: $isOn, color: .blue, dotColor: .white)
```

## Icon System (`Helpers/`)

| Type | Purpose |
| --- | --- |
| `IconType` | SF Symbol catalog (32 cases) with `systemImage` + `accessibilityLabel` |
| `Icon` / `IconView` | An icon value and its renderer |
| `IconButton` | A tappable icon in a styled background |
| `IconButtonGroup` | A row of icons sharing one background container (`@IconButtonItemBuilder`) |

Background and icon colors are **parameters**, not read from an environment — pass your theme colors at the call site.

```swift
IconButton(.undo, action: undo)

HStack(spacing: 8) {
  IconButtonGroup(style: .rectangle(spacing: 8)) {
    IconButtonItem(.undo, action: undo)
    IconButtonItem(.redo, action: redo)
  }
  IconButton(.delete, style: .rectangle, color: .red, action: delete)
}
```

## PalettePicker

A simple fill-width grid of square swatches over a `Palette`. Equal flexible columns plus square cells mean the grid fills the available width and derives its own height — no geometry measurement. Selection is by `Palette.Element.ID`.

```swift
@State private var selection: Palette.Element.ID?

PalettePicker(palette: .material, selection: $selection)                  // 2×8 rounded squares
PalettePicker(palette: .material, columns: 8, style: .circle, selection: $selection)
```

## Notes

- The icon `accessibilityLabel`s and `previewGroups` are covered by tests; `CustomButtonConfiguration` math is too.
- `IconButtonViewModel` and `CustomGroupButtonPressStyle` are internal plumbing for `IconButtonGroup` and are not part of the public API.
