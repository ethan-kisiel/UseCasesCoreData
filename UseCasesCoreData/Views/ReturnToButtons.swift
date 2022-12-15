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
        HStack
        {
            NavigationButton(text: "Return to Projects")
            {
                router.reset()
            }

            NavigationButton(text: "Return to Categories")
            {
                router.goToCategories()
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
