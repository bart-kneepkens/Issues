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

struct IssuesExtensionEntry: TimelineEntry {
    let date: Date
    let fetchIssuesResult: FetchIssuesResult
    let nationName: String?
    let isSignedOut: Bool?
    
    init(fetchIssuesResult: FetchIssuesResult, nationName: String) {
        self.date = Date()
        self.fetchIssuesResult = fetchIssuesResult
        self.nationName = nationName
        self.isSignedOut = false
    }
    
    init(isSignedOut: Bool) {
        self.date = Date()
        self.fetchIssuesResult = FetchIssuesResult(issues: [], timeLeftForNextIssue: "", nextIssueDate: Date())
        self.nationName = nil
        self.isSignedOut = isSignedOut
    }
    
    static func filler(nationName: String) -> IssuesExtensionEntry {
        .init(fetchIssuesResult: .filler, nationName: nationName)
    }
    
    static var signedOut: IssuesExtensionEntry {
        .init(isSignedOut: true)
    }
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
    
    func placeholder(in context: Context) -> IssuesExtensionEntry {
        .filler(nationName: container.nationName)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (IssuesExtensionEntry) -> Void) {
        completion(.filler(nationName: container.nationName))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<IssuesExtensionEntry>) -> Void) {
        // Credentials could have been changed in the meantime, so reload them from keychain
        self.container.refresh()
        
        guard let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) else { return }
        
        guard canAuthenticate else {
            let timeline = Timeline(entries: [IssuesExtensionEntry.signedOut], policy: .after(nextUpdateDate))
            completion(timeline)
            return
        }
        
        self.cancellables?
            .append(issuesProvider.fetchIssues()
                        .sink(receiveCompletion: { _ in },
                              receiveValue: { fetchIssueResult in
                                guard let result = fetchIssueResult, result.isOk else { return }
                                
                                let timeline = Timeline(entries: [
                                    IssuesExtensionEntry(fetchIssuesResult: result, nationName: self.container.nationName)
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

@main
struct IssuesExtension: Widget {
    let kind: String = "IssuesExtension"
    let provider = Provider()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            IssuesExtensionContents(provider: provider, entry: entry)
        }
        .configurationDisplayName("Issues Widget")
        .description("Keep track of your pending issues")
    }
}
