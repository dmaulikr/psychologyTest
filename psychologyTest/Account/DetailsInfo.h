//
//  DetailsInfo.h
//  psychologyTest
//
//  Created by stanley_Hwang on 4/15/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface DetailsInfo : DBObject

@property NSNumber*         user_id;

@property NSString*         address;

@property NSString*         mail;

@property NSString*         cellphone;

@property NSString*         dormetry;

@property NSString*         enrollment_status;

@property NSString*         current_status;

@property NSString*         ethnic_group;

@property NSString*         graduate_school;

@property NSNumber*         is_recommended_by_contest;

@property NSNumber*         is_recommended;

@property NSNumber*         is_art_student;

@property NSNumber*         is_poor_student;

@property NSString*         native_place_province;

@property NSNumber*         native_place_id;

@property NSNumber*         native_place_status;

@property NSNumber*         political_status_status;

@property NSNumber*         political_status_id;

@property NSString*         political_status;

@property NSNumber*         religion_id;

@property NSString*         religion_name;

@property NSNumber*         religion_status;

@property NSNumber*         source_area_id;

@property NSString*         source_area_province;

@property NSNumber*         source_area_status;

@property NSNumber*         student_id;

@property NSString*         telephone;

@property NSString*         zip_code;


+ (NSMutableDictionary *)toDictionary;

@end
