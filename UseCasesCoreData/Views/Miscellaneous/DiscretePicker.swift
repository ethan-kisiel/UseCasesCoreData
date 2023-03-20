//
//  DiscretePicker.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/8/22.
//

import SwiftUI

struct DiscretePicker<T: Hashable>: View
{
    // The display text appears in front of the currently selected item
    // The selection binding must be a binding to an object of the
    // same type as the list of selectables.
    // ** Objects passed to this view MUST HAVE a member of type String
    // The keypath is a path to the object T's String member
    
    
    // Usage:
    // DiscretePicker(displayText: "Prefix: ",
    //                selection: $object,
    //                selectables = [objects],
    //                keyPath: \Object.string)
    // Output:
    // "Prefix: (object.string)" <-- this is now a picker
    
    
    let displayText: String

    @Binding var selection: T
    
    let selectables: [T]
    let keyPath: KeyPath<T, String>
    
    var body: some View
    {
        HStack(alignment: .top)
        {
            withAnimation
            {
                Menu
                {
                    Picker(selection: $selection,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(selectables, id: \.self)
                        { obj in
                            Text(obj[keyPath: keyPath])
                        }
                    })
                } label:
                {
                    Text(displayText)
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                    Text("**\(selection[keyPath: keyPath])**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }
            }
        }
    }
}

/*struct DiscretePicker_Previews: PreviewProvider
{
    static var previews: some View
    {
        DiscretePicker()
    }
}*/
