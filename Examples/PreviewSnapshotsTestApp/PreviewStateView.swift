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
import SwiftUI

struct PreviewStateView: View {
    let title: String
    let subtitle: String
    let message: String
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.title)

                Text(subtitle)
                    .font(.subheadline)
            }

            Text(message)
                .font(.body)
        }
        .multilineTextAlignment(.center)
        .padding(8)
    }
}

struct PreviewStateView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }
    
    static var snapshots: PreviewSnapshots<PreviewState> {
        PreviewSnapshots(
            states: [
                .init(name: "Short", title: "Hello", subtitle: "PreviewSnapshots", message: "This is a test"),
                .init(
                    name: "Long",
                    title: "Hello PreviewSnapshots",
                    subtitle: "Welcome to PreviewSnapshots",
                    message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                )
            ],
            configure: {
                PreviewStateView(title: $0.title, subtitle: $0.subtitle, message: $0.message)
            }
        )
    }
    
    struct PreviewState: NamedPreviewState {
        let name: String
        let title: String
        let subtitle: String
        let message: String
    }
}
