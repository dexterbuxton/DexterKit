import SwiftUI

/// Manages press animation for standalone buttons with local state.
/// Ensures the scale animation completes its full cycle even for quick taps.
///
/// By default, the background grows *proportionally* on press
/// (`CustomButtonConfiguration.pressedBackgroundScale`) — the right choice
/// when the style doesn't know its content's size (e.g. `CustomContentButton`
/// wrapping layout-sized content). Pass `pressExpansion:` to switch to
/// fixed-point growth instead, matching `IconButton`/`TextButton`'s feel: the
/// style measures its own content via a background `GeometryReader` and
/// derives the scale ratio that grows each axis by exactly that many points.
public struct CustomButtonPressStyle: ButtonStyle {

  @State private var isPressed = false
  @State private var isAnimating = false
  @State private var pressStartTime: Date?
  @State private var animationTask: Task<Void, Never>?
  @State private var measuredSize: CGSize = .zero
  private let pressedReport: Binding<Bool>?
  private let pressExpansion: CGFloat?

  /// - Parameters:
  ///   - isPressed: Optional binding to observe the press state externally.
  ///   - pressExpansion: Fixed-point background growth in each direction. `nil`
  ///     (the default) keeps the proportional scale used for unknown-size
  ///     content. Pass a value (e.g. `CustomButtonConfiguration.defaultPressExpansion`)
  ///     for layout-sized content that should grow like `IconButton`/`TextButton`.
  public init(isPressed: Binding<Bool>? = nil, pressExpansion: CGFloat? = nil) {
    self.pressedReport = isPressed
    self.pressExpansion = pressExpansion
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(
        GeometryReader { geometry in
          Color.clear
            .onAppear { measuredSize = geometry.size }
            .onChange(of: geometry.size) { _, newValue in measuredSize = newValue }
        }
      )
      .scaleEffect(
        isPressed ? CustomButtonConfiguration.pressedIconScale : CustomButtonConfiguration.normalIconScale
      )
      .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: isPressed)
      .opacity(isPressed ? CustomButtonConfiguration.pressedIconOpacity : CustomButtonConfiguration.enabledOpacity)
      .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: isPressed)
      .scaleEffect(x: backgroundScaleX, y: backgroundScaleY)
      .animation(.easeOut(duration: CustomButtonConfiguration.backgroundAnimationDuration), value: isAnimating)
      .onChange(of: configuration.isPressed) { _, newValue in
        if newValue {
          animationTask?.cancel()
          animationTask = nil
          pressStartTime = Date()
          isPressed = true
          isAnimating = true
        }
        else {
          isPressed = false
          guard let startTime = pressStartTime else {
            isAnimating = false
            return
          }
          let elapsed = Date().timeIntervalSince(startTime)
          let cycleDuration = Double(CustomButtonConfiguration.minimumAnimationCycle) / 1_000_000_000
          if elapsed < cycleDuration {
            let remaining = cycleDuration - elapsed
            animationTask = Task {
              try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
              if !Task.isCancelled {
                isAnimating = false
                pressStartTime = nil
                animationTask = nil
              }
            }
          }
          else {
            isAnimating = false
            pressStartTime = nil
          }
        }
      }
      .onChange(of: isPressed) { _, newValue in
        pressedReport?.wrappedValue = newValue
      }
  }

  // MARK: Computed Helpers

  private var backgroundScaleX: CGFloat {
    scale(for: measuredSize.width)
  }

  private var backgroundScaleY: CGFloat {
    scale(for: measuredSize.height)
  }

  /// Resolves the per-axis scale ratio: identity when not animating,
  /// fixed-point growth (derived from the measured dimension) when
  /// `pressExpansion` is set, otherwise the shared proportional scale.
  private func scale(for dimension: CGFloat) -> CGFloat {
    guard isAnimating else { return CustomButtonConfiguration.normalScale }
    guard let pressExpansion, dimension > 0 else {
      return CustomButtonConfiguration.pressedBackgroundScale
    }
    return (dimension + pressExpansion * 2) / dimension
  }
}
