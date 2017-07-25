//
//  FilesPlugin.m
//  ClickMobileCDV
//
//  Created by ClickMobile Touch Team on 10/7/14.
//
//

#import "FilesPlugin.h"
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import <PluginUtils/QSStrings.h>
#import <CoreLocation/CoreLocation.h>
#import "CDVFile.h"
#import <PluginUtils/S3FileObject.h>
#import <MobileCoreServices/MobileCoreServices.h>

//#import "AWSS3Model.h"
//#import <AWSS3/AWSS3Model.h>


@interface AWSCustomCredinalProvider : NSObject<AWSCredentialsProvider>
    
    @property (nonatomic, readonly) NSString *accessKey;
    @property (nonatomic, readonly) NSString *secretKey;
    @property (nonatomic, readonly) NSString *sessionKey;
    @property (nonatomic, readonly) NSDate   *expiration;
    @property (nonatomic, strong) AWSExecutor *refreshExecutor;
    
    
+ (instancetype)credentialsWithAccessKey:(NSString *)accessKey
                               secretKey:(NSString *)secretKey sessionKey:(NSString*)sessionKey expiration:(NSDate*)expiration;
    
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey sessionKey:(NSString*)sessionKey expiration:(NSDate*)expiration;
    
    @end

static NSString *const AWSCredentialsProviderKeychainAccessKeyId = @"accessKey";
static NSString *const AWSCredentialsProviderKeychainSecretAccessKey = @"secretKey";
static NSString *const AWSCredentialsProviderKeychainSessionToken = @"sessionKey";
static NSString *const AWSCredentialsProviderKeychainExpiration = @"expiration";


@implementation AWSCustomCredinalProvider
    @synthesize accessKey=_accessKey;
    @synthesize secretKey=_secretKey;
    @synthesize sessionKey=_sessionKey;
    
    @synthesize expiration=_expiration;
    
+ (instancetype)credentialsWithAccessKey:(NSString *)accessKey
                               secretKey:(NSString *)secretKey sessionKey:(NSString*)sessionKey expiration:(NSDate*)expiration
    {
        AWSCustomCredinalProvider *credentials = [[AWSCustomCredinalProvider alloc]initWithAccessKey:accessKey secretKey:secretKey sessionKey:sessionKey expiration:expiration];
        return credentials;
    }
    
- (instancetype)initWithAccessKey:(NSString *)accessKey
                        secretKey:(NSString *)secretKey sessionKey:(NSString*)sessionKey expiration:(NSDate*)expiration
    {
        if (self = [super init]) {
            
            _accessKey = accessKey;
            _secretKey = secretKey;
            _sessionKey = sessionKey;
            _expiration = expiration;
            
        }
        return self;
    }
    
- (NSString *)accessKey {
    @synchronized(self) {
        if (!_accessKey) {
            
        }
        return _accessKey;
    }
}
    
- (NSString *)secretKey {
    @synchronized(self) {
        if (!_secretKey) {
            
        }
        return _secretKey;
    }
}
    
- (NSString *)sessionKey {
    @synchronized(self) {
        if (!_sessionKey) {
            
        }
        return _sessionKey;
    }
}
    
    
- (void)setAccessKey:(NSString *)accessKey {
    @synchronized(self) {
        _accessKey = accessKey;
        
    }
}
    
- (void)setSecretKey:(NSString *)secretKey {
    @synchronized(self) {
        _secretKey = secretKey;
        
    }
}
    
- (void)setSessionKey:(NSString *)sessionKey {
    @synchronized(self) {
        _sessionKey = sessionKey;
        
    }
}
    
- (void)setexpiration:(NSDate *)expiration {
    @synchronized(self) {
        _expiration = expiration;
        
    }
}
    
    @end




@interface FilesPlugin ()
    @property(nonatomic,strong) S3FileObject *fileObj;
    @end

@implementation FilesPlugin
    
#define S3InitNotifaction @"S3InitNotifaction"
    
    
    @synthesize fileObj;
    
    typedef int FileError;
    
