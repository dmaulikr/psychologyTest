//
//  BasicInfo.h
//  psychologyTest
//
//  Created by stanley_Hwang on 4/24/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//


#import <DBAccess/DBAccess.h>

@interface BasicInfo : DBObject

@property NSNumber*    user_id;

@property NSString*    birthday;

@property NSString*    degree;

@property NSNumber*    degree_id;

@property NSString*    degree_name;

@property NSString*    department;

@property NSNumber*    department_id;

@property NSString*    department_num;

@property NSString*    department_name;

@property NSString*    enrollment;

@property NSString*    enrollment_id;

@property NSString*    enrollment_status;

@property NSString*    file_num;

@property NSNumber*    gender_id;

@property NSString*    gender;

@property NSNumber*    grade_id;

@property NSString*    grade_name;

@property NSNumber*    head_pic_id;

@property NSString*    head_pic_url;

@property NSNumber*    info_complete;
// id

// info_updated

// init_time

@property NSString*    major;

@property NSString*    name;

@property NSString*    school_name;

@property NSNumber*    school_id;

@property NSString*    school_number;

@property NSNumber*    school_status;

@property NSNumber*    status;

@property NSString*    student_num;

@property NSNumber*    student_type_id;

@property NSNumber*    type_id;

@property NSString*    type_name;

@property NSString*    update_time;

+ (NSMutableDictionary *)toDictionary;

@end
