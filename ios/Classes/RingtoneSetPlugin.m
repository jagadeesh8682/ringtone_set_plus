#import "RingtoneSetPlugin.h"
#if __has_include(<ringtone_set_plus/ringtone_set_plus-Swift.h>)
#import <ringtone_set_plus/ringtone_set_plus-Swift.h>
#else
#import "ringtone_set_plus-Swift.h"
#endif

@implementation RingtoneSetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRingtoneSetPlugin registerWithRegistrar:registrar];
}
@end
