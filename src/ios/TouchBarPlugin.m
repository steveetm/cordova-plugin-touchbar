#import "TouchBarPlugin.h"

#import <Cordova/CDVAvailability.h>
#import "MainViewController+TouchBarPluginMainViewController.h"
@implementation TouchBarPlugin
static NSString* callbackId;
static NSMutableDictionary *identifierHolder;
- (void)pluginInitialize {
    ((MainViewController *) self.viewController).touchBarDelegate=self;
    identifierHolder = [[NSMutableDictionary alloc] init];
}
- (void)_setCallbackHandler:(CDVInvokedUrlCommand *)command {
    callbackId= command.callbackId;
}
- (void)setDefaultItemIdentifiers:(CDVInvokedUrlCommand *)command {
    self.viewController.touchBar.defaultItemIdentifiers= command.arguments;
}

- (nullable NSTouchBarItem *)createNSButton:(NSString *)title identifier:(NSString *) identifier {
    NSCustomTouchBarItem *touchBarItem =
    [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
    NSButton *button = [NSButton buttonWithTitle:title
                                          target:self
                                          action:@selector(onTapButton:)];
    touchBarItem.view = button;
    button.identifier=identifier;
    touchBarItem.customizationLabel = NSLocalizedString(title, @"");
    return touchBarItem;
}

- (nullable NSTouchBarItem *)createNSSlider:(NSString *)title identifier:(NSString *) identifier {
    NSSliderTouchBarItem *touchBarItem =
    [[NSSliderTouchBarItem alloc] initWithIdentifier:identifier];
    touchBarItem.customizationLabel=title;
    return touchBarItem;
}

- (void)defineTouchBarItem:(NSDictionary *)item {
        SEL creatorMethod =  NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@:identifier:",@"create",item[@"type"]]);
        NSTouchBarItem* touchBarItem = [self performSelector:creatorMethod withObject:item[@"title"] withObject:item[@"identifier"]];
        [identifierHolder setObject:touchBarItem forKey:item[@"identifier"]];
    
}
- (void)defineTouchBarItems:(CDVInvokedUrlCommand *)command {
    for (NSDictionary* item in command.arguments) {
        [self defineTouchBarItem:item];
    }
}

- (void) onTapButton:(NSButton *)sender {
    NSLog([NSString stringWithFormat:@"%@%@",sender.identifier,@"Tapped"]);
    NSMutableDictionary* resultObj = [[NSMutableDictionary alloc] init];
    [resultObj setValue:sender.identifier forKey:@"identifier"];
    [resultObj setValue:@"tap" forKey:@"event"];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultObj];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if (identifierHolder[identifier])
    {
        return identifierHolder[identifier];
       
    }

    return nil;
}


@end
