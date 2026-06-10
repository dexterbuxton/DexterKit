// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "DexterKit",
  platforms: [
    .iOS(.v26),
    .macOS(.v26)
  ],
  products: [
    .library(name: "Extensions", targets: ["Extensions"]),
    .library(name: "CustomColors", targets: ["CustomColors"])
  ],
  dependencies: [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.63.2")
  ],
  targets: [
    .target(
      name: "Extensions",
      plugins: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
      ]
    ),
    .testTarget(
      name: "ExtensionsTests",
      dependencies: ["Extensions"],
      plugins: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
      ]
    ),
    .target(
      name: "CustomColors",
      dependencies: ["Extensions"],
      plugins: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
      ]
    ),
    .testTarget(
      name: "CustomColorsTests",
      dependencies: ["CustomColors"],
      plugins: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
      ]
    )
  ]
)
