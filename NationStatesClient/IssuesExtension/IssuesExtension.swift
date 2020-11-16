//
//  IssuesExtension.swift
//  IssuesExtension
//
//  Created by Bart Kneepkens on 12/11/2020.
//

import WidgetKit
import SwiftUI
import Intents
import Combine

struct IssuesEntry: TimelineEntry {
    let date: Date
    let issues: [Issue]
}

class Provider: TimelineProvider {
    @StateObject var container: AuthenticationContainer
    
    let issuesProvider: IssueProvider
    private var cancellables: [Cancellable]? = []
    
    init() {
        let container = AuthenticationContainer()
        _container = StateObject(wrappedValue: container)
        self.issuesProvider = APIIssueProvider(container: container)
    }
    
    var canAuthenticate: Bool {
        container.canPerformSilentLogin
    }

    func placeholder(in context: Context) -> IssuesEntry {
        .init(date: Date(), issues: [.filler()])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (IssuesEntry) -> Void) {
        completion(.init(date: Date(), issues: [.filler()]))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<IssuesEntry>) -> Void) {
        
        // fetch Issues
        self.cancellables?.append(issuesProvider.fetchIssues().sink(receiveCompletion: { completion in
            // TODO
            print(completion)
        }, receiveValue: { fetchIssueResult in
            
            guard let result = fetchIssueResult else { return }
            
            let timeline = Timeline(entries: [IssuesEntry(date: Date(), issues: result.issues)], policy: .after(result.nextIssueDate))
            
            completion(timeline)
        }))
    }
}

struct IssuesExtensionContents: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    let provider: Provider
    
    let entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SmallExtensionView(entry: entry)
        case .systemMedium:
            MediumExtensionView(entry: entry)
        case .systemLarge:
            LargeExtensionView(entry: entry)
        @unknown default:
            EmptyView()
        }
    }
}

@main
struct IssuesExtension: Widget {
    let kind: String = "IssuesExtension"
    let provider = Provider()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            IssuesExtensionContents(provider: provider, entry: entry)
        }
        .configurationDisplayName("Issues Widget")
        .description("TODO: fill out this text")
    }
}
