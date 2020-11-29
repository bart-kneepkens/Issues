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
    let fetchIssuesResult: FetchIssuesResult
    let nationName: String
}

class Provider: TimelineProvider {
    var container: AuthenticationContainer
    
    let issuesProvider: IssueProvider
    private var cancellables: [Cancellable]? = []
    
    init() {
        self.container = AuthenticationContainer()
        self.issuesProvider = APIIssueProvider(container: container)
    }
    
    var canAuthenticate: Bool {
        container.canPerformSilentLogin
    }

    func placeholder(in context: Context) -> IssuesEntry {
        .init(date: Date(), fetchIssuesResult: .filler, nationName: self.container.nationName)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (IssuesEntry) -> Void) {
        completion(.init(date: Date(), fetchIssuesResult: .filler, nationName: self.container.nationName))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<IssuesEntry>) -> Void) {
        self.container.refresh()
        
        guard let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) else { return }
        
        self.cancellables?
            .append(issuesProvider.fetchIssues()
                        .sink(receiveCompletion: { _ in  }, receiveValue: { fetchIssueResult in
                            
                            guard let result = fetchIssueResult, result.isOk else { return }
                            
                            let timeline = Timeline(entries: [
                                IssuesEntry(date: Date(), fetchIssuesResult: .filler, nationName: self.container.nationName)
                            ], policy: .after(nextUpdateDate))
                            
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

struct SignInToUseWidgetView: View {
    var body: some View {
        Text("Please sign to find your issues here")
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
