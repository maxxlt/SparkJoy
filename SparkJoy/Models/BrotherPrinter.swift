//
//  BrotherPrinter.swift
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

// This is a "Container" Class used to hold all data relevant to the current printer model selected by user.
// It is used for convenience as a central data store that can be passed as a parameter or added to the SwiftUI Environment.
class BrotherPrinter:ObservableObject {

    //*** Constants
    let keyCurrentPrinterModel = "Current Model"
    let keyChannelType = "Channel Type"
    let keyChannelInfo = "Channel Info"

    //*** Variable properties
    
    // NOTE: @Published allows SwiftUI to redraw any GUI which depends on this property.
    @Published public var model:SupportedModels
    {
        didSet {
            // Save to UserDefaults
            self.saveDefaultPrinterModel(model: model)
            
            // Update everything in this class to be consistent with the new model
            self.updatePrinterModel(newModel: model)
        }
    }
    
    public var channel:BRLMChannel
    {
        didSet {
            // Save to UserDefaults
            self.saveDefaultChannel(channel: channel)
        }
    }

    // Utility method to set both model and channel (e.g. from Search) at the same time.
    func setModelAndChannel(newModel:SupportedModels, newChannel:BRLMChannel)
    {
        self.model = newModel
        self.channel = newChannel
     }

    
    // NOTE: printSettings is defined as an "Optional" because it is defined in SDK as "nullable",
    // presumably because settings are not needed for PRN data. Only needed for PDF and Image.
    public var printSettings:BRLMPrintSettingsProtocol? = nil

    // App contains/specifies default PDF/Image/PRN files to print for each model.
    // We set these defaults when the model changes.
    var printFiles = FilesToPrint()
        

    // ***************************************************
    // Init function(s)
    // ***************************************************

    init()
    {
        // Set model and channel for PJ-773 and Wireless Direct, for initial use
        model = .PJ_773
        channel = BRLMChannel(wifiIPAddress: "192.168.118.1")
        
        // setup printSettings and printFiles to be consistent with the default model
        self.updatePrinterModel(newModel: model)

        // If model/channel have been saved to UserDefaults, use these instead
        // NOTE: If these exist, the "didSet" will be called on each to perform other changes
        if self.loadDefaultPrinterModel(model: &model)
        {
            _ = self.loadDefaultChannel(channel: &channel)
        }
    } // init

    
    // ***************************************************
    // Private Functions
    // ***************************************************
    
    private func updatePrinterModel(newModel:SupportedModels)
    {
        // Set everything to be consistent with the new model
        
        // In this "Basic" sample, set printSettings based on HardCoded values. This is what most ISVs do anyway.
        // In the "Advanced" sample, we demonstrate how to create a GUI to allow user to change the settings
        printSettings = HardCodedSettings().hardCodedSettingsForModel(model:newModel)
        
        // This app defines default files to print (PDF, IMAGE, and PRN) based on model so the file is appropriate.
        // In this "Basic" sample, we will only allow printing these built-in files.
        // In the "Advanced" sample, we will also allow users to select a different file.
        printFiles.setDefaultFilesForModel(model: newModel)
        
        // * NOTE: Channel will only be updated as a result of the PrinterSearch.
        // This "Basic" sample does not provide any GUI for setting channel in a different way.
        // The "Advanced" sample will also allow both Search and Manual user entry.
        
    } // updatePrinterModel
    
    private func saveDefaultPrinterModel(model:SupportedModels)
    {
        //*** Save the new printer model to UserDefaults
        let defaults = UserDefaults.standard
        
        // NOTE: We cannot save enum value directly. This wil CRASH!!!
        // So, we must convert to "rawValue" when we save, and convert it back to enum when we load.
        //
        // NOTE: We could save as String, which is useful in case **future** SDK changes the enum values related to model.
        // But for now, let's just save based on enum rawValue.
        // BTW: Changing the enum values would be a BAD thing for SDK to do, but it's possible it could happen.
        // I know this because I did it before, oops ;-)
        
        defaults.set(model.rawValue, forKey: keyCurrentPrinterModel)
        
    } // saveDefaultPrinterModel
    
