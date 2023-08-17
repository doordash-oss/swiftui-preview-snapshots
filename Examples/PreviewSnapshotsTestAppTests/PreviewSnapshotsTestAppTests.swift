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

import PreviewSnapshotsTesting
import SnapshotTesting
import SwiftUI
import XCTest

@testable import PreviewSnapshotsTestApp

final class PreviewSnapshotsTestAppTests: XCTestCase {
    func test_simpleViewSnapshots() {
        SimpleView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }
    
    func test_previewStateViewSnapshots() {
        PreviewStateView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }
    
    func test_observableObjectSnapshots() {
        ObservableObjectView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }
    
    func test_previewStateLightAndDark() {
        PreviewStateView_Previews.snapshots
            .assertSnapshots(
                as: [
                    "Light": .testStrategy(userInterfaceStyle: .light),
                    "Dark": .testStrategy(userInterfaceStyle: .dark),
                ],
                named: platformName
            )
    }
}

#if os(iOS)
let platformName = "iOS"

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    /// Shared image test strategy
    static func testStrategy(userInterfaceStyle: UIUserInterfaceStyle = .light) -> Self {
        let traits = UITraitCollection(traitsFrom: [
            UITraitCollection(displayScale: 1),
            UITraitCollection(userInterfaceStyle: userInterfaceStyle),
        ])
        
        return .image(
            layout: .fixed(width: 400, height: 400),
            traits: traits
        )
    }
}
#elseif os(macOS)
let platformName = "macOS"

extension Snapshotting where Value: SwiftUI.View, Format == NSImage {
    /// Shared image test strategy
    static func testStrategy(userInterfaceStyle: UserInterfaceStyle = .light) -> Self {
        let snapshotting = Snapshotting<NSView, NSImage>.image(size: .init(width: 400, height: 400)).pullback { (view: Value) in
            let view = NSHostingView(rootView: view.environment(\.colorScheme, userInterfaceStyle.colorScheme))
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            return view
        }
        
        return Snapshotting(
            pathExtension: snapshotting.pathExtension,
            diffing: snapshotting.diffing,
            asyncSnapshot: { view in
                Async { callback in
                    userInterfaceStyle.appearance.performAsCurrentDrawingAppearance {
                        snapshotting.snapshot(view).run(callback)
                    }
                }
            }
        )
    }
}

enum UserInterfaceStyle {
    case light, dark
    
    var colorScheme: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var appearance: NSAppearance {
        switch self {
        case .light: return NSAppearance(named: .aqua)!
        case .dark: return NSAppearance(named: .darkAqua)!
        }
    }
}
#endif
