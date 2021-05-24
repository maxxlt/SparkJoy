//
//  FilesToPrint.swift
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

class FilesToPrint
{
    //*** Variables
    
    // NOTE: Use URL instead of PATH (String) because print APIs require URL.
    //
    // NOTE: Another reason to use URL...
    // If app allows FilePicker (UIDocumentPickerViewController) (as the "advanced" sample does),
    // we MUST call url.startAccessingSecurityScopedResource() and url.stopAccessingSecurityScopedResource(),
    // which seemingly requires us to PERSIST the *SAME* "URL object",
    // i.e. startAccessingSecurityScopedResource() does NOT work if we convert
    // URL -> FilePath (String) -> URL, even if the resulting URL is exactly the same.
    // So, by using URL here, we avoid this conversion between URL to String to URL,
    // and we can store the URL object received from File Picker directly into these vars, which then
    // allows startAccessingSecurityScopedResource to work correctly.
    

    var pdfFilePathURL:URL = URL(fileURLWithPath: "")
    var imageFilePathURL:URL = URL(fileURLWithPath: "")
    var imageToDisplay:UIImage? = nil
    var prnFilePathURL:URL = URL(fileURLWithPath: "")
    
    //*** Constants
    // These all match files that we have built-in to our App Bundle.
    let PDF_FILEEXT = "pdf"
    let PRN_FILEEXT = "prn"
    let IMAGE_FILEEXT = "jpg"

    let PDF_FILENAME_PJ673 = "Workorder-PJ673"
    let IMAGE_FILENAME_PJ673 = "Citation-PJ673"
    //let PRN_FILENAME_PJ673 = "Bigwater-PJ673" // Raster-mode PRN, ~338 KB. Takes ~90 sec to begin print with BIL SDK, so not the best example.
    let PRN_FILENAME_PJ673 = "AsciiChart-ESCP-AddESC~FF" // Try an ESC/P job instead. This works!

    let PDF_FILENAME_RJ4040 = "DriverInfoExchange-RJ4040"
    let IMAGE_FILENAME_RJ4040 = "GeneralRetailOutlets-RJ4040"
    let PRN_FILENAME_RJ4040 = "RJ4-BPL-FW120FONT105"
    
    let PDF_FILENAME_TD2120N = "TD2 2x3 3-page"
    let IMAGE_FILENAME_TD2120N = "TD2 2x3 Markdown"
    let PRN_FILENAME_TD2120N = "TD2-BPL"
    
    let PDF_FILENAME_TD2130N = "TD2 2x3 3-page"
    let IMAGE_FILENAME_TD2130N = "TD2 2x3 Apparel"
    let PRN_FILENAME_TD2130N = "TD2130N-escp"
    
    let PDF_FILENAME_RJ3050 = "BMS Retail Outlets-RJ3"
    let IMAGE_FILENAME_RJ3050 = "ABC Retailers-RJ3050"
    let PRN_FILENAME_RJ3050 = "RJ3-BPL"
    
    let PDF_FILENAME_RJ3150 = "BMS Retail Outlets-RJ3"
    let IMAGE_FILENAME_RJ3150 = "Retail-3x1 Juice-RJ3150"
    let PRN_FILENAME_RJ3150 = "RJ3-escp"
    
    let PDF_FILENAME_QL = "Hazardous Waste-4x6"
    let IMAGE_FILENAME_QL = "Insurance"
    let PRN_FILENAME_QL = "RJ3-escp" // best with a continuous roll
    let PRN_FILENAME_QL820 = "HelloWorld-escp" // simple to print on just a single label

    //*** Functions
    
