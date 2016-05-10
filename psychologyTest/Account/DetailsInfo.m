//
//  DetailsInfo.m
//  psychologyTest
//
//  Created by stanley_Hwang on 4/15/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsInfo.h"

@implementation DetailsInfo

@dynamic user_id, address, mail, cellphone, dormetry, enrollment_status, current_status, ethnic_group, graduate_school, is_recommended, is_art_student, is_poor_student, is_recommended_by_contest, native_place_id, native_place_province, native_place_status, political_status, political_status_id, political_status_status, religion_id, religion_name, religion_status,source_area_id, source_area_province, source_area_status, student_id, telephone, zip_code;

+ (NSMutableDictionary *)toDictionary {
    NSNumber* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    DetailsInfo* object = [[[[DetailsInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:userId forKey:@"id"];
    [dic setObject:object.religion_id forKey:@"religion_id"];
//    [dic setObject:object.student_type forKey:@""];
    [dic setObject:object.source_area_id forKey:@"source_area_id"];
//    [dic setObject:object.residence forKey:@""];
//    [dic setObject:object.birthday forKey:@""];
    [dic setObject:object.address forKey:@"address"];
    [dic setObject:object.zip_code forKey:@"zip_code"];
    [dic setObject:object.dormetry forKey:@"dormetry"];
    [dic setObject:object.mail forKey:@"mail"];
    [dic setObject:object.telephone forKey:@"telephone"];
    [dic setObject:object.cellphone forKey:@"cellphone"];
    [dic setObject:object.enrollment_status forKey:@"enrollment_status"];
    [dic setObject:object.current_status forKey:@"current_status"];
    [dic setObject:object.political_status forKey:@"political_status"];
    [dic setObject:object.ethnic_group forKey:@"ethnic_group"];
    [dic setObject:object.graduate_school forKey:@"graduate_school"];
    [dic setObject:object.is_recommended forKey:@"is_recommended"];
    [dic setObject:object.is_recommended_by_contest forKey:@"is_recommended_by_contest"];
    [dic setObject:object.is_art_student forKey:@"is_art_student"];
    [dic setObject:object.is_poor_student forKey:@"is_poor_student"];
    [dic setObject:object.native_place_province forKey:@"native_place"];
    
//    [dic setObject:object.student_status forKey:<#(nonnull id<NSCopying>)#>]
//    [dic setObject:object.education_status forKey:@""];
    
    // customer settings
//    [dic setObject:object.update_time forKey:@"update_time"];
//    [dic setObject:object.status forKey:@"status"];
    return dic;
}

@end