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
@property (nonatomic,strong) MethodServer *methodServer;
@property (nonatomic,strong) MPWByteStream *console;
@property (nonatomic,strong) MPWActionStreamAdapter *adapter;
@property (nonatomic,strong) MPWPipe *pipe;


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
    self.console=[MPWByteStream streamWithTarget:self.messages.textStorage.mutableString];
    MPWSocketStream *socket=[[MPWSocketStream alloc] initWithURL:[NSURL URLWithString:@"socket://localhost:9001"]];
    MPWByteStream *socketSource=[MPWByteStream streamWithTarget:socket];
    self.pipe=[MPWPipe filters:@[[[MPWActionStreamAdapter alloc] initWithUIControl:self.messageBox target:nil], ^(NSString *s){ return [s stringByAppendingString:@"\n"];},@[ self.console, socketSource ]]];
    
//    MPWScatterStream *splitter=[MPWScatterStream filters:];
//    [self.pipe setTarget:splitter];
    [socket setTarget:self.console];
    [socketSource setTarget:socket];
    [self.console setTarget:self.messages.textStorage.mutableString];
  
    [socket open];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)methodsDefined
{
}



@end