- (void) openWith:(CDVInvokedUrlCommand*)command
    {
        CDVPluginResult * pluginResult;
        NSString* callbackID = command.callbackId;
        //    [callbackID retain];
        
        NSString* path = [command.arguments objectAtIndex:0];
        //    [path retain];
        
        //    NSString* uti = @"public.jpeg";
        //    [uti retain];
        
        
        //UTI
        NSDictionary *inventory = @{
                                    @"jpg" : @"public.jpeg",
                                    @"jpeg" : @"public.jpeg",
                                    @"png" : @"public.png",
                                    @"tif" : @"public.jpeg",
                                    @"tiff" : @"public.jpeg",
                                    @"pdf" : @"com.adobe.pdf",
                                    @"doc" : @"com.microsoft.word.doc",
                                    @"docx" : @"org.openxmlformats.wordprocessingml.document",
                                    @"bmp" : @"com.microsoft.bmp",
                                    @"xls" : @"com.microsoft.excel.xls",
                                    @"ppt" : @"com.microsoft.powepoint.?ppt",
                                    @"txt" : @"public.plain-text",
                                    @"html" : @"public.html",
                                    @"htm" : @"public.html",
                                    @"xml" : @"public.xml",
                                    @"xlsx" : @"org.openxmlformats.spreadsheetml.sheet",
                                    @"gif" : @"com.compuserve.gif",
                                    @"psd" : @"com.adobe.photoshop-?image",
                                    };
        
        //    [inventory retain];
        //    const CFStringRef  kUTTagClassFilenameExtension ;
        
        //warning removal
        //    CFStringRef fileExtension = (CFStringRef) [path pathExtension];
        //end-warning removal
        
        NSString *value = [inventory objectForKey:[path pathExtension]];
        //CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        //UTI
        
        
        NSURL* fileURL = [NSURL fileURLWithPath:path];
        //    NSURL *fileURL = [NSURL fileURLWithPath:localFile];
        NSLog(@"fileURL: %@",fileURL);
        UIDocumentInteractionController* controller = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        //    [controller retain];
        controller.delegate = self;
        controller.UTI = value;
        //    BOOL result = [controller presentPreviewAnimated:YES];
        
        //    MainViewController* cont = (MainViewController*)[self viewController];
        
        BOOL result = [controller presentPreviewAnimated:YES];
        //    [self setupControllerWithURL:fileURL usingDelegate:self];
        if (result == YES)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@""];
        }
        //    [self writeJavascript:[pluginResult toSuccessCallbackString:callbackID]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
        
        //    [callbackID release];
        //    [path release];
        //    [uti release];
        //    [inventory release];
    }
    
    
    
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"File URL: %@",fileURL);
    
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    //    [interactionController retain];
    [interactionController presentPreviewAnimated:YES];
    return interactionController;
}
    
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
    {
        return [self viewController];
    }
    
    
- (void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
    {
        NSLog(@"documentInteractionControllerDidDismissOpenInMenu");
        [self cleanupTempFile:controller];
    }
    
- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
    {
        NSLog(@"didEndSendingToApplication: %@",application);
        [self cleanupTempFile:controller];
    }
    
- (void) cleanupTempFile:(UIDocumentInteractionController *)controller
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error;
        BOOL fileExists = [fileManager fileExistsAtPath:localFile];
        
        NSLog(@"Path to file: %@", localFile);
        NSLog(@"File exists: %d", fileExists);
        NSLog(@"Is deletable file or path: %d", [fileManager isDeletableFileAtPath:localFile]);
        
        if (fileExists)
        {
            BOOL success = [fileManager removeItemAtPath:localFile error:&error];
            if (!success) NSLog(@"Error: %@",[error localizedDescription]);
        }
        //    [localFile release];
        //    [controller release];
    }
    
- (void) previewFile:(CDVInvokedUrlCommand*)command
    {
        //PluginResult* pluginResult;
        //    NSString* callbackID = command.callbackId;
        //    [callbackID retain];
        
        NSString* path = [command.arguments objectAtIndex:0];
        //    [path retain];
        
        NSString* uti = [command.arguments objectAtIndex:1];
        //    [uti retain];
        
        NSLog(@"path %@, uti:%@",path, uti);
        NSURL * fileURL = [NSURL fileURLWithPath:path];
        
        [self setupControllerWithURL:fileURL usingDelegate:self];
        
    }
    
