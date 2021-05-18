//
//  BRLMPrinterKit-Bridging-Header.h
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

#ifndef BRLMPrinterKit_Bridging_Header_h
#define BRLMPrinterKit_Bridging_Header_h

// The 2 "umbrella" headers needed to use v4 and v3 SDK APIs
// NOTE: With SDK 4.0.2, with Xcode12+, this will produce many warnings at compile-time because the umbrella
// headers do #import "header.h" instead of #import <BRLMPrinterKit/header.h>.
// The SDK will be fixed in a future release to resolve this.
// For now, you can disable these warnings in Project Settings by changing "Quote Include in Framework Header" to NO.
#import <BRLMPrinterKit/BRLMPrinterKit.h> // v4
#import <BRLMPrinterKit/BRPtouchPrinterKit.h> // v3: needed for search, Network/BLE/BluetoothManager, and more...

// Internal Obj-C Classes that will be used from Swift classes
#import "./Printing/ObjC/ObjCPrintHandler.h"
#import "./Printing/ObjC/ObjCPDFPrintHandler.h"
#import "./Printing/ObjC/ObjCImagePrintHandler.h"
#import "./Printing/ObjC/ObjCPRNPrintHandler.h"


#endif /* BRLMPrinterKit_Bridging_Header_h */
