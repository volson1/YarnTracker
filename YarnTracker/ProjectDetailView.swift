//
//  ProjectDetailView.swift
//  crochetApp
//
//  Created by Virginia Olson on 9/30/24.
//

import SwiftUI
import PhotosUI

final class PhotoPickerViewModel: ObservableObject {
    @Published private(set) var selectedPhoto: UIImage? = nil
    @Published var selectedPhotoData: Data? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedPhoto = uiImage
                    selectedPhotoData = data
                    return
                }
            }
        }
    }
    
    func loadImage(data: Data?) {
        guard let data else { return }
        
        let uiImage = UIImage(data: data)
        selectedPhoto = uiImage
        selectedPhotoData = data
        return
    }
    
    func removeImage() {
        selectedPhoto = nil
        imageSelection = nil
        selectedPhotoData = nil
        print("Image removed")
    }
}

struct ProjectDetailView: View {
    @State var project: Project
    
    @State var description: String = ""
    @State var type: String = ""
    @State var stage: String
    @State var notes: String = ""
    
    @State var dateStarted: Date = Date()
    @State var dateCompleted: Date = Date()
    
    @State var projectList = ProjectList()
    static let stages = ["To do", "Currently working", "Done"]
    
    @State var queue: Int = 0
    
    @StateObject private var viewModel: PhotoPickerViewModel = PhotoPickerViewModel()
    
    @State var showingSaving = false
    @State var showingRemoveImage = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let link = project.link
        
        Form {
            Text("Type: " + type)
            Picker("Stage", selection: $stage) {
                ForEach(Self.stages, id: \.self) { stage in
                    Text(stage)
                }
            }
            
            if (stage == "To do") {
                Picker("Queue Position", selection: $queue) {
                    let range = 0..<(projectList.numOfToDoProjects() + 1)
                    
                    ForEach(range) { i in
                        if (i != 0) {
                            Text("\(i)")
                        }
                    }
                }
            }
            else if (stage == "Currently working") {
                DatePicker(selection: $dateStarted, in: ...Date.now, displayedComponents: .date) {
                    Text("Date Started")
                }
            }
            else if (stage == "Done") {
                DatePicker(selection: $dateStarted, in: ...Date.now, displayedComponents: .date) {
                    Text("Date Started")
                }
                DatePicker(selection: $dateCompleted, in: ...Date.now, displayedComponents: .date) {
                    Text("Date Completed")
                }
            }
            if(link != "") {
                Link("Pattern Link", destination: URL(string: link)!)
            }
            
            Section {
                if let image = viewModel.selectedPhoto {
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
                PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }
                
                if viewModel.imageSelection != nil || showingRemoveImage {
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.removeImage()
                            showingRemoveImage = false
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                        }

                    
                }
            }

            TextField("Any notes on your project...", text: $notes, axis: .vertical)
                .frame(alignment: .topLeading)
                .padding(.vertical, 10)
        }
        .onAppear(perform: {
            let imageData = project.image
            
            if let imageData {
                viewModel.loadImage(data: imageData)
                showingRemoveImage = true
            }
            
            queue = project.queue
            dateStarted = project.dateStarted
            dateCompleted = project.dateCompleted
            description = project.description
            type = project.type
            notes = project.notes
            
        })
        .alert("Save?", isPresented: $showingSaving) {
            Button("Cancel") {
                showingSaving = false
            }
            Button("Save") {
                showingSaving = false
            }
        } message: {
            Text("After saving to update the project page press the refresh button in the top right")
        }
        .navigationTitle(project.description)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    showingSaving = true
                    if (queue != 0) {
                        save(stage: stage, description: description, queue: queue, notes: notes)
                    }
                    else {
                        save(stage: stage, description: description, notes: notes)
                    }
                }
            }
        }
    }
    func save(stage: String, description: String, notes: String) {
        let index = projectList.getIndex(project: project)
        print(String(index))
        
        if (index != -1 && (stage != project.stage || project.description != description || viewModel.selectedPhotoData != project.image || notes != project.notes)) {
            projectList.projects[index] = Project(id: UUID(), stage: stage, description: description, notes: notes, image: viewModel.selectedPhotoData)
            }
        }
    
    func save(stage: String, description: String, queue: Int, notes: String) {
        let index = projectList.getIndex(project: project)
        print(String(index))
        
        if (index != -1 && (stage != project.stage || project.description != description || queue != project.queue || viewModel.selectedPhotoData != project.image || notes != project.notes)) {
            projectList.projects[index] = Project(id: UUID(), stage: stage, description: description, queue: queue, notes: notes, image: viewModel.selectedPhotoData)
            }
        }
}

#Preview {
    ProjectDetailView(project: ProjectList().projects.first!, stage: "Done")
}
