// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "DexterKit",
  platforms: [
    .iOS(.v26),
    .macOS(.v26)
  ],
  products: [
    .library(name: "Extensions", targets: ["Extensions"])
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
    )
  ]
)
