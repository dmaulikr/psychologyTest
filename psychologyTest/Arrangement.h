//
//  Arrangement.h
//  psychologyTest
//
//  Created by stanley_Hwang on 5/8/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface Arrangement : DBObject

@property NSNumber*         ampm;

@property NSString*         timeInterval;

@property NSString*         doctor;

@property NSNumber*         status;

@end