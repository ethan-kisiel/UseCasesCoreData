//
//  ProjectCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/7/22.
//

import CoreData
import SwiftUI

struct ProjectCellView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
    @State var trashIsEnabled: Bool = false
    let project: ProjectEntity
    
    var body: some View
    {
        NavigationLink(value: Route.project(project))
        {
            VStack
            {
                HStack(alignment: .center)
                {
                    // Constants.TRASH_ICON: String
                    // Tap-hold gesture enables trashIsEnabled boolean
                    // when trashIsEnabled is true, a tap gesture on the Image
                    // will cause project to be deleted from the localRealm DB
                    
                    Text(project.wrappedTitle)
                        .bold()
                    
                    Spacer()
                }
                HStack
                {
                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text(project.wrappedDescription)
                            .font(.caption)
    
                        Text("**Last updated:** \(project.wrappedDate)")
                            .font(.caption)
                    }.padding(.leading, 8)
                    
                    Spacer()
                }
            }.background(NM_MAIN)
        }
    }
    
    private func deleteProject(_ project: ProjectEntity)
    {
        if let deleteIndex = projects.firstIndex(where: { $0.id == project.id })
        {
            print("attempting deletion")
            withAnimation
            {
                moc.delete(projects[deleteIndex])
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
}

struct ProjectCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectCellView(project: ProjectEntity())
    }
}
