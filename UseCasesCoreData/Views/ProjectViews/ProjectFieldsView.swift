//
//  EditProjectView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/9/22.
//

import SwiftUI

struct ProjectFieldsView: View
{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State var title: String = EMPTY_STRING
    
    @State var description: String = EMPTY_STRING
    
    @FocusState var isFocused: Bool
    
    private let project: ProjectEntity?
    
    private let isNewProject: Bool
    
    init(_ project: ProjectEntity? = nil)
    {
        if let project = project
        {
            self.project = project
            
            isNewProject = false
            
            // initialization happens here, so that the state values
            // which are used as bindings for the text fields
            // can be set to the values of the passed project
            
            _title = State(wrappedValue: project.wrappedTitle)
            
            _description = State(wrappedValue: project.desc ?? EMPTY_STRING)
        }
        else
        {
            self.project = nil
            
            isNewProject = true
        }
    }
    
    var invalidFields: Bool
    {
        title.isEmpty || description.isEmpty
    }
    
    var body: some View
    {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                withAnimation
                {
                    TextBoxWithFocus("Title", text: $title, isFocused: $isFocused)
                        .padding(8)
                }
                
                withAnimation
                {
                    TextEditorWithFocus("Description", text: $description, isFocused: $isFocused)
                        .padding(8)
                }
                
                HStack
                {
                    Button(action:
                            {
                        
                        isNewProject ? addProject() : updateProject(project!)
                        
                        title = EMPTY_STRING
                        description = EMPTY_STRING
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
                    
                    Button(action:
                            {
                        dismiss()
                    })
                    {
                        Text("Cancel").foregroundColor(.primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .padding(8)
                }
                
                Text(UserInfoUtil.shared.getUserName() ?? "No User")
                
                Spacer()
                  
            }.background(NM_MAIN)
                .padding()
            
        }
        .navigationTitle("\(isNewProject ? "Add" : "Edit") Project")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addProject()
    {
        withAnimation
        {
            let project = ProjectEntity(context: moc)
            project.id = EntityIdUtil.shared
                .getNewObjectId(ProjectEntity.self)

            project.dateCreated = Date()
            project.lastUpdated = project.dateCreated
            
            project.title = title
            project.desc = description
            
            
            if let userId = UserInfoUtil.shared.getUserId()
            {
                project.title = userId
            }

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

    private func updateProject(_ project: ProjectEntity)
    {
        project.title = title
        project.desc = description
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
        ProjectFieldsView()
    }
}
