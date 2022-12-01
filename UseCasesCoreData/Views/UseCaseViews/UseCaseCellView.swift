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
            VStack
            {
                HStack(alignment: .center)
                {
                    Text(useCase.wrappedTitle)
                        .bold()
                    
                    Spacer()
                }
                HStack
                {
                    VStack(alignment: .leading, spacing: 8)
                    {
                        Text(useCase.wrappedDescription)
                            .font(.caption)
                        Text("**Last updated:** \(useCase.wrappedDate)")
                            .font(.caption)
                    }.padding(.leading, 8)
                    
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
