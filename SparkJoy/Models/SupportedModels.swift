//
//  SupportedModels.swift
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

// ****************************
// top-level key for each model. We'll save preferences uniquely for each model (in the "Advanced" sample, not the "Basic" one).
// ****************************
let keyPJ673PrintSettings = "PJ-673 Print Settings"
let keyPJ763MFiPrintSettings = "PJ-763MFi Print Settings"
let keyPJ773PrintSettings = "PJ-773 Print Settings"

let keyRJ4040PrintSettings = "RJ-4040 Print Settings"
let keyRJ4030AiPrintSettings = "RJ-4030Ai Print Settings"
let keyRJ4230BPrintSettings = "RJ-4230B Print Settings"
let keyRJ4250WBPrintSettings = "RJ-4250WB Print Settings"
let keyRJ3050PrintSettings  = "RJ-3050 Print Settings"
let keyRJ3050AiPrintSettings = "RJ-3050Ai Print Settings"
let keyRJ3150PrintSettings = "RJ-3150 Print Settings"
let keyRJ3150AiPrintSettings = "RJ-3150Ai Print Settings"
let keyRJ2050PrintSettings = "RJ-2050 Print Settings"
let keyRJ2140PrintSettings = "RJ-2140 Print Settings"
let keyRJ2150PrintSettings = "RJ-2150 Print Settings"

let keyTD2120NPrintSettings = "TD-2120N Print Settings"
let keyTD2130NPrintSettings = "TD-2130N Print Settings"
let keyTD4100NPrintSettings = "TD-4100N Print Settings"
let keyTD4550DNWBPrintSettings = "TD-4550DNWB Print Settings"

let keyQL720NWPrintSettings = "QL-720NW Print Settings"
let keyQL820NWBPrintSettings = "QL-820NWB Print Settings"
let keyQL1110NWBPrintSettings = "QL-1110NWB Print Settings"

let keyMW260MFiPrintSettings = "MW-260MFi Print Settings"
let keyMW145MFiPrintSettings = "MW-145MFi Print Settings"

let keyPTE550WPrintSettings = "PT-E550W Print Settings"


/*
 TODO: Add more keys later if we add other SupportedModels to the app via this enum, for example:
 
 let keyTD4420DNPrintSettings = "TD-4420DN Print Settings"
 let keyTD4520DNPrintSettings = "TD-4520DN Print Settings"
 
 let keyMW170PrintSettings = "MW-170 Print Settings"
 let keyMW270PrintSettings = "MW-270 Print Settings"
  */

// ****************************************************************
// NOTE: The purpose of this enum is:
//
// a) to demonstrate a way for your app to handle a SUBSET of the printer models supported by the SDK.
//    * Since SDK's BRLMPrinterModel enum is an ObjC enum, switch statements require a "default" case to avoid a warning.
//    * Then, if you ADD a new model to the app LATER, the compiler will NOT warn you in these "switch" statements that you didn't
//       handle the new model. So, you would have to search for all "switch" statements manually and add code for the new model.
//    * But, a Swift enum like this will provide an ERROR at compile-time if any switch statement doesn't handle the new model,
//       making it easier to find all the places in the code you need to handle it.
//
// b) to provide a convenient place to access all "model dependent" features that can be accessed by code
//    * e.g. isWIFI, isMFi, isBLE can be used when designing a GUI to handle "channel"
//    * the "keyXXX" above and "settingsKey" below allows easily getting the key for saving/loading UserDefaults
//    * other features below can be used when designing a GUI for PrintSettings
//    * I've done a lot of the "heavy lifting" for you by gathering this info from the revelant Command Reference Guides
//      for each printer model.
// ****************************************************************

enum SupportedModels:Int, CaseIterable
{
    // NOTE: This list of models is only a SUBSET of the available models supported by the SDK.
    // If you need to add a different model to this list, the compiler will warn you for all places
    // where you need to add it (except when "default" is used in a switch statement).
    case PJ_673
    case PJ_763MFi
    case PJ_773
    case RJ_2050
    case RJ_2140
    case RJ_2150
    case RJ_3050
    case RJ_3050Ai
    case RJ_3150
    case RJ_3150Ai
    case RJ_4040
    case RJ_4030Ai
    case RJ_4230B
    case RJ_4250WB
    case TD_2120N
    case TD_2130N
    case TD_4100N       // NOTE: TD-4100N doesn't work with PDF or Image. PRN is OK. SDK team has been notified.
    case TD_4550DNWB
    case MW_260MFi
    case MW_145MFi
    case QL_720NW
    case QL_820NWB
    case QL_1110NWB
    case PT_E550W
    
