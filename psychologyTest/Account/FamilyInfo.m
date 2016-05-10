//
//  FamilyInfo.m
//  psychologyTest
//
//  Created by stanley_Hwang on 4/15/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FamilyInfo.h"

@implementation FamilyInfo

@dynamic user_id, father_status, father_age, father_profession, father_education, father_telephone, mother_age, mother_education, mother_profession, mother_status, mother_telephone, emergency_name, emergency_telephone, brother_sister_count, parents_marriage, parents_marriage_id, parents_marriage_status, family_id, emergency_relation, family_rank;


+ (NSMutableDictionary *) toDictionary {
    NSNumber* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    FamilyInfo* object = [[[[FamilyInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:object.brother_sister_count forKey:@"brother_sister_count"];
    [dic setObject:object.emergency_name forKey:@"emergency_name"];
    [dic setObject:object.emergency_relation forKey:@"emergency_relation"];
    [dic setObject:object.emergency_telephone forKey:@"emergency_telephone"];
    [dic setObject:object.family_rank forKey:@"family_rank"];
    [dic setObject:object.father_age forKey:@"father_age"];
    [dic setObject:object.father_education forKey:@"father_education"];
    [dic setObject:object.father_profession forKey:@"father_profession"];
    [dic setObject:object.father_status forKey:@"father_status"];
    [dic setObject:object.father_telephone forKey:@"father_telephone"];
    [dic setObject:object.mother_age forKey:@"mother_age"];
    [dic setObject:object.mother_education forKey:@"mother_education"];
    [dic setObject:object.mother_profession forKey:@"mother_profession"];
    [dic setObject:object.mother_status forKey:@"mother_status"];
    [dic setObject:object.mother_telephone forKey:@"mother_telephone"];
    NSMutableDictionary* parents_marriage_dic = [[NSMutableDictionary alloc] init];
    [parents_marriage_dic setObject:object.parents_marriage_id forKey:@"id"];
    [parents_marriage_dic setObject:object.parents_marriage forKey:@"marriage"];
    [parents_marriage_dic setObject:object.parents_marriage_status forKey:@"status"];
    [dic setObject:parents_marriage_dic forKey:@"parents_marriage"];
    [dic setObject:object.parents_marriage_id forKey:@"parents_marriage_id"];
    [dic setObject:object.student_id forKey:@"student_id"];
    return dic;
}

@end