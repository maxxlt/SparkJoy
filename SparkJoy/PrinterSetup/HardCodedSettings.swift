//
//  HardCodedSettings.swift
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

struct HardCodedSettings
{
    //********************************************************************************************
    // The PURPOSE of this is to demonstrate how to allocate and customize the default printSettings object for EACH model.
    //
    // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the default value.
    // We will set ALL settings and change some settings to non-default values for demonstration only.
    //
    // NOTE: returns optional. Caller must verify non-nil
    //
    // NOTE: All models in same PRINTER FAMILY share the same settings class. Different "families" use a different classes.
    // Each class can be initialized based on a specific model, in case SDK has different defaults for each.
    //
    // NOTE: Each class will have both BRLMPrintImageSettings class properties (by virtue of conforming to the protocol)
    // as well as its own properties that are specific to the model family.
    //
    // NOTE: In some cases, not all models in the same "family" will support all available options.
    // In these cases, the property value will be ignored.
    //********************************************************************************************
    // NOTE: Can't make this a static method unless all private instance methods are also static.
    func hardCodedSettingsForModel(model:SupportedModels) -> BRLMPrintSettingsProtocol?
    {
        switch model
        {
            case .PJ_673,
                 .PJ_763MFi,
                 .PJ_773:
                return self.hardSettingsForPJ(model:model.sdkModel)
            
            case .RJ_2050,
                 .RJ_2140,
                 .RJ_2150,
                 .RJ_3050,
                 .RJ_3050Ai,
                 .RJ_3150,
                 .RJ_3150Ai,
                 .RJ_4040,
                 .RJ_4030Ai,
                 .RJ_4230B,
                 .RJ_4250WB:
                return self.hardSettingsForRJ(model:model.sdkModel)
                        
            case .TD_2120N,
                 .TD_2130N,
                 .TD_4100N,
                 .TD_4550DNWB:
                return self.hardSettingsForTD(model:model.sdkModel)
                        
            case .MW_260MFi,
                 .MW_145MFi:
                return self.hardSettingsForMW(model:model.sdkModel)
            
            case .QL_720NW,
                 .QL_820NWB,
                 .QL_1110NWB:
                return self.hardSettingsForQL(model:model.sdkModel)
                
            case .PT_E550W:
                return self.hardSettingsForPT(model: model.sdkModel)
        }
    } // hardCodedSettingsForModel
    
    // This method sets COMMON settings that are available in EACH BRLMXXPrintSettings class
    // NOTE: Most (maybe not all) of these should match the defaults provided by the SDK.
    // But, we will demononstrate setting all available settings anyway.
    private func hardSettingsForImageSettings(imageSettings:inout BRLMPrintImageSettings)
    {
        // scaleMode
        // * 'original' will be same size in pixels as the original image. No scaling occurs.
        //   -> if image exceeds the size of the paper, an error will occur (instead of clip)
        // * 'scaleValue' can increase or decrease size based on separate scaleValue setting.
        // * 'fitPageAspect' will fit image to the PrintableArea (paperSize - margins), preserving aspect ratio of your image
        // * 'fitPaperAspect' will fit image to the Paper, ignoring the unprintable margins of the paper.
        //   -> It will clip image at unprintable margins, removing data if image is non-white at the edges.
        //   -> I believe it's useful to trim margins from a PDF file.
        //
        // NOTE: v3,v4 SDK does NOT (currently) provide a "stretchToFit" option like BMS SDK does.
        // I'm mentioning this for anyone switching from the BMS SDK to v4.
        // This option (when available) will distort the "aspect ratio". It allows using the entire printable area of the paper.
        // In many cases it can be the best option if not too much stretching occurs.
        // Hopefully v4 SDK will add a stretchToFit option in the future.
        imageSettings.scaleMode = .fitPageAspect
        
        imageSettings.scaleValue = 1.0 // N/A unless scaleMode = .scaleValue
        imageSettings.printOrientation = .portrait //.landscape
 
        // halftone
        // NOTE: SDK default seems to be threshold, which is NOT good for use with Graphics.
        // * errorDiffusion is the best all-purpose choice for text or graphics.
        // * threshold produces a binary result which is bad for images but good for BLACK text
        //   -> With this option, the "halftoneThreshold" setting also applies. See below.
        // * patternDither may be OK for images, compare with diffusion to determine preference.
        imageSettings.halftone = .errorDiffusion
        
        // halftoneThreshold - N/A unless halftone = .threshold
        // -> For any pixel byte value (0-255), this property determines whether that pixel will be black or white.
        // -> Set in range of 1-254.
        // For Black/White only images, recommend setting a value in the middle (128 is good)
        // For Color images, especially colored text, it may be necessary to increase this value so the color will print as black.
        imageSettings.halftoneThreshold = 128

        // Horizontal/Vertical alignment of the image on the page, when (scaled/fit) image is smaller than the PrintableArea or Paper.
        imageSettings.hAlignment = .left //.center, .right
        imageSettings.vAlignment = .top //.center, .bottom
        
        // compression method - used to reduce the amount of data to send over the I/O channel
        // * mode9 is a proprietary format which produces good compression especially with images
        // * none will produce larger data stream. Other compress options are probably better.
        // * tiff is a standard compression that usually reduces data size unless data is non-repeating
        imageSettings.compress = .mode9
        
        // # Copies
        imageSettings.numCopies = 1
        
        // skipStatusCheck - by default, SDK does a status check before starting to print.
        // Set this to true to bypass this status check, which may be useful in some cases.
        // NOTE: This may be N/A with PJ-673?
        imageSettings.skipStatusCheck = false    // true
        
        // printQuality
        // NOTE: Only some QL/TD models support this. c.f. SupportedModels.supportsPrintQualityCommand for more details.
        // For other models, this setting is N/A.
        // TODO: SDK should REMOVE this from the common settings and add it only to the XXPrintSettings classes that support it.
        imageSettings.printQuality = .best // .fast
    }

