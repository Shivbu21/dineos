//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<bonsoir_darwin/SwiftBonsoirPlugin.h>)
#import <bonsoir_darwin/SwiftBonsoirPlugin.h>
#else
@import bonsoir_darwin;
#endif

#if __has_include(<file_picker_darwin/FilePickerPlugin.h>)
#import <file_picker_darwin/FilePickerPlugin.h>
#else
@import file_picker_darwin;
#endif

#if __has_include(<mobile_scanner/MobileScannerPlugin.h>)
#import <mobile_scanner/MobileScannerPlugin.h>
#else
@import mobile_scanner;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [SwiftBonsoirPlugin registerWithRegistrar:[registry registrarForPlugin:@"SwiftBonsoirPlugin"]];
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [MobileScannerPlugin registerWithRegistrar:[registry registrarForPlugin:@"MobileScannerPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
}

@end
