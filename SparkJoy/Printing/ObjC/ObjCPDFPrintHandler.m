//
//  ObjCPDFPrintHandler.m
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

#import "ObjCPDFPrintHandler.h"

@implementation ObjCPDFPrintHandler

//********************************************************************************************
// IMPORTANT NOTE: Notice that we have added an additional protocol (BRLMPrintImageSettings) to ALL of the
// method definitions compared to the public API definition (which has only BRLMPrintSettingsProtocol).
// The reasons I did this are:
// 1) I need the printerModel to pass into my objcCheckPrinterStatus method.
// 2) You cannot get this from BRLMPrintSettingsProtocol, you can only get it from BRLMPrintImageSettings
// 3) If I add BRLMPrintImageSettings to the PUBLIC API definition in the .h file, then Swift compiler complains BECAUSE
// a swift var can only have 1 TYPE AT A TIME. So, it cannot be both!
//
// UPDATE: Another way we could solve it would be to take BRLMPrinterModel as a parameter,
// which is easy to get from the Swift side, similar to how we pass it to the PRNPrintHandler methods.
// But, I'm leaving this as the solution described above for now as an example of how to get around this issue
// without adding another parameter.
//********************************************************************************************



// *********************************************************
// objcPrintPDFFilePathURL: print ALL pages of a single PDF file
// NOTE: This is the only API we are (currently) using in this app.
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintPDFFilePathURL:(NSURL *)pdfFilePathURL
                                       channel:(BRLMChannel *)channel
                                 printSettings:(id<BRLMPrintSettingsProtocol,BRLMPrintImageSettings>) printSettings
{
    NSLog(@"objcPrintPDFFilePathURL: URL = %@",pdfFilePathURL);
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintPDFFilePathURL"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:printSettings.printerModel];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    // Optional: validate the print settings.
    // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
    // if there's an issue with printSettings.
    //
    // You can use it to abort printing too if desired.
    // But I will let it fall through and append any string it returns to our return string.
    NSString *validateErrorString = [self validatePrintSettings:printSettings];
    
    // Print the PDF
    BRLMPrintError *printError = [printerDriver printPDFWithURL:pdfFilePathURL settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintPDFFilePathURL"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintPDFFilePathURL: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
}  // objcPrintCPDFFilePathURL

// *********************************************************
// objcPrintPDFFilePathURLArray: Print ALL pages of an ARRAY of PDF files
// TODO: Test this
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintPDFFilePathURLArray:(NSArray<NSURL *> *) pdfFilePathURLArray
                                            channel:(BRLMChannel *)channel
                                      printSettings:(id<BRLMPrintSettingsProtocol, BRLMPrintImageSettings>) printSettings
{
    
    NSLog(@"objcPrintPDFFilePathURLArray");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintPDFFilePathURLArray"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:printSettings.printerModel];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    // Optional: validate the print settings.
    // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
    // if there's an issue with printSettings.
    //
    // You can use it to abort printing too if desired.
    // But I will let it fall through and append any string it returns to our return string.
    NSString *validateErrorString = [self validatePrintSettings:printSettings];
    
    // Print the PDF file array
    BRLMPrintError *printError = [printerDriver printPDFWithURLs:pdfFilePathURLArray settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintPDFFilePathURLArray"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintPDFFilePathURLArray: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintPDFFilePathURLArray

// *********************************************************
// objcPrintPagesInPDFFilePathURL: Print only the specified pages of a single PDF file
// TODO: Test this
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintPagesInPDFFilePathURL:(NSURL *)pdfFilePathURL
                                            pageArray:(NSArray<NSNumber *> *)pageArray
                                              channel:(BRLMChannel *)channel
                                        printSettings:(id<BRLMPrintSettingsProtocol, BRLMPrintImageSettings>) printSettings
{
    NSLog(@"objcPrintPagesInPDFFilePathURL");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintPDFFilePathURLArray"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:printSettings.printerModel];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    // Optional: validate the print settings.
    // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
    // if there's an issue with printSettings.
    //
    // You can use it to abort printing too if desired.
    // But I will let it fall through and append any string it returns to our return string.
    NSString *validateErrorString = [self validatePrintSettings:printSettings];
    
    // Print the PDF only with specified pages
    BRLMPrintError *printError = [printerDriver printPDFWithURL:pdfFilePathURL pages: pageArray settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintPDFFilePathURLArray"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintPDFFilePathURLArray: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
} // objcPrintPagesInPDFFilePathURL

@end
