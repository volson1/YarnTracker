//
//  ContentView.swift
//  YarnTracker
//
//  Created by Virginia Olson on 9/18/24.
//

import SwiftUI

struct Project: Identifiable, Codable {
    var id = UUID()
    var stage = String()
    var description = String()
    var queue = Int()
    var type = String()
    var link = String()
    var dateStarted = Date()
    var dateCompleted = Date()
    var notes = String()
    
    var image: Data?    
}

struct ContentView: View {
    @State var projectList = ProjectList()
    
    @State private var showingAddProjectView = false
    @State private var internalState = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Currently Working").font(.headline)
                    
                    ForEach(projectList.projects) { project in
                        if project.stage == "Currently working" {
                            if project.image != nil {
                                HStack {
                                    VStack(alignment: .leading,
                                           content: {
                                            Text(project.description)
                                    })
                                    
                                    Spacer(minLength: 40)
                                    
                                    let data = project.image
                                    
                                    if let data,
                                       let uiImage = UIImage(data: data) {
                                        NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                        {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            else {
                                VStack(alignment: .leading,
                                       content: {
                                    NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                    {
                                        Text(project.description)
                                    }
                                })
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        projectList.projects.remove(atOffsets: indexSet)
                    })
                }
                
                
                Section {
                    Text("To Do").font(.headline)
                    ForEach(projectList.projects) { project in
                        if project.stage == "To do" {
                            if project.image != nil {
                                HStack {
                                    VStack(alignment: .leading,
                                           content: {
                                        Text(project.description + ":")
                                        Text(String(project.queue))
                                    })
                                    
                                    Spacer(minLength: 40)
                                    
                                    let data = project.image
                                    
                                    if let data,
                                       let uiImage = UIImage(data: data) {
                                        NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                        {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            else {
                                VStack(alignment: .leading,
                                       content: {
                                    NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                    {
                                        Text(project.description + ":")
                                        Text(String(project.queue))
                                    }
                                })
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        projectList.projects.remove(atOffsets: indexSet)
                    })
                }
                
                Section {
                    Text("Done").font(.headline)
                    ForEach(projectList.projects) { project in
                        if project.stage == "Done" {
                            if project.image != nil {
                                HStack {
                                    VStack(alignment: .leading,
                                           content: {
                                            Text(project.description)
                                    })
                                    
                                    Spacer(minLength: 40)
                                    
                                    let data = project.image
                                    
                                    if let data,
                                       let uiImage = UIImage(data: data) {
                                        NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                        {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            else {
                                VStack(alignment: .leading,
                                       content: {
                                    NavigationLink(destination: ProjectDetailView(project: project, stage: project.stage))
                                    {
                                        Text(project.description)
                                    }
                                })
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        projectList.projects.remove(atOffsets: indexSet)
                    })
                }
            }
            .sheet(
                isPresented: $showingAddProjectView,
                content: {
                    AddProjectView(projectList: projectList)
                }
            )
            .navigationBarTitle("Projects", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Refresh", systemImage: "arrow.clockwise") {
                        projectList = ProjectList()
                        for loopProj in projectList.projects {
                            print(loopProj)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add project", systemImage: "plus") {
                        self.showingAddProjectView = true
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

#Preview {
    ContentView()
}