    // Convert our SupportedModels enum to the SDKs BRLMPrinterModel enum
    // c.f. func supportedModelFromBRLMPrinterModel below to go the other direction
    var sdkModel: BRLMPrinterModel {
        
        // NOTE: It's interesting that Swift Bridging Header results in lower-case values of BRLMPrinterModel enum
        // if the original ObjC enum has a lower-case "i" as in "Ai" or "MFi".

        switch self
        {
            case .PJ_673:
                return BRLMPrinterModel.PJ_673
            case .PJ_763MFi:
                return BRLMPrinterModel.pj_763MFi
            case .PJ_773:
                return BRLMPrinterModel.PJ_773
            case .RJ_2050:
                return BRLMPrinterModel.RJ_2050
            case .RJ_2140:
                return BRLMPrinterModel.RJ_2140
            case .RJ_2150:
                return BRLMPrinterModel.RJ_2150
            case .RJ_3050:
                return BRLMPrinterModel.RJ_3050
            case .RJ_3050Ai:
                return BRLMPrinterModel.rj_3050Ai
            case .RJ_3150:
                return BRLMPrinterModel.RJ_3150
            case .RJ_3150Ai:
                return BRLMPrinterModel.rj_3150Ai
            case .RJ_4040:
                return BRLMPrinterModel.RJ_4040
            case .RJ_4030Ai:
                return BRLMPrinterModel.rj_4030Ai
            case .RJ_4230B:
                return BRLMPrinterModel.RJ_4230B
            case .RJ_4250WB:
                return BRLMPrinterModel.RJ_4250WB
            case .TD_2120N:
                return BRLMPrinterModel.TD_2120N
            case .TD_2130N:
                return BRLMPrinterModel.TD_2130N
            case .TD_4100N:
                return BRLMPrinterModel.TD_4100N
            case .TD_4550DNWB:
                return BRLMPrinterModel.TD_4550DNWB
            case .MW_260MFi:
                return BRLMPrinterModel.mw_260MFi
            case .MW_145MFi:
                return BRLMPrinterModel.mw_145MFi
            case .QL_720NW:
                return BRLMPrinterModel.QL_720NW
            case .QL_820NWB:
                return BRLMPrinterModel.QL_820NWB
            case .QL_1110NWB:
                return BRLMPrinterModel.QL_1110NWB
            case .PT_E550W:
                return BRLMPrinterModel.PT_E550W
       } // switch
    } // sdkModel
    
    // title is used to display text in GUI.
    // NOTE: In some cases, using modelName will be more appropriate.
    var title:String
    {
        switch (self)
        {
            case .PJ_673:
                return  "PJ-673"
            case .PJ_763MFi:
                return "PJ-763MFi"
            case .PJ_773:
                return "PJ-773"
            case .RJ_2050:
                return "RJ-2050"
            case .RJ_2140:
                return "RJ-2140"
            case .RJ_2150:
                return "RJ-2150"
            case .RJ_3050:
                return "RJ-3050"
            case .RJ_3050Ai:
                return "RJ-3050Ai"
            case .RJ_3150:
                return "RJ-3150"
            case .RJ_3150Ai:
                return "RJ-3150Ai"
            case .RJ_4040:
                return "RJ-4040"
            case .RJ_4030Ai:
                return "RJ-4030Ai"
            case .RJ_4230B:
                return "RJ-4230B"
            case .RJ_4250WB:
                return "RJ-4250WB"
            case  .TD_2120N:
                return "TD-2120N"
            case .TD_2130N:
                return "TD-2130N"
            case .TD_4100N:
                return "TD-4100N"
            case .TD_4550DNWB:
                return "TD-4550DNWB"
            case .MW_260MFi:
                return "MW-260MFi"
            case .MW_145MFi:
                return "MW-145MFi"
            case .QL_720NW:
                return "QL-720NW"
            case .QL_820NWB:
                return "QL-820NWB"
            case .QL_1110NWB:
                return "QL-1110NWB"
            case .PT_E550W:
                return "PT-E550W"

        } // switch
    } // var title
    
    // NOTE: SDK DeviceInfo.modelName doesn't always match the string we prefer use for title.
    // So, use this instead of title when you need to match DeviceInfo.modelName.
    // The main culprit is PJ-763MFi, where SDK/Printer removes the "MFi" from the model name.
    // And MW-260MFi, MW-145MFi, where SDK/Removes the "i" (so only "MF" at the end)
    // As far as I know, these are the only one that are different.
    var modelName:String
    {
        switch (self)
        {
            case .PJ_763MFi:
                return "PJ-763"
            case .MW_260MFi:
                return "MW-260MF"
            case .MW_145MFi:
                return "MW-145MF"
            default:
                return self.title
        }
    }

