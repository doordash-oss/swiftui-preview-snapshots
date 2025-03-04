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
import PreviewSnapshotsTesting
import SwiftUI

#if os(iOS) || os(tvOS)
let frameworkName = "UIKit"

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    /// Shared image test strategy
    static var testStrategy: Self {
        .image(
            layout: .fixed(width: 400, height: 400),
            traits: UITraitCollection(displayScale: 1)
        )
    }
}
#elseif os(macOS)
let frameworkName = "AppKit"

extension Snapshotting where Value: SwiftUI.View, Format == NSImage {
    /// Shared image test strategy
    static var testStrategy: Self {
        Snapshotting<NSView, NSImage>.image(size: .init(width: 400, height: 400)).pullback { view in
            let view = NSHostingView(rootView: view)
            view.wantsLayer = true
            view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            return view
        }
    }
}
#endif
