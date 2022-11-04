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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)], animation: .default)
    private var projects: FetchedResults<Project>
    
    @State var trashIsEnabled: Bool = false
    let project: Project
    
    var body: some View
    {
        NavigationLink(value: Route.project(project))
        {
            HStack(alignment: .center)
            {
                // Constants.TRASH_ICON: String
                // Tap-hold gesture enables trashIsEnabled boolean
                // when trashIsEnabled is true, a tap gesture on the Image
                // will cause project to be deleted from the localRealm DB
                Image(systemName: TRASH_ICON).foregroundColor(trashIsEnabled ? .red : .gray)
                    .disabled(trashIsEnabled)
                    .onTapGesture
                    {
                        print("pressed")
                        if trashIsEnabled
                        {
                            print("delete pressed")
                            deleteProject(project)
                        }
                    }
                    .onLongPressGesture(minimumDuration: 0.8)
                    {
                        trashIsEnabled.toggle()
                        print("TeSTTESTTETST")
                    }
    
                Text(project.name ?? EMPTY_STRING)
                Spacer()
                let projectId = project.id?.uuidString ?? EMPTY_STRING
                Text(projectId.shorten(by: 3) + "...")
            }
        }
    }
    
    private func deleteProject(_ project: Project)
    {
        if let deleteIndex = projects.firstIndex(where: { $0.id == project.id })
        {
            print("attempting deletion")
            withAnimation
            {
                moc.delete(projects[deleteIndex])
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
}

struct ProjectCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectCellView(project: Project())
    }
}
