//
//  StatusBarAppAppDelegate.m
//  StatusBarApp
//
//  Created by CCoding on 18.09.11.
//  Copyright 2011 CCoding. All rights reserved.
//

#import "StatusBarAppAppDelegate.h"
#import <ParseOSX/Parse.h>
//#import <ParseOSX/PFFacebookUtils.h>

@implementation StatusBarAppAppDelegate

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Icon1" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"Icon2" ofType:@"png"]]; 
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    //Use a title instead of images
    //[statusItem setTitle:@"This text will appear instead of images"];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"You do not need this..."];
    [statusItem setHighlightMode:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    eventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler: ^(NSEvent *event) {
        NSUInteger flags = [event modifierFlags] & NSDeviceIndependentModifierFlagsMask;
        if (flags == NSControlKeyMask + NSShiftKeyMask) {
            // cntrl shift
            if ([event keyCode] == 8) {
                [self sendClipboard:nil];
            }
        }
    }];
    
    // TRY MAKING SURE TO REMOVE THE MONITOR TO GET THIS KEYBOARD SHORTCUT TO WORK!
    
    [Parse setApplicationId:@"Gm97bunEwR2nDQWO0SULDGNwxtPLZsorqYrR7UjR"
                  clientKey:@"M5jjdO9CCgmnMPfpaV3QIdI6m3TVu2fo1pBYcP4F"];
    
//    [PFFacebookUtils initializeWithApplicationId:@"your_facebook_app_id"];
    
//    [PFUser enableAutomaticUser];
//    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
//    [defaultACL setPublicReadAccess:YES];
//    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    if (eventHandler) {
        [NSEvent removeMonitor:eventHandler];
    }
}

- (IBAction)doSomething:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://www.codereview.cc"]];
}

- (IBAction)sendClipboard:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSString *contents = [pasteboard stringForType:NSPasteboardTypeString];
    NSInteger contentsLen = [[contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count];
    
    NSLog(@"SENDING: %@ LENGTH: %i", contents, contentsLen);
    
    PFObject *review = [PFObject objectWithClassName:@"Review"];
    [review setObject:contents forKey:@"code"];
    [review setObject:@"" forKey:@"filename"];
    [review setObject:[NSNumber numberWithInt:contentsLen] forKey:@"lineCount"];
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    
    review.ACL = defaultACL;
    
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
            NSString *url = [NSString stringWithFormat:@"http://www.codereview.cc/r/%@", review.objectId];
            [pasteboard setString:url forType:NSStringPboardType];
        }
    }];
}

@end