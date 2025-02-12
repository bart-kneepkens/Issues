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
        self.nationName = nationName.capitalized
        self.isSignedOut = false
    }
    
    init(isSignedOut: Bool) {
        self.date = Date()
        self.fetchIssuesResult = FetchIssuesResult(issues: [], timeLeftForNextIssue: "", nextIssueDate: Date())
        self.nationName = nil
        self.isSignedOut = isSignedOut
    }
    
    static var signedOut: IssuesExtensionEntry {
        .init(isSignedOut: true)
    }
}

#if DEBUG
extension IssuesExtensionEntry {
    static func filler(nationName: String) -> IssuesExtensionEntry {
        .init(fetchIssuesResult: .filler, nationName: nationName)
    }
}
#endif

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
        .init(fetchIssuesResult: FetchIssuesResult(issues: [
            Issue(id: 0, title: "A very pressing issue", text: "", options: [], imageName: ""),
            Issue(id: 1, title: "Apocalypse looms in your nation", text: "", options: [], imageName: ""),
            Issue(id: 2, title: "Unicorns have become endangered", text: "", options: [], imageName: "")
        ], timeLeftForNextIssue: "2 hours", nextIssueDate: Date()), nationName: "Nation")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (IssuesExtensionEntry) -> Void) {
        completion(.init(fetchIssuesResult: FetchIssuesResult(issues: [
            Issue(id: 0, title: "A very pressing issue", text: "", options: [], imageName: ""),
            Issue(id: 1, title: "Apocalypse looms in your nation", text: "", options: [], imageName: ""),
            Issue(id: 2, title: "Unicorns have become endangered", text: "", options: [], imageName: "")
        ], timeLeftForNextIssue: "2 hours", nextIssueDate: Date()), nationName: "Nation"))
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
        case .systemLarge, .systemExtraLarge:
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
        .contentMarginsDisabled()
        .configurationDisplayName("Issues Widget")
        .description("Keep track of your pending issues")
    }
}

#if DEBUG
struct IssuesExtensionContents_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        IssuesExtensionContents(provider: Provider(), entry: .filler(nationName: "Elest Adra"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            IssuesExtensionContents(provider: Provider(), entry: .filler(nationName: "Elest Adra"))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            IssuesExtensionContents(provider: Provider(), entry: .filler(nationName: "Elest Adra"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
#endif
