#import "PlatformTextViewFactory.h"
#import "PlatformTextView.h"

@implementation PlatformTextViewFactory

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    PlatformTextView *textView = [[PlatformTextView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args];
    return textView;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}


@end
