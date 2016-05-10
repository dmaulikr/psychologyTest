
//
//  BasicInfo.m
//  psychologyTest
//
//  Created by stanley_Hwang on 4/24/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicInfo.h"

@implementation BasicInfo

@dynamic user_id, degree, degree_id, degree_name, department, department_id, department_num, department_name, enrollment, enrollment_id, enrollment_status, file_num, gender, grade_id, grade_name, head_pic_id, head_pic_url, major, name, school_name,
school_id, school_number, school_status, status, student_num, student_type_id, type_id, type_name, update_time, birthday, gender_id, info_complete;


+ (NSMutableDictionary *)toDictionary {
    NSNumber* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    BasicInfo* object = [[[[BasicInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"id"];
    [dic setObject:object.student_num forKey:@"student_num"];
    [dic setObject:object.name forKey:@"name"];
    
    [dic setObject:object.major forKey:@"major"];
    [dic setObject:object.student_num forKey:@"student_num"];
    [dic setObject:object.gender_id forKey:@"gender_id"];
    [dic setObject:object.birthday forKey:@"birthday"];
    [dic setObject:object.school_id forKey:@"school_id"];
    [dic setObject:object.department_id forKey:@"department_id"];
    [dic setObject:object.degree_id forKey:@"degree_id"];
    [dic setObject:object.grade_id forKey:@"grade_id"];
    [dic setObject:object.head_pic_id forKey:@"head_pic_id"];
    [dic setObject:object.student_type_id forKey:@"student_type_id"];
    [dic setObject:object.info_complete forKey:@"info_complete"];
    
    
    return nil;
}


@end