import SwiftUI

/// Tracks press state and animation timing for a single `IconButton`, without
/// applying any visual effect itself.
///
/// `IconButton` reads the reported `isPressed` / `isAnimating` values and
/// applies its own layered effects: the icon scales proportionally
/// (`isPressed`) while the background grows by a fixed point value
/// (`isAnimating`). This style only owns *when* those states are true, not
/// *how* they look — keeping the icon and background layers independent is
/// what lets one scale and the other expand by a fixed amount.
///
/// Ensures the background completes a full grow/shrink cycle even for quick
/// taps shorter than `CustomButtonConfiguration.minimumAnimationCycle`.
struct IconButtonPressStyle: ButtonStyle {

  // MARK: Properties

  @Binding var isPressed: Bool
  @Binding var isAnimating: Bool

  @State private var pressStartTime: Date?
  @State private var animationTask: Task<Void, Never>?

  // MARK: Body

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed) { _, newValue in
        if newValue {
          beginPress()
        }
        else {
          endPress()
        }
      }
  }

  // MARK: Press Handling

  private func beginPress() {
    animationTask?.cancel()
    animationTask = nil
    pressStartTime = Date()
    isPressed = true
    isAnimating = true
  }

  private func endPress() {
    isPressed = false
    guard let startTime = pressStartTime else {
      isAnimating = false
      return
    }
    let elapsed = Date().timeIntervalSince(startTime)
    let cycleDuration = Double(CustomButtonConfiguration.minimumAnimationCycle) / 1_000_000_000
    guard elapsed < cycleDuration else {
      isAnimating = false
      pressStartTime = nil
      return
    }
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
}
