// Copyright 2022 DoorDash, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License
// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
// or implied. See the License for the specific language governing permissions and limitations under
// the License.

import SwiftUI

// MARK: - PreviewSnapshots

/// A collection of configurations to validate via SwiftUI previews and/or snapshot testing.
///
/// Here's an example of a `View` using a `String` as the configuration `State`:
/// ```swift
/// struct ContentView: View {
///     var message: String
///     var isEnabled: Bool
///
///     var body: some View { ... }
/// }
///
/// struct ContentView_Previews: PreviewProvider {
///     static var previews: some View {
///         snapshots.previews
///     }
///
///     static var snapshots: PreviewSnapshots<String> {
///         PreviewSnapshots(
///             configurations: [
///                 .init(name: "Short Message", state: "Test"),
///
///                 .init(name: "Medium Message", state: "Medium length message",
///
///                 .init(name: "Long Message", state: "This is a much longer message than the other messages being tested",
///             ],
///             configure: { state in
///                 ContentView(message: state, isEnabled: true).padding()
///             }
///         )
///     }
/// }
/// ```
///
/// You could also used a tuple:
/// ```swift
///     static var snapshots: PreviewSnapshots<(message: String, isEnabled: Bool)> {
///         PreviewSnapshots(
///             configurations: [
///                 .init(name: "Short Message enabled",
///                       state: (message: "Test", isEnabled: true),
///
///                 .init(name: "Short Message disabled",
///                       state: (message: "Test", isEnabled: false),
///             ],
///             configure: { state in
///                 ContentView(message: state.message, isEnabled: state.isEnabled).padding()
///             }
///         )
///     }
/// ```
///
/// or a dedicated type:
/// ```swift
///     static var snapshots: PreviewSnapshots<PreviewState> {
///         PreviewSnapshots(
///             states: [
///                 .init(name: "Short Message", message: "Test"),
///
///                 .init(name: "Short Message disabled" message: "Test", isEnabled: false),
///             ],
///             configure: { state in
///                 ContentView(message: state.message, isEnabled: state.isEnabled).padding()
///             }
///         )
///     }
///
///     struct PreviewState: NamedPreviewState {
///         let name: String
///         let message: String
///         let isEnabled: Bool
///
///         init(name: String, message: String, isEnabled: Bool = true) { ... }
///     }
/// ```
///
/// Use the `assertSnapshots()` function defined in `PreviewSnapshotsTesting` to create snapshot
/// tests for every configuration automatically.
///
/// ```swift
/// import PreviewSnapshotsTesting
/// import XCTest
///
/// @testable import ContentModule
///
/// final class ContentViewSnapshotTests: XCTestCase {
///     func test_snapshots() {
///         ContentView_Previews.snapshots.assertSnapshots()
///     }
///
///     func test_disabled_snapshots() {
///         // `PreviewProvider` can define multiple `PreviewSnapshot` collections to group like tests.
///         ContentView_Previews.disabledSnapshots.assertSnapshots()
///     }
/// }
/// ```
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PreviewSnapshots<State> {
    /// Array of configurations to apply to the view for preview and snapshot testing.
    public let configurations: [Configuration]
    
    /// Function to configure the `View` being tested given a configuration state.
    public let configure: (State) -> AnyView
    
    /// Create a `PreviewSnapshots` collection.
    ///
    /// - Parameters:
    ///   - configurations: The list of configurations to construct for previews and snapshot testing.
    ///   - configure: A closure that constructs the `View` to be previewed/tested given a configuration state.
    public init<V: View>(
        configurations: [Configuration],
        configure: @escaping (State) -> V
    ) {
        self.configurations = configurations
        self.configure = { AnyView(configure($0)) }
    }

    /// Create a `PreviewSnapshots` collection.
    ///
    /// A `Configuration` will be created for each `NamedPreviewState` using its name.
    ///
    /// - Parameters:
    ///   - states: The list of named states to construct for previews and snapshot testing.
    ///   - configure: A closure that constructs the `View` to be previewed/tested given a configuration state.
    public init<V: View>(
        states: [State],
        configure: @escaping (State) -> V
    ) where State: NamedPreviewState {
        self.init(states: states, name: \.name, configure: configure)
    }
    
    /// Create a `PreviewSnapshots` collection.
    ///
    /// A `Configuration` will be created for each `State` using the `String` located at `namePath`.
    ///
    /// - Parameters:
    ///   - states: The list of states to construct for previews and snapshot testing.
    ///   - namePath: A key path to retrieve the name of a preview state.
    ///   - configure: A closure that constructs the `View` to be previewed/tested given a configuration state.
    public init<V: View>(
        states: [State],
        name namePath: KeyPath<State, String>,
        configure: @escaping (State) -> V
    ) {
        self.configurations = states.map { Configuration(name: $0[keyPath: namePath], state: $0) }
        self.configure = { AnyView(configure($0)) }
    }

    /// The previews to be displayed by the `PreviewProvider`.
    public var previews: some View {
        ForEach(configurations, id: \.name) { configuration in
            configure(configuration.state)
                .previewDisplayName("\(configuration.name)")
        }
    }
}

// MARK: - PreviewSnapshots.Configuration

public extension PreviewSnapshots {
    /// A single configuration used for preview snapshotting.
    struct Configuration {
        /// The name of the configuration. Should be unique across an instance of `PreviewSnapshots`.
        public let name: String
        /// The state to render.
        public let state: State
        
        /// Create a `PreviewSnapshots.Configuration`.
        ///
        /// - Parameters:
        ///   - name: The name of the configuration.
        ///   - state: The state the configuration should render.
        public init(name: String, state: State) {
            self.name = name
            self.state = state
        }
    }
}

// MARK: - NamedPreviewState

/// A preview state with a name
///
/// Useful to present more complex states without having to define the configuration name and state
/// separately.
///
/// ```
/// static var snapshots: PreviewSnapshots<PreviewState> {
///     PreviewSnapshots(
///         states: [
///             .init(name: "Small", foo: 1, bar: "Hello", baz: 2),
///             .init(name: "Large", foo: 1_000, bar: "Hello, PreviewSnapshots!", baz: 2_000),
///         ],
///         configure: { state in
///             ContentView(foo: state.foo, bar: state.bar, baz: baz)
///         }
///     )
/// }
///
/// struct PreviewState: NamedPreviewState {
///     let name: String
///     let foo: Int
///     let bar: String
///     let baz: Double
/// }
/// ```
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol NamedPreviewState {
    /// The name of the preview state
    var name: String { get }
}