    private func hardSettingsForPJ(model:BRLMPrinterModel) -> BRLMPJPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.
        
        // get default settings object from SDK for the specified model.
        guard let settings = BRLMPJPrintSettings(defaultPrintSettingsWith: model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForPJ ERROR: settings = nil")
            return nil
        }
        
        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)
        

        //**************************************************************************************
        //*** PJ Settings
        //**************************************************************************************

        // paperSize:
#if USE_CUSTOM_SIZE
        // Create paperSize using the "customPaper" option
        // NOTE: Init 4x6 in dots using printer resolution = 300 dpi. e.g 4.0" = 4*300 = 1200 dots
        // NOTE: "feedDots" seems to behave as follows when nofeed mode is specified:
        // * If Image/pdf length + feedDots <  customPaperLength, nofeed works and feedDots is applied as “extrafeed” behavior.
        // * If Image/pdf length + feedDots >  customPaperLength, paper feeds only to customPaperLength
        // NOTE: The intended purpose of feedDots is to eject the paper from printer when nofeed is specified so that you don't tear off
        // data that may still be inside the printer, and to add some "bottom margin" after tear-off.
        // SDK TODO: feedDots SHOULD be moved from PJCustomPaper class into PJPrintSettings class,
        // because it should be available for standard paper sizes too when nofeed is specified!!
        settings.paperSize = BRLMPJPrintSettingsPaperSize(customPaper: BRLMPJPrintSettingsCustomPaperSize(widthDots: 1200, lengthDots: 1800, feedDots: 200 /*5000*//*2550*/))
        
#else // USE_STANDARD_SIZE
        // Create paperSize using the "paperSizeStandard" option
        // paperSize options include:
        //  .letter, .legal, .A4, .A5, .custom
        // NOTE: .custom is "read only", and will be set by SDK in paperSizeStandard if the "customPaper" option was used as above.
        settings.paperSize = BRLMPJPrintSettingsPaperSize(paperSizeStandard: .letter)
        
