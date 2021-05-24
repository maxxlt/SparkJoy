//
//  ObjCImagePrintHandlerObjC.m
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

#import "ObjCImagePrintHandler.h"

@implementation ObjCImagePrintHandler

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
// objcPrintImageURL: print an Image file
// NOTE: This is the only API we are (currently) using in this app.
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintImageURL:(NSURL *)imageFilePathURL
                                 channel:(BRLMChannel *)channel
                           printSettings:(id<BRLMPrintSettingsProtocol, BRLMPrintImageSettings>) printSettings
{
    NSLog(@"objcPrintImageURL: URL = %@",imageFilePathURL);
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintImageURL"];
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
    
    // Print the Image URL
    BRLMPrintError *printError = [printerDriver printImageWithURL:imageFilePathURL settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintImageURL"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintImageURL: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintImageURL

// *********************************************************
// objcPrintCGImage: print a CGImage
// TODO: Test this
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintCGImage:(CGImageRef)imageRef
                                channel:(BRLMChannel *)channel
                          printSettings:(id<BRLMPrintSettingsProtocol, BRLMPrintImageSettings>) printSettings
{
    NSLog(@"objcPrintCGImage");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintCGImage"];
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
    
    // Print the CGImage
    BRLMPrintError *printError = [printerDriver printImageWithImage:imageRef settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintCGImage"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintCGImage: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintCGImage


// *********************************************************
// objcPrintImageURLArray: print an ARRAY of Image Files
// TODO: Test this
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintImageURLArray:(NSArray<NSURL *> *) imageFilePathURLArray
                                      channel:(BRLMChannel *)channel
                                printSettings:(id<BRLMPrintSettingsProtocol, BRLMPrintImageSettings>) printSettings
{
    NSLog(@"objcPrintImageURLArray");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintImageURLArray"];
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
    
    // Print the Image URL Array
    BRLMPrintError *printError = [printerDriver printImageWithURLs:imageFilePathURLArray settings:printSettings];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintImageURLArray"];
        NSLog(@"%@", errorMsg);
        
        if (validateErrorString != nil)
        {
            // Concatenate the 2 strings, so both can be displayed by the same Alert
            errorMsg = [NSString stringWithFormat:@"%@\n\nValidate Report:\n%@", errorMsg, validateErrorString];
        }
    }
    else {
        NSLog(@"objcPrintImageURLArray: Success");
        
        // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
        if (validateErrorString != nil)
        {
            errorMsg = validateErrorString;
        }
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintImageURLArray


@end
