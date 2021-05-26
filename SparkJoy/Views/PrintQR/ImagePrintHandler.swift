//
//  ImagePrintHandler.swift
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

// NOTE: This class has multiple ways to print an Image based on SDK functionality.
// We are (currently) only using the method with a single Image URL.
// The other methods in this class are provided for your information.

class ImagePrintHandler:PrintHandler
{
    // *********************************************************
    // printImageURL: print an Image file
    // NOTE: This is the only API we are (currently) using in this app.
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printImageURL(imageFilePathURL:URL, channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol)  -> String?
    {
        print("printImageURL: URL = \(imageFilePathURL)")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printImageURL")
                print(errorString!)
                
                return errorString
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        let imageSettings = printSettings as! BRLMPrintImageSettings
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: imageSettings.printerModel)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Optional: validate the print settings.
        // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
        // if there's an issue with printSettings.
        //
        // You can use it to abort printing too if desired.
        // But I will let it fall through and append any string it returns to our return string.
        let validateErrorString:String? = self.validatePrintSettings(printSettings:printSettings)
        
        // Print the Image
        let printError = printerDriver.printImage(with: imageFilePathURL, settings: printSettings)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printImageURL")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n"  + validateErrorString!
            }
        }
        else {
            print("printImageURL: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
    } // printImageURL
    
    // Below are 2 other APIs the SDK provides for printing images.
    
    // *********************************************************
    // printCGImage: print a CGImage
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printCGImage(cgimage:CGImage, channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        print("printCGImage")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printCGImage")
                print(errorString!)
                
                return errorString
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        let imageSettings = printSettings as! BRLMPrintImageSettings
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: imageSettings.printerModel)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Optional: validate the print settings.
        // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
        // if there's an issue with printSettings.
        //
        // You can use it to abort printing too if desired.
        // But I will let it fall through and append any string it returns to our return string.
        let validateErrorString:String? = self.validatePrintSettings(printSettings:printSettings)
        
        // Print the Image
        let printError = printerDriver.printImage(with: cgimage, settings: printSettings)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printCGImage")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n"  + validateErrorString!
            }
        }
        else {
            print("printCGImage: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
        
    } // printCGImage
    
    
    // *********************************************************
    // printImageURLArray: print an ARRAY of Image Files
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printImageURLArray(imageURLArray:[URL], channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        print("printImageURLArray")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printImageURLArray")
                print(errorString!)
                
                return errorString
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        let imageSettings = printSettings as! BRLMPrintImageSettings
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: imageSettings.printerModel)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Optional: validate the print settings.
        // This can be used primarily for DEBUG, to get more information about the cause of an error at print-time,
        // if there's an issue with printSettings.
        //
        // You can use it to abort printing too if desired.
        // But I will let it fall through and append any string it returns to our return string.
        let validateErrorString:String? = self.validatePrintSettings(printSettings:printSettings)
        
        // Print the Image Array
        let printError = printerDriver.printImage(with: imageURLArray, settings: printSettings)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printImageURLArray")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n"  + validateErrorString!
            }
        }
        else {
            print("printImageURLArray: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
        
    } // printImageURLArray
    
}
