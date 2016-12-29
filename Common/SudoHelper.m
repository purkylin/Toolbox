//
//  SudoHelper.m
//  PriviliegeSample
//
//  Created by Purkylin King on 2016/12/22.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

#import "SudoHelper.h"
#import "Common.h"
#import "HelperTool.h"

#include <ServiceManagement/ServiceManagement.h>

@interface SudoHelper() {
    AuthorizationRef    _authRef;
}

@property (atomic, copy,   readwrite) NSData *                  authorization;
@property (atomic, strong, readwrite) NSXPCConnection *         helperToolConnection;

@end

@implementation SudoHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SudoHelper *_helper;

    dispatch_once(&onceToken, ^{
        _helper = [[SudoHelper alloc] init];
        [_helper config];
        [_helper install];
    });
    
    return _helper;
}

- (void)config {
    OSStatus                    err;
    AuthorizationExternalForm   extForm;
    
    // Create our connection to the authorization system.
    //
    // If we can't create an authorization reference then the app is not going to be able
    // to do anything requiring authorization.  Generally this only happens when you launch
    // the app in some wacky, and typically unsupported, way.  In the debug build we flag that
    // with an assert.  In the release build we continue with self->_authRef as NULL, which will
    // cause all authorized operations to fail.
    
    err = AuthorizationCreate(NULL, NULL, 0, &self->_authRef);
    if (err == errAuthorizationSuccess) {
        err = AuthorizationMakeExternalForm(self->_authRef, &extForm);
    }
    if (err == errAuthorizationSuccess) {
        self.authorization = [[NSData alloc] initWithBytes:&extForm length:sizeof(extForm)];
    }
    assert(err == errAuthorizationSuccess);
    
    // If we successfully connected to Authorization Services, add definitions for our default
    // rights (unless they're already in the database).
    
    if (self->_authRef) {
        [Common setupAuthorizationRights:self->_authRef];
    }
}

- (void)logText:(NSString *)text
// Logs the specified text to the text view.
{
    // any thread
//    assert(text != nil);
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [[self.textView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
//    }];
    
    NSLog(@"%@", text);
}

- (void)logWithFormat:(NSString *)format, ...
// Logs the formatted text to the text view.
{
    va_list ap;
    
    // any thread
    assert(format != nil);
    
    va_start(ap, format);
    [self logText:[[NSString alloc] initWithFormat:format arguments:ap]];
    va_end(ap);
}

- (void)logError:(NSError *)error
// Logs the error to the text view.
{
    // any thread
    assert(error != nil);
    [self logWithFormat:@"error %@ / %d\n", [error domain], (int) [error code]];
}

- (void)connectToHelperTool
// Ensures that we're connected to our helper tool.
{
    assert([NSThread isMainThread]);
    if (self.helperToolConnection == nil) {
        self.helperToolConnection = [[NSXPCConnection alloc] initWithMachServiceName:kHelperToolMachServiceName options:NSXPCConnectionPrivileged];
        self.helperToolConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperToolProtocol)];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        // We can ignore the retain cycle warning because a) the retain taken by the
        // invalidation handler block is released by us setting it to nil when the block
        // actually runs, and b) the retain taken by the block passed to -addOperationWithBlock:
        // will be released when that operation completes and the operation itself is deallocated
        // (notably self does not have a reference to the NSBlockOperation).
        self.helperToolConnection.invalidationHandler = ^{
            // If the connection gets invalidated then, on the main thread, nil out our
            // reference to it.  This ensures that we attempt to rebuild it the next time around.
            self.helperToolConnection.invalidationHandler = nil;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.helperToolConnection = nil;
                [self logText:@"connection invalidated\n"];
            }];
        };
#pragma clang diagnostic pop
        [self.helperToolConnection resume];
    }
}

- (void)connectAndExecuteCommandBlock:(void(^)(NSError *))commandBlock
// Connects to the helper tool and then executes the supplied command block on the
// main thread, passing it an error indicating if the connection was successful.
{
    assert([NSThread isMainThread]);
    
    // Ensure that there's a helper tool connection in place.
    
    [self connectToHelperTool];
    
    // Run the command block.  Note that we never error in this case because, if there is
    // an error connecting to the helper tool, it will be delivered to the error handler
    // passed to -remoteObjectProxyWithErrorHandler:.  However, I maintain the possibility
    // of an error here to allow for future expansion.
    
    commandBlock(nil);
}

#pragma mark * IB Actions

- (void)install
// Called when the user clicks the Install button.  This uses SMJobBless to install
// the helper tool.
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasInstalled = [defaults boolForKey:@"installed"];
    if (hasInstalled) {
        return;
    }
    
    Boolean             success;
    CFErrorRef          error;
    
    success = SMJobBless(
                         kSMDomainSystemLaunchd,
                         CFSTR("com.purkylin.HelperTool"),
                         self->_authRef,
                         &error
                         );
    
    if (success) {
        [self logWithFormat:@"success\n"];
        [defaults setBool:YES forKey:@"installed"];
        [defaults synchronize];
    } else {
        [self logError:(__bridge NSError *) error];
        CFRelease(error);
    }
}

- (void)runCommand:(NSString *)cmd completion: (void (^)(NSString *output, BOOL success))block {
    [self connectAndExecuteCommandBlock:^(NSError * connectError) {
        if (connectError != nil) {
            [self logError:connectError];
            block(@"connect failed", NO);
        } else {
            [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
                [self logError:proxyError];
                block([proxyError localizedDescription], NO);

            }] runCommand:cmd withReply:^(NSString *output, BOOL success) {
                if (success) {
                    NSLog(@"Run success");
                    block(output, YES);
                } else {
                    NSLog(@"%@", output);
                    block(output, NO);
                }
            }];
        }
    }];
}

@end