#endif
        // paperType:
        // * .cutSheet is used with sheet paper
        // * .roll is used with either ContinuousRoll or Perforated (Marked) Roll
        // NOTE: In each case, set the appropriate "feedMode" as described below.
        settings.paperType = .cutSheet

        // feedMode:
        // * .noFeed is best with ContinuousRoll, used to save paper.
        // * .fixedPage is best with cutSheet paper, but can be used with ContinuousRoll paper to produce a "fixed" length
        // * .endOfPage is generally NOT recommended, but can be used with PerforatedRoll (reducing Printable Area)
        //      or in cases where you may need to support different paper sizes (e.g. letter+A4) with same setting
        // * .endOfPageRetract is best option with PerforatedRoll paper.
        //   -> It causes paper to retract at beginning of each page in order to produce the same PrintableArea as Cutsheet paper
        //
        // SDK TODO: Details about these options should be added to the User Guide.
        // SDK TODO: SDK has a bug related to PrintableArea (P/A) difference between endOfPage and endOfPageRetract.
        //           The statements above are correct as concerns the physical P/A of the printer in response to the feedMode.
        //           However, SDK internally seems to have reversed the two, which can affect scaleMode "fit" options.
        //           The bug is not always obvious. But, if you encounter it, please contact us and hopefully we can get this fixed.
        settings.feedMode = .fixedPage
        
        // paperInsertionPosition:
        // * .left: allows inserting paper at left edge when paperWidth < letter/legal width.
        // * .center: requires inserting paper center-justified when paperWidth < letter/legal width, which may be challenging
        //      without a paper guide.
        settings.paperInsertionPosition = .left
        
        // density:
        //  -> controls the printhead heat time, which makes prints darker or lighter.
        //  -> darker density will take longer to print the page
        // * .weakLevel5 is lightest
        // * .neutral is mid-level (maybe the default?)
        // * .strongLevel5 is darkest
        // * .usePrinterSetting means the density setting will NOT be sent with the job, using the setting that has been
        //      configured on the printer using (for example) our Windows Printer Setting Tool.
        settings.density = .strongLevel5
        
        // rollCase:
        // * .none = no roll case installed.
        // * .PARC001_NoAntiCurl
        // * .PARC001
        settings.rollCase = .none
        
        // printSpeed:
        // options include 2.5, 1.9, 1.6, 1.1 inches per second
        // 2.5 works fine in most cases, but slow it down if necessary
        settings.printSpeed = .speed2_5inchPerSec
        
        settings.usingCarbonCopyPaper = false   // only use with 2-ply (carbon copy) paper. Affect is similar to density.
        settings.printDashLine = false          // prints a line between pages when using continuousRoll paper
        
        return settings
        
    } // hardSettingsForPJ
    
    // paperBinFilenameForRJTDModel
    //  -> Returns the name of the BIN file to use for each RJ/TD model.
    //
    // NOTE: RJ/TD series models can specify paper using either a paper BIN file or "by Parameter" via PrustomPaperSize.
    // * Currently (SDK 4.0.2), only 4" wide models are supported by the CustomPaperSize option.
    // * Paper BIN file method is supported by ALL RJ/TD models
    // * BIN files should be generated using the Windows Printer Driver for the SPECIFIC model you are using.
    // * BIN files can support some features that are NOT currently available in the SDK when using CustomPaperSize option.
    //      For example, "energyRank", "sensor sensitivity", and other "advanced" settings available in the Windows driver
    //      can ONLY be supported by the BIN file. And, the SDK will overwrite these options if they have been configured externally.
    //
    // The BIN files below are provided by the SDK, and they are each configured for use with ContinuousRoll paper only.
    // For labels, you will need to create your own BIN files (contact us for assistance).
    //
    // SDK TODO: Support CustomPaperSize by parameter option for ALL RJ/TD models, and add capability for the "advanced" features
    // that are available in the paper BIN file, so as not to "overwrite".
    private func paperBinFilenameForRJTDModel(model:BRLMPrinterModel) -> String?
    {
        // Returning the ContinuousRoll type for ALL models.
        // If you need a different papertype, use a different filename.
        // Be sure that these BIN files are added to the app bundle.
        switch model
        {
            case .RJ_2050:
                return ("rj2050_58mm.bin")
            case .RJ_2140:
                return ("rj2140_58mm.bin")
            case .RJ_2150:
                return ("rj2150_58mm.bin")
            
            case .RJ_3050:
                return ("rj3050_76mm.bin")
            case .rj_3050Ai:
                return ("rj3050ai_76mm.bin")
            case .RJ_3150:
                return ("rj3150_76mm.bin")
            case .rj_3150Ai:
                return ("rj3150ai_76mm.bin")
            
            case .RJ_4040:
                // note: this model supports CustomSize option. Bin file not required.
                return ("rj4040_102mm.bin")
            case .rj_4030Ai:
                // note: this model supports CustomSize option. Bin file not required.
                return ("rj4030ai_102mm.bin")
            case .RJ_4230B:
                // note: this model supports CustomSize option. Bin file not required.
                return ("rj4230b_102mm.bin")
            case .RJ_4250WB:
                // note: this model supports CustomSize option. Bin file not required.
                return ("rj4250wb_102mm.bin")
            
            case .TD_2120N:
                return ("td2120_57mm.bin")
            case .TD_2130N:
                return ("td2130_57mm.bin")
            case .TD_4550DNWB:
                // note: this model supports CustomSize option. Bin file not required.
                return ("td4550dnwb_102mm.bin")
            case .TD_4100N:
                return ("td4100n_102mm.bin")
            default:
                print("paperBinFilenameForRJTDModel ERROR: Unknown printer model")
                return nil
        }
    } // paperBinFilenameForRJTDModel
    
    
    private func hardSettingsForRJ(model:BRLMPrinterModel) -> BRLMRJPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.

        // get default settings object from SDK for the specified model.
        guard let settings = BRLMRJPrintSettings(defaultPrintSettingsWith:model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForRJ ERROR: settings = nil")
            return nil
        }

        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)

        //**************************************************************************************
        // RJ Settings
        //**************************************************************************************
        
        //*** customPaperSize:
        //
        // IMPORTANT: customPaperSize can be specified either with a paper BIN file or by Parameter.
        // In either case, the paper specified MUST match the actual paper size/type being used.
        // * 3 different paper types (ContinuousRoll, Die-cut Label, Marked Label).
        // * NOTE: RJ-2050 and RJ-3050[Ai] models do NOT support die-cut label!! They only support continuousRoll or MarkedLabel.
        //      The other RJ-21xx and RJ-31xx models support all 3
        // * Not all RJ/TD models are currently supported in SDK with the "by Parameter" option.
        // * ALL models support using a paper.bin file. So, this method is always a valid option!
        // * c.f. comments in "paperBinFilenameForRJTDModel()" for additional information.
        //
        //
        // Use the proper "init" method in BRLMCustomPaperSize class to specify using bin file or custom paper by Parameter,
        // based on the size+type of paper used. See User Guide for more info.
        //
        // Let's use the parameterized version here for the models that support it, for demonstration.

        
        // NOTE: I have created "var supportsCustomPaperSizeCommand" in the SupportedModels enum to indicate which models
        // are (currently) supported or not by SDK for use with the "by Parameter" option.
        //
        // Need to convert SDKs BRLMPrinterModel (in param) to our SupportedModels enum so we can run this check.
        let supportedModel = SupportedModels.supportedModelFromBRLMPrinterModel(model: model)
 
        // If the "by parameter" option is supported in the SDK...
        if supportedModel!.supportsCustomPaperSizeCommand
        {
            // Create the custom paper definition using parameters. Valid only with SOME models, per SDK capability.
            
            // This method allows defining the paper dimensions and margins using a set of properties (parameters to init).
            // To support "any" size, you can create a GUI to allow user to modify these values.
            // Or, just create the ones you want to support using this or a similar init method that matches your actual paper.
            // There are 3 different init methods available, based on paper type.
            
            
            // NOTE: For paperWidth, let's set an appropriate value for the specific model.
            // For this I will use a variable in my custom SupportedModels enum, just for fun.
            // Using "headSizeDots" instead of "maxPaperWidthDots", since SDK currently has a problem with the latter,
            // even with non-zero margins.
            //
            // WARNING: Normally, you would set this to the actual width of the paper you are using.
            // e.g. let paperWidthInches = 4.0
            // If the "headSizeDots" is wider than your paper, it's likely that the printed data will extend beyond
            // the edge of the paper (which would be BAD).
            //
            // NOTE: Must convert dots to inches as well, since SDK currently doesn't include dots as a valid unit.
            // inches = dots / (dots/inch)
            let paperWidthInches = Float(supportedModel!.headSizeDots) / Float(supportedModel!.horzResolution)
            
            // NOTE: roll, diecut, markroll have different sets of parameters that are valid, as indicated by the
            // designated init method for each type.
            //
            // This demonstrates how to use ContinuousRoll paper with custom settings, in units of inches.
            // All parameters should be entered based on the specified unitOfLength parameter.
            //
            // NOTE: The margins specified here are typical defaults with most paper sizes.
            
            settings.customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: CGFloat(paperWidthInches), // e.g. 2.0,
                margins: BRLMCustomPaperSizeMargins(top: 0.12, left: 0.06, bottom: 0.12, right: 0.06),
                unitOfLength: BRLMCustomPaperSizeLengthUnit.inch)

        }
        else
        {
            // Use Paper.bin file approach. Valid with ALL models.
            
            // IMPORTANT: EACH PRINTER MODEL and EACH PAPER ** MUST ** have a DIFFERENT BIN FILE.
            // Paper BIN files are created with the Windows Driver. They can support any paper type.
            // SDK may provide most common BIN files.
            // Normally, you will include the BIN file as a resource in your app and reference it as follows below.
            // For this sample, we will specify paper.bin for ContinuousRoll.
            //
            // EXTRA NOTE: To allow dynamic paper size with BIN file, you can allow user to add files to your app and select from a list.
            guard let pathToPaperBinFile:String = Bundle.main.path(forResource: self.paperBinFilenameForRJTDModel(model: model), ofType: nil)
                else {
                    print("hardSettingsForRJ ERROR: invalid paper bin file")
                    return nil
            }
            
            let urlPathToPaperBinFile = URL(fileURLWithPath: pathToPaperBinFile)
            settings.customPaperSize = BRLMCustomPaperSize(file: urlPathToPaperBinFile)

        }
        
        settings.density = BRLMRJPrintSettingsDensity.strongLevel2
        settings.rotate180degrees = false //true // default is false
        settings.peelLabel = false // N/A unless your printer has a peeler and using die-cut labels.
        
        return settings
        
    } // hardSettingsForRJ
    
    
    private func hardSettingsForTD(model:BRLMPrinterModel) -> BRLMTDPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.

        // get default settings object from SDK for the specified model.
        guard let settings = BRLMTDPrintSettings(defaultPrintSettingsWith: model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForTD ERROR: settings = nil")
            return nil
        }

        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)

        //**************************************************************************************
        // TD Settings
        //**************************************************************************************
        //*** customPaperSize:
        //
        // IMPORTANT: customPaperSize can be specified either with a paper BIN file or by Parameter.
        // In either case, the paper specified MUST match the actual paper size/type being used.
        // * 3 different paper types (ContinuousRoll, Die-cut Label, Marked Label).
        // * Not all RJ/TD models are currently supported in SDK with the "by Parameter" option.
        //      * TD4 models support it
        //      * TD2 models do not
        // * ALL models support using a paper.bin file. So, this method is always a valid option!
        // * c.f. comments in "paperBinFilenameForRJTDModel()" for additional information.
        //
        //
        // Use the proper "init" method in BRLMCustomPaperSize class to specify using bin file or custom paper by Parameter,
        // based on the size+type of paper used. See User Guide for more info.
        //
        // Let's use the parameterized version here for the models that support it, for demonstration.
        
        
        // NOTE: I have created "var supportsCustomPaperSizeCommand" in the SupportedModels enum to indicate which models
        // are (currently) supported or not by SDK for use with the "by Parameter" option.
        //
        // Need to convert SDKs BRLMPrinterModel (in param) to our SupportedModels enum so we can run this check.
        let supportedModel = SupportedModels.supportedModelFromBRLMPrinterModel(model: model)
        
        // If the "by parameter" option is supported in the SDK...
        if supportedModel!.supportsCustomPaperSizeCommand
        {
            // Create the custom paper definition using parameters. Valid only with SOME models, per SDK capability.
            
            // This method allows defining the paper dimensions and margins using a set of properties (parameters to init).
            // To support "any" size, you can create a GUI to allow user to modify these values.
            // Or, just create the ones you want to support using this or a similar init method that matches your actual paper.
            // There are 3 different init methods available, based on paper type.
            
            
            // NOTE: For paperWidth, let's set an appropriate value for the specific model.
            // For this I will use a variable in my custom SupportedModels enum, just for fun.
            // Using "headSizeDots" instead of "maxPaperWidthDots", since SDK currently has a problem with the latter,
            // even with non-zero margins.
            //
            // WARNING: Normally, you would set this to the actual width of the paper you are using.
            // e.g. let paperWidthInches = 4.0
            // If the "headSizeDots" is wider than your paper, it's likely that the printed data will extend beyond
            // the edge of the paper (which would be BAD).
            //
            // NOTE: Must convert dots to inches as well, since SDK currently doesn't include dots as a valid unit.
            // inches = dots / (dots/inch)
            let paperWidthInches = Float(supportedModel!.headSizeDots) / Float(supportedModel!.horzResolution)
             
            // NOTE: roll, diecut, markroll have different sets of parameters that are valid, as indicated by the
            // designated init method for each type.
            //
            // This demonstrates how to use ContinuousRoll paper with custom settings, in units of inches.
            // All parameters should be entered based on the specified unitOfLength parameter.
            //
            // NOTE: The margins specified here are typical defaults with most paper sizes.
            
            settings.customPaperSize = BRLMCustomPaperSize(rollWithTapeWidth: CGFloat(paperWidthInches), // e.g. 2.0,
                margins: BRLMCustomPaperSizeMargins(top: 0.12, left: 0.06, bottom: 0.12, right: 0.06),
                unitOfLength: BRLMCustomPaperSizeLengthUnit.inch)
            
        }
        else
        {
            // Use Paper.bin file approach. Valid with ALL models.
            
            // IMPORTANT: EACH PRINTER MODEL and EACH PAPER ** MUST ** have a DIFFERENT BIN FILE.
            // Paper BIN files are created with the Windows Driver. They can support any paper type.
            // SDK may provide most common BIN files.
            // Normally, you will include the BIN file as a resource in your app and reference it as follows below.
            // For this sample, we will specify paper.bin for ContinuousRoll.
            //
            // EXTRA NOTE: To allow dynamic paper size with BIN file, you can allow user to add files to your app and select from a list.
            guard let pathToPaperBinFile:String = Bundle.main.path(forResource: self.paperBinFilenameForRJTDModel(model: model), ofType: nil)
                else {
                    print("hardSettingsForTD ERROR: invalid paper bin file")
                    return nil
            }
            
            let urlPathToPaperBinFile = URL(fileURLWithPath: pathToPaperBinFile)
            settings.customPaperSize = BRLMCustomPaperSize(file: urlPathToPaperBinFile)
            
        }

        
        settings.density = BRLMTDPrintSettingsDensity.strongLevel2
        
        #if SDK_ADDS_SUPPORT_FOR_THIS
        settings.rotate180degrees = true // SDK TODO: TD2 printers support this but SDK doesn't!!
        #endif
        
        settings.peelLabel = false // N/A unless your printer has a peeler and using die-cut labels.
        
        return settings
    } // hardSettingsForTD
    

    private func hardSettingsForMW(model:BRLMPrinterModel) -> BRLMMWPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.

        // get default settings object from SDK for the specified model.
        guard let settings = BRLMMWPrintSettings(defaultPrintSettingsWith: model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForMW ERROR: settings = nil")
            return nil
        }

        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)

        //**************************************************************************************
        // MW Settings - Nothing to do!
        // Only available settings is paperSize, but this is read-only since it's fixed for each MW model.
        //**************************************************************************************
 
        return settings
    } // hardSettingsForMW

    
    private func hardSettingsForQL(model:BRLMPrinterModel) -> BRLMQLPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.

        // get default settings object from SDK for the specified model.
        guard let settings = BRLMQLPrintSettings(defaultPrintSettingsWith: model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForQL ERROR: settings = nil")
            return nil
        }

        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)
        
        // Override "imageSettings" if desired, since these are being set commonly for all models in this sample.
        // replace with TIFF compression since QL does not support Mode9 compression.
        //
        // NOTE: validate function will tell you SDK will change this to .tiff internally.
        // So, it's not necessary to change it here. But, this avoids the warning.
        // For now, I will leave this commented out so you can see what happens when "validate" is called at print-time.
