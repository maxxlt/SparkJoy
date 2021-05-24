//
//  PrintHandler.swift
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

// Super class for common methods used by the other PrintHandlers
class PrintHandler {
    
    // Need to store this outside of each printing function to allow cancelPrinting
    var printerDriver:BRLMPrinterDriver? = nil
    
    // *********************************************************
    // cancelPrinting
    // -> Allow user to cancel printing via a ProgressView
    // *********************************************************
    func cancelPrinting()
    {
        self.printerDriver?.cancelPrinting()
    }
    
    // *********************************************************
    // checkPrinterStatus
    // -> Ask printer to return it's status response. If received, evaluate it.
    //
    // NOTE: This can only be sent at the beginning or end of a job.
    // Not all fields of the status response will be valid at these times. Many fields are used by SDK internally.
    // Review the Raster Command Reference Guide for your desired printer model to understand the response returned.
    // Hopefully, in the future, the SDK will provide a more detailed BRLMGetPrinterStatusResult class that evaluates
    // the status response for you, beyond the current list of possible errors.
    //
    // RETURNS:
    // * "nil" if printer checks out OK.
    // * an error string if wrong model is connected or some other problem.
    // NOTE: We return String so the View can display this in an Alert.
    // *********************************************************
    func checkPrinterStatus(printerDriver:BRLMPrinterDriver, expectedModel:BRLMPrinterModel) -> String?
    {
        print("checkPrinterStatus")
        
        let status:BRLMGetPrinterStatusResult = printerDriver.getPrinterStatus()
        if status.error.code != .noError
        {
            var errorMsg = "checkPrinterStatus: Error getting status: \(status.error.description)"
            // NOTE: Since BRLMGetStatusError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
            // If so, let's add it to the message. So far, it seems that nothing is available here. must check for nil.
            if status.error.errorRecoverySuggestion != nil {
                errorMsg += "\nRecovery: \(status.error.errorRecoverySuggestion!)"
            }
            print(errorMsg)
            
            return errorMsg
        } // if error getting status
        else
        {
            // status was received OK. Now evaluate it.
            
            // Assure model connected matches the expectedModel.
            // This assures that we won't send the wrong print data for the model.
            // Also, this can serve as a "gate" to prevent using the app with compatible non-certified models.
            if expectedModel != status.status?.model
            {
                let errorMsg = "checkPrinterStatus: Error - wrong model connected"
                print(errorMsg)
                
                return errorMsg
            }
            
            // TODO: Check other things by examining status and comparing against the Command Reference Guide
            // These will be model-dependent, but the status response data is similar for most models.
            // Ideally, SDK will add more capability to do this analysis for you and put it in the BRLMGetPrinterStatusResult.
            // For now, I'll only validate the connected printer model per above.
            
        } // else status received OK
        
        return nil // nil means all OK
        
    } // checkPrinterStatus
    
    // *********************************************************
    // validatePrintSettings
    // -> This can be used primarily for DEBUG, to get more information about the cause of an error at print-time
    // if it is related to print settings.
    //
    // RETURNS:
    // * nil if no issues
    // * error string if there are any significant issues
    // *********************************************************
    func validatePrintSettings(printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        //*** Generate a BRLMValidatePrintSettingsReport by allowing SDK to evaluate the printSettings.
        // NOTE:
        // * if report.errorCount > 0, printing will fail. But, if we proceed to print anyway, we can get an error code as well and handle that error.
        // * if report.warningCount > 0, there is an issue with settings, but the SDK will modify settings internally to print the job anyway.
        // * if report.noticeCount > 0, there is an issue with settings, but it is non-fatal and SDK can print without any internal modifications.
        // * In either case, you should investigate the settings and modify them as necessary.
        let report:BRLMValidatePrintSettingsReport = BRLMValidatePrintSettings.validate(printSettings)
        print("validatePrintSettings report:\n\(report.description)")
        
        if report.errorCount > 0 || report.warningCount > 0 || report.noticeCount > 0
        {
            // Allow caller to know there's a potential issue and add this to an alert if desired.
            return report.description
        }
        
        return nil // no issues
    } // validatePrintSettings
    
    
    // *********************************************************
    // stringFromOpenChannelError
    // -> Produce an error string from the result of calling the BRLMPrinterDriverGenerator's open channel API
    //
    // RETURNS:
    // * nil if no issues
    // * error string if there are any issues
    // *********************************************************
    func stringFromOpenChannelError(openChannelError:BRLMOpenChannelError, callingFunction:String) -> String
    {
        // NOTE: BRLMOpenChannelError.error currently ONLY has "code", it does NOT provide a "description" like BRLMPrintError does (for now).
        // So, we will add our own description for each "code" here.
        
        var errorMsg = "\(callingFunction): Open Channel ERROR: "
        
        switch openChannelError.code {
            case .noError:
                // Shouldn't call this in this case, but handle it anyway.
                errorMsg = "\(callingFunction): Open Channel: SUCCESS"
            
            case .openStreamFailure:
                errorMsg = errorMsg + "openStreamFailure"
            
            case .timeout:
                errorMsg = errorMsg + "TIMEOUT"
            
            @unknown default:
                errorMsg = errorMsg + "unknown default"
            
        }
        
        // NOTE: Since BRLMOpenChannelError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
        // If so, let's add it to the message. So far, it seems that nothing is available here. Must check for nil.
        if openChannelError.errorRecoverySuggestion != nil {
            errorMsg += "\nRecovery: \(openChannelError.errorRecoverySuggestion!)"
        }
        
        return errorMsg
    }
    
    // *********************************************************
    // stringFromPrintError
    // -> Produce an error string from the result of calling any printing API
    //
    // RETURNS:
    // * nil if no issues
    // * error string if there are any issues
    // *********************************************************
    func stringFromPrintError(printError:BRLMPrintError, callingFunction:String) -> String
    {
        // NOTE: SDK provides "description" for this. So, let's use it, unless we want to make our own description.
        var errorMsg = "\(callingFunction): ERROR: \(printError.description)"
        
        // NOTE: Since BRLMPrintError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
        // If so, let's add it to the message. So far, it seems that nothing is available here. Must check for nil.
        if printError.errorRecoverySuggestion != nil {
            errorMsg += "\nRecovery: \(printError.errorRecoverySuggestion!)"
        }
        
        return errorMsg
    }
    
} // class PrintHandler
