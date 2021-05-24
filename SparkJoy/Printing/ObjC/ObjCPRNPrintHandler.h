//
//  ObjCPRNPrintHandler.h
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
#import "ObjCPrintHandler.h"

NS_ASSUME_NONNULL_BEGIN

// NOTE: This class has multiple ways to print a PRN based on SDK functionality.
// We are only using the method with a single PRN URL.
@interface ObjCPRNPrintHandler : ObjCPrintHandler

// NOTE: Need to declare these return values as "nullable" because they will be read by a Swift "optional".
// If we don't do this, then if we return "nil", in Swift code the result is "" (Empty String) instead.

-(nullable NSString *) objcPrintPRNDataURL:(NSURL *)prnFilePathURL
                                   channel:(BRLMChannel *)channel
                                     model:(BRLMPrinterModel) model;

-(nullable NSString *) objcPrintPRNDataURLArray:(NSArray<NSURL *> *)prnURLArray
                                        channel:(BRLMChannel *)channel
                                          model:(BRLMPrinterModel) model;

-(nullable NSString *) objcPrintRawData:(NSData *)prnData
                                channel:(BRLMChannel *)channel
                                  model:(BRLMPrinterModel) model;

@end

NS_ASSUME_NONNULL_END
