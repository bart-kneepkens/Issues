//
//  IssueCardView.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 08/06/2025.
//

import SwiftUI

struct IssueCardView: View {

    @StateObject var viewModel: IssueDetailViewModel
    let isCompact: Bool
    
    init(viewModel: IssueDetailViewModel, isCompact: Bool = false) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.isCompact = isCompact
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if !isCompact {
                HStack {
                    Spacer()
                    Text("\(viewModel.nationName) Times")
                        .font(.custom("Copperplate", size: 20))
                    Spacer()
                }
                .padding(.bottom, 8)
                
                NewsPaperDivider.horizontal
            }
            
            
            CachedRemoteImage(url: URLBuilder.imageUrl(for: viewModel.issue.imageName))
                .aspectRatio(contentMode: .fit)
                .saturation(0.5)
                .border(Color.black)
                .padding(.vertical)
            
            Text("\"\(viewModel.issue.title)\"")
                .font(.title3)
                .fontWeight(.bold)
                .italic()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.bottom)

            
            if !isCompact {
                Text(viewModel.issue.text)
                    .font(.body)
                
                Spacer()
                
                NewsPaperDivider.horizontal
                    .padding(.bottom, 8)
                
                HStack {
                    Text("1 \(viewModel.currency)")
                    Spacer()
                    Text("#\(String(viewModel.issue.id))")
                }
                .font(.footnote)
            }
        }
        .foregroundStyle(Color.primary)
        .padding()
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        
    }
    
    @ViewBuilder private var background: some View {
        Image("PaperTexture")
            .resizable()
    }
}

extension IssueCardView {
    @inlinable func compact() -> some View {
        IssueCardView(viewModel: viewModel, isCompact: true)
    }
}

#if DEBUG
#Preview {
    IssueCardView(viewModel: .init(.filler(), provider: MockedIssueProvider(), nationDetailsProvider: MockedNationDetailsProvider(), nationName: "Elest Adra", issueContainer: IssuesViewModel(provider: MockedIssueProvider(), completedIssueProvider: MockedCompletedIssueProvider(), authenticationContainer: .init())))
        .padding()
}

#endif