    private func loadDefaultPrinterModel(model:inout SupportedModels) -> Bool
    {
        //*** Load the default printer model from UserDefaults
        let defaults = UserDefaults.standard
        
        // Since we saved it as the enum rawvalue, load it back the same way.
        // NOTE: When we load integer (i.e. rawValue), the value will be 0 if key DOES NOT EXIST.
        // .PJ-673 has rawValue = 0.
        // So, we need to determine if the key exists, and if not then return the same value that was passed in
        // so we don't change it.
        
        let keys = defaults.dictionaryRepresentation()
        if keys[keyCurrentPrinterModel] != nil {
            let tmpRawValue = defaults.integer(forKey: keyCurrentPrinterModel)
            
            // convert rawValue back to enum, and default to same value passed in if there's an error.
            model = SupportedModels(rawValue: tmpRawValue) ?? model
            
            return true
        }
        else {return false}
        
    } // loadDefaultPrinterModel

    private func saveDefaultChannel(channel: BRLMChannel)
    {
        //*** Save the new channel to UserDefaults
        let defaults = UserDefaults.standard
        
        // NOTE: Must use "rawValue" for channelType enum. Cannot set enum value to UserDefaults or it will crash.
        defaults.set(channel.channelType.rawValue, forKey: keyChannelType)
        defaults.set(channel.channelInfo, forKey: keyChannelInfo)
    } // saveDefaultChannel
    
    private func loadDefaultChannel(channel:inout BRLMChannel) -> Bool
    {
        let defaults = UserDefaults.standard
        
        // NOTE: When we load integer (i.e. rawValue), the value will be 0 if key DOES NOT EXIST.
        // BRLMChannelTypeBluetoothMFi (in ObjC enum) has rawValue = 0.
        // We need to determine if the key exists, and if not then return the same value that was passed in
        // so we don't change it.
        
        let keys = defaults.dictionaryRepresentation()
        if keys[keyChannelType] != nil && keys[keyChannelInfo] != nil {
            // both keys exist, OK to proceed

            // NOTE: BRLMChannel object is immutable.
            // So we need to load each part individually to temp vars and then instantiate a new one.
            var channelType:BRLMChannelType
            var channelInfo:String
            
            // 1. load channelType (as rawValue, same as we saved it)
            // convert rawValue back to enum, and default to same value passed in if there's an error.
            let tmpRawValue = defaults.integer(forKey: keyChannelType)
            channelType = BRLMChannelType(rawValue: tmpRawValue) ?? channel.channelType

            // 2. load channelInfo
            channelInfo = defaults.string(forKey: keyChannelInfo) ?? channel.channelInfo
            
            // 3. replace "inout channel" param with a newly instantiated BRLMChannel object
            switch channelType {
                case .wiFi:
                    channel = BRLMChannel(wifiIPAddress: channelInfo)
                    
                case .bluetoothMFi:
                    channel = BRLMChannel(bluetoothSerialNumber: channelInfo)
                    
                case .bluetoothLowEnergy:
                    channel = BRLMChannel(bleLocalName: channelInfo)
                                    
                // For some reason, Obj-C enums produce the compiler warning:
                // "Switch covers known cases, but XXX may have additional unknown values".
                // c.f. https://www.avanderlee.com/swift/unknown-default-enums-in-swift/
                // This is same as "default", i.e. removes the warning mentioned above.
                // However, it will produce a new compiler warning in the FUTURE if the obj-c enum in SDK adds a new value.
                @unknown default:
                    print("loadDefaultChannel: Unknown channel")
                    // leave channel unchanged
                
            } // switch

            return true
        }
        else {return false}
        
    } // loadDefaultChannel

    // ***************************************************
    // Public Functions
    // ***************************************************
    public func stringFromChannelType(channelType:BRLMChannelType) -> String
    {
        switch channelType {
            case .wiFi:
                return "WiFi"
            case .bluetoothMFi:
                return "Bluetooth"
            case .bluetoothLowEnergy:
                return "BLE"
            default:
                return "Unsupported ChannelType"
        }
    } // stringFromChannelType

    
}
