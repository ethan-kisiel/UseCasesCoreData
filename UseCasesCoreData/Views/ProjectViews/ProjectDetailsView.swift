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
    
    @FocusState var isCommentBoxFocused: Bool
    @State var areCommentsExpanded: Bool = false
    
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
                .padding(.leading)
                .padding(.bottom, 5)
                .font(.title)
                .foregroundColor(NM_SEC)
                
                HStack
                {
                    Text("Description: ")
                    Text(project.wrappedDescription)
                        .bold()
                }
                .font(.headline)
                .padding(.leading)
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
                    .padding(.leading)
                    .foregroundColor(NM_SEC)
                }
                
                HStack
                {
                    Text("Last updated: ")
                    Text(project.wrappedDate)
                        .bold()
                }
                .font(.headline)
                .padding(.leading)
                .foregroundColor(NM_SEC)
            }
            .padding()

            HStack
            {
                NeumorphicButton("Edit", buttonColor: .blue, fontColor: NM_MAIN)
                {
                    Log.info("Edit button pressed.")
                }
                
                NeumorphicButton("Delete", buttonColor: .red, fontColor: NM_MAIN)
                {
                    Log.info("Delete button pressed.")
                }
            }
            
            Spacer()
            
            NeumorphicButton("Add a comment...")
            {
                areCommentsExpanded = true
                $isCommentBoxFocused.wrappedValue = true
            }
        }
        .sheet(isPresented: $areCommentsExpanded)
        {
            NavigationView
            {
                ZStack
                {
                    NM_MAIN.edgesIgnoringSafeArea(.all)
                    CommentsView(
                        isExpanded: $areCommentsExpanded,
                        parentObject: project,
                        isFocused: $isCommentBoxFocused
                    )
                }
            }
            .presentationDetents([.medium])
        }
        .background(NM_MAIN)
        .navigationTitle("Project Details")
        .onTapGesture
        {
            isCommentBoxFocused = false
            areCommentsExpanded = false
        }
    }
}
/*
struct ProjectDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView()
    }
}
*/
