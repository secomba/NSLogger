//
//  LoggerSecMessage.m
//  NSLogger
//
//  Created by Robert on 30.10.19.
//  Copyright © 2019 Florent Pillet. All rights reserved.
//

// sample log file entries:
//{"Id":0,"Time":"2014-11-07T16:12:21.742663+01:00","ThreadId":1,"Message":"Version: 2.1.201.15","Data":"No Data","Tag":"AppInfo","Type":1,"OperationName":null,"UserContext":null,"Path":null,"Process":null}
//{"Id":6,"Time":"2014-11-07T16:12:36.7509994+01:00","ThreadId":7,"Message":"Mode: Open | DesiredAccess: Synchronize | FlagsAndAttributes: Directory | ShareMode: None","Data":"No Data","Tag":"No Tag","Type":1,"OperationName":"OpenFile ","UserContext":"0","Path":"\\","Process":"vmtoolsd.exe"}

#import "LoggerSecMessage.h"

@implementation LoggerSecMessage

- (instancetype)initWithData:(NSData *)data connection:(LoggerConnection *)aConnection
{
    self = [super init];
    
    if(self)
    {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        if(![((NSString*)json[@"Tag"]) isEqualToString:@"No Tag"]) {
            self.tag = (NSString *)json[@"Tag"];
        }
        
        self.message = [self messageFromJson:json];
        self.level = self.type;
        
        if(json[@"ThreadId"] != [NSNull null]) {
            self.threadID = [NSString stringWithFormat:@"%@", json[@"ThreadId"]];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
        
        NSDate *date = [dateFormat dateFromString:json[@"Time"]];
        struct timeval ts = self.timestamp;
        ts.tv_sec = (__darwin_time_t) [date timeIntervalSince1970];
        self.timestamp = ts;
    }
    return self;
}


- (NSString *)messageFromJson:(NSDictionary *)json {
    
    NSMutableString *result = [[NSMutableString alloc] init];
    if(json[@"Duration"] != [NSNull null]) {
        [result appendFormat:@"%@ | ", json[@"Duration"]];
    }
    if(json[@"Process"] != [NSNull null]) {
        [result appendFormat:@"%@ | ", json[@"Process"]];
    }
    if(json[@"OperationName"] != [NSNull null]) {
        [result appendFormat:@"%@ | ", json[@"OperationName"]];
    }
    if(json[@"Path"] != [NSNull null]) {
        [result appendFormat:@"%@ | ", json[@"Path"]];
    }
    if(json[@"FileUserContext"] != [NSNull null]) {
        [result appendFormat:@"FileUserContext: %@ | ", json[@"FileUserContext"]];
    }
    if(json[@"HandleUserContext"] != [NSNull null]) {
        [result appendFormat:@"HandleUserContext: %@ | ", json[@"HandleUserContext"]];
    }
    [result appendFormat:@"%@", json[@"Message"]];
    if(![((NSString*)json[@"Data"]) isEqualToString:@"No Data"]) {
        [result appendFormat:@"\r\n%@ ", json[@"Data"]];
    }
    return [result copy];
}

@end
