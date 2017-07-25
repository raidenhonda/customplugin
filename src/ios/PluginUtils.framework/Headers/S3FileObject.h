//
//  S3FileObject.h
//  ClickMobileCDV
//
//  Created by ClickMobile Touch Team on 11/01/2016.
//
//

#import <Foundation/Foundation.h>

@interface S3FileObject : NSObject

    @property(strong,nonatomic) NSString *bucket;
    @property(strong,nonatomic) NSString *originalFileName;
    @property(strong,nonatomic,setter=setwithoutGUIDFileName:,getter=withoutGUIDFileName) NSString *withoutGUIDFileName;
    @property(strong,nonatomic) NSString *fileUrl;
    @property(strong,nonatomic) NSString *s3AccessKey;
    @property(strong,nonatomic) NSDate *s3ExpireTime;
    @property(strong,nonatomic) NSString *s3SecretKey;
    @property(strong,nonatomic) NSString *AWSRegion;
    @property(strong,nonatomic) NSString *s3SessionToken;
    @property(strong,nonatomic) NSString *tenant;
    @property(strong,nonatomic) NSString *userName;

- (void) setwithoutGUIDFileName:(NSString *)withoutGUIDFileName;
- (NSString*) withoutGUIDFileName;

@end
