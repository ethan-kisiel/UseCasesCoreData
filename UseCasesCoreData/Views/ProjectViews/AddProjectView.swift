//
//  AddProjectView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/17/22.
//

import SwiftUI

struct AddProjectView: View
{
    @Environment(\.managedObjectContext) var moc

    @State private var title: String = EMPTY_STRING
    @State private var projectId: String = EMPTY_STRING

    @FocusState var isFocused: Bool

    private var invalidFields: Bool
    {
        title.isEmpty || projectId.isEmpty
    }

    var body: some View
    {
        VStack(spacing: 5)
        {
            withAnimation
            {
                TextBoxWithFocus("Title", text: $title, isFocused: $isFocused).padding(8)
            }
            withAnimation
            {
                TextBoxWithFocus("Project ID", text: $projectId, isFocused: $isFocused).padding(8)
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
            .disabled(invalidFields)
            .padding(8)
        }.padding()
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
            project.customId = projectId

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

struct AddProjectView_Previews: PreviewProvider
{
    static var previews: some View
    {
        AddProjectView()
    }
}
