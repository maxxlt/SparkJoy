//
//  SearchWIFIPrinters.swift
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

/*
 NOTE: This class is used as a work-around in SwiftUI, because a SwiftUI View CANNOT conform to an ObjC protocol,
 which the SDK's WIFI/Network search REQUIRES.
 
 NOTE: In a UIKit ViewController, normally you would conform to the BRPtouchNetworkDelegate protocol (as we do here)
 and implement both "startSearch" and the "didFinishSearch" delegate callback method that SDK sends when search is completed.
 
 NOTE: As part of the work-around, I've create a custom "wifiSearchNotificationName" that we will post when "didFinishSearch" fires.
 Caller should handle this notification, and the search results will be available in our "discoveredPrinterList".
 */
class SearchWIFIPrinters: NSObject,BRPtouchNetworkDelegate  {
    
    // This will contain the list of discovered printers provided by the SDK callback
    var discoveredPrinterList:[BRPtouchDeviceInfo] = []
    
    // This custom notification will be sent by us after we process SDK's "didFinishSearch" notification.
    static let wifiSearchNotificationName = "didFinishWIFISearch"

    // Start the search using SDK method
    func startSearchWiFiPrinter(printerNameArray:[String], searchTimeout:Int32) {

        // NOTE: We must tell SDK which printer model(s) we want to find.
        // If printerName(s) are not specified, then no printers will be found.
        // If only 1 model, you can just use printerName and a string instead of using printerNames with an array.
        // Alternatively, you can use the basic init and then call setPrinterName(s) afterward.
        // But, conceivably that could fail, which (I guess) is why manager is an "optional" when using the designated initializers.
        if let manager = BRPtouchNetworkManager(printerNames: printerNameArray)
        {
            manager.delegate = self
            manager.startSearch(searchTimeout)
        }
        else {
            print("ERROR: startSearchWiFiPrinter could not create manager.")
        }
        

    }

    // Handle SDKs "didFinishSearch" method defined in BRPtouchNetworkDelegate protocol
    //
    // NOTE: A pure SwiftUI view cannot conform to an Obj-C protocol as needed here.
    // So, we will use an NSObject-derived class to handle this completely.
    //
    // As such, we will store the found devicelist in a local var and send a Notification to the caller (which must register for it)
    // to let it know when the delegate method completes.
    //
    func didFinishSearch(_ sender: Any!) {
        guard let manager = sender as? BRPtouchNetworkManager else {
            print("didFinishSearch ERROR: invalid manager")
            
            // Must set discoveredPrintList and send notification. Caller may be expecting this to handle GUI.
            self.discoveredPrinterList = []
            NotificationCenter.default.post(name:NSNotification.Name(SearchWIFIPrinters.wifiSearchNotificationName), object: nil)

            return
        }
        guard let devices = manager.getPrinterNetInfo() else {
            print("didFinishSearch ERROR: invalid devices")

            // Must set discoveredPrintList and send notification. Caller may be expecting this to handle GUI.
            self.discoveredPrinterList = []
            NotificationCenter.default.post(name:NSNotification.Name(SearchWIFIPrinters.wifiSearchNotificationName), object: nil)
            
            return
       }
        
        // Update our local var with the discovered list of devices.
        // Then, post notification to tell caller that the search has completed.
        self.discoveredPrinterList = devices as? [BRPtouchDeviceInfo] ?? []
        NotificationCenter.default.post(name:NSNotification.Name(SearchWIFIPrinters.wifiSearchNotificationName), object: nil)
        
        #if DEBUG
        // Print the found devices to the console.
        for deviceInfo in devices {
            if let deviceInfo = deviceInfo as? BRPtouchDeviceInfo {
                print("Model: \(deviceInfo.strModelName ?? "unavailable"), IP Address: \(deviceInfo.strIPAddress ?? "unavailable")")
            }
        }
        #endif
    } // didFinishSearch (WIFI delegate callback from SDK)

    
}
