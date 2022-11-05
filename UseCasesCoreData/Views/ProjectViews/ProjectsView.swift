//
//  ProjectView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/7/22.
//

import CoreData
import Neumorphic
import SwiftUI

struct ProjectsView: View
{
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.lastUpdated, ascending: true)], animation: .default)
    private var projects: FetchedResults<Project>
    
    @State var title: String = EMPTY_STRING
    @State var projectId: String = EMPTY_STRING

    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Spacer()
                Image(systemName: showAddFields ? LESS_ICON : MORE_ICON)
                    .onTapGesture
                    {
                        showAddFields.toggle()
                    }
            }.padding()

            if showAddFields
            {
                VStack(spacing: 10)
                {
                    withAnimation
                    {
                        TextInputFieldWithFocus("Title", text: $title, isFocused: $isFocused).padding(8)
                    }
                    withAnimation
                    {
                        TextInputFieldWithFocus("Project ID", text: $projectId, isFocused: $isFocused).padding(8)
                    }
                    Button(action:
                        {
                            addProject()
                            title = EMPTY_STRING
                            projectId = EMPTY_STRING
                            isFocused = false
                        })
                    {
                        Text("Create Project").foregroundColor(title.isEmpty || projectId.isEmpty ? .secondary : .primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .disabled(title.isEmpty || projectId.isEmpty)
                }.padding()
            }

            Spacer()
            ProjectListView()
            Spacer()
                .navigationTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addProject()
    {
        withAnimation
        {
            let project = Project(context: moc)
            project.id = UUID()
            project.created = Date()
            project.lastUpdated = project.created
            project.name = title
            
            do
            {
                try moc.save()
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
}

struct ProjectsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let moc = PersistenceController.shared.container.viewContext
        ProjectsView()
            .environment(\.managedObjectContext, moc)
    }
}
