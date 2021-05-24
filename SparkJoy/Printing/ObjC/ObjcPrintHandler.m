//
//  ObjCPrintHandler.m
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

#import "ObjCPrintHandler.h"

// Super class for common methods used by the other PrintHandlers
@implementation ObjCPrintHandler

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
-(NSString *) objcCheckPrinterStatus:(BRLMPrinterDriver *)printerDriver
                       expectedModel:(BRLMPrinterModel)expectedModel
{
    BRLMGetPrinterStatusResult *status = printerDriver.getPrinterStatus;
    
    if (status.error.code != BRLMGetStatusErrorCodeNoError)
    {
        
        NSString *errorMsg = [NSString stringWithFormat:@"checkPrinterStatus: Error getting status: %@", status.error.description];
        
        // NOTE: Since BRLMGetStatusError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
        // If so, let's add it to the message. So far, it seems that nothing is available here. Must check for nil.
        if (status.error.errorRecoverySuggestion != nil)
        {
            errorMsg = [NSString stringWithFormat:@"%@\nRecovery: %@", errorMsg,status.error.errorRecoverySuggestion];
        }
        
        
        NSLog(@"%@", errorMsg);
        return errorMsg;
    } // if error getting status
    else
    {
        // status was received OK. Now evaluate it.
        
        // Assure model connected matches the expectedModel.
        // This assures that we won't send the wrong print data for the model.
        // Also, this can serve as a "gate" to prevent using the app with compatible non-certified models.
        if (expectedModel != status.status.model)
        {
            NSString *errorMsg = @"objcCheckPrinterStatus: Error - wrong model connected";
            NSLog(@"%@", errorMsg);
            
            return errorMsg;
        }
        
        // TODO: Check other things by examining status and comparing against the Command Reference Guide
        // These will be model-dependent, but the status response data is similar for most models.
        // Ideally, SDK will add more capability to do this analysis for you and put it in the BRLMGetPrinterStatusResult.
        // For now, I'll only validate the connected printer model per above.
        
    } // else status received OK
    
    return nil; // nil means all OK
    
} // objcCheckPrinterStatus


// *********************************************************
// validatePrintSettings
// -> This can be used primarily for DEBUG, to get more information about the cause of an error at print-time
// if it is related to print settings.
//
// RETURNS:
// * nil if no issues
// * error string if there are any significant issues
// *********************************************************
-(NSString *)validatePrintSettings:(id<BRLMPrintSettingsProtocol>)printSettings
{
    //*** Generate a BRLMValidatePrintSettingsReport by allowing SDK to evaluate the printSettings.
    // NOTE:
    // * if report.errorCount > 0, printing will fail. But, if we proceed to print anyway, we can get an error code as well and handle that error.
    // * if report.warningCount > 0, there is an issue with settings, but the SDK will modify settings internally to print the job anyway.
    // * if report.noticeCount > 0, there is an issue with settings, but it is non-fatal and SDK can print without any internal modifications.
    // * In either case, you should investigate the settings and modify them as necessary.
    
    BRLMValidatePrintSettingsReport *report = [BRLMValidatePrintSettings validate:printSettings];
    NSLog(@"validatePrintSettings report:\n%@", report.description);
    
    if (report.errorCount > 0 || report.warningCount > 0 || report.noticeCount > 0)
    {
        // Allow caller to know there's a potential issue and add this to an alert if desired.
        return report.description;
    }
    
    return nil; // no issues
    
} // validatePrintSettings

// *********************************************************
// stringFromOpenChannelError
// -> Produce an error string from the result of calling the BRLMPrinterDriverGenerator's open channel API
//
// RETURNS:
// * nil if no issues
// * error string if there are any issues
// *********************************************************
-(NSString *)stringFromOpenChannelError:(BRLMOpenChannelError *) openChannelError
                        callingFunction:(NSString *)callingFunction
{
    // NOTE: BRLMOpenChannelError.error currently ONLY has "code", it does NOT provide a "description" like BRLMPrintError does (for now).
    // So, we will add our own description for each "code" here.
    
    NSString *errorMsg = nil;
    
    switch (openChannelError.code) {
        case BRLMOpenChannelErrorCodeNoError:
            // Shouldn't call this in this case, but handle it anyway.
            errorMsg = [NSString stringWithFormat:@"%@: Open Channel: SUCCESS", callingFunction];
            break;
        case BRLMOpenChannelErrorCodeOpenStreamFailure:
            errorMsg = [NSString stringWithFormat:@"%@: Open Channel ERROR: openStreamFailure", callingFunction];
            break;
        case BRLMOpenChannelErrorCodeTimeout:
            errorMsg = [NSString stringWithFormat:@"%@: Open Channel ERROR: TIMEOUT", callingFunction];
            break;
            
    }
    
    // NOTE: Since BRLMOpenChannelError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
    // If so, let's add it to the message. So far, it seems that nothing is available here. Must check for nil.
    if (openChannelError.errorRecoverySuggestion != nil) {
        errorMsg = [NSString stringWithFormat:@"%@: \nRecovery: %@", errorMsg, openChannelError.errorRecoverySuggestion];
    }
    
    return errorMsg;
    
} // stringFromOpenChannelError

// *********************************************************
// stringFromPrintError
// -> Produce an error string from the result of calling any printing API
//
// RETURNS:
// * nil if no issues
// * error string if there are any issues
// *********************************************************
-(NSString *)stringFromPrintError:(BRLMPrintError *) printError
                  callingFunction:(NSString *)callingFunction
{
    // NOTE: SDK provides "description" for this. So, let's use it, unless we want to make our own description.
    NSString *errorMsg = [NSString stringWithFormat:@"%@: \nERROR: %@", callingFunction, printError.description];

    // NOTE: Since BRLMPrintError is a subclass of BRLMError, it could potentially provide an "errorRecoverySuggestion".
    // If so, let's add it to the message. So far, it seems that nothing is available here. Must check for nil.
    if (printError.errorRecoverySuggestion != nil) {
        errorMsg = [NSString stringWithFormat:@"%@\nRecovery: %@", errorMsg, printError.errorRecoverySuggestion];
    }
    
    return errorMsg;
} // stringFromPrintError


@end