- (void) writeBinaryData:(CDVInvokedUrlCommand*)command
    {
        NSString* callbackId = command.callbackId;
        NSString* argFileName = [command.arguments objectAtIndex:0];
        NSString* argData = [command.arguments objectAtIndex:1];
        unsigned long long pos = (unsigned long long)[[ command.arguments objectAtIndex:1] longLongValue];
        
        //NSString* fileName = argFileName;
        
        [self truncateFile:argFileName atPosition:pos];
        
        [self writeBinaryToFile: argFileName withData:argData append:YES callback: callbackId];
    }
    
- (void) writeBinaryToFile:(NSString*)fileName withData:(NSString*)data append:(BOOL)shouldAppend callback: (NSString*) callbackId
    {
        CDVPluginResult * result = nil;
        //    warning removal
        //    NSString* jsString = nil;
        
        //    idan ofek - warning removeal
        //    FileError errCode = INVALID_MODIFICATION_ERR;
        
        int bytesWritten = 0;
        
        //NSRange range = [data rangeOfString:@","];
        //NSString *fixedDataString = [data substringFromIndex:(range.location + 1)];
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* dirName = [userDefaults stringForKey:@"user_name"];
        
        NSData * encData = [QSStrings decodeBase64WithString:data];
        
        NSString * dirPath = [NSString stringWithFormat:@"Documents/ClickMobile/%@",dirName];
        
        NSString * documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
        NSString * fullPath = [documentsDir stringByAppendingPathComponent:fileName];
        
        NSLog(@"Full path %@", fullPath);
        
        
        
        if (fullPath) {
            NSOutputStream* fileStream = [NSOutputStream outputStreamToFileAtPath:fullPath append:shouldAppend ];
            
            if (fileStream) {
                
                NSError* error = [fileStream streamError];
                
                //            NSUInteger len = [ encData length ];
                
                [ fileStream open ];
                
                bytesWritten =
                (int)[ fileStream write:[encData bytes]
                              maxLength:(int)[ encData length ]];
                
                [ fileStream close ];
                
                if (bytesWritten > 0) {
                    
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fullPath];
                    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
                    
                    //warning removel
                    //
                    //                jsString = [result toSuccessCallbackString:callbackId];
                    
                    //} else {
                    // can probably get more detailed error info via [fileStream streamError]
                    //errCode already set to INVALID_MODIFICATION_ERR;
                    //bytesWritten = 0; // may be set to -1 on error
                }
                else
                {
                    if (error)
                    NSLog(@"Error: %@",[error localizedDescription]);
                }
            } // else fileStream not created return INVALID_MODIFICATION_ERR
        }
        
        
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        
        //warning removel
        //    if(!jsString) {
        ////        // was an error
        ////        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: errCode cast: @"window.localFileSystem._castError"];
        //        jsString = [result toErrorCallbackString:callbackId];
        //    }
        //    [self writeJavascript: jsString];
        
    }
    
- (unsigned long long) truncateFile:(NSString*)filePath atPosition:(unsigned long long)pos
    {
        
        unsigned long long newPos = 0UL;
        
        NSFileHandle* file = [ NSFileHandle fileHandleForWritingAtPath:filePath];
        if(file)
        {
            [file truncateFileAtOffset:(unsigned long long)pos];
            newPos = [ file offsetInFile];
            [ file synchronizeFile];
            [ file closeFile];
        }
        return newPos;
    }
    
    
#pragma mark S3 - Plugin methods to use with Bucket
    
