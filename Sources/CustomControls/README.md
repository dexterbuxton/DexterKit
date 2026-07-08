# CustomControls

Buttons, an icon system, and a palette picker — the UI control layer of DexterKit.

- **Dependencies:** `Extensions`, `CustomColors`
- **Platforms:** iOS 26, macOS 26

## Button Foundation (`Helpers/`)

| Type | Purpose |
| --- | --- |
| `CustomButtonStyle` | Shape of a button background: `.circle` / `.square` |
| `CustomButtonConfiguration` | Single source of truth for sizes, ratios, corner radii, and animation constants |
| `CustomButtonPressStyle` | Standard press animation (proportional scale + opacity) for buttons of unknown/arbitrary size, e.g. `CustomContentButton` |
| `IconButtonPressStyle` | Press timing for `IconButton`/`IconButtonGroup`/`TextButton` — reports state only; each view applies its own layered effect |
| `CustomContentButton` | Applies the standard press feel to arbitrary content |

Icon and Text buttons share a set of environment modifiers rather than init
parameters, so their initializers stay minimal:

| Modifier | Controls |
| --- | --- |
| `.buttonSize(_:)` | Height (and width, for `IconButton`/`IconButtonGroup`) |
| `.buttonWidth(_:)` | Fixed width for `TextButton` |
| `.buttonPressExpansion(_:)` | Fixed-point background growth on press (default 4pt) — applied instead of a proportional scale, so a wide button doesn't stretch its short side by the same proportion as its long side |
| `.iconColor(_:)` / `.iconBackground(_:)` | Overrides `IconButtonTheme`'s colors for everything beneath |

## Icon System (`Icon Components/`)

| Type | Purpose |
| --- | --- |
| `IconRepresentable` | Symbol identity (`symbolName` + `accessibilityLabel`) — the extension seam |
| `IconType` | Built-in SF Symbol catalog (32 cases), conforms to `IconRepresentable` |
| `EmptyIcon` / `FilledDotIcon` | A symbol that renders nothing; a filled-circle symbol |
| `Icon` / `IconView` | A resolved icon value and its renderer |
| `IconButtonColors` | The color set for icon buttons — foreground/background, enabled and disabled |
| `IconButtonTheme` | Wraps `IconButtonColors` + weight; set once via `.iconButtonTheme(_:)` |
| `IconButton` | A tappable icon in a styled background |
| `IconButtonGroup` | A row of icons sharing one background container (`@IconButtonItemBuilder`) |
| `IconToggleButton` | A standalone two-symbol cross-fade toggle driven by a `Bool` binding |
| `TextButton` | A tappable icon + text label at a fixed size |

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
default reproduces the historical look (`.primary` icon on an adaptive neutral
background), so buttons work with zero setup. Set a theme once to restyle
everything beneath; `.iconColor(_:)`/`.iconBackground(_:)` still override per call.

`IconButtonTheme` wraps a single `IconButtonColors` value — that's the one
thing to hand a new set of colors to override an app's entire icon-button look:

```swift
ContentView()
  .iconButtonTheme(
    IconButtonTheme(
      colors: IconButtonColors(
        foreground: .accentColor,
        background: .secondary.opacity(0.12)
      )
    )
  )

IconButton(.undo, action: undo)                       // themed
IconButton(.trash, action: delete).iconColor(.red)     // per-call override
```

### Disabling

Every icon button type supports disabling two equivalent ways — a call-site
`isDisabled:` parameter, or a chained `.disabled(_:)` modifier — and they
compose (SwiftUI ANDs nested `isEnabled` writes), so either path, or both,
disables the button:

```swift
IconButton(.undo, isDisabled: !canUndo, action: undo)  // call-site
IconButton(.undo, action: undo).disabled(!canUndo)     // modifier
```

Disabling blocks taps and gets the standard SwiftUI disabled accessibility
treatment (VoiceOver announces "dimmed") for free, since it's driven by the
same `@Environment(\.isEnabled)` a native `Button` uses.

`IconButtonColors` carries `foreground`/`background` for the enabled state and
optional `foregroundDisabled`/`backgroundDisabled` overrides:

```swift
IconButtonColors(
  foreground: .primary,
  background: .appSurfaceMedium,
  backgroundDisabled: .appSurfaceLight   // solid swap
)
```

- Leave a `*Disabled` color unset (the default) and that color dims via the
  standard disabled opacity instead of swapping — no extra setup needed.
- Set it explicitly for a solid color swap instead of a fade, e.g. a lighter
  surface token for the background while the icon still just dims.

In `IconButtonGroup`, individual items disable via
`IconButtonItem(_:isDisabled:action:)` and dim/swap independently. Disabling
the *group* — chaining `.disabled(true)` on the whole `IconButtonGroup` —
supersedes every item's own state and dims/swaps the group's shared background
too:

```swift
IconButtonGroup {
  IconButtonItem(.undo, isDisabled: !canUndo, action: undo)
  IconButtonItem(.redo, action: redo)
}
.disabled(isLocked)   // true disables both, regardless of canUndo/redo
```

### Groups

Both `.circle` and `.square(spacing:)` report the same overall width for a
given item count and spacing, so a circle group and a square group line up
exactly:

```swift
HStack(spacing: 8) {
  IconButtonGroup(style: .square(spacing: 8)) {
    IconButtonItem(.undo, action: undo)
    IconButtonItem(.redo, action: redo)
  }
  IconButton(.trash, style: .square, action: delete).iconColor(.red)
}
```

### Toggle

`IconToggleButton` cross-fades between two symbols, keyed on the binding's value —
so an external change animates exactly like a tap. The press feel matches
`IconButton`. An `EmptyIcon` "off" symbol fades a single icon in and out, which is
the basis for the indicator replacement.

```swift
IconToggleButton(isOn: $isPlaying, on: .toggleOn, off: .toggleOff)
IconToggleButton(isOn: $showGrid, on: .gridOn, off: .gridOff, style: .square)

// Swatch indicator: a filled dot fades in over a colored background.
IconToggleButton.indicator(isOn: $isSelected, color: .blue, dotColor: .white)
```

### Text Button

`TextButton` pairs an icon with a text label at a fixed, non-intrinsic size.
The title defaults to the icon's own `accessibilityLabel` (e.g. `.done` reads
"Done"), so the common case needs no text at all:

```swift
TextButton(icon: .done, action: { })                    // shows "Done"
TextButton("Confirm", icon: .done, action: { })          // override the title
TextButton(icon: .cancel, action: { }).iconTrailing()    // icon after the text
```

Press feedback is weight-only — icon and text both step up in font weight,
matching `IconButton`'s press feel without scaling text (which tends to blur
mid-animation).

Additional modifiers beyond the shared set above:

| Modifier | Controls |
| --- | --- |
| `.iconTrailing(_:)` | Icon after the text instead of before. Leading by default. |
| `.contentAlignment(_:)` | Where the icon+text group sits inside the button's width when it doesn't fill it (`.leading`/`.center`/`.trailing`). `.center` by default. |
| `.contentSpacing(_:)` | Gap between the icon and text. |
| `.contentPadding(_:)` | Inset between the button's edge and its icon+text content. |
| `.fontSize(_:)` | Overrides the icon+text size independently of `.buttonSize(_:)`. Defaults to matching `IconButton`'s icon size for the current button size. |

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
- `IconButtonItem` keeps a direct per-item color parameter rather than a
  modifier — it's a data struct passed into `IconButtonGroup`'s result
  builder, not a rendered view, so there's no view hierarchy for a modifier
  to attach to. This is an intentional asymmetry with `IconButton`.
