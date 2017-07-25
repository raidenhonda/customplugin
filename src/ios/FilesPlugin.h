//
//  FilesPlugin.h
//  ClickMobileCDV
//
//  Created by ClickMobile Touch Team on 10/7/14.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <Cordova/CDV.h>
#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
#import <AWSCognito/AWSCognito.h>


typedef enum {
    upload = 1,
    download
}FileState;

@interface FilesPlugin : CDVPlugin <UIDocumentInteractionControllerDelegate>{
    NSString *localFile;
    
}
@end
