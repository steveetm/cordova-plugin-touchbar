#import <Cordova/CDVPlugin.h>

@interface TouchBarPlugin : CDVPlugin {

}

// The hooks for our plugin commands
- (void)setDefaultItemIdentifiers:(CDVInvokedUrlCommand *)command;
- (void)defineTouchBarItems:(CDVInvokedUrlCommand *)command;
- (void)_setCallbackHandler:(CDVInvokedUrlCommand *)command;
- (nullable NSTouchBarItem *)createNSButton:(NSString *)title identifier:(NSString *) identifier;
- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier;
- (void)modifyNSButton:(CDVInvokedUrlCommand *)command;

@end
