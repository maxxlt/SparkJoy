//
//  PRNPrintHandler.swift
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

// NOTE: This class has multiple ways to print a PRN based on SDK functionality.
// This app is (currently) only using the method with a single URL.
// The other methods in this class are provided for your information.

class PRNPrintHandler:PrintHandler
{
    // *********************************************************
    // This is the API we are using in this app.
    // Print a single file URL
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printPRNDataURL(prnFilePathURL:URL, channel:BRLMChannel, model:BRLMPrinterModel) -> String?
    {
        print("printPRNDataURL: URL = \(prnFilePathURL)")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printPRNDataURL")
                print(errorString!)
                
                return errorString
                
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: model)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Print the PRN
        let printError = printerDriver.sendPRNFile(with: prnFilePathURL)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printPRNDataURL")
            
            print(errorString!)
        }
        else {
            print("printPRNDataURL: Success")
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
    } // printPRNDataURL
    
    // Below are 2 other APIs the SDK provides for printing PRN data
    
    // *********************************************************
    // printPRNDataURLArray: Print an ARRAY of file URLs
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printPRNDataURLArray(prnURLArray:[URL], channel:BRLMChannel, model:BRLMPrinterModel) -> String?
    {
        print("printPRNDataURLArray")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printPRNDataURLArray")
                print(errorString!)
                
                return errorString
                
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: model)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Print the PRN
        let printError = printerDriver.sendPRNFile(with: prnURLArray)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printPRNDataURLArray")
            
            print(errorString!)
        }
        else {
            print("printPRNDataURLArray: Success")
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
        
    } // printPRNDataURLArray
    
    // *********************************************************
    // printRawData: Print Data that your app generates, not using a file.
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printRawData(prnData:Data, channel:BRLMChannel, model:BRLMPrinterModel) -> String?
    {        
        print("printRawData")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printRawData")
                print(errorString!)
                
                return errorString
                
        }
        
        // Store this in super-class to allow cancelPrinting
        self.printerDriver = printerDriver

        // Optional: check status before printing
        errorString = self.checkPrinterStatus(printerDriver: printerDriver, expectedModel: model)
        if errorString != nil
        {
            // cleanup and return error
            printerDriver.closeChannel()
            return errorString
        }
        
        // Print the PRN
        let printError = printerDriver.sendRawData(prnData)
        
        // check for errors
        if printError.code != .noError {
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printRawData")
            
            print(errorString!)
        }
        else {
            print("printRawData: Success")
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
        
    } // printRawData
    
    
} // class PRNPrintHandler


