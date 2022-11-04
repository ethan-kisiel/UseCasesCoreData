//
//  String+Extensions.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/3/22.
//

import Foundation

extension String
{
    func shorten(by: Int) -> String
    {
        return self.count <= by ? self : String(self[self.startIndex ..< (self.index( self.startIndex, offsetBy: by, limitedBy: self.endIndex) ?? self.endIndex)])
    }
    
}
