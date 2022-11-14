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

    let project: Project
    @State var title: String
    @State var projectId: String
    @FocusState var isFocused: Bool
    
    init(project: Project)
    {
        self.project = project
        _title = State(wrappedValue: project.wrappedName)
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
                Text(project.wrappedName)
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
    
    private func updateProject(_ project: Project)
    {
        project.name = title
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
        EditProjectView(project: Project())
    }
}
