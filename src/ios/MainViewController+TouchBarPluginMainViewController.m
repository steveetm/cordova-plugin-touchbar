//
//  MainViewController+PluginMainViewController.m
//  TouchBarApp
//
//  Created by Istvan Tabanyi on 2017. 09. 18..
//


#import "MainViewController+TouchBarPluginMainViewController.h"
#import <Cordova/CDVPlugin.h>
#import <objc/runtime.h>

static char touchBarDelegateKey;

@implementation MainViewController(TouchBar)
// Can't define custom properties with Catalogs, the best way could find is this, make our own setter/getter.

- (void) setTouchBarDelegate:(TouchBarPlugin*)plugin {
    objc_setAssociatedObject(self, &touchBarDelegateKey,
                             plugin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TouchBarPlugin*) touchBarDelegate {
    return objc_getAssociatedObject(self, &touchBarDelegateKey);
}

- (id)init {
    self =[super init];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return self;
}

- (NSTouchBar *)makeTouchBar
{
    NSTouchBar *bar = [[NSTouchBar alloc] init];
    bar.delegate = self;
    bar.defaultItemIdentifiers = @[NSTouchBarItemIdentifierOtherItemsProxy];
    
    return bar;
}

- (nullable NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    if (self.touchBarDelegate != nil) {
        // Let's pass this to our plugin to handle everything.
        return [self.touchBarDelegate touchBar:touchBar makeItemForIdentifier:identifier];
    } else {
        return nil;
    }
}

@end

