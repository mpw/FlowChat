//
//  MPWActionStreamAdapter.m
//  FlowChat
//
//  Created by Marcel Weiher on 2/13/17.
//  Copyright © 2017 metaobject. All rights reserved.
//

#import "MPWActionStreamAdapter.h"
#import <Cocoa/Cocoa.h>

@interface MPWStream(sender)
-(void)writeObject:(id)anObject sender:aSender;
@end


@implementation MPWActionStreamAdapter

-initWithUIControl:aControl target:aTarget
{
    self=[super initWithTarget:aTarget];
    [aControl setTarget:self];
    [aControl setAction:@selector(getString:)];
    return self;
}

-initWithTextField:aControl target:aTarget
{
    self=[super initWithTarget:aTarget];
    [aControl setDelegate:self];
    return self;
}

-(void)getString:sender
{
//    NSLog(@"getString %@ from %@ write to %@",[sender stringValue],sender,self.target);
    [self.target writeObject:[sender stringValue]];
}

- (void) controlTextDidChange: (NSNotification *)note {
    
    NSTextField * changedField = [note object];
    [self.target writeObject:[changedField stringValue]];
}


@end
