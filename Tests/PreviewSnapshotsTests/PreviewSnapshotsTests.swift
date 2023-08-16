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
import XCTest

final class PreviewSnapshotsTests: XCTestCase {
    /// PreviewSnapshots with a basic Swift type as the state
    func test_simpleState() {
        struct ContentView: View {
            let message: String
            
            var body: some View {
                Text(message)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding(8)
            }
        }
        
        let snapshots = PreviewSnapshots<String>(
            configurations: [
                .init(name: "Short Message", state: "Hello!"),
                .init(name: "Long Message", state: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            ],
            configure: { message in
                ContentView(message: message)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy)
    }
    
    /// PreviewSnapshots assertion using `named` parameter
    func test_namedAssertion() {
        struct ContentView: View {
            let message: String
            
            var body: some View {
                Text(message)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding(8)
            }
        }
        
        let snapshots = PreviewSnapshots<String>(
            configurations: [
                .init(name: "Short Message", state: "Hello!"),
                .init(name: "Long Message", state: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            ],
            configure: { message in
                ContentView(message: message)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy, named: "Named Assertion")
    }
    
    /// PreviewSnapshots with a tuple as the state
    func test_tupleState() {
        struct ContentView: View {
            let message: String
            let count: Int
            
            var body: some View {
                VStack(spacing: 24) {
                    Text(message).font(.title)
                    
                    HStack(spacing: 4) {
                        Button("+") {
                            // Increment
                        }
                        
                        Text("\(count)")
                        
                        Button("-") {
                            // Decrement
                        }
                    }
                    .font(.body)
                }
            }
        }
        
        let snapshots = PreviewSnapshots<(message: String, count: Int)>(
            configurations: [
                .init(name: "Small", state: ("Hello", 1)),
                .init(name: "Large", state: ("Hello PreviewSnapshotsTests", 1_000)),
            ],
            configure: {
                ContentView(message: $0.message, count: $0.count)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy)
    }
    
    /// PreviewSnapshots with an ObservableObject as the state
    func test_viewModel() {
        final class ContentViewModel: ObservableObject {
            @Published var message = ""
            @Published var isLoading = true
            
            func loaded(message: String) {
                self.message = message
                isLoading = false
            }
        }
        
        struct ContentView: View {
            @ObservedObject var viewModel: ContentViewModel
            
            var body: some View {
                Text(viewModel.isLoading ? "Loading..." : viewModel.message)
                    .font(.title)
            }
        }
        
        let loadingViewModel = ContentViewModel()
        
        let loadedViewModel = ContentViewModel()
        loadedViewModel.loaded(message: "Lorem ipsum")
        
        let snapshots = PreviewSnapshots<ContentViewModel>(
            configurations: [
                .init(name: "Loading", state: loadingViewModel),
                .init(name: "Loaded", state: loadedViewModel),
            ],
            configure: {
                ContentView(viewModel: $0)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy)
    }
    
    /// PreviewSnapshots using a NamedPreviewState as the state
    func test_namedPreviewState() {
        struct ContentView: View {
            let title: String
            let subtitle: String
            let message: String
            
            var body: some View {
                VStack(spacing: 0) {
                    Text(title)
                        .font(.title)
                        .padding(.bottom, 4)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .padding(.bottom, 16)
                    
                    Text(message)
                        .font(.body)
                }
                .padding(8)
            }
        }
        
        struct PreviewState: NamedPreviewState {
            let name: String
            let title: String
            let subtitle: String
            let message: String
        }
        
        let snapshots = PreviewSnapshots<PreviewState>(
            states: [
                .init(name: "Short", title: "Hello", subtitle: "PreviewSnapshots", message: "This is a test"),
                .init(
                    name: "Long",
                    title: "Hello PreviewSnapshots",
                    subtitle: "Welcome to a PreviewSnapshots unit test",
                    message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                )
            ],
            configure: { state in
                ContentView(title: state.title, subtitle: state.subtitle, message: state.message)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy)
    }
    
    /// PreviewSnapshots using assertSnapshots's modify function
    func test_modify() {
        struct ContentView: View {
            let message: String
            
            var body: some View {
                Text(message)
                    .font(.title)
                    .padding(8)
            }
        }
        
        let snapshots = PreviewSnapshots<String>(
            configurations: [
                .init(name: "Short Message", state: "Hello!"),
                .init(name: "Long Message", state: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            ],
            configure: {
                ContentView(message: $0)
            }
        )
        
        snapshots.assertSnapshots(as: .testStrategy) { view in
            view.border(Color.blue)
        }
    }
}

extension Snapshotting where Value: SwiftUI.View, Format == UIImage {
    /// Shared image test strategy
    static var testStrategy: Self {
        .image(
            layout: .fixed(width: 400, height: 400),
            traits: UITraitCollection(displayScale: 1)
        )
    }
}
