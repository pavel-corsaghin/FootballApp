//
//  ScopeFunction.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

// Utility functions  that support executing a block of code within the context of an object
// Basically, these functions do the same: execute a block of code on an object.
// What's different is how this object becomes available inside the block and what is the result of the whole expression
//
// Reference: https://kotlinlang.org/docs/scope-functions.html
// Replicating https://github.com/JetBrains/kotlin/blob/master/libraries/stdlib/src/kotlin/util/Standard.kt in Swift

import Foundation

/// Invoke functions as a group to improve readability code
///
/// - Example:
/// ```
///    run {
///        Analytics.registerAnalyticsService(AmplitudeService())
///        Analytics.registerAnalyticsService(ApptentiveService())
///    }
///    ```
///
/// - Parameter block: The executing block with return type
/// - Returns: return type executing of  block
@inlinable
@inline(__always)
func run<R>(_ block: () -> R) -> R {
    return block()
}

protocol ScopeFunc {}
extension ScopeFunc {
    ///  Invoke one or more functions on results of call chains
    ///
    /// - seealso: [let operator on kotlinlang.org](https://kotlinlang.org/docs/scope-functions.html#let)
    ///
    /// - Example:
    /// ```
    /// messageLabel.let {
    ///     $0.font = .systemFont(ofSize: 14)
    ///     $0.textColor = .secondaryLabel
    ///     $0.textAlignment = .center
    ///     $0.numberOfLines = 0
    ///     $0.lineBreakMode = .byWordWrapping
    /// }
    ///    ```
    ///
    /// - Parameter block: The executing block with return type
    /// - Returns: return type executing of  block
    @inlinable
    @inline(__always)
    func `let`<R>(_ block: (Self) -> R) -> R {
        return block(self)
    }

    /// Perform some actions that take the context object as an argument.
    /// Use also for actions that need a reference rather to the object than to its properties and functions
    ///
    /// - seealso: [also operator on kotlinlang.org](https://kotlinlang.org/docs/scope-functions.html#also)
    ///
    /// - Example:
    /// ```
    /// let titleLabel = UILabel().also {
    ///         $0.text = title.text
    ///        $0.font = font
    ///        $0.textColor = color
    ///    }
    ///    ```
    ///
    /// - Parameter block: The executing block without return type
    /// - Returns: Current object after executing a block
    @inlinable
    @inline(__always)
    func also(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }

    /// These functions let you embed checks of the object state in call chains
    ///
    /// It is especially useful together with scope functions.
    /// A good case is chaining them with let for running a code block on objects that match the given predicate.
    ///
    /// - seealso: [takeIf and takeUnless operators on kotlinlang.org](https://kotlinlang.org/docs/scope-functions.html#takeif-and-takeunless)
    ///
    /// - Example:
    /// ```
    ///    contactUsPage
    ///        .takeIf { $0.isHTTPLink }?
    ///        .let {
    ///            // Do with the strong httplink here
    ///            Log.debug(message: "HTTP Link is: \($0)")
    ///        }
    ///    ```
    ///
    /// - Parameter predicate: The conditional checking block
    /// - Returns: Current object after executing a block or nil
    @inlinable
    @inline(__always)
    func takeIf(_ predicate: (Self) -> Bool) -> Self? {
        if predicate(self) {
            return self
        } else {
            return nil
        }
    }

    /// These functions let you embed checks of the object state in call chains
    ///
    /// Refer to `takeIf` function
    @inlinable
    @inline(__always)
    func takeUnless(_ predicate: (Self) -> Bool) -> Self? {
        if !predicate(self) {
            return self
        } else {
            return nil
        }
    }
}

extension NSObject: ScopeFunc {}
extension String: ScopeFunc {}
extension Int: ScopeFunc {}
extension URL: ScopeFunc {}
extension Date: ScopeFunc {}
