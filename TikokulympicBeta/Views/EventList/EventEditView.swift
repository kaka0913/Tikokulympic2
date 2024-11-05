//
//  EventEditView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/26.
//

import SwiftUI
import GooglePlaces


struct EventEditView: View {
    @StateObject private var viewModel = EventEditViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingCancelAlert = false
    @State private var isShowingCreateAlert = false

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Text("イベント編集")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    ScrollViewReader { ScrollProxy in
                        
                        
                        ScrollView {
                            VStack(spacing: 16) {
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(height: 5)
                                        .padding(.horizontal, 80)
                                        .padding(.bottom, 20)
                                    
                                    InputField(title: "イベント名:", placeholder: "", text: $viewModel.eventName)
                                    InputField(title: "概要:", placeholder: "", text: $viewModel.eventDescription)
                                    DateSelectionField(title: "参加応募締切:", date: $viewModel.applicationDeadline)
                                    DateSelectionField(title: "開始:", date: $viewModel.startDateTime)
                                    DateSelectionField(title: "終了:", date: $viewModel.endDateTime)
                                    InputField(title: "場所名:", placeholder: "", text: $viewModel.locationName)
                                    InputField(title: "参加費:", placeholder: "数字のみを入力", text: $viewModel.fee, keyboardType: .numberPad)
                                }
                                
                                ContactInfoSection(message: $viewModel.contactInfo)
                                
                                VStack(alignment: .leading) {
                                    Text("地点名（検索）:")
                                        .font(.system(size: 15))
                                        .bold()
                                    TextField("地点を入力してください", text: $viewModel.pointName, onEditingChanged: { isEditing in
                                        if !isEditing {
                                            viewModel.autocompleteResults.removeAll()
                                        }
                                    })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: viewModel.pointName) { newValue in
                                        viewModel.fetchAutocompleteResults(input: newValue)
                                    }
                                    
                                        ForEach(viewModel.autocompleteResults, id: \.placeID) { result in
                                            HStack{
                                                Image(systemName: "figure.walk.diamond")
                                                Text(result.attributedPrimaryText.string)
                                                    .font(.system(size: 15))
                                                    .bold()
                                            }
                                            .onTapGesture {
                                                viewModel.fetchPlaceDetails(placeID: result.placeID)
                                                viewModel.pointName = result.attributedPrimaryText.string
                                                viewModel.autocompleteResults.removeAll()
                                            }
                                        }
                                    
                                    
                                }
                                .onChange(of: viewModel.autocompleteResults) { results in
                                                if let lastResult = results.last {
                                                    ScrollProxy.scrollTo(lastResult.placeID, anchor: .bottom)
                                                }
                                            }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding()
                        }
                    }
                    EditBottomBar(
                        cancelAction: { isShowingCancelAlert = true },
                        completeAction: {
                            isShowingCreateAlert = true
                        },
                        isFormValid: viewModel.isFormValid
                    )
                    
                }
                .background(ThemeColor.customBlue)
                .navigationBarHidden(true)
                
                Spacer()
            }
        }
        .alert("確認", isPresented: $isShowingCancelAlert) {
            Button("はい", role: .destructive, action: cancelEditing)
            Button("いいえ", role: .cancel) { }
        } message: {
            Text("本当にキャンセルしますか？")
        }
        .alert("イベントを作成しますか？", isPresented: $isShowingCreateAlert) {
            Button("はい", role: .destructive, action: submitEvent)
            Button("いいえ", role: .cancel) { }
        }
    }
    
    private func cancelEditing() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func submitEvent() {
        Task {
            await viewModel.completeEditing()
            presentationMode.wrappedValue.dismiss()
        }
    }
}
