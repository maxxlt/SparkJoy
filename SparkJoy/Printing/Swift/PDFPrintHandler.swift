//
//  PDFPrintHandler.swift
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

// NOTE: This class demonstrates multiple ways to print a PDF based on the comnplete SDK functionality.
// This app is (currently) only using the method with a single URL that prints all pages without a page list.
// The other methods in this class are provided for your information.

class PDFPrintHandler:PrintHandler
{
    // *********************************************************
    // printPDFFilePathURL: print ALL pages of a single PDF file
    // NOTE: This is the only API we are (currently) using in this app.
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printPDFFilePathURL(pdfFilePathURL:URL, channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        print("printPDFFilePathURL: URL = \(pdfFilePathURL)")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printPDFFilePathURL")
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
        
        
        // Print the PDF
        let printError = printerDriver.printPDF(with: pdfFilePathURL, settings: printSettings)
        
        // check for errors
        if printError.code != .noError {
            
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printPDFFilePathURL")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n" + validateErrorString!
            }
        }
        else {
            print("printPDFFilePathURL: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
    } // printPDFFilePathURL
    
    // Below are 2 other APIs the SDK provides for printing PDF.
    
    // *********************************************************
    // printPDFFilePathURLArray: Print ALL pages of an ARRAY of PDF files
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printPDFFilePathURLArray(pdfFilePathURLArray:[URL], channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        print("printPDFFilePathURLArray")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printPDFFilePathURL")
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
        // You can use it to abort printing too if desired. But I will let it fall through and append any string it returns to our return string.
        let validateErrorString:String? = self.validatePrintSettings(printSettings:printSettings)
        
        
        // Print the PDF Array
        let printError = printerDriver.printPDF(with: pdfFilePathURLArray, settings: printSettings)
        
        // check for errors
        if printError.code != .noError {
            
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printPDFFilePathURLArray")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n"  + validateErrorString!
            }
        }
        else {
            print("printPDFFilePathURLArray: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
    } // printPDFFilePathURLArray
    
    
    // *********************************************************
    // printPagesInPDFFilePathURL: Print only the specified pages of a single PDF file
    // TODO: Test this
    //
    // RETURNS:
    // * nil if printing succeeded
    // * Error String in case of any errors, so it can be displayed by calling View in an Alert message.
    // *********************************************************
    func printPagesInPDFFilePathURL(pdfFilePathURL:URL, pageArray:[NSNumber], channel:BRLMChannel, printSettings:BRLMPrintSettingsProtocol) -> String?
    {
        print("printPagesInPDFFilePathURL")
        
        var errorString:String? = nil
        
        // Open the I/O channel. This generates the "BRLMPrinterDriver" which allows access to the printing APIs.
        let generateResult = BRLMPrinterDriverGenerator.open(channel)
        guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
            let printerDriver = generateResult.driver else {
                
                errorString = self.stringFromOpenChannelError(openChannelError: generateResult.error,
                                                              callingFunction: "printPDFFilePathURL")
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
        // You can use it to abort printing too if desired. But I will let it fall through and append any string it returns to our return string.
        let validateErrorString:String? = self.validatePrintSettings(printSettings:printSettings)
        
        
        // Print the PDF only with specified pages
        let printError = printerDriver.printPDF(with: pdfFilePathURL, pages: pageArray, settings:printSettings)
        
        // check for errors
        if printError.code != .noError {
            
            errorString = self.stringFromPrintError(printError: printError, callingFunction: "printPagesInPDFFilePathURL")
            print(errorString!)
            
            if validateErrorString != nil {
                // Concatenate the 2 strings, so both can be displayed by the same Alert
                errorString = errorString! + "\n\nValidate Report:\n"  + validateErrorString!
            }
        }
        else {
            print("printPagesInPDFFilePathURL: Success")
            
            // If SUCCESS, we still want to show an alert if there was an issue with validatePrintSettings.
            if validateErrorString != nil
            {
                errorString = validateErrorString
            }
        }
        
        // Close the channel
        printerDriver.closeChannel()
        
        return errorString
        
        
    } // printPagesInPDFFilePathURL
    
    
} //class PDFPrintHandler