    // used for saving preferences to UserDefaults, separately for each supported printer model
    var settingsKey:String
    {
        switch (self)
        {
            case .PJ_673:
                return keyPJ673PrintSettings
            case .PJ_763MFi:
                return keyPJ763MFiPrintSettings
            case .PJ_773:
                return keyPJ773PrintSettings
            
            case .RJ_2050:
                return keyRJ2050PrintSettings
            case .RJ_2140:
                return keyRJ2140PrintSettings
            case .RJ_2150:
                return keyRJ2150PrintSettings
            case .RJ_3050:
                return keyRJ3050PrintSettings
            case .RJ_3050Ai:
                return keyRJ3050AiPrintSettings
            case .RJ_3150:
                return keyRJ3150PrintSettings
            case .RJ_3150Ai:
                return keyRJ3150AiPrintSettings
            case .RJ_4040:
                return keyRJ4040PrintSettings
            case .RJ_4030Ai:
                return keyRJ4030AiPrintSettings
            case .RJ_4230B:
                return keyRJ4230BPrintSettings
            case .RJ_4250WB:
                return keyRJ4250WBPrintSettings
            
            
            case .TD_2120N:
                return keyTD2120NPrintSettings
            case .TD_2130N:
                return keyTD2130NPrintSettings
            case   .TD_4100N:
                return keyTD4100NPrintSettings
            case   .TD_4550DNWB:
                return keyTD4550DNWBPrintSettings
  
            case .QL_720NW:
                return keyQL720NWPrintSettings
            case .QL_820NWB:
                return keyQL820NWBPrintSettings
            case .QL_1110NWB:
                return keyQL1110NWBPrintSettings

            case .MW_260MFi:
                return keyMW260MFiPrintSettings
            case .MW_145MFi:
                return keyMW145MFiPrintSettings

            case .PT_E550W:
                return keyPTE550WPrintSettings
                
            /*
             case   .TD_4420DN:
                 return keyTD4420DNPrintSettings
             case   .TD_4520DN:
                 return keyTD4520DNPrintSettings
             case .MW_170:
                 return keyMW170PrintSettings
             case .MW_270:
                 return keyMW270PrintSettings
             */
        } // switch
    } // var settingsKey
    
    // TODO: Add more models here if we add more QL models to SupportedModels
    var isQLModel:Bool
    {
        switch (self)
        {
            case .QL_720NW:
                return true
            case .QL_820NWB:
                return true
            case .QL_1110NWB:
                return true
           default:
                return false
            
        }
    }

    // TODO: Add more models here if we add more PT models to SupportedModels
    var isPTModel:Bool
    {
        switch (self)
        {
            case .PT_E550W:
                return true
            default:
                return false
        }
    }

    //**********************************************************************************************
    // Below are various model-dependent settings, that your app can get programatically if desired.
    // The SDK does not provide this type of information and it can be useful, especially when designing a GUI.
    // Most of this info has been taken from Command Reference Guides for each model.
    //**********************************************************************************************

    // Does the printer model support WIFI?
    var isWIFI:Bool
    {
        switch (self)
        {
            case .PJ_673:
                return true
            case .PJ_763MFi:
                return false
            case .PJ_773:
                return true
            case .RJ_2050:
                return true
            case .RJ_2140:
                return true
            case .RJ_2150:
                return true
            case .RJ_3050:
                return true
            case .RJ_3050Ai:
                return true
            case .RJ_3150:
                return true
            case .RJ_3150Ai:
                return true
            case .RJ_4040:
                return true
            case .RJ_4030Ai:
                return false
            case .RJ_4230B:
                return false
            case .RJ_4250WB:
                return true
            case  .TD_2120N:
                return true
            case .TD_2130N:
                return true
            case .TD_4100N:
                return true
            case .TD_4550DNWB:
                return true
            case .MW_260MFi:
                return false
            case .MW_145MFi:
                return false
            case .QL_720NW:
                return true
            case .QL_820NWB:
                return true
            case .QL_1110NWB:
                return true
            case .PT_E550W:
                return true

        } // switch
    } // isWIFI
    
    // Does the printer model support MFi Bluetooth?
    var isMFi:Bool
    {
        switch (self)
        {
            case .PJ_673:
                return false
            case .PJ_763MFi:
                return true
            case .PJ_773:
                return false
            case .RJ_2050:
                return true
            case .RJ_2140:
                return false
            case .RJ_2150:
                return true
            case .RJ_3050:
                return false
            case .RJ_3050Ai:
                return true
            case .RJ_3150:
                return false
            case .RJ_3150Ai:
                return true
            case .RJ_4040:
                return false
            case .RJ_4030Ai:
                return true
            case .RJ_4230B:
                return true
            case .RJ_4250WB:
                return true
            case  .TD_2120N:
                return false
            case .TD_2130N:
                return false
            case .TD_4100N:
                return false
            case .TD_4550DNWB:
                return true
            case .MW_260MFi:
                return true
            case .MW_145MFi:
                return true
            case .QL_720NW:
                return false
            case .QL_820NWB:
                return true
            case .QL_1110NWB:
                return true
            case .PT_E550W:
                return false

        } // switch
    } // isMFi
    
    // Does the printer model support BLE (Bluetooth Low Energy)?
    var isBLE:Bool
    {
        switch (self)
        {
            case .PJ_673:
                return false
            case .PJ_763MFi:
                return false
            case .PJ_773:
                return false
            case .RJ_2050:
                return false
            case .RJ_2140:
                return false
            case .RJ_2150:
                return false
            case .RJ_3050:
                return false
            case .RJ_3050Ai:
                return false
            case .RJ_3150:
                return false
            case .RJ_3150Ai:
                return false
            case .RJ_4040:
                return false
            case .RJ_4030Ai:
                return false
            case .RJ_4230B:  // Yes
                return true
            case .RJ_4250WB: // Yes
                return true
            case  .TD_2120N:
                return false
            case .TD_2130N:
                return false
            case .TD_4100N:
                return false
            case .TD_4550DNWB: // Yes
                return true
            case .MW_260MFi:
                return false
            case .MW_145MFi:
                return false
            case .QL_720NW:
                return false
           case .QL_820NWB:
                return false
            case .QL_1110NWB:
                return false
            case .PT_E550W:
                return false

        } // switch
    } // isBLE

