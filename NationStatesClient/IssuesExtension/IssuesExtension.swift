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
    var issues: [Issue]
}

class Provider: TimelineProvider {
    let container: AuthenticationContainer
    let issuesProvider: IssueProvider
    private var cancellables: [Cancellable]? = []
    
    init() {
        self.container = AuthenticationContainer()
        self.issuesProvider = MockedIssueProvider()
    }

    func placeholder(in context: Context) -> IssuesEntry {
        .init(date: Date(), issues: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (IssuesEntry) -> Void) {
        completion(.init(date: Date(), issues: []))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<IssuesEntry>) -> Void) {
        self.cancellables?.append(issuesProvider.fetchIssues().sink(receiveCompletion: { completion in
            // TODO
            print(completion)
        }, receiveValue: { fetchIssueResult in
            let timeline = Timeline(entries: [IssuesEntry(date: Date().addingTimeInterval(5), issues: fetchIssueResult?.issues ?? [])], policy: .atEnd)
            
            completion(timeline)
        }))
    }
}

@main
struct IssuesExtension: Widget {
    let kind: String = "IssuesExtension"
    @Environment(\.widgetFamily) var family
    
    func extensionView(entry: Provider.Entry) -> some View {
        return Group {
            if family == .systemSmall {
                SmallExtensionView(entry: entry)
            } else if family == .systemMedium {
                MediumExtensionView(entry: entry)
            } else {
                EmptyView()
            }
        }
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
           extensionView(entry: entry)
        }
        .configurationDisplayName("Issues Widget")
        .description("TODO: fill out this text")
    }
}