//        settings.compress =  .tiff // .none
        
        //**************************************************************************************
        // QL Settings
        //**************************************************************************************
        
        // User TODO: Set labelSize to your papertype.
        //
        // NOTE: If you wish to detect the currently installed label, c.f. "detectQLorPTLabel" in ContentView.swift.
        // NOTE: We are now calling that at print-time for PDF/Image, so the labelSize being set here will be REPLACED.
        settings.labelSize = .rollW62
        
        settings.autoCut = false                // cut every N labels as indicated by autoCutForEachPageCount
        settings.autoCutForEachPageCount = 1    // N/A unless autocut is true
        settings.cutAtEnd = true // false       // cut at end of job
       
        // resolution:
        // NOTE: The following comments may not be applicable to all QL models.
        // * .low => NOT SUPPORTED with QL printers in iOS SDK. If you set it, SDK will force to .normal
        // * .normal => recommend this option. Uses 300x300 dpi
        // * .high => SDK TODO: strange issues with this option, at least on QL-820.
        //                      * "Communication Error" occurs at print time when using RB label, even though openChannel succeeds.
        //                          Apparently, high resolution is NOT supported when using the RB paper
        //                      * With 29x90mm label, it prints. However, "cutAtEnd" will cut the label in the middle of the label.
        //              NOTE: Seems to use 300x600 dpi, which will reeduce the length of printed image by half compared to normal
        settings.resolution = .normal

        return settings
    } // hardSettingsForQL

    private func hardSettingsForPT(model:BRLMPrinterModel) -> BRLMPTPrintSettings?
    {
        // NOTE: It is NOT necessary to change all settings. You only need to change if you don't like the SDK default value.
        // We will set ALL settings and change some settings to non-default values for demonstration only.
        
        // get default settings object from SDK for the specified model.
        guard let settings = BRLMPTPrintSettings(defaultPrintSettingsWith: model) // NOTE: using BRLMPrinterModel enum here
        else {
            print("hardSettingsForPT ERROR: settings = nil")
            return nil
        }
        
        //**************************************************************************************
        //*** BRLMPrintImageSettings
        // NOTE: These settings are common to all BRLMXXPrintSettings classes.
        // Use a common function, for convenience
        //**************************************************************************************
        var imageSettings:BRLMPrintImageSettings = settings
        self.hardSettingsForImageSettings(imageSettings: &imageSettings)
        
        // Override "imageSettings" if desired, since these are being set commonly for all models in this sample.
        // Replace with TIFF compression since PT does not support Mode9 compression.
        //
        // NOTE: validate function will tell you SDK will change this to .tiff internally.
        // So, it's not necessary to change it here. But, this avoids the warning.
        // For now, I will leave this commented out so you can see what happens when "validate" is called at print-time.
        //        settings.compress =  .tiff // .none
        
        //**************************************************************************************
        // PT Settings
        //**************************************************************************************
        
        // User TODO: Set labelSize to your papertype.
        //
        // NOTE: If you wish to detect the currently installed label, c.f. "detectQLorPTLabel" in ContentView.swift.
        // NOTE: We are now calling that at print-time for PDF/Image, so the labelSize being set here will be REPLACED.
        settings.labelSize = .width12mm

        // NOTE: TBH, I don't know what most of these settings do or what combinations are allowed.
        // Refer to manual or experiment.
        settings.cutmarkPrint = false           // if true, print a cut mark. NOTE: PT-E550W does NOT support true.
        settings.autoCut = false                // cut every N labels as indicated by autoCutForEachPageCount
        settings.autoCutForEachPageCount = 1    // N/A unless autocut is true
        settings.halfCut = false
        settings.chainPrint = false
        settings.specialTapePrint = false       // If true, disables cutting
        settings.forceVanishingMargin = false   // If true, forces margins to zero
        
        // resolution:
        // * .low => NOT SUPPORTED with PT printers in iOS SDK. If you set it, SDK will force to .normal
        // * .normal => recommend this option. I believe this will use 180x180
        // * .high -> I believe this will use 180x360, which reduces length of printed image by half compared to normal
        settings.resolution = .normal
        
        return settings
    } // hardSettingsForPT

} // struct HardCodedSettings

