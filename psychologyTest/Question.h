//
//  Question.m
//  psychologyTest
//
//  Created by stanley_Hwang on 12/20/15.
//  Copyright © 2015 stanley_Hwang. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface Question : DBObject

@property int               questionID;

@property NSString*         content;

@property int               type;

@end