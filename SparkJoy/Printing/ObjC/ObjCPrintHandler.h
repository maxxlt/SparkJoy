//
//  ObjCPrintHandler.h
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

#import <Foundation/Foundation.h>
#import <BRLMPrinterKit/BRLMPrinterKit.h>

NS_ASSUME_NONNULL_BEGIN

// Super class for common utility methods used by the other XXXPrintHandler subclasses
@interface ObjCPrintHandler : NSObject

-(NSString *)objcCheckPrinterStatus:(BRLMPrinterDriver *)printerDriver
                      expectedModel:(BRLMPrinterModel)expectedModel;

-(NSString *)validatePrintSettings:(id<BRLMPrintSettingsProtocol>)printSettings;
-(NSString *)stringFromOpenChannelError:(BRLMOpenChannelError *) openChannelError
                        callingFunction:(NSString *)callingFunction;
-(NSString *)stringFromPrintError:(BRLMPrintError *) printError
                  callingFunction:(NSString *)callingFunction;

@end

NS_ASSUME_NONNULL_END
