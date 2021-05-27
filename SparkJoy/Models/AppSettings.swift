//
//  AppSettings.swift
//  BMS_SwiftUI_Sample_v4_Basic
//
//  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
//  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
//  PARTICULAR PURPOSE.
//
//  Created by Rob Roy
//  Copyright © 2020 Brother Mobile Solutions. All rights reserved.
//

import Foundation

class AppSettings:ObservableObject
{
    let keyPrintUsingObjC = "Print Using ObjC"

    //**********************************************
    // printUsingObjC: used for test of ObjC code only
    //
    // Enabled (true): print using ObjCPrintHandler methods
    // Disabled (false): print using Swift PrintHandler methods
    //**********************************************
    @Published var printUsingObjC:Bool = false
    {
        didSet {
            let defaults = UserDefaults.standard
            
            defaults.set(printUsingObjC, forKey: keyPrintUsingObjC)
        }
    }


    init() {
        // init from UserDefaults, if key exists.
        // If not, use the initial value already specified above.
        
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation()
        
        // NOTE: When we load integer, bool, etc (i.e. rawValue), the value will be 0 if key DOES NOT EXIST.
        // So, we need to determine if the key exists. This is why we use dictionaryRepresentation
          
        if keys[keyPrintUsingObjC] != nil {
            self.printUsingObjC = defaults.bool(forKey: keyPrintUsingObjC)
        }

    }
    

} // class
