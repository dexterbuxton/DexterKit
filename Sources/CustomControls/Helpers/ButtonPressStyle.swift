import SwiftUI

/// Manages press animation for standalone buttons with local state.
///
/// Ensures the scale animation completes its full cycle even for quick taps
/// shorter than `AppButtonConfiguration.minimumAnimationCycle`.
public struct ButtonPressStyle: ButtonStyle {

  @State private var isPressed = false
  @State private var isAnimating = false
  @State private var pressStartTime: Date?
  @State private var animationTask: Task<Void, Never>?

  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(
        isPressed ? AppButtonConfiguration.pressedIconScale : AppButtonConfiguration.normalIconScale
      )
      .animation(.easeOut(duration: AppButtonConfiguration.iconScaleAnimationDuration), value: isPressed)
      .opacity(isPressed ? AppButtonConfiguration.pressedIconOpacity : AppButtonConfiguration.enabledOpacity)
      .animation(.easeOut(duration: AppButtonConfiguration.iconAnimationDuration), value: isPressed)
      .scaleEffect(
        isAnimating ? AppButtonConfiguration.pressedBackgroundScale : AppButtonConfiguration.normalScale
      )
      .animation(.easeOut(duration: AppButtonConfiguration.backgroundAnimationDuration), value: isAnimating)
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
          let cycleDuration = Double(AppButtonConfiguration.minimumAnimationCycle) / 1_000_000_000
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
  }
}