- (NSString*) fileMIMEType:(NSString*) file {
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[file pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    return (__bridge NSString *)MIMEType;
}
    
    
-(NSArray *)findFilesByPartName :(NSString*)beginDir partFileName:(NSString *)partFileName
    {
        NSMutableArray *matches = [[NSMutableArray alloc]init];
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *item;
        NSArray *contents = [manager contentsOfDirectoryAtPath:
                             [NSHomeDirectory() stringByAppendingPathComponent:beginDir] error:nil];
        for (item in contents)
        {
            if ( [item containsString:partFileName])
            {
                [matches addObject:item];
            }
        }
        
        return matches;
    }
    
    
    /**
     *
     *  method return number of file found in bucket name
     *  @param bucket   s3 bucket name
     *  @param maxKeys  s3 max keys to look for
     *  @param prefix   s3 prefix to look for
     *  @param fileName file name to look fo in the folder bukcet
     *
     *  @return - callback to uniq file number [serial of 1] by number names
     */
- (void)getUniqNameForFile:(NSString*)bucket maxKeys:(NSNumber*)maxKeys prefix:(NSString*)prefix fileToFindName:(NSString*)fileName compleationBlock:(void (^)(NSString* uniqFileName))compleationBlock
    {
        
        //    old method of file name - index the file name
        //    __block int numberValueFile=1;
        //    AWSS3 *s3 = [AWSS3 defaultS3];
        //    AWSS3ListObjectsRequest *listObjectsRequest = [AWSS3ListObjectsRequest new];
        //    listObjectsRequest.bucket = bucket;
        //    listObjectsRequest.maxKeys = maxKeys;
        //    listObjectsRequest.prefix = prefix;
        //    [[s3 listObjects:listObjectsRequest] continueWithBlock:^id(AWSTask *task) {
        //
        //        AWSS3ListObjectsOutput *listObjectsOutput = task.result;
        //        for (AWSS3Object *s3Object in listObjectsOutput.contents) {
        //            if ([s3Object.key containsString:fileName])
        //                numberValueFile+=1;
        //        }
        //
        //        compleationBlock([NSString stringWithFormat:@"%@%@_%@",prefix,[NSNumber numberWithInt:numberValueFile],fileName]);
        //
        //        return nil;
        //    }];
        //    end - old method of file name - index the file name
        
        //  Idan Ofek :
        //bug - #75169 - Files that are saved in chrome PC, downloaded on a mobile device and uploaded again have a combined name - file name+ExternalURL_SO
        //sln : get file name :
        compleationBlock([NSString stringWithFormat:@"%@%@",prefix,fileName]);
        //end - bug - #75169 - Files that are saved in chrome PC, downloaded on a mobile device and uploaded again have a combined name - file name+ExternalURL_SO
        
        //    return [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:numberValueFile]];
        
    }
    
    
    /**
     *  Util method - put into object
     *
     *  @param Parmams The Command arguemts from plugin
     */
-(void)initS3Object:(CDVInvokedUrlCommand*)Parmams
    {
        
        [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
        
        //    should do one init and one init only
        if (!fileObj) {
            fileObj = [[S3FileObject alloc] init];
        }
        
        @try {
            NSDictionary *json = [Parmams.arguments objectAtIndex:0];
            if ([json isKindOfClass:[NSDictionary class]]){
                fileObj.bucket = json[@"bucket"];
                fileObj.originalFileName = json[@"fileName"];
                fileObj.withoutGUIDFileName = json[@"fileName"];
                fileObj.fileUrl = json[@"fileUrl"];
                fileObj.s3AccessKey = json[@"s3AccessKey"];
                fileObj.s3ExpireTime = json[@"s3ExpireTime"];
                fileObj.AWSRegion = json[@"awsRegion"];
                fileObj.s3SecretKey = json[@"s3SecretKey"];
                fileObj.s3SessionToken = json[@"s3SessionToken"];
                fileObj.tenant = json[@"tenant"];
                fileObj.userName = json[@"userName"];
            }
            
            //init s3 conenction
            //[{"AWSCredentials": {"BucketName": "na01-mobile-pr01","AccessKeyId": "AKIAILPRXFKCCQHZQWQQ","SecretAccessKey": "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"}}]
            //don't leave it open - it's not safe
            //        AWSStaticCredentialsProvider *credentialsProvider =
            //        [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"AKIAILPRXFKCCQHZQWQQ" secretKey:@"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"];
            
            //Access Key Id: AKIAIO22CZGUU7GZCE7Q
            //Secret Access Key : 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
            //        [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"AKIAIO22CZGUU7GZCE7Q" secretKey:@"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"];
            
            
            AWSCustomCredinalProvider *credentialsProvider = [[AWSCustomCredinalProvider alloc]
                                                              initWithAccessKey:fileObj.s3AccessKey secretKey:fileObj.s3SecretKey sessionKey:fileObj.s3SessionToken expiration:fileObj.s3ExpireTime];
            
            AWSRegionType regionType = AWSRegionEUWest1; //default value
            
            if ([fileObj.AWSRegion isEqualToString:@"eu-west-1"]) {
                regionType = AWSRegionEUCentral1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"eu-central-1"])
            {
                regionType = AWSRegionEUCentral1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"ap-northeast-1"])
            {
                regionType = AWSRegionAPNortheast1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"ap-northeast-2"])
            {
                regionType = AWSRegionAPNortheast2;
            }
            else if([fileObj.AWSRegion isEqualToString:@"ap-southeast-1"])
            {
                regionType = AWSRegionAPSoutheast1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"ap-southeast-2"])
            {
                regionType = AWSRegionAPSoutheast2;
            }
            else if([fileObj.AWSRegion isEqualToString:@"ap-south-1"])
            {
                regionType = AWSRegionAPSouth1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"us-west-1"])
            {
                regionType = AWSRegionUSWest1;
            }
            else if([fileObj.AWSRegion isEqualToString:@"us-west-2"])
            {
                regionType = AWSRegionUSWest2;
            }
            
            //        AWSRegionUSWest1
            AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:regionType credentialsProvider:credentialsProvider];
            AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
            
            
            //NSString *returnFileName = fileObj.fileUrl;
            
            
            //AWSRegion
            
            //                AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
            //                                                                      initWithRegionType:AWSRegionUSEast1
            //                                                                      identityPoolId:@"us-east-1:a29177bc-4c7c-4230-a9fc-334678ab5c45"];
            //
            //                AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
            //
            //                [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
            
            
            
            //        AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
            //                                                              initWithRegionType:AWSRegionUSEast1
            //                                                              identityPoolId:@"us-east-1:a29177bc-4c7c-4230-a9fc-334678ab5c45"];
            //
            //        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
            //
            //        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
            
        }
        @catch (NSException *exception) {
            NSLog(@"error with file conevetion %@",[exception description]);
        }
        
    }
    
    
