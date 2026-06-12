# Extensions

Small, dependency-free extensions to the Swift standard library and SwiftUI, shared across DexterKit.

- **Dependencies:** none
- **Platforms:** iOS 26, macOS 26

## Contents

| File | Adds |
| --- | --- |
| `ClosedRange+Extensions` | `clamp(_:)` — constrain a value to a range |
| `BinaryFloatingPoint+Extensions` | `normalized(in:)`, `shortened(...)`, value mapping helpers |
| `Int+Extensions` | `gcd(_:)`, `lcm(_:)` |
| `Array+Extensions` | `chunked(into:)`, `removingDuplicates()`, `toJoinedString(...)` |
| `View+Extension` | `modifying(_:)` — apply a transform inline |

## Usage

```swift
import Extensions

(0...10).clamp(15)            // 10
12.gcd(8)                     // 4
[1, 2, 3, 4, 5].chunked(into: 2)   // [[1, 2], [3, 4], [5]]
[1, 1, 2, 3, 3].removingDuplicates()  // [1, 2, 3]

let t = 0.5.normalized(in: 0...10)    // map within a range

someView.modifying { $0.opacity(0.5) }
```

## Notes

These are intentionally minimal and have no third-party or intra-package dependencies, so every other target can build on them freely.
