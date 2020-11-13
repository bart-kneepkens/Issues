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


class Provider: TimelineProvider {
    let container: AuthenticationContainer
    let issuesProvider: IssueProvider
    private var cancellables: [Cancellable]? = []
    
    init() {
        self.container = AuthenticationContainer()
        self.issuesProvider = MockedIssueProvider()
    }

    func placeholder(in context: Context) -> SimpleEntry {
        .init(date: Date(), issues: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(.init(date: Date(), issues: []))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        self.cancellables?.append(issuesProvider.fetchIssues().sink(receiveCompletion: { completion in
            // TODO
            print(completion)
        }, receiveValue: { fetchIssueResult in
            let timeline = Timeline(entries: [SimpleEntry(date: Date().addingTimeInterval(5), issues: fetchIssueResult?.issues ?? [])], policy: .atEnd)
            
            completion(timeline)
        }))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var issues: [Issue]
}

struct IssuesExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(entry.issues, id: \.id) { issue in
                    HStack {
                        Text("\(issue.title)")
                    Spacer()
                }
                Divider()
            }
        }.padding()
    }
}

struct IssuesAmountView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "person.fill").resizable().frame(width: 40, height: 40, alignment: .center)
                ZStack {
                    Circle().foregroundColor(.red)
                        .overlay(Text("\(entry.issues.count)").font(.headline))
                }
                .frame(width: 30, height: 30, alignment: .center)
                .offset(x: 20, y: -20)
                
                Text("Issues")
                    .offset(x: 0, y: 35)
            }
        }
    }
}

@main
struct IssuesExtension: Widget {
    let kind: String = "IssuesExtension"
    @Environment(\.widgetFamily) var family
    
    func extensionView(entry: Provider.Entry) -> some View {
        return Group {
            IssuesAmountView(entry: entry)
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

struct IssuesExtension_Previews: PreviewProvider {
    static var previews: some View {
        IssuesAmountView(entry: SimpleEntry(date: Date(), issues: [.filler]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
