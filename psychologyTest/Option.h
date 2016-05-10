//
//  Selection.h
//  psychologyTest
//
//  Created by stanley_Hwang on 12/20/15.
//  Copyright © 2015 stanley_Hwang. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface Option : DBObject

@property int               optionID;

@property NSString*         content;

@property int               questionID;

@end
