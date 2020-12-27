//
//  CreateNationSheet.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 26/12/2020.
//

import SwiftUI

struct CreateNationSheet: View {
    private enum CreateNationFlowState {
        case initial
        case web
        case final
    }
    
    let onCompletion: ((CreateNationWebView.CreateNationResult?) -> Void)
    
    @State private var state: CreateNationFlowState = .initial
    @State private var result: CreateNationWebView.CreateNationResult?
    
    private var header: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
            HStack {
                Spacer()
                Button(action: {
                    onCompletion(nil)
                }) {
                    Text("Cancel").bold()
                }
            }.padding()
        }.frame(height: 54)
    }
    
    var body: some View {
        header
        
        ZStack {
            CreateNationWebView { result in
                self.result = result
                self.state = .final
            } onFinishedStyling: {
                if self.state == .initial {
                    self.state = .web
                }
            }
            
            if self.state == .initial {
                Color.primary.colorInvert()
                ProgressView()
            } else if self.state == .final {
                Color.primary.colorInvert()
                ProgressView("Finishing up..")
                    .onAppear {
                        // Wait here for a while, to allow the server to process the new nation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.onCompletion(self.result)
                        }
                    }
            }
        }
    }
}

struct CreateNationSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("Text").sheet(isPresented: .constant(true), content: {
                CreateNationSheet() { result in
                    
                }
            })
        }
    }
}
