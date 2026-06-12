import SwiftUI

// MARK: Icon Button View Model

/// Manages press state and animation cycles for `IconButtonGroup`.
///
/// Ensures animations complete their full cycle even for quick taps. This is
/// internal coordination — consumers interact only with `IconButtonGroup`.
@MainActor
@Observable
final class IconButtonViewModel {

  // MARK: Properties

  var pressedButtonIndex: Int?
  var animatingButtonIndex: Int?

  private var pressStartTimes: [Int: Date] = [:]
  private var animationTasks: [Int: Task<Void, Never>] = [:]

  // MARK: Initialization

  init() {}

  // MARK: Press Management

  /// Updates which button is pressed and manages animation cycles.
  func setButtonPressed(at index: Int, isPressed: Bool) {
    if isPressed {
      animationTasks[index]?.cancel()
      animationTasks.removeValue(forKey: index)
      pressStartTimes[index] = Date()
      pressedButtonIndex = index
      animatingButtonIndex = index
    }
    else {
      handleButtonRelease(at: index)
    }
  }

  /// Whether a button is currently in scaled state (pressed or completing animation).
  func isButtonScaled(at index: Int) -> Bool {
    animatingButtonIndex == index
  }

  /// Whether a button is actively pressed down.
  func isButtonPressed(at index: Int) -> Bool {
    pressedButtonIndex == index
  }

  // MARK: Computed Helpers

  private func handleButtonRelease(at index: Int) {
    guard pressedButtonIndex == index else { return }
    pressedButtonIndex = nil

    guard let startTime = pressStartTimes[index] else {
      animatingButtonIndex = nil
      return
    }

    let elapsed = Date().timeIntervalSince(startTime)
    let cycleDuration = Double(CustomButtonConfiguration.minimumAnimationCycle) / 1_000_000_000.0

    if elapsed < cycleDuration {
      let remainingTime = cycleDuration - elapsed
      let task = Task { @MainActor in
        try? await Task.sleep(nanoseconds: UInt64(remainingTime * 1_000_000_000))
        if !Task.isCancelled {
          self.animatingButtonIndex = nil
          self.pressStartTimes.removeValue(forKey: index)
          self.animationTasks.removeValue(forKey: index)
        }
      }
      animationTasks[index] = task
    }
    else {
      animatingButtonIndex = nil
      pressStartTimes.removeValue(forKey: index)
    }
  }
}

// MARK: Group Button Press Style

/// Forwards press events from a grouped button to the shared `IconButtonViewModel`.
///
/// Icon scale and opacity are driven by `IconButtonGroup` from the view model's
/// state; this style only reports press transitions.
struct CustomGroupButtonPressStyle: ButtonStyle {

  let index: Int
  let viewModel: IconButtonViewModel

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .onChange(of: configuration.isPressed) { _, newValue in
        viewModel.setButtonPressed(at: index, isPressed: newValue)
      }
  }
}
