//
//  LoggerSecMessage.h
//  NSLogger
//
//  Created by Robert on 30.10.19.
//  Copyright © 2019 Florent Pillet. All rights reserved.
//

#import "LoggerMessage.h"

@class LoggerConnection;

@interface LoggerSecMessage : LoggerMessage
{
}

- (id)initWithData:(NSData *)data connection:(LoggerConnection *)aConnection;

@end
