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

import PreviewSnapshots
import SnapshotTesting
import SwiftUI

extension PreviewSnapshots {
    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk.
    ///
    /// - Parameters:
    ///   - snapshotting: Snapshotting instance for  `AnyView` into a `UIImage`.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    public func assertSnapshots(
        as snapshotting: Snapshotting<AnyView, UIImage> = .image,
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for configuration in configurations {
            assertSnapshot(
                matching: configure(configuration.state),
                as: snapshotting,
                named: configuration.snapshotName(prefix: name),
                record: recording,
                file: file, testName: testName, line: line
            )
        }
    }
    
    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk.
    ///
    /// - Parameters:
    ///   - strategies: A dictionary of names and strategies for serializing, deserializing, and
    ///         comparing values.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    public func assertSnapshots(
        as strategies: [String: Snapshotting<AnyView, UIImage>],
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for configuration in configurations {
            for (key, strategy) in strategies {
                assertSnapshot(
                    matching: configure(configuration.state),
                    as: strategy,
                    named: configuration.snapshotName(prefix: name) + "-\(key)",
                    record: recording,
                    file: file, testName: testName, line: line
                )
            }
        }
    }
    
    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk.
    ///
    /// - Parameters:
    ///   - strategies: An array of strategies for serializing, deserializing, and comparing values.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    public func assertSnapshots(
        as strategies: [Snapshotting<AnyView, UIImage>],
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for configuration in configurations {
            for (position, strategy) in strategies.enumerated() {
                assertSnapshot(
                    matching: configure(configuration.state),
                    as: strategy,
                    named: configuration.snapshotName(prefix: name) + "-\(position + 1)",
                    record: recording,
                    file: file, testName: testName, line: line
                )
            }
        }
    }
}

// MARK: - PreviewSnapshots.assertSnapshots + modify

extension PreviewSnapshots {
    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk after applying some modification.
    ///
    /// `modify` can be used to update the configured view in a way that's useful for snapshotting,
    /// but doesn't make sense for previews.
    ///
    /// For example, adding a border to better visualize the edges of the view in snapshots:
    ///
    /// ```swift
    /// func test_snapshots() {
    ///     ContentView_Previews.snapshots.assertSnapshots {
    ///         $0.border(.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - snapshotting: Snapshotting instance that converts an `AnyView` into a `UIImage`.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    ///   - modify: A closure to update the preview content before snapshotting.
    public func assertSnapshots<Modified: View>(
        as snapshotting: Snapshotting<Modified, UIImage> = .image,
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        modify: (AnyView) -> Modified
    ) {
        for configuration in configurations {
            assertSnapshot(
                matching: modify(configure(configuration.state)),
                as: snapshotting,
                named: configuration.snapshotName(prefix: name),
                record: recording,
                file: file, testName: testName, line: line
            )
        }
    }

    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk after applying some modification.
    ///
    /// `modify` can be used to update the configured view in a way that's useful for snapshotting,
    /// but doesn't make sense for previews.
    ///
    /// For example, adding a border to better visualize the edges of the view in snapshots:
    ///
    /// ```swift
    /// func test_snapshots() {
    ///     ContentView_Previews.snapshots.assertSnapshots {
    ///         $0.border(.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - strategies: A dictionary of names and strategies for serializing, deserializing, and
    ///         comparing values.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    ///   - modify: A closure to update the preview content before snapshotting.
    public func assertSnapshots<Modified: View>(
        as strategies: [String: Snapshotting<AnyView, UIImage>],
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        modify: (AnyView) -> Modified
    ) {
        for configuration in configurations {
            for (key, strategy) in strategies {
                assertSnapshot(
                    matching: configure(configuration.state),
                    as: strategy,
                    named: configuration.snapshotName(prefix: name) + "-\(key)",
                    record: recording,
                    file: file, testName: testName, line: line
                )
            }
        }
    }
    
    /// Assert that all of the snapshots defined in a `PreviewSnapshots` collection match their
    /// snapshots recorded on disk after applying some modification.
    ///
    /// `modify` can be used to update the configured view in a way that's useful for snapshotting,
    /// but doesn't make sense for previews.
    ///
    /// For example, adding a border to better visualize the edges of the view in snapshots:
    ///
    /// ```swift
    /// func test_snapshots() {
    ///     ContentView_Previews.snapshots.assertSnapshots {
    ///         $0.border(.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - snapshotting: Snapshotting instance that converts an `AnyView` into a `UIImage`.
    ///   - name: An optional description of the snapshot to include with the configuration name.
    ///   - recording: Whether or not to record a new reference.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///         which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///         of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///         this function was called.
    ///   - modify: A closure to update the preview content before snapshotting.
    public func assertSnapshots<Modified: View>(
        as strategies: [Snapshotting<Modified, UIImage>],
        named name: String? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        modify: (AnyView) -> Modified
    ) {
        for configuration in configurations {
            for (position, strategy) in strategies.enumerated() {
                assertSnapshot(
                    matching: modify(configure(configuration.state)),
                    as: strategy,
                    named: configuration.snapshotName(prefix: name) + "-\(position)",
                    record: recording,
                    file: file, testName: testName, line: line
                )
            }
        }
    }
}

// MARK: Configuration name helper

extension PreviewSnapshots.Configuration {
    /// Construct a snapshot name based on the configuration name and an optional suffix.
    func snapshotName(prefix: String?) -> String {
        guard let prefix else { return name }
        return "\(prefix)-\(name)"
    }
}