-(NSString*)getFileNameWithAction:(FileState)state
    {
        NSString *returnFileName;
        switch (state) {
            case upload:
            {
                //                returnFileName =@"";
            }
            break;
            case download:
            {
                returnFileName=
                //                fileObj.fileName;
                [NSString stringWithFormat:@"%@/%@"
                 ,fileObj.tenant,fileObj.originalFileName];
            }
            break;
        }
        
        
        return returnFileName;
    }
    
    /**
     *  Plugin method - upload file into s3 bucket
     *
     *  @param command - params from web service [recvied from web site]
     */
-(void)uploadFile:(CDVInvokedUrlCommand*)command
    {
        [self initS3Object:command];
        
        
        //    NSString *tempUrl = [NSTemporaryDirectory() stringByAppendingPathComponent:fileObj.fileUrl];
        //    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        //    NSString* dirName = [userDefaults stringForKey:@"user_name"];
        
        
        
        NSString * dirPath = [NSString stringWithFormat:@"Documents/ClickMobile/%@",fileObj.userName];
        NSString * documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
        
        
        NSArray *filesArrValue =[self findFilesByPartName:[NSString stringWithFormat:@"Documents/ClickMobile/%@",fileObj.userName] partFileName:fileObj.withoutGUIDFileName];
        
        NSString *finalFileName = filesArrValue.lastObject;
        
        NSString *fullPath = [documentsDir stringByAppendingPathComponent:finalFileName];
        NSURL *fileURL =[NSURL fileURLWithPath:fullPath];  // The file to upload.
        
        //    NSString * dirPath = [NSString stringWithFormat:@"Documents/ClickMobile/%@",dirName];
        //    NSString * documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
        //    NSString * fullPath = [documentsDir stringByAppendingPathComponent:fileName];
        
        
        @try {
            
            [self getUniqNameForFile:fileObj.bucket
                             maxKeys:[NSNumber numberWithInt:100]
                              prefix:[NSString stringWithFormat:@"%@/",fileObj.tenant]
                      fileToFindName:fileObj.originalFileName compleationBlock:
             ^(NSString *uniqFileName) {
                 AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
                 __block CDVPluginResult *result;
                 
                 
                 AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask * _Nonnull task, NSError * _Nullable error) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // Do something e.g. Alert a user for transfer completion.
                         // On successful downloads, `location` contains the S3 object file URL.
                         // On failed downloads, `error` contains the error object.
                         
                         NSString *returnName = [NSString stringWithFormat:@"http://%@.s3.amazonaws.com/%@"
                                                 ,fileObj.bucket,uniqFileName];
                         
                         /**
                          *  When occurrences of tenant is duplactioed into the SO [url] object
                          */
                         if ([returnName containsString:[NSString stringWithFormat:@"/%@/%@/",fileObj.tenant,fileObj.tenant]]) {
                             [uniqFileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@/%@/",fileObj.tenant,fileObj.tenant]
                                                                     withString:[NSString stringWithFormat:@"/%@/",fileObj.tenant ]];
                             
                             
                             returnName = [NSString stringWithFormat:@"http://%@.s3.amazonaws.com/%@"
                                           ,fileObj.bucket,uniqFileName];
                         }
                         
                         
                         
                         result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnName];
                         
                         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                         
                     });
                 };
                 
                 
                 [[transferUtility uploadFile:fileURL
                                       bucket:fileObj.bucket
                                          key:uniqFileName
                                  contentType:[self fileMIMEType:fileURL.path]
                                   expression:nil
                             completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
                     if (task.error) {
                         
                         NSLog(@"Error: %@", task.error);
                         
                         result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[task.error description]];
                         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                         
                     }
                     if (task.result) {
                         
                     }
                     
                     return nil;
                 }];
                 
             }];
            
            
            
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
    }
    
    
    /**
     *  Plugin method - download file from s3 bucket
     *
     *  @param command - params from web service [recvied from web site]
     */
