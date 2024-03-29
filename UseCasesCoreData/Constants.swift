//
//  Constants.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/4/22.
//

import Foundation
import Neumorphic
import SwiftUI

let EMPTY_STRING: String = ""
let MISSING_DATA: String = "MISSING DATA"
let USER_ID_STRING: String = "UserId"

let TRASH_ICON: String = "trash.circle.fill"
let UNCHECKED_ICON: String = "square"
let CHECKED_ICON: String = "square.inset.filled"
let MORE_ICON: String = "ellipsis.circle"
let LESS_ICON: String = "minus.circle"
let ADD_ICON: String = "plus.circle"
// neumorphic UI main color
let NM_MAIN = Color.Neumorphic.main
let NM_LIGHT_SHADOW = Color.Neumorphic.lightShadow
// neumorphic UI secondary color
let NM_SEC = Color.Neumorphic.secondary
let NM_DARK_SHADOW = Color.Neumorphic.darkShadow

// character amount to shorten display title to if display title > DT_SHORT
let DISP_SHORT: Int = 10

// alert texts:
let ALERT_DEL = "Delete"

// These are the default values for the entity ids
// based off int64 maximum size

let CAT_ID_DEFAULT: Int64 = 1000000000000000
let UC_ID_DEFAULT: Int64 = 2000000000000000
let STEP_ID_DEFAULT: Int64 = 3000000000000000
let COM_ID_DEFAULT: Int64 = 4000000000000000
