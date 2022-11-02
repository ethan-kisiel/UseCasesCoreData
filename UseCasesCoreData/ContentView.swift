//
//  ContentView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        Text("Hello world")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
