//
//  ObjCPDFPrintHandler.h
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

// NOTE: This class has multiple ways to print a PDF based on SDK functionality.
// We are (currently) only using the method with a single URL that prints all pages without a page list.
@interface ObjCPDFPrintHandler : ObjCPrintHandler

// NOTE: Need to declare these return values as "nullable" because they will be read by a Swift "optional".
// If we don't do this, then if we return "nil", in Swift code the result is "" (Empty String) instead.

-(nullable NSString *) objcPrintPDFFilePathURL:(NSURL *)pdfFilePathURL
                                       channel:(BRLMChannel *)channel
                                 printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;

-(nullable NSString *) objcPrintPDFFilePathURLArray:(NSArray<NSURL *> *) pdfFilePathURLArray
                                            channel:(BRLMChannel *)channel
                                      printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;

-(nullable NSString *) objcPrintPagesInPDFFilePathURL:(NSURL *)pdfFilePathURL
                                            pageArray:(NSArray<NSNumber *> *)pageArray
                                              channel:(BRLMChannel *)channel
                                        printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;

@end

NS_ASSUME_NONNULL_END
