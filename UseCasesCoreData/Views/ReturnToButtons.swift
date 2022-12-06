//
//  ReturnToButtons.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/6/22.
//

import SwiftUI

struct ReturnToButtons: View
{
    @EnvironmentObject var router: Router

    var body: some View
    {
        VStack
        {
            NavigationButton(text: "Return to Project Categories")
            {
                router.goToCategories()
            }

            NavigationButton(text: "Return to Project List")
            {
                router.reset()
            }
        }
    }
}

struct ReturnToButtons_Previews: PreviewProvider
{
    static var previews: some View
    {
        ReturnToButtons()
    }
}
