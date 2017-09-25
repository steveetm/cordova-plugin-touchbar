//
//  MainViewController+PluginMainViewController.h
//  TouchBarApp
//
//  Created by Istvan Tabanyi on 2017. 09. 18..
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"
#import "TouchBarPlugin.h"
@interface MainViewController(TouchBar) <NSTouchBarDelegate> 
@property (nonatomic, assign) TouchBarPlugin* touchBarDelegate;
- (void) setTouchBarDelegate:(TouchBarPlugin*)plugin;
@end
