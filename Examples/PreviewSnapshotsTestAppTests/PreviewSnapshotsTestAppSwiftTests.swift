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
import Testing

@testable import PreviewSnapshotsTestApp

@MainActor
@Suite
struct PreviewSnapshotsTestAppSwiftTests {

    @Test
    func test_simpleViewSnapshots() throws {
        SimpleView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }

    @Test
    func test_previewStateViewSnapshots() throws {
        PreviewStateView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }

    @Test
    func test_observableObjectSnapshots() throws {
        ObservableObjectView_Previews.snapshots.assertSnapshots(as: .testStrategy(), named: platformName)
    }

    @Test
    func test_previewStateLightAndDark() throws {
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
