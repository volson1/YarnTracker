//
//  AddProjectView.swift
//  YarnTracker
//
//  Created by Virginia Olson on 9/19/24.
//

import SwiftUI
import PhotosUI

struct AddProjectView: View {
    @State var projectList: ProjectList
    
    @State private var stage = ""
    
    @State private var description = ""
    
    @State private var queue: Int = 0
    
    @State private var type = ""
    
    @State private var link = ""
    
    @State private var notes = ""
    
    @State private var dateStarted: Date = Date()
    @State private var dateCompleted: Date = Date()
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    @Environment(\.presentationMode) var presentationMode
    static let stages = ["To do", "Currently working", "Done"]
    static let types = ["Knitting", "Crochetting"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Description", text: $description)
                Picker("Project type", selection: $type) {
                    ForEach(Self.types, id: \.self) { type in
                        Text(type)
                    }
                }
                Picker("Stage", selection: $stage) {
                    ForEach(Self.stages, id: \.self) { stage in
                        Text(stage)
                    }
                }
                if (stage == "To do") {
                    Picker("Queue Position", selection: $queue) {
                        let range = 0..<(projectList.numOfToDoProjects() + 2)
                        
                        ForEach(range) { i in
                            if (i != 0) {
                                Text("\(i)")
                            }
                        }
                    }
                }
                else if (stage == "Currently working") {
                    DatePicker(selection: $dateStarted, in: ...Date.now, displayedComponents: .date) {
                        Text("Date started")
                    }
                }
                else if (stage == "Done") {
                    DatePicker(selection: $dateStarted, in: ...Date.now, displayedComponents: .date) {
                        Text("Date started")
                    }
                    DatePicker(selection: $dateCompleted, in: ...Date.now, displayedComponents: .date) {
                        Text("Date completed")
                    }
                }

                TextField("Link", text: $link)
                
                if let selectedPhotoData,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    HStack {
                        Spacer()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                        Spacer()
                    }
                }
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }
                
                if selectedPhotoData != nil {
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                        }

                    
                }
                
                TextField("Any notes on your project...", text: $notes, axis: .vertical)
                    .frame(alignment: .topLeading)
                    .padding(.vertical, 10)
            }
            .navigationBarTitle("Add New Project", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                if (stage == "Currently working") {
                    if let selectedPhotoData {
                        save(description: description, type: type, stage: stage, link: link, dateStarted: dateStarted, image: selectedPhotoData)
                    }
                    else {
                        save(description: description, type: type, stage: stage, link: link, dateStarted: dateStarted)
                    }
                }
                else if (stage == "Done") {
                    if let selectedPhotoData {
                        save(description: description, type: type, stage: stage, link: link, dateStarted: dateStarted, dateCompleted: dateCompleted, image: selectedPhotoData)
                    }
                    else {
                        save(description: description, type: type, stage: stage, link: link, dateStarted: dateStarted, dateCompleted: dateCompleted)
                    }
                }
                else if (stage == "To do") {
                    if let selectedPhotoData {
                        save(description: description, type: type, stage: stage, queue: queue, link: link, image: selectedPhotoData)
                    }
                    else {
                        save(description: description, type: type, stage: stage, queue: queue, link: link)
                    }
                }
                presentationMode.wrappedValue.dismiss()
            })
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
    
    func save(description: String, type: String, stage: String, queue: Int, link: String, image: Data) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, queue: queue, type: type, link: link, notes: notes, image: image))
        }
    }
    func save(description: String, type: String, stage: String, link: String, dateStarted: Date, image: Data) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, type: type, link: link, dateStarted: dateStarted, notes: notes, image: image))
        }
    }
    func save(description: String, type: String, stage: String, link: String, dateStarted: Date, dateCompleted: Date, image: Data) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, type: type, link: link, dateStarted: dateStarted, dateCompleted: dateCompleted, notes: notes, image: image))
        }
    }
    
    func save(description: String, type: String, stage: String, queue: Int, link: String) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, queue: queue, type: type, link: link, notes: notes))
        }
    }
    func save(description: String, type: String, stage: String, link: String, dateStarted: Date) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, type: type, link: link, dateStarted: dateStarted, notes: notes))
        }
    }
    func save(description: String, type: String, stage: String, link: String, dateStarted: Date, dateCompleted: Date) {
        if (stage != "" && description != "" && type != "") {
            projectList.projects.append(Project(id: UUID(), stage: stage, description: description, type: type, link: link, dateStarted: dateStarted, dateCompleted: dateCompleted, notes: notes))
        }
    }
}

#Preview {
    AddProjectView(projectList: ProjectList())
}
