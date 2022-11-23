//
//  EditProjectView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/9/22.
//

import SwiftUI

struct EditProjectView: View
{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    let project: ProjectEntity
    @State var title: String
    @State var projectId: String
    @FocusState var isFocused: Bool
    
    init(project: ProjectEntity)
    {
        self.project = project
        
        // initialization happens here, so that the state values
        // which are used as bindings for the text fields
        // can be set to the values of the passed project
        
        _title = State(wrappedValue: project.wrappedTitle)
        _projectId = State(wrappedValue: project.wrappedId)
    }
    
    var invalidFields: Bool
    {
        title.isEmpty || projectId.isEmpty
    }
    
    var body: some View
    {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                Text(project.wrappedTitle)
                withAnimation
                {
                    TextBoxWithFocus("Project Name", text: $title, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextBoxWithFocus("Project ID", text: $projectId, isFocused: $isFocused).padding(8)
                }
                
                Button(action:
                        {
                    updateProject(project)
                    
                    title = EMPTY_STRING
                    projectId = EMPTY_STRING
                    isFocused = false
                    dismiss()
                })
                {
                    Text("Save Project").foregroundColor(invalidFields ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(invalidFields)
                .padding(8)
                
                Spacer()
                    .navigationTitle("Edit Project")
                    .navigationBarTitleDisplayMode(.inline)
            }.background(NM_MAIN)
                .padding()
            
        }
    }
    
    private func updateProject(_ project: ProjectEntity)
    {
        project.title = title
        project.lastUpdated = Date()
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

struct EditProjectView_Previews: PreviewProvider
{
    static var previews: some View
    {
        EditProjectView(project: ProjectEntity())
    }
}
