# DexterKit

A modular Swift package of reusable building blocks — extensions, color models, sliders, and UI controls — for iOS and macOS apps.

## Overview

DexterKit is a modular monolith: one package exposing several focused library products you can depend on independently. Lower layers stay dependency-light; higher layers compose them. Take only what you need.

## Requirements

- iOS 26+ / macOS 26+
- Swift 6.2 (Xcode 26)

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/dexterbuxton/DexterKit.git", from: "1.0.0")
]
```

Then depend on the products you want:

```swift
.target(
  name: "YourApp",
  dependencies: [
    .product(name: "CustomControls", package: "DexterKit"),
    .product(name: "CustomColors", package: "DexterKit")
  ]
)
```

## Modules

| Module | Description | Depends on |
| --- | --- | --- |
| [Extensions](Sources/Extensions/README.md) | Standard-library & SwiftUI helpers (`clamp`, `gcd`, `chunked`, …) | — |
| [CustomColors](Sources/CustomColors/README.md) | Color models, conversions, adaptive colors, `Palette` | Extensions |
| [CustomSliders](Sources/CustomSliders/README.md) | Custom slider controls and color-picker examples | Extensions |
| [CustomControls](Sources/CustomControls/README.md) | Buttons, icon system, `PalettePicker` | Extensions, CustomColors |

## Dependency Graph

```
Extensions                      (base — no dependencies)
├── CustomColors
│   └── CustomControls          (← Extensions, CustomColors)
└── CustomSliders
```

## At a Glance

```swift
import SwiftUI
import CustomColors
import CustomControls

struct ContentView: View {
  @State private var selection: Palette.Element.ID?

  var body: some View {
    VStack(spacing: 24) {
      PalettePicker(palette: .material, selection: $selection)

      HStack(spacing: 8) {
        IconButtonGroup(style: .rectangle(spacing: 8)) {
          IconButtonItem(.undo, action: {})
          IconButtonItem(.redo, action: {})
        }
        IconButton(.done, color: .green, action: {})
      }
    }
    .padding()
  }
}
```

## Development

- **Linting:** SwiftLint runs automatically on build via the [SwiftLintPlugins](https://github.com/SimplyDanny/SwiftLintPlugins) build-tool plugin, resolved as a package dependency. Rules live in `.swiftlint.yml`.
- **Tests:** run the full suite with `swift test`, or a single module with `swift test --filter CustomColorsTests`.
