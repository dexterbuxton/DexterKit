import SwiftUI

/// Manages press animation for standalone buttons with local state.
/// Ensures the scale animation completes its full cycle even for quick taps.
public struct CustomButtonPressStyle: ButtonStyle {

  @State private var isPressed = false
  @State private var isAnimating = false
  @State private var pressStartTime: Date?
  @State private var animationTask: Task<Void, Never>?
  private let pressedReport: Binding<Bool>?

  public init(isPressed: Binding<Bool>? = nil) {
    self.pressedReport = isPressed
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(
        isPressed ? CustomButtonConfiguration.pressedIconScale : CustomButtonConfiguration.normalIconScale
      )
      .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: isPressed)
      .opacity(isPressed ? CustomButtonConfiguration.pressedIconOpacity : CustomButtonConfiguration.enabledOpacity)
      .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: isPressed)
      .scaleEffect(
        isAnimating ? CustomButtonConfiguration.pressedBackgroundScale : CustomButtonConfiguration.normalScale
      )
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
}
