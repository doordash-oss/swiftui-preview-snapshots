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
        SimpleView_Previews.snapshots.assertSnapshots(as: .testStrategy())
    }
    
    func test_previewStateViewSnapshots() {
        PreviewStateView_Previews.snapshots.assertSnapshots(as: .testStrategy())
    }
    
    func test_observableObjectSnapshots() {
        ObservableObjectView_Previews.snapshots.assertSnapshots(as: .testStrategy())
    }
    
    func test_previewStateLightAndDark() {
        PreviewStateView_Previews.snapshots
            .assertSnapshots(as: [
                "Light": .testStrategy(userInterfaceStyle: .light),
                "Dark": .testStrategy(userInterfaceStyle: .dark),
            ])
    }
}

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
