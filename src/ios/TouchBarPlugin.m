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

- (nullable NSTouchBarItem *)createNSButton:(NSDictionary *) properties {
    NSCustomTouchBarItem *touchBarItem =
    [[NSCustomTouchBarItem alloc] initWithIdentifier:properties[@"identifier"]];
    NSButton *button = [NSButton buttonWithTitle:properties[@"title"] target:self action:@selector(onTapButton:)];
//    [button setTitle:properties[@"title"]];
//    [button setTarget:self];
//    [button setAction:@selector(onTapButton:)];
    touchBarItem.view = button;
    button.identifier=properties[@"identifier"];
    NSImage* btnImage;
    btnImage=[NSImage imageNamed:properties[@"image"]] ?: [[NSImage alloc] initWithContentsOfFile:properties[@"image"]];
    if (btnImage) {
        [button setImage:btnImage];
        [button setImagePosition:NSImageLeft];
 }
    touchBarItem.customizationLabel = NSLocalizedString(properties[@"title"], @"");
    return touchBarItem;
}

- (nullable NSTouchBarItem *)createNSSlider:(NSDictionary *) properties {
    NSSliderTouchBarItem *touchBarItem =
    [[NSSliderTouchBarItem alloc] initWithIdentifier:properties[@"identifier"]];
    touchBarItem.customizationLabel=properties[@"title"];
    touchBarItem.target = self;
    touchBarItem.slider.minValue=[properties[@"minValue"] doubleValue];
    touchBarItem.slider.maxValue=[properties[@"maxValue"] doubleValue];
    touchBarItem.action = @selector(onSliderEvent:);

    return touchBarItem;
}

- (void)modifyNSButton:(CDVInvokedUrlCommand *)command {
    NSButton* button;
    NSString* identifier;
    NSDictionary* properties;
    identifier = [command.arguments objectAtIndex:0];
    properties = [command.arguments objectAtIndex:1];
    
    button = ((NSCustomTouchBarItem*) identifierHolder[identifier]).view;
    if (button) {
        [button setValuesForKeysWithDictionary:properties];
        
    }
}

- (void)modifyNSSlider:(CDVInvokedUrlCommand *)command {
    NSSliderTouchBarItem* slider;
    NSString* identifier;
    NSDictionary* properties;
    NSDictionary* sliderProps;
    identifier = [command.arguments objectAtIndex:0];
    properties = [command.arguments objectAtIndex:1];
    sliderProps = properties[@"slider"];

    slider = ((NSSliderTouchBarItem*) identifierHolder[identifier]).view;
   
    if (sliderProps) {
        [slider.slider setValuesForKeysWithDictionary:sliderProps];
    }
}

- (void)defineTouchBarItem:(NSDictionary *)item {
        SEL creatorMethod =  NSSelectorFromString([[NSString alloc] initWithFormat:@"%@%@:",@"create",item[@"type"]]);
        if (creatorMethod) {
            NSTouchBarItem* touchBarItem = [self performSelector:creatorMethod withObject:item];
            [identifierHolder setObject:touchBarItem forKey:item[@"identifier"]];
        }
}
- (void)defineTouchBarItems:(CDVInvokedUrlCommand *)command {
    for (NSDictionary* item in command.arguments) {
        [self defineTouchBarItem:item];
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
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

- (void) onSliderEvent:(NSSliderTouchBarItem *)sender {
    NSLog([NSString stringWithFormat:@"%@%@",sender.identifier,@"Tapped"]);
    NSMutableDictionary* resultObj = [[NSMutableDictionary alloc] init];
    [resultObj setValue:sender.identifier forKey:@"identifier"];
    [resultObj setValue:@"change" forKey:@"event"];
    [resultObj setValue:[NSNumber numberWithInteger:sender.slider.integerValue] forKey:@"value"];
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
