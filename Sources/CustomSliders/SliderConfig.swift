import SwiftUI
import Combine
import Extensions

/// A configuration class for a custom slider, providing properties and methods to manage the slider's behavior and appearance.
class SliderConfig: ObservableObject {

  // MARK: Properties

  /// The current value of the slider.
  @Published var value: Double

  /// The range of values the slider can represent.
  let range: ClosedRange<Double>

  /// The size of the thumb view.
  let thumbSize: CGFloat

  /// The step value for incrementing or decrementing the slider's value.
  private var step: Double

  /// The minimum value of the slider's range.
  private var minimumValue: Double { range.lowerBound }

  /// The maximum value of the slider's range.
  private var maximumValue: Double { range.upperBound }

  /// The total range of values the slider can represent.
  private var totalValue: Double { maximumValue - minimumValue }

  /// The percentage (between 0 and 1) of the current value within the slider's range.
  var percent: Double {
    let adjustedValue = value - minimumValue
    if totalValue == 0 { return 0 }
    return (adjustedValue / totalValue).normalized()
  }

  /// The initial percentage value when the slider is first interacted with.
  private var initialPercent: CGFloat?

  /// Half the size of the thumb view.
  private var halfThumb: CGFloat { thumbSize / 2 }

  // MARK: Initializer

  /// Initializes a new `SliderConfig` instance.
  ///
  /// - Parameters:
  ///   - value: The initial value of the slider.
  ///   - range: The range of values the slider can represent.
  ///   - thumbSize: The size of the thumb view.
  ///   - step: The step value for incrementing or decrementing the slider's value.
  init(value: Double, range: ClosedRange<Double>, thumbSize: CGFloat, step: Double) {
    self.value = range.clamp(value)
    self.range = range
    self.thumbSize = thumbSize
    self.step = step
  }

  // MARK: Private Methods

  /// Calculates the available distance for the slider's thumb to move, based on the thumb size and the width of the view.
  ///
  /// - Parameter width: The width of the slider's view.
  /// - Returns: The available distance for the thumb to move.
  private func availableSize(from width: CGFloat) -> CGFloat {
    return width - thumbSize
  }

  /// Calculates the center position of the thumb based on the width of the view.
  ///
  /// - Parameter width: The width of the slider's view.
  /// - Returns: The center position of the thumb.
  private func thumbCenter(from width: CGFloat) -> CGFloat {
    return (percent * availableSize(from: width)) + halfThumb
  }

  /// Calculates the slider's value based on a given percentage.
  ///
  /// - Parameter percent: The percentage (between 0 and 1) within the slider's range.
  /// - Returns: The corresponding value within the slider's range.
  private func valueFrom(percent: CGFloat) -> CGFloat {
    return (totalValue * percent.normalized()) + minimumValue
  }

  /// Calculates the change in percentage based on two positions and the width of the view.
  ///
  /// - Parameters:
  ///   - start: The starting position.
  ///   - current: The current position.
  ///   - width: The width of the slider's view.
  /// - Returns: The change in percentage.
  private func percentChange(from start: CGFloat, to current: CGFloat, given width: CGFloat) -> CGFloat {
    let differenceInPostion = current - start
    if width <= 0 { return 0 }
    return (differenceInPostion / availableSize(from: width))
  }

  /// Updates the slider's value, ensuring it remains within the defined range.
  ///
  /// - Parameter newValue: The new value to set.
  private func updateValue(_ newValue: CGFloat) {
    let roundedValue = round(1000 * newValue) / 1000
    value = range.clamp(roundedValue)
  }

  // MARK: Public Methods

  /// Calculates the position of the thumb based on the size of the view and the current percentage.
  ///
  /// - Parameter width: The width of the slider's view.
  /// - Returns: The position of the thumb as a `CGPoint`.
  func position(given width: CGFloat) -> CGPoint {
    return CGPoint(
      x: thumbCenter(from: width),
      y: halfThumb
    )
  }

  /// Updates the slider's value based on the size of the view, the start point, and the end point.
  ///
  /// - Parameters:
  ///   - start: The starting position of the interaction.
  ///   - end: The ending position of the interaction.
  ///   - width: The width of the slider's view.
  func move(from start: CGFloat, to end: CGFloat, given width: CGFloat) {
    if initialPercent == nil {
      initialPercent = percent
    }
    if let initialPercent = initialPercent {
      let percentChange = percentChange(from: start, to: end, given: width)
      let newValue = valueFrom(percent: (initialPercent + percentChange))
      updateValue(newValue)
    }
  }

  /// Resets the internal state after the thumb has been moved.
  func stop() {
    initialPercent = nil
  }

  /// Updates the slider's value by stepping left or right based on the tap location.
  ///
  /// - Parameters:
  ///   - xLocation: The x-coordinate of the tap location.
  ///   - width: The width of the slider's view.
  func step(at xLocation: CGFloat, given width: CGFloat) {
    // Determine which side of the thumb was tapped
    let center = thumbCenter(from: width)
    // Update the value with the new amount
    let amount = xLocation > center ? step : -step
    updateValue(value + amount)
  }
}
