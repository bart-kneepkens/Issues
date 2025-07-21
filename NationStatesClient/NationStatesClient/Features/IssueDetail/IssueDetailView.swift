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
    @State var isExpanded = false
    @State var shouldrenderButtons = false
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { reader in
                    
                    HStack {
                        Spacer()
                        
                        Text("\(viewModel.nationName) Times")
                            .font(.custom("Copperplate", size: 20))
                            .foregroundStyle(Color.primary)
                        Spacer()
                    }
                    .padding()
                    
                    Group {
                        CachedRemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName)).aspectRatio(contentMode: .fit)
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
            
            bottomContents
        }
        
        .safeAreaPadding()
        .background(
            Image("PaperTexture")
//                .resizable(resizingMode: .tile)
        )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingOptions, content: {
            IssueDetailOptionsView(viewModel: self.viewModel)
        })
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
        .onAppear {
            var transaction = Transaction(animation: .easeInOut(duration: 0.3))
            
            transaction.addAnimationCompletion {
                shouldrenderButtons = true
            }

            withTransaction(transaction) {
                isExpanded = true
            }
        }
        .scaleEffect(isExpanded ? 1 : 0.8)
        .opacity(isExpanded ? 1 : 0)
        .overlay {
            HStack {
                VStack {
                    Button(action: {
                        dismissWithoutAnimation()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.primary, Material.ultraThin)
                        
                    }
                    .opacity(shouldrenderButtons ? 1 : 0)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .overlay(alignment: .top) {
            if isExpanded {
                Image("PaperTile")
                    .resizable()
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 0) 
            }
        }
    }
    
    private func dismissWithoutAnimation() {
        var transaction = Transaction(animation: .easeInOut(duration: 0.3))
        
        shouldrenderButtons = false
        
        transaction.addAnimationCompletion {
            dismiss()
        }

        withTransaction(transaction) {
            isExpanded = false
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        Spacer()
        
        NewsPaperDivider.horizontal
        
        HStack {
            Button {
                shouldShowDismissAlert.toggle()
            } label: {
                Image(systemName: "xmark")
                    .bold()
            }
            .padding()
            .background(
                Material.ultraThick
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Button {
                showingOptions.toggle()
            } label: {
                Spacer()
                if viewModel.isAnsweringIssue {
                    ProgressView()
                } else {
                    Text("Answer")
                        .bold()
                }
                Spacer()
            }
            .padding()
            .background(Material.ultraThick)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding()
        .opacity(shouldrenderButtons ? 1 : 0)
        .disabled(viewModel.isAnsweringIssue)
    }
    
    @ViewBuilder
    private var bottomContents: some View {
        if viewModel.answeredIssueResult == nil {
            actionButtons
        }
    }
    
    @ViewBuilder
    private var answeredIssueSection: some View {
        if let result = viewModel.answeredIssueResult {
            AnsweredIssueSection(result: result)
//            Spacer()
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
//    IssueDetailView(
//        viewModel: .init(.filler(),
//                         provider: MockedIssueProvider(),
//                         nationDetailsProvider: MockedNationDetailsProvider(),
//                         nationName: "Nation",
//                         issueContainer: IssuesViewModel(
//                            provider: MockedIssueProvider(),
//                            completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer: .init())))
    
    IssueDetailView(
        viewModel: .init(completedIssue: CompletedIssue(issue: .filler(), result: .filler), nationDetailsProvider: MockedNationDetailsProvider(), nationName: "Elest Adra")
    )
}
#endif
