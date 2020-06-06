/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  MainViewController.h
//  Pillowfort
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import <WebKit/WebKit.h>

@implementation MainViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // Effectively, status bar background color
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0.133333333 green:0.133333333 blue:0.133333333 alpha:1.0];

    WKWebView* webView = self.webView;

    UILayoutGuide* layoutGuide = self.view.safeAreaLayoutGuide;
    
    webView.translatesAutoresizingMaskIntoConstraints = false;
    [webView.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor].active = true;
    [webView.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor].active = true;
    [webView.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor].active = true;
    [webView.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor].active = true;
    
    [self addCustomCss:@".sidebar-header { float: left; } nav > .container-fluid { display: flex; justify-content: flex-start; } .navbar-right { display: flex; margin-left: auto; } .navbar-header { padding-top: 0 !important; } body nav .navbar-right .navbar-text { padding: 0 !important; display: flex !important; align-items: center; justify-content: center; } .navbar-right p { margin-bottom: 0.25em; } .navbar-text, a#sidebar-expand-down, a#sidebar-close, .nav-logout { border-left: none !important; border-right: none !important; } .navbar { height: initial !important; } .post { border-radius: 4px; overflow: hidden; width: calc(100% - 3px) !important; } .sidebar { width: 100% !important; } .sidebar-toggle-indicator, .sidebar-header { height: 0; padding: 0; margin: 0; overflow: hidden; } .sidebar-boxes { padding-top: 4px; }" toWebView:webView];
    
    webView.UIDelegate = self;
    
    [super viewWillAppear:animated];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
  if (!navigationAction.targetFrame.isMainFrame) {
    [webView loadRequest:navigationAction.request];
  }

  return nil;
}

-(void)addCustomCss:(NSString*)cssString toWebView:(WKWebView*)webView  {
    NSString *scriptString = @"javascript:(function() { var style = document.createElement('style'); style.type = 'text/css'; style.innerHTML = window.atob('%@'); document.head.appendChild(style)})()";
    
    NSString *cssBase64 = [self encodeStringTo64:cssString];
    WKUserScript *cssScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:scriptString, cssBase64] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    
    [webView.configuration.userContentController addUserScript:cssScript];
}

-(void)addCustomJs:(NSString*)jsString toWebView:(WKWebView*)webView {
    NSString *scriptString = @"javascript:(function() { var script = document.createElement('script'); script.type = 'text/javascript'; script.innerHTML = window.atob('%@'); document.head.appendChild(script)})()";
    
    NSString *jsBase64 = [self encodeStringTo64:jsString];
    WKUserScript *jsScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:scriptString, jsBase64] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    [webView.configuration.userContentController addUserScript:jsScript];
}

- (NSString*)encodeStringTo64:(NSString*)fromString {
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];
    }

    return base64String;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}

// CB-12098
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  
- (NSUInteger)supportedInterfaceOrientations
#else  
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return [super supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate 
{
    return [super shouldAutorotate];
}
*/

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
