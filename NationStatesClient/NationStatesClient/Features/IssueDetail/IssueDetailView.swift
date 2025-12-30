//
//  IssueDetailView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/10/2020.
//

import SwiftUI

struct IssueDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: IssueDetailViewModel
    @State var showingOptions = false
    @State var shouldShowDismissAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    ScrollViewReader { reader in
                        Group {
                            CachedRemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName))
                                .aspectRatio(contentMode: .fit)
                                .saturation(0.5)
                                .border(Color.black)
                            
                            HStack {
                                Text("\"\(viewModel.issue.title)\"")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .italic()
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                                Spacer()
                            }
                            .padding(.top)
                            
                            Text(viewModel.issue.text)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(Color.primary)
                                .padding(.bottom, 40)
                            
                        }
                        
                        answeredIssueSection
                            .onAppear {
                                reader
                                    .scrollTo("AnsweredIssueSection.Top", anchor: .top)
                            }
                            .scrollIndicatorsFlash(onAppear: true)
                    }
                }
                .scrollIndicatorsFlash(onAppear: viewModel.answeredIssueResult != nil)
               
                if viewModel.answeredIssueResult == nil {
                    NewsPaperDivider.horizontal
                }
            }
            
            .safeAreaPadding()
            .background(
                Image("PaperTexture")
            )
            .sheet(isPresented: $showingOptions) {
                IssueDetailOptionsView(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
            }
            .alert(isPresented: self.shouldShowAlert, content: {
                Alert(title: Text("Something went wrong"), message: Text("Please try again later"), dismissButton: nil)
            })
            .alert(isPresented: $shouldShowDismissAlert, content: {
                Alert(
                    title: Text("Dismiss issue?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Dismiss")){
                        viewModel.answer(with: Option.dismiss)
                        dismiss()
                    }
                )
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismissWithoutAnimation()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("\(viewModel.nationName) Timespace")
                        .font(.custom("Copperplate", size: 20))
                        .foregroundStyle(Color.primary)
                }
                
                if viewModel.answeredIssueResult == nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(role: .destructive) {
                            shouldShowDismissAlert.toggle()
                        } label: {
                            Image(systemName: "nosign")
                        }
                        
                        Spacer()
                        
                        answerIssueButton
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    private func dismissWithoutAnimation() {
        dismiss()
    }
    
    private var answerIssueButton: some View {
        if #available(iOS 26.0, *) {
            Button(role: .confirm) {
                showingOptions.toggle()
            } label: {
                if viewModel.isAnsweringIssue {
                    ProgressView()
                } else {
                        Text("Answer")
                            .bold()
                            .contentShape(.capsule)
                }
            }
        } else {
            Button {
                showingOptions.toggle()
            } label: {
                if viewModel.isAnsweringIssue {
                    ProgressView()
                } else {
                    
                        Text("Answer")
                            .bold()
                            .foregroundStyle(Color.accentColor)
                            .contentShape(.capsule)
                            
                }
            }
        }
    }
    
    @ViewBuilder
    private var answeredIssueSection: some View {
        if let result = viewModel.answeredIssueResult {
            AnsweredIssueSection(result: result)
        }
    }
    
    private var shouldShowAlert: Binding<Bool> {
        Binding(
            get: { self.viewModel.error != nil },
            set: { print($0) }
        )
    }
}

#if DEBUG
#Preview {
    IssueDetailView(
        viewModel: .init(completedIssue: CompletedIssue(issue: .filler(), result: .filler), nationDetailsProvider: MockedNationDetailsProvider(), nationName: "Elest Adra")
    )
}

#Preview {
    IssueDetailView(
        viewModel: .init(.filler(),
                         provider: MockedIssueProvider(),
                         nationDetailsProvider: MockedNationDetailsProvider(),
                         nationName: "Nation",
                         issueContainer: IssuesViewModel(
                            provider: MockedIssueProvider(),
                            completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer: .init())))
}
#endif