    //****************************************************************
    // setDefaultFilesForModel
    //
    // Given a specific printer model, update our built-in default PDF, Image, and PRN files to print.
    // The goal is to print an appropriate file for each model, without requiring user to choose a file each time.
    // This allows the app to be used easily as a demo.
    //
    // NOTE: The "advanced" version this sample app allows user to select and print a different file.
    // But, this selection will only last until this method is called again
    // (i.e. when a new model is selected, we revert back to the default built-in files).
    //****************************************************************
    func setDefaultFilesForModel(model: SupportedModels) -> Void
    {
        var pdfBundleFileName = ""
        var imageBundleFileName = ""
        var prnBundleFileName = ""
       
        switch (model) {
        case .PJ_673,
             .PJ_763MFi,
             .PJ_773:
            
            pdfBundleFileName = PDF_FILENAME_PJ673;
            imageBundleFileName = IMAGE_FILENAME_PJ673;
            prnBundleFileName = PRN_FILENAME_PJ673;
            
        
        case .RJ_4030Ai,
             .RJ_4040,
             .RJ_4230B,
             .RJ_4250WB:
            
            pdfBundleFileName = PDF_FILENAME_RJ4040;
            imageBundleFileName = IMAGE_FILENAME_RJ4040;
            prnBundleFileName = PRN_FILENAME_RJ4040;
 
        case .RJ_3050,
             .RJ_3050Ai:
            
            pdfBundleFileName = PDF_FILENAME_RJ3050;
            imageBundleFileName = IMAGE_FILENAME_RJ3050;
            prnBundleFileName = PRN_FILENAME_RJ3050;
            
            
        case .RJ_3150,
             .RJ_3150Ai:
           
            pdfBundleFileName = PDF_FILENAME_RJ3150;
            imageBundleFileName = IMAGE_FILENAME_RJ3150;
            prnBundleFileName = PRN_FILENAME_RJ3150;
 
        case .TD_2120N:
            pdfBundleFileName = PDF_FILENAME_TD2120N;
            imageBundleFileName = IMAGE_FILENAME_TD2120N;
            prnBundleFileName = PRN_FILENAME_TD2120N;
            
        case .TD_2130N:
            pdfBundleFileName = PDF_FILENAME_TD2130N;
            imageBundleFileName = IMAGE_FILENAME_TD2130N;
            prnBundleFileName = PRN_FILENAME_TD2130N;

        case .RJ_2140,
             .RJ_2050,
             .RJ_2150:
            // TODO: new default sample print files for RJ2. For now, use some we already have built-in for other models.
            pdfBundleFileName = PDF_FILENAME_RJ3050; // 1-page
            if (model == .RJ_2050) {
                // NOTE: 2050 does not support die-cut labels, though it does support marked labels.
                // Since it's primarily a receipt printer, set the image file to a receipt instead of a label.
                imageBundleFileName = IMAGE_FILENAME_RJ3050; // receipt, 3" wide so it will be down-scaled causing loss of quality.
            }
            else {
                imageBundleFileName = IMAGE_FILENAME_TD2120N; // label
            }
            prnBundleFileName = PRN_FILENAME_TD2120N; // 2" ZPL
            
            case .TD_4100N,
                 .TD_4550DNWB:
                // TODO: new default files. For now use same as RJ-4
                pdfBundleFileName = PDF_FILENAME_RJ4040;
                imageBundleFileName = IMAGE_FILENAME_RJ4040;
                if model == .TD_4100N {
                    prnBundleFileName = PRN_FILENAME_TD2130N; //esc/p
                }
                else {
                    prnBundleFileName = PRN_FILENAME_RJ4040; // zpl
                }
                
            case .MW_260MFi,
                 .MW_145MFi:
                // Use same as PJ. These actually work OK on both MFi models!
                pdfBundleFileName = PDF_FILENAME_PJ673;
                imageBundleFileName = IMAGE_FILENAME_PJ673;
                prnBundleFileName = PRN_FILENAME_PJ673; // assure this is the ASCII chart, not Bigwater (which uses PJ raster)

            case .QL_720NW,
                 .QL_820NWB,
                 .QL_1110NWB:
                // TODO: new default files. For now use same as TD-2130N since 2" and 300 dpi
                // NOTE: max print width (of 720/820) is 2.3". resolution = 300 dpi
                // QL-1110 is ~4" wide
                pdfBundleFileName = PDF_FILENAME_QL
                imageBundleFileName = IMAGE_FILENAME_QL;
                // Use an ESC/P file for PRN on QL.
                if model == .QL_820NWB {
                    prnBundleFileName = PRN_FILENAME_QL820
                }
                else {
                    prnBundleFileName = PRN_FILENAME_QL;
                }
            case .PT_E550W:
                // TODO: new default files.
                pdfBundleFileName = PDF_FILENAME_RJ3050 // this is only 1-page PDF file
                imageBundleFileName = IMAGE_FILENAME_TD2120N;
                // NOTE: PT-E550W does not appear to support ESC/P or ZPL. I don't know about other PT models.
                // It should be possible to generate a RASTER mode or TEMPLATE mode PRN that will work. TODO.
                // For now, let's just report an error with PT when PRN button is pressed.
                prnBundleFileName = "HelloWorld-escp";       // ESC/P
            
        } //switch
        
        //*** Set our class vars to the new URLs for each file built-in to our App Bundle.
        self.pdfFilePathURL = Bundle.main.url(forResource: pdfBundleFileName, withExtension: PDF_FILEEXT) ?? URL(fileURLWithPath: "")
        self.imageFilePathURL = Bundle.main.url(forResource: imageBundleFileName, withExtension: IMAGE_FILEEXT) ?? URL(fileURLWithPath: "")
        self.prnFilePathURL = Bundle.main.url(forResource: prnBundleFileName, withExtension: PRN_FILEEXT) ?? URL(fileURLWithPath: "")

        // Convert imageFile to UIImage for display in our main GUI
        self.imageToDisplay = UIImage(contentsOfFile: self.imageFilePathURL.path)
 
    } // setDefaultFilesForModel
    
}

