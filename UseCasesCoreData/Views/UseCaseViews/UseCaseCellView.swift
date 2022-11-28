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
    
    var body: some View
    {
        NavigationLink(value: Route.useCase(useCase))
        {
            VStack(spacing: 8)
            {
                HStack(alignment: .center)
                {
                    Text(useCase.wrappedTitle)
                    
                    Spacer()
                }
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text("**Created on:** \(useCase.wrappedDate)")
                            .font(.caption)
                        Text("**Last updated:** \(useCase.wrappedDate)")
                            .font(.caption)
                    }
                    
                    Spacer()
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
