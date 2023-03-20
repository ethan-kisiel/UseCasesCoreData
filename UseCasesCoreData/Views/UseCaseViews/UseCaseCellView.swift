//
//  UseCaseCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/10/22.
//

import Neumorphic
import SwiftUI

struct UseCaseCellView: View
{
    @Environment(\.managedObjectContext) var moc
    
    let useCase: UseCaseEntity
    
    var isSelectedPath: Bool
    {
        return useCase.id == (Router.shared.targetPath["useCase"] as? UseCaseEntity)?.id
    }
    
    var body: some View
    {
        NavigationLink(value: Route.useCase(useCase))
        {
            VStack(alignment: .leading, spacing: 5)
            {
                HStack
                {
                    // Target path selector
                    Image(systemName: isSelectedPath ? "star.fill" : "star")
                        .foregroundColor(isSelectedPath ? .yellow : .accentColor)
                        .onTapGesture
                        {
                            if !isSelectedPath
                            {
                                Router.shared.updateTargetPath(useCase)
                            }
                        }
                    
                    Text(useCase.wrappedTitle)
                        .bold()
                }
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text(useCase.wrappedDescription)
                            .font(.caption)
                        Text("**Last updated:** \(useCase.wrappedDate)")
                            .font(.caption)
                    }
                }
            }
        }
    }
}

struct UseCaseCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let context = PersistenceController.shared.container.viewContext
        let useCase = UseCaseEntity(context: context)
        UseCaseCellView(useCase: useCase)
    }
}
