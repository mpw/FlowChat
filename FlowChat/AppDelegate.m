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

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic,strong) MethodServer *methodServer;
@property (nonatomic,strong) MPWByteStream *console;
@property (nonatomic,strong) MPWActionStreamAdapter *adapter;


@end

@interface AppDelegate(st)
-(void)connect;
@end

@implementation AppDelegate

-(MPWStCompiler*)interpreter
{
    return [[self methodServer] interpreter];
}


-(void)connect
{
    
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    [self setMethodServer:[[MethodServer alloc] initWithMethodDictName:@"flowchat"]];
    [[self methodServer] setupMethodServer];
    NSLog(@"interpreter: %@ solver: %@",[self interpreter],[[self interpreter] solver]);
    [[self interpreter] bindValue:self toVariableNamed:@"delegate"];
    [[self interpreter] evaluateScriptString:@"scheme:ivar := ref:var:delegate asScheme."];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(methodsDefined) name:@"methodsDefined" object:nil];
    
    
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    NSLog(@"message box: %@",self.messageBox);
    self.console=[MPWByteStream Stderr];
    MPWPipe *p= [MPWPipe filters:@[ ^(NSString *s){ return [s stringByAppendingString:@"\n"];}]];
    [p setTarget:self.console];

    self.adapter=[[MPWActionStreamAdapter alloc] initWithTextField:self.messageBox target:p];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)methodsDefined
{
}



@end