-(void)downloadFile:(CDVInvokedUrlCommand*)command
    {
        [self initS3Object:command];
        
        //    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //     __block NSString *tempUrl = [ [paths objectAtIndex:0] stringByAppendingPathComponent:fileObj.fileName];
        
        //    [NSHomeDirectory() stringByAppendingPathComponent:
        //                      [NSString stringWithFormat:@"/%@/%@/%@",fileObj.tenant,fileObj.userName,fileObj.fileName]];
        //    NSURL *documentsURL = [NSURL fileURLWithPath:tempUrl];
        
        //    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        //    NSString* dirName = [userDefaults stringForKey:@"user_name"];
        
        
        
        NSString * dirPath = [NSString stringWithFormat:@"Documents/ClickMobile/%@",fileObj.userName];
        NSString * documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:dirPath];
        
        //        NSString *finalFileName = [self findFilesByPartName:[NSString stringWithFormat:@"Documents/ClickMobile/%@",fileObj.userName] partFileName:fileObj.withoutGUIDFileName][0];
        //        NSString *fullPath = [documentsDir stringByAppendingPathComponent:finalFileName];
        NSString * fullPath = [documentsDir stringByAppendingPathComponent:fileObj.originalFileName];
        NSURL *fileURL =[NSURL fileURLWithPath:fullPath];  // The file to upload.
        
        NSURL *documentsURL = fileURL;
        
        
        __block CDVPluginResult *result;
        
        AWSS3TransferUtilityDownloadExpression *expression = [AWSS3TransferUtilityDownloadExpression new];
        
        AWSS3TransferUtilityDownloadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityDownloadTask *task, NSURL *location, NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Do something e.g. Alert a user for transfer completion.
                // On successful downloads, `location` contains the S3 object file URL.
                // On failed downloads, `error` contains the error object.
                
                NSString *valueFileReturnValue = fullPath;
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
                          valueFileReturnValue];
                
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            });
        };
        
        
        
        AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
        [[transferUtility downloadToURL:documentsURL
                                 bucket:fileObj.bucket
                                    key:[self getFileNameWithAction:download]
                             expression:expression
                       completionHander:completionHandler] continueWithBlock:^id(AWSTask *task) {
            if (task.error) {
                NSLog(@"Error: %@", task.error);
                
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[task.error description]];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
            if (task.result) {
                
                // Do something with downloadTask.
            }
            
            return nil;
        }];
        
        
    }
    
#pragma mark -
    
    
    
    @end
