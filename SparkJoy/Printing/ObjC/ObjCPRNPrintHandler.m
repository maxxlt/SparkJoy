//
//  PRNPrintHandlerObjC.m
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

#import "ObjCPRNPrintHandler.h"

@implementation ObjCPRNPrintHandler:ObjCPrintHandler

// *********************************************************
// objcPrintPRNDataURL - Print a single file URL
// This is the API we are using in this app.
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintPRNDataURL:(NSURL *)prnFilePathURL
                                   channel:(BRLMChannel *)channel
                                     model:(BRLMPrinterModel) model
{
    NSLog(@"objcPrintPRNDataURL: URL = %@",prnFilePathURL);
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintPRNDataURL"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:model];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    
    // Print the PRN URL
    BRLMPrintError *printError = [printerDriver sendPRNFileWithURL:prnFilePathURL];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintPRNDataURL"];
        NSLog(@"%@", errorMsg);
    }
    else {
        NSLog(@"objcPrintPRNDataURL: Success");
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintPRNDataURL


// *********************************************************
// objcPrintPRNDataURLArray: Print an ARRAY of file URLs
// TODO: Test this
//
// RETURNS:
// * nil if printing succeeded
// * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
// *********************************************************
-(nullable NSString *) objcPrintPRNDataURLArray:(NSArray<NSURL *> *)prnURLArray
                                        channel:(BRLMChannel *)channel
                                          model:(BRLMPrinterModel) model
{
    NSLog(@"objcPrintPRNDataURLArray");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintPRNDataURLArray"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:model];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    
    // Print the PRN URL Array
    BRLMPrintError *printError = [printerDriver sendPRNFileWithURLs:prnURLArray];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintPRNDataURLArray"];
        NSLog(@"%@", errorMsg);
    }
    else {
        NSLog(@"objcPrintPRNDataURLArray: Success");
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintPRNDataURLArray


// Print Data that your app generates, not using a file.
-(nullable NSString *) objcPrintRawData:(NSData *)prnData
                                channel:(BRLMChannel *)channel
                                  model:(BRLMPrinterModel) model
{
    NSLog(@"objcPrintRawData");
    
    NSString *errorMsg = nil;
    
    // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
    BRLMPrinterDriverGenerateResult *driverGenerateResult = [BRLMPrinterDriverGenerator openChannel:channel];
    if (driverGenerateResult.error.code != BRLMOpenChannelErrorCodeNoError ||
        driverGenerateResult.driver == nil) {
        
        errorMsg = [self stringFromOpenChannelError:driverGenerateResult.error
                                    callingFunction:@"objcPrintRawData"];
        NSLog(@"%@", errorMsg);
        
        return errorMsg;
    }
    
    BRLMPrinterDriver *printerDriver = driverGenerateResult.driver;
    
    // Optional: check status before printing
    errorMsg = [self objcCheckPrinterStatus:printerDriver expectedModel:model];
    if (errorMsg != nil)
    {
        // cleanup and return error
        [printerDriver closeChannel];
        
        // NOTE: error message already logged to console
        
        return errorMsg;
    }
    
    
    // Print the Raw Data
    BRLMPrintError *printError = [printerDriver sendRawData:prnData];
    
    // check for errors
    if (printError.code != BRLMPrintErrorCodeNoError) {
        
        errorMsg = [self stringFromPrintError:printError callingFunction:@"objcPrintRawData"];
        NSLog(@"%@", errorMsg);
    }
    else {
        NSLog(@"objcPrintRawData: Success");
    }
    
    // Close the channel
    [printerDriver closeChannel];
    
    return errorMsg;
    
} // objcPrintRawData

@end
