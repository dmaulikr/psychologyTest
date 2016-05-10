//
//  FamilyInfo.h
//  psychologyTest
//
//  Created by stanley_Hwang on 4/15/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface FamilyInfo : DBObject

@property NSNumber*     user_id;

@property NSString*     father_status;

@property NSNumber*     father_age;

@property NSString*     father_profession;

@property NSString*     father_telephone;

@property NSString*     father_education;

@property NSString*     mother_status;

@property NSNumber*     mother_age;

@property NSString*     mother_profession;

@property NSString*     mother_telephone;

@property NSString*     mother_education;

@property NSNumber*     brother_sister_count;

@property NSNumber*     family_rank;

@property NSString*     parents_marriage;

@property NSNumber*     parents_marriage_status;

@property NSNumber*     parents_marriage_id;

@property NSString*     emergency_name;

@property NSString*     emergency_telephone;

@property NSNumber*     student_id;

@property NSNumber*     family_id;

@property NSString*     emergency_relation;


+ (NSMutableDictionary *)toDictionary;

@end
