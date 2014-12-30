//
//  issueInfo.h
//  MyComics
//
//  Created by Michael Thomas on 8/7/14.
//
//

#import <Foundation/Foundation.h>

@interface issueInfo : NSObject

@property(nonatomic,strong) NSString *imageIconURL;
@property(nonatomic,strong) NSString *imageMediumURL;
@property(nonatomic,strong) NSNumber *issueNumber;
@property(nonatomic, strong) NSString *coverDate;
@property(nonatomic,strong) NSString *issueName;
@property(nonatomic, strong) NSString *comicDescription;
@property(nonatomic, strong) NSNumber *issueID;

@property(nonatomic, strong) NSString *issueAPIURL;

@end
