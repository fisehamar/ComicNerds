//
//  comicInfo.h
//  MyComics
//
//  Created by Michael Thomas on 8/1/14.
//
//

#import <Foundation/Foundation.h>

@interface comicInfo : NSObject

@property (nonatomic, strong) NSString *volumeName;      
@property (nonatomic, strong) NSNumber *issueCount;
@property (nonatomic, strong) NSNumber *volumeID;
@property (nonatomic, strong) NSString *publisherName;
@property (assign) BOOL hasBeenAdded;

@end
