//
//  StitchTrackerView.swift
//  YarnTracker
//
//  Created by Virginia Olson on 8/10/25.
//

import SwiftUI

struct StitchTrackerView: View {
    @State private var row = 0
    @State private var stitch = 0
    @State private var ISBy = 1
    @State private var IRBy = 1
    var rowIsDisabled: Bool { row < 1 }
    var stitchIsDisabled: Bool { stitch < 1 }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("Row").font(.title).fontWeight(.bold)
                    HStack {
                        Button() {
                            row -= 1
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 60))
                        }
                        .disabled(rowIsDisabled)
                        
                        Text(String(row))
                            .font(.largeTitle)
                        
                        Button() {
                            row += IRBy
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 60))
                        }
                    }
                }
                
                VStack(spacing: 10) {
                    Text("Stitch").font(.title).fontWeight(.bold)
                    HStack {
                        Button() {
                            stitch -= 1
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 60))
                        }
                        .disabled(stitchIsDisabled)
                        
                        Text(String(stitch))
                            .font(.largeTitle)
                        
                        Button() {
                            stitch += ISBy
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 60))
                        }
                    }
                    
                    VStack {
                        HStack {
                            Text("Increase stitch by")
                            TextField(String(ISBy), value: $ISBy, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 25)
                        }
                        HStack {
                            Text("Increace Row by")
                            TextField(String(IRBy), value: $IRBy, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 25)
                        }
                    }
                    .padding(30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        ZStack {
                            Color.gray.opacity(0.2)
                                .edgesIgnoringSafeArea(.all)
                                .frame(height: 60)
                                .cornerRadius(20)
                            
                            Button() {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "list.dash.header.rectangle")
                                    .font(.title)
                            }
                        }
                        
                        ZStack {
                            Color.gray.opacity(0.2)
                                .edgesIgnoringSafeArea(.all)
                                .frame(height: 60)
                                .cornerRadius(20)
                            
                            NavigationLink(destination: StitchTrackerView(), label: {
                                Image(systemName: "candybarphone")
                                    .font(.title3)
                            })
                            .disabled(true)
                        }
                    }
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            let decoder = JSONDecoder()
            if let data = UserDefaults.standard.data(forKey: "stitchData") {
                stitch = try! decoder.decode(Int.self, from: data)
            }
            if let data = UserDefaults.standard.data(forKey: "rowData") {
                row = try! decoder.decode(Int.self, from: data)
            }
            if let data = UserDefaults.standard.data(forKey: "ISByData") {
                ISBy = try! decoder.decode(Int.self, from: data)
            }
            if let data = UserDefaults.standard.data(forKey: "IRByData") {
                IRBy = try! decoder.decode(Int.self, from: data)
            }
        }
        .onDisappear() {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(stitch) {
                UserDefaults.standard.set(data, forKey: "stitchData")
            }
            if let data = try? encoder.encode(row) {
                UserDefaults.standard.set(data, forKey: "rowData")
            }
            if let data = try? encoder.encode(ISBy) {
                UserDefaults.standard.set(data, forKey: "ISByData")
            }
            if let data = try? encoder.encode(IRBy) {
                UserDefaults.standard.set(data, forKey: "IRByData")
            }
        }
    }
}

#Preview {
    StitchTrackerView()
}
