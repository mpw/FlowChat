//
//  AppDelegate.m
//  FlowChat
//
//  Created by Marcel Weiher on 2/13/17.
//  Copyright © 2017 metaobject. All rights reserved.
//

#import "AppDelegate.h"
#import <MethodServer/MethodServer.h>
#import <ObjectiveSmalltalk/MPWStCompiler.h>
#import "MPWActionStreamAdapter.h"
#import "MPWFoundation/MPWSocketStream.h"
#import "MPWFoundation/MPWScatterStream.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,strong) MPWPipe *pipe;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MPWByteStream *console=[MPWByteStream stream];
    MPWSocketStream *socket=[[MPWSocketStream alloc] initWithURL:[NSURL URLWithString:@"socket://localhost:9001"]];
    
    self.pipe=[MPWPipe filters:
                 @[ [[MPWActionStreamAdapter alloc] initWithUIControl:self.messageBox target:nil],
                    @"%%@\n",
                       @[ console,
                          @[[MPWByteStream stream], socket, console ]
                        ],
                  ]
               ];
    
    [self.pipe setTarget:self.messages.textStorage.mutableString];
    [socket open];
}


@end