    // Printer's Horizontal Resolution, in DPI (dots per inch)
    var horzResolution:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 300
            case .PJ_763MFi:
                return 300
            case .PJ_773:
                return 300
            case .RJ_2050:
                return 203
            case .RJ_2140:
                return 203
            case .RJ_2150:
                return 203
            case .RJ_3050:
                return 203
            case .RJ_3050Ai:
                return 203
            case .RJ_3150:
                return 203
            case .RJ_3150Ai:
                return 203
            case .RJ_4040:
                return 203
            case .RJ_4030Ai:
                return 203
            case .RJ_4230B:
                return 203
            case .RJ_4250WB:
                return 203
            case  .TD_2120N:
                return 203
            case .TD_2130N:
                return 300
            case .TD_4100N:
                return 300
            case .TD_4550DNWB:
                return 300
 
            // NOTE: These are probably not being used anyway.
            case .MW_260MFi:
                return 300
            case .MW_145MFi:
                return 300
           case .QL_720NW:
                return 300 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .QL_820NWB:
                return 300 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .QL_1110NWB:
                return 300 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .PT_E550W:
                return 180 // TODO: This model has variable resolution 180x180 and 180x360. I don't know how to handle this yet.
       } // switch
    } // horzResolution
    
    // Printer's Veertical Resolution, in DPI (dots per inch)
    var vertResolution:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 300
            case .PJ_763MFi:
                return 300
            case .PJ_773:
                return 300
            case .RJ_2050:
                return 203
            case .RJ_2140:
                return 203
            case .RJ_2150:
                return 203
            case .RJ_3050:
                return 203
            case .RJ_3050Ai:
                return 203
            case .RJ_3150:
                return 203
            case .RJ_3150Ai:
                return 203
            case .RJ_4040:
                return 203
            case .RJ_4030Ai:
                return 203
            case .RJ_4230B:
                return 203
            case .RJ_4250WB:
                return 203
            case  .TD_2120N:
                return 203
            case .TD_2130N:
                return 300
            case .TD_4100N:
                return 300
            case .TD_4550DNWB:
                return 300
                
            // NOTE: These are probably not being used anyway.
            case .MW_260MFi:
                return 300
            case .MW_145MFi:
                return 300
            case .QL_720NW:
                return 600 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .QL_820NWB:
                return 600 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .QL_1110NWB:
                return 600 // TODO: This model has variable resolution "up to 300x600". I don't know how to handle this yet.
            case .PT_E550W:
                return 180 // TODO: This model has variable resolution 180x180 and 180x360. I don't know how to handle this yet.
       } // switch
    } // vertResolution
    
    // Minimum paper width, in dots
    var minPaperWidthDots:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 1200 // 4*300, arbitrary restriction to handle likely skewing of narrower paper
            case .PJ_763MFi:
                return 1200 // 4*300, arbitrary restriction to handle likely skewing of narrower paper
            case .PJ_773:
                return 1200 // 4*300, arbitrary restriction to handle likely skewing of narrower paper
            case .RJ_2050:
                return 95 // 0.47*203
            case .RJ_2140:
                return 95 // 0.47*203
            case .RJ_2150:
                return 95 // 0.47*203
            case .RJ_3050:
                return 95 // 0.47*203
            case .RJ_3050Ai:
                return 95 // 0.47*203
            case .RJ_3150:
                return 95 // 0.47*203
            case .RJ_3150Ai:
                return 95 // 0.47*203
            case .RJ_4040:
                return 95 // 0.47*203
            case .RJ_4030Ai:
                return 95 // 0.47*203
            case .RJ_4230B:
                return 95 // 0.47*203
            case .RJ_4250WB:
                return 95 // 0.47*203
            case  .TD_2120N:
                return 95 // 0.47*203
            case .TD_2130N:
                return 141 // 0.47*300
            case .TD_4100N:
                return 141 // 0.47*300, not in spec, used Windows Driver to determine
            case .TD_4550DNWB:
                return 225 // 0.75*300, not in spec, used Windows Driver to determine
            
            // The following models cannot specify custom paper size, so min/max paper dimensions are N/A.
            // Set to 0.
            case .MW_260MFi:
                return 0
            case .MW_145MFi:
                return 0
            case .QL_720NW:
                return 0
            case .QL_820NWB:
                return 0
            case .QL_1110NWB:
                return 0
            case .PT_E550W:
                return 0
       } // switch
    } // minPaperWidthDots

    // Number of dots in the print head
    // c.f. comments in maxPaperWidthDots
    var headSizeDots:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 2464
            case .PJ_763MFi:
                return 2464
            case .PJ_773:
                return 2464
            case .RJ_2050:
                return 432
            case .RJ_2140:
                return 432
            case .RJ_2150:
                return 432
            case .RJ_3050:
                return 576
            case .RJ_3050Ai:
                return 576
            case .RJ_3150:
                return 576
            case .RJ_3150Ai:
                return 576
            case .RJ_4040:
                return 832
            case .RJ_4030Ai:
                return 832
            case .RJ_4230B:
                return 832
            case .RJ_4250WB:
                return 832
            case  .TD_2120N:
                return 448
            case .TD_2130N:
                return 672
            case .TD_4100N:
                return 1168 // NOTE: Just guessing. Online spec says max print width is 3.9" (98.6mm). 1168 is close and divisible by 8.
            case .TD_4550DNWB:
                return 1280
            
            // The following models cannot specify custom paper size, so min/max paper dimensions (and headsize) are N/A.
            // Set to 0.
            case .MW_260MFi:
                return 0
            case .MW_145MFi:
                return 0
            case .QL_720NW:
                return 0
            case .QL_820NWB:
                return 0
            case .QL_1110NWB:
                return 0
            case .PT_E550W:
                return 0

        } // switch
    } // headSizeDots

    // Maximum paper width, in dots
    //
    // NOTE: SDK currently cannot handle these max paper widths as defined in the Command Reference Guide, at least for RJ/TD models.
    // It will produce a PrintSettingsError due to "paper width is too large" (if you use the Validate Report to discover the reason for the failure).
    // It seems the SDK is rejecting any paper width that exceeds the width of the print head, which is INCORRECT behavior, because
    // most RJ/TD models allow paper that is wider than the print head.
    // In these cases (where paperwidth exceeds headsize), the "margins" need to be large enough to reduce the printable width
    // so that the PRINTABLE width <= headSize. (printableWidth = paperWidth - leftMargin - rightMargin).
    // To resolve this, I will create a "headSizeDots" variable here to use until SDK fixes this issue
    var maxPaperWidthDots:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 2550 // 8.5*300
            case .PJ_763MFi:
                return 2550 // 8.5*300
            case .PJ_773:
                return 2550 // 8.5*300
            case .RJ_2050:
                return 462 // 2.28*203
            case .RJ_2140:
                return 462 // 2.28*203
            case .RJ_2150:
                return 462 // 2.28*203
            case .RJ_3050:
                return 639 // 3.15*203
            case .RJ_3050Ai:
                return 639 // 3.15*203
            case .RJ_3150:
                return 639 // 3.15*203
            case .RJ_3150Ai:
                return 639 // 3.15*203
            case .RJ_4040:
                return 832 // 4.10*203
            case .RJ_4030Ai:
                return 832 // 4.10*203
            case .RJ_4230B:
                return 912 // 4.49*203
            case .RJ_4250WB:
                return 912 // 4.49*203
            case  .TD_2120N:
                return 503 // 2.48*203
            case .TD_2130N:
                return 744 // 2.48*300
            case .TD_4100N:
                return 1251 // 4.17*300, not in spec, used Windows Driver to determine
            case .TD_4550DNWB:
                return 1395 // 4.65*300, not in spec, used Windows Driver to determine
            
            // The following models cannot specify custom paper size, so min/max paper dimensions are N/A.
            // Set to 0.
            case .MW_260MFi:
                return 0
            case .MW_145MFi:
                return 0
            case .QL_720NW:
                return 0
            case .QL_820NWB:
                return 0
            case .QL_1110NWB:
                return 0
            case .PT_E550W:
                return 0

       } // switch
    } // maxPaperWidthDots


    // Minimum paper length, in dots
    var minPaperLengthDots:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 600 // 2"*300 arbitrary restriction to allow PerfRoll paper to print anything due to large unprintable area
            case .PJ_763MFi:
                return 600 // 2"*300 arbitrary restriction to allow PerfRoll paper to print anything due to large unprintable area
            case .PJ_773:
                return 600 // 2"*300 arbitrary restriction to allow PerfRoll paper to print anything due to large unprintable area
            case .RJ_2050:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_2140:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_2150:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3050:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3050Ai:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3150:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3150Ai:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4040:
                return 204 // 1", spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4030Ai:
                return 204 // 1", spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4230B:
                return 204 // 1", spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4250WB:
                return 204 // 1", spec section 4.3.4 Maximum and Minimum Lengths
            case  .TD_2120N:
                return 96 // 0.47*203, spec section 4.3.4 Maximum and Minimum Lengths
            case .TD_2130N:
                return 142 // 0.47*300, spec section 4.3.4 Maximum and Minimum Lengths
            case .TD_4100N:
                return 72 // 0.24*300, not in spec, used Windows Driver to determine
            case .TD_4550DNWB:
                return 75 // 0.25*300, not in spec, used Windows Driver to determine
            
            // The following models cannot specify custom paper size, so min/max paper dimensions are N/A.
            // Set to 0.
            case .MW_260MFi:
                return 0
            case .MW_145MFi:
                return 0
            case .QL_720NW:
                return 0
            case .QL_820NWB:
                return 0
            case .QL_1110NWB:
                return 0
            case .PT_E550W:
                return 0

        } // switch
    } // minPaperWidthDots
    
    // Maximum paper length, in dots
    var maxPaperLengthDots:UInt
    {
        switch (self)
        {
            case .PJ_673:
                return 30000 // 100", arbitrary
            case .PJ_763MFi:
                return 30000 // 100", arbitrary
            case .PJ_773:
                return 30000 // 100", arbitrary
            case .RJ_2050:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_2140:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_2150:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3050:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3050Ai:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3150:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_3150Ai:
                return 7992 // 1 meter (39.37"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4040:
                return 24094 // 3 meter (118.69"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4030Ai:
                return 24094 // 3 meter (118.69"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4230B:
                return 24094 // 3 meter (118.69"), spec section 4.3.4 Maximum and Minimum Lengths
            case .RJ_4250WB:
                return 24094 // 3 meter (118.69"), spec section 4.3.4 Maximum and Minimum Lengths
            case  .TD_2120N:
                return 7992 // 1 meter (39.37" @203dpi), spec section 4.3.4 Maximum and Minimum Lengths
            case .TD_2130N:
                return 11811 // 1 meter (39.37" @300dpi), spec section 4.3.4 Maximum and Minimum Lengths
            case .TD_4100N:
                return 11811 // 1 meter (39.37" @300dpi), not in spec, used Windows Driver to determine
            case .TD_4550DNWB:
                return 11811 // 1 meter (39.37" @300dpi), not in spec, used Windows Driver to determine
            
            // The following models cannot specify custom paper size, so min/max paper dimensions are N/A.
            // Set to 0.
            case .MW_260MFi:
                return 0
            case .MW_145MFi:
                return 0
            case .QL_720NW:
                return 0
            case .QL_820NWB:
                return 0
            case .QL_1110NWB:
                return 0
            case .PT_E550W:
                return 0

       } // switch
    } // minPaperWidthDots
    
    //*****************************************
    // supportsPrintQualityCommand:Bool
    //
    // Used to determine whether to show PrintQuality control in ImageSettingsFormSectionView.
    // SDK NOTE: This property does not belong in the common BRLMPrintImageSettings because not all print families support this capability,
    // which requires the FW to support a specific command(actually, just a single bit contained in a command).
    // So, I have implemented this property as a workaround, so Settings GUI only shows the option for the models that support it.
    //
    // As I understand, only some QL, PT, and TD models support it.
    // How to know: c.f. Raster Command Reference Guide for each model, "Print Information" Command (Esc iz), [n1] byte -> PI_QUALITY
    // After reviewing these manuals, here is a summary:
    // NOTE: Not all models listed here are even supported by the SDK. I'm listing all models covered by the manuals I reviewed.
    // -------------
    // NO:
    // -------------
    // PJ-6/7 series -> NO
    // RJ-2/3/4/42 series -> NO
    // MW series -> NO (no raster reference available)
    // QL-500, 550, 560, 570, 580N, 650TD, 1050, 1060N -> NO (flag not listed)
    // PT-E550W, P750W, P710BT -> NO (manual says flag is "not used")
    // PT-P900, P900W, P950NW -> NO (manual says flag is "not used")
    // PT-H500, P700, E500 -> NO (manual says flag is "not used")
    // TD-4100N -> NO (no raster reference available)
    // TD-4410D, 4420DN, 4510D, 4520DN, 4550DNWB -> NO (flag not listed)
    // -------------
    // YES:
    // -------------
    // QL-600, 710W, 720NW -> YES
    // QL-1100, 1110NWB, 1115NWB -> YES
    // QL-800, 810W, 820NWB -> YES (except, not valid with 2-color printing)
    // TD-2020, 2120N, 2130N -> YES
    //*****************************************

    var supportsPrintQualityCommand:Bool
    {
        switch (self)
        {
            case .PJ_673:
                return false
            case .PJ_763MFi:
                return false
            case .PJ_773:
                return false
            case .RJ_2050:
                return false
            case .RJ_2140:
                return false
            case .RJ_2150:
                return false
            case .RJ_3050:
                return false
            case .RJ_3050Ai:
                return false
            case .RJ_3150:
                return false
            case .RJ_3150Ai:
                return false
            case .RJ_4040:
                return false
            case .RJ_4030Ai:
                return false
            case .RJ_4230B:
                return false
            case .RJ_4250WB:
                return false
            case .TD_2120N:     // yes
                return true
            case .TD_2130N:     // yes
                return true
            case .TD_4100N:
                return false
            case .TD_4550DNWB:  // TODO: no? It's surprising that TD-2 supports but TD-4D does not. Maybe manual is wrong?
                return false
            case .MW_260MFi:
                return false
            case .MW_145MFi:
                return false
            case .QL_720NW:     // yes
                return true
            case .QL_820NWB:    // yes
                return true
            case .QL_1110NWB:   // yes
                return true
            case .PT_E550W:
                return false    // TODO: Not sure about this. Raster manual says PI_QUALITY is "Not Used".

        } // switch
    } // supportsPrintQualityCommand

    // This is used with RJ/TD models only, to decide whether to show RJTDCustomPaperView.
    // Support for this is actually a function of the SDK, not the printer model.
    // SDK currently supports only SOME of the RJ/TD models with the BRLMCustomPaperCommand class.
    // Eventually, all RJ/TD models should be supported.
    // Refer to the v3 User Guide for BRCustomPaperInfoCommand, since that's where it is actually documented.
    // TODO: Update this when SDK adds support for other RJ/TD models.
    //
    // NOTE: ALL RJ/TD models support using the paper.bin file approach to specify paper. Use that method in case of false here.
    // "CustomPaper by property" is a new option that allows specifying paper dynamically rather than requiring a BIN file.
    var supportsCustomPaperSizeCommand:Bool
    {
        switch (self)
        {
            case .RJ_2050:
                return false
            case .RJ_2140:
                return false
            case .RJ_2150:
                return false
            case .RJ_3050:
                return false
            case .RJ_3050Ai:
                return false
            case .RJ_3150:
                return false
            case .RJ_3150Ai:
                return false
            case .RJ_4040:      // yes
                return true
            case .RJ_4030Ai:    // yes
                return true
            case .RJ_4230B:     // yes
                return true
            case .RJ_4250WB:    // yes
                return true
            case .TD_2120N:
                return false
            case .TD_2130N:
                return false
            case .TD_4100N:     // yes
                return true
            case .TD_4550DNWB:  // yes
                return true
            default:            // N/A for PJ/QL/PT models
                return false    // NOTE: PJ models do support custom size, but N/A with this var. So return false for those too.
            
        } // switch
    } // supportsCustomPaperSizeCommand
    
    
    //**********************************************************************************************
    // functions
    //**********************************************************************************************

    
    // Convert SDKs BRLMPrinterModel enum to our SupportedModels enum.
    // c.f. "var sdkModel" above to go the other direction
    //
    // TODO: Add/Remove cases here as necessary. Unfortunately the switch must be exhaustive, so we have to include a default case
    // So, let's make the return value optional so we can return nil if caller gives us an unsuppported model
    // NOTE: static allows this to be called without an instance variable
    static func supportedModelFromBRLMPrinterModel(model:BRLMPrinterModel) -> SupportedModels?
    {
        // NOTE: It's interesting that Swift Bridging Header results in lower-case values of BRLMPrinterModel enum
        // if the original ObjC enum has a lower-case "i" as in "Ai" or "MFi".
        
        switch (model)
        {
            case .PJ_673:
                return .PJ_673
            case .pj_763MFi:
                return .PJ_763MFi
            case .PJ_773:
                return .PJ_773
            case .RJ_2050:
                return .RJ_2050
            case .RJ_2140:
                return .RJ_2140
            case .RJ_2150:
                return .RJ_2150
            case .RJ_3050:
                return .RJ_3050
            case .rj_3050Ai:
                return .RJ_3050Ai
            case .RJ_3150:
                return .RJ_3150
            case .rj_3150Ai:
                return .RJ_3150Ai
            case .RJ_4040:
                return .RJ_4040
            case .rj_4030Ai:
                return .RJ_4030Ai
            case .RJ_4230B:
                return .RJ_4230B
            case .RJ_4250WB:
                return .RJ_4250WB
            case  .TD_2120N:
                return .TD_2120N
            case .TD_2130N:
                return .TD_2130N
            case .TD_4100N:
                return .TD_4100N
            case .TD_4550DNWB:
                return .TD_4550DNWB
            case .mw_260MFi:
                return .MW_260MFi
            case .mw_145MFi:
                return .MW_145MFi
            case .QL_720NW:
                return .QL_720NW
            case .QL_820NWB:
                return .QL_820NWB
            case .QL_1110NWB:
                return .QL_1110NWB
            case .PT_E550W:
                return .PT_E550W
                
            // NOTE: Xcode requires switch to be "exhaustive".
            // So, we must use default here or add all SDK models as SupportedModels.
            default:
                return nil

        } // switch
    } // supportedModelFromBRLMPrinterModel

    // NOTE: static allows this to be called without an instance variable
    static func getArrayOfAllSupportedWIFIModels() -> [String]
    {
        var allModelArray:[String] = []
        
        for model in SupportedModels.allCases
        {
            if (model.isWIFI)
            {
                // NOTE: Since we are using this with DeviceInfo, it is more appropriate to use modelName instead of title here,
                // even though it may not make a difference with WIFI models.
                
                // NOTE: It seems that it is no longer necessary to add "Brother " before the model name.
                // DeviceInfo.strModelName DOES add "Brother". However, with WIFI, we pass the list of printers to filter
                // to the SDK, and the SDK does the filtering. So, with WIFI, it works either with or without "Brother" in the string.
                
                // allModelArray.append("Brother \(model.modelName)") // add Brother
                allModelArray.append(model.modelName) // don't add Brother
            }
        }
        
        return allModelArray
    }

    // NOTE: static allows this to be called without an instance variable
    static func getArrayOfAllSupportedMFiModels() -> [String]
    {
        var allModelArray:[String] = []
        
        for model in SupportedModels.allCases
        {
            if (model.isMFi)
            {
                // NOTE: Since we are using this with DeviceInfo, it is more appropriate to use modelName instead of title.
                // This is needed for PJ763MFi model.
                
                // NOTE: Do NOT add "Brother ", since DeviceInfo.strModelName (or EAAccessory.modelName) does NOT contain this for MFi.
                // We are using this array to filter the list of DeviceInfo objects returned.
                //allModelArray.append("Brother \(model.modelName)")
                allModelArray.append(model.modelName)
            }
        }
        
        return allModelArray
    }
    
    // NOTE: static allows this to be called without an instance variable
    static func getArrayOfAllSupportedBLEModels() -> [String]
    {
        var allModelArray:[String] = []
        
        for model in SupportedModels.allCases
        {
            if (model.isBLE)
            {
                // NOTE: Since we are using this with DeviceInfo, it is more appropriate to use modelName instead of title.
                #if DO_NOT_USE
                // NOTE: In this case, ** DO ** add "Brother " before the model name.
                // BLE DOES add "Brother" in DeviceInfo.strModelName and we need to match it.
                allModelArray.append("Brother \(model.modelName)")
                #else
                // Indeed, DeviceInfo does (for now) return "Brother XXX" in its strModelName for BLE.
                // And, if we compare the string exactly, then we should add Brother here too.
                // However, I think it's better if we are consistent here to include ONLY the model string,
                // and handle the case where "Brother " is added to DeviceInfo in a different way that only looks
                // to find this as a substring instead of as the complete string.
                //
                // This code had been working fine, until I added another case that created an array with a single model.
                // I had forgotten to add "Brother " to that single model case and the code using the array wasn't working.
                // That's when I decided to make this change here and in the code that processes the array.
                allModelArray.append(model.modelName)
                #endif
            }
        }
        
        return allModelArray
    }

    //***************************************************
    // v4QLLabelSizeFromV3LabelIdType
    // This function converts v3 SDK enum -> v4 SDK enum
    //
    // NOTE: To determine the CURRENTLY INSTALLED label in QL models, you can use v3 SDK API "getLabelInfoStatus".
    // However, the enum value returned is DIFFERENT from what v4 SDK requires.
    //
    // Refer to BRPtouchLabelInfoStatus.h (v3 SDK header) and BRLMQLPrintSettings.h (v4 SDK header)
    //***************************************************
    static func v4QLLabelSizeFromV3LabelIdType(v3labelID:LabelIdType) -> BRLMQLPrintSettingsLabelSize?
    {
        switch (v3labelID)
        {
            //** Die-cut
            case .W17H54:
                return .dieCutW17H54
            case .W17H87:
                return .dieCutW17H87
            case .W23H23:
                return .dieCutW23H23
            case .W29H42:
                return .dieCutW29H42
            case .W29H90:
                return .dieCutW29H90
            case .W38H90:
                return .dieCutW38H90
            case .W39H48:
                return .dieCutW39H48
            case .W52H29:
                return .dieCutW52H29
            case .W62H29:
                return .dieCutW62H29
            case .W62H100:
                return .dieCutW62H100
            case .W60H86:
                return .dieCutW60H86
            case .W54H29:               //** QL-800 series only
                return .dieCutW54H29
            case .W102H51:              //** QL_1100 only
                return .dieCutW102H51
            case .W102H152:             //** QL_1100 only
                return .dieCutW102H152
            case .W103H164:             //** QL_1100 only
                return .dieCutW103H164

            //** Continuous Roll
            case .W12:                  //** also used in PT
                return .rollW12
            case .W29:
                return .rollW29
            case .W38:
                return .rollW38
            case .W50:
                return .rollW50
            case .W54:
                return .rollW54
            case .W62:
                return .rollW62
            case .W62RB:                //** QL-800 series only
                return .rollW62RB
            
            //** QL_1100 only
            case .W102:
                return .rollW102
            case .W103:
                return .rollW103
            case .DT_W90:
                return .dtRollW90
            case .DT_W102:
                return .dtRollW102
            case .DT_W102H51:
                return .dtRollW102H51
            case .DT_W102H152:
                return .dtRollW102H152
            
            default:
                return nil          // label not supported by QL with v4 SDK (as of v4.0.2)
        }
    } // v4QLLabelSizeFromV3LabelIdType
    
    //***************************************************
    // v4PTLabelSizeFromV3LabelIdType
    // This function converts v3 SDK enum -> v4 SDK enum
    //
    // NOTE: To determine the CURRENTLY INSTALLED label in PT models, you can use v3 SDK API "getLabelInfoStatus".
    // However, the enum value returned is DIFFERENT from what v4 SDK requires.
    //
    // Refer to BRPtouchLabelInfoStatus.h (v3 SDK header) and BRLMPTPrintSettings.h (v4 SDK header)
    //***************************************************
    static func v4PTLabelSizeFromV3LabelIdType(v3labelID:LabelIdType) -> BRLMPTPrintSettingsLabelSize?
    {
        switch (v3labelID)
        {
            // PT
            case .W3_5:
                return .width3_5mm
            case .W6:
                return .width6mm
            case .W9:
                return .width9mm
            case .W12:                  //** also used in QL
                return .width12mm
            case .W18:
                return .width18mm
            case .W24:
                return .width24mm
            case .W36:
                return .width36mm
            case .HS_W6:
                return .widthHS_5_8mm
            case .HS_W9:
                return .widthHS_8_8mm
            case .HS_W12:
                return .widthHS_11_7mm
            case .HS_W18:
                return .widthHS_17_7mm
            case .HS_W24:
                return .widthHS_23_6mm
            case .FLE_W21H45:
                return .widthFL_21x45mm
                
            default:                    //** label not supported by PT with v4 SDK (as of v4.0.2)
                return nil
         }
        
    } // v4PTLabelSizeFromV3LabelIdType
    
} // enum


