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
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    var useCases: FetchedResults<UseCaseEntity>
    
    let useCase: UseCaseEntity
    
    private func priorityBackground(_ priority: Priority) -> Color
    {
        switch priority
        {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
    
    var body: some View
    {
        NavigationLink(value: Route.useCase(useCase))
        {
            HStack
            {
                Image(systemName: useCase.isComplete ? CHECKED_ICON : UNCHECKED_ICON)
                    .onTapGesture
                {
                    updateIsComplete(useCase)
                }
                
                Text(useCase.wrappedTitle)
                Spacer()
                Text(useCase.priority ?? "None")
                    .padding(5)
                    .frame(width: 75)
                    .background(
                        priorityBackground(Priority(rawValue: useCase.priority!) ?? .low))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }
    
    private func updateIsComplete(_ useCase: UseCaseEntity)
    {
        if let useCaseIndex = useCases.firstIndex(where: { $0.id == useCase.id })
        {
            withAnimation
            {
                useCases[useCaseIndex].isComplete.toggle()
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

    private func deleteUseCase(_ useCase: UseCaseEntity)
    {
        
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
