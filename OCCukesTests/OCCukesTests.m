// OCCukesTests OCCukesTests.m
//
// Copyright © 2012, 2013, The OCCukes Organisation. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "OCCukesTests.h"

#import <OCCukes/OCCukes.h>

@implementation OCCukesTests

+ (void)initialize
{
	if (self == [OCCukesTests class])
	{
		// You will see two connections and disconnections. The first incoming
		// connection originates from env.rb where the Ruby-based Cucumber
		// process synchronises with the Objective-C wire server. This
		// connection appears and immediately disappears without sending or
		// receiving wire messages. The second connection runs the wire protocol
		// proper.
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserverForName:OCCucumberRuntimeConnectNotification
							object:nil
							 queue:nil
						usingBlock:^(NSNotification *note) {
			NSLog(@"*** CONNECT at %@", [NSDate date]);
		}];
		[center addObserverForName:OCCucumberRuntimeDisconnectNotification
							object:nil
							 queue:nil
						usingBlock:^(NSNotification *note) {
			NSLog(@"*** DISCONNECT at %@", [NSDate date]);
		}];
	}
}

- (void)testInvokeSingleStep
{
	int __block integer = 0;
	[OCCucumber given:@"^single step$" step:^(NSArray *arguments) {
		integer++;
	}];
	[OCCucumber step:@"single step"];
	XCTAssertEqual(integer, 1);
}

- (void)testInvokeSingleStepWithArguments
{
	NSMutableArray *strings = [NSMutableArray array];
	[OCCucumber given:@"^single step with \"(.*)\"$" step:^(NSArray *arguments) {
		[strings addObjectsFromArray:arguments];
	}];
	[OCCucumber step:@"single step with \"a\"" arguments:@[ @"b", @"c" ]];
	NSArray *abc = @[ @"a", @"b", @"c" ];
	XCTAssertEqualObjects(strings, abc);
}

@end
