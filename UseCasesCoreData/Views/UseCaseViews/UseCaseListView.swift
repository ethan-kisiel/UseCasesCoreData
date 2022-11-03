//
//  UseCasesListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/10/22.
//

import SwiftUI
enum Sections: String, CaseIterable
{
    case incomplete
    case complete
}

struct UseCaseListView: View
{
    // takes category for filter query purposes
    @State var category: Category
    /*
    @ObservedResults(UseCase.self) var useCases: Results<UseCase>
    var categoryUseCases: Results<UseCase>
    {
        // filter observed results to get only project cases
        return useCases.where { $0.parentCategory._id == category._id }
    }

    var completeUseCases: Results<UseCase>
    {
        return categoryUseCases.where { $0.isComplete == true }
    }

    var incompleteUseCases: Results<UseCase>
    {
        return categoryUseCases.where { $0.isComplete == false }
    }
*/
    var body: some View
    {
        List
        {
            ForEach(Sections.allCases, id: \.self)
            {
                section in
                //let filteredCases = section == .incomplete ? incompleteUseCases : completeUseCases
                Spacer()
                
                Section
                {
                    /*if filteredCases.isEmpty
                    {
                        Text("No \(section.rawValue) use cases to display.")
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                    }
                    else
                    {
                        switch section
                        {
                        case .incomplete:
                            Text("Incomplete use cases:")
                                .fontWeight(.semibold)
                                .opacity(0.5)
                        case .complete:
                            Text("Complete use cases:")
                                .fontWeight(.semibold)
                                .opacity(0.5)
                        }
                        
                        ForEach(filteredCases, id: \.self)
                        {
                            useCase in
                            UseCaseCellView(useCase: useCase)
                        }
                        /*
                        .onDelete
                        {
                            indexSet in
                            indexSet.forEach
                            {
                                index in
                                UseCaseManager.shared.deleteUseCase(filteredCases[index])
                            }
                        }*/
                    }*/
                }
            }
        }
        .listStyle(.plain)
        .padding()
    }
}

struct UseCasesListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let category: Category = Category()
        UseCaseListView(category: category)
    }
}
