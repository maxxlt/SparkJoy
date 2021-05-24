//
//  ObjCImagePrintHandler.h
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

// NOTE: This class has multiple ways to print an IMAGE based on SDK functionality.
// We are only using the method with a single image URL.
@interface ObjCImagePrintHandler : ObjCPrintHandler

// NOTE: Need to declare these return values as "nullable" because they will be read by a Swift "optional".
// If we don't do this, then if we return "nil", in Swift code the result is "" (Empty String) instead.

-(nullable NSString *) objcPrintImageURL:(NSURL *)imageFilePathURL
                                 channel:(BRLMChannel *)channel
                           printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;

-(nullable NSString *) objcPrintCGImage:(CGImageRef)imageRef
                                channel:(BRLMChannel *)channel
                          printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;


-(nullable NSString *) objcPrintImageURLArray:(NSArray<NSURL *> *) imageFilePathURLArray
                                      channel:(BRLMChannel *)channel
                                printSettings:(id<BRLMPrintSettingsProtocol>) printSettings;



@end

NS_ASSUME_NONNULL_END
