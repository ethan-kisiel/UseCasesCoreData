//
//  ProjectDetailsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/15/22.
//

import SwiftUI

struct ProjectDetailsView: View
{
    @State var project: ProjectEntity
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)])
    var projects: FetchedResults<ProjectEntity>
    
    private var sortedProjects: [ProjectEntity]
    {
        projects.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                DiscretePicker(displayText: "Project: ", selection: $project, selectables: sortedProjects, keyPath: \ProjectEntity.wrappedTitle)

                Spacer()
            }
            .padding(.leading, 8)
            
            VStack(alignment: .leading)
            {
                HStack
                {
                    Text("Title: ")
                    Text(project.wrappedTitle)
                        .bold()
                }
                .padding()
                .font(.title)
                .foregroundColor(NM_SEC)
                
                HStack
                {
                    Text("Description: ")
                    Text(project.wrappedDescription)
                        .bold()
                }
                .font(.headline)
                .padding([.leading, .top])
                .foregroundColor(NM_SEC)
                
                if let userName = UserInfoUtil.shared.getUserFullName()
                {
                    HStack
                    {
                        Text("Created by: ")
                        Text(userName)
                            .bold()
                    }
                    .font(.headline)
                    .padding([.leading, .top])
                    .foregroundColor(NM_SEC)
                }
                
                HStack
                {
                    Text("Last updated: ")
                    Text(project.wrappedDate)
                        .bold()
                }
                .font(.headline)
                .padding([.leading, .top])
                .foregroundColor(NM_SEC)
            }
            .padding()

            Spacer()
                
            HStack
            {
                NeumorphicButton("Edit", buttonColor: .blue, fontColor: NM_MAIN)
                {
                    print("Edit Pressed")
                }
                
                NeumorphicButton("Delete", buttonColor: .red, fontColor: NM_MAIN)
                {
                    print("Delete Pressed")
                }
            }
            
            Spacer()
        }
        .background(NM_MAIN)
        .navigationTitle("Project Details")
    }
}

/*
struct ProjectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView()
    }
}
*/
