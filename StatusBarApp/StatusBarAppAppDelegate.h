//
//  StatusBarAppAppDelegate.h
//  StatusBarApp
//
//  Created by CCoding on 18.09.11.
//  Copyright 2011 CCoding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusBarAppAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    id eventHandler;
}

- (IBAction)doSomething:(id)sender;
- (IBAction)sendClipboard:(id)sender;

@end
