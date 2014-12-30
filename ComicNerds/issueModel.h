//
//  issueModel.h
//  MyComics
//
//  Created by Michael Thomas on 8/7/14.
//
//

#import <Foundation/Foundation.h>

@protocol issueModelDelegate <NSObject>

- (void)itemsRetrieved:(NSArray *)items;

@end

@interface issueModel : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<issueModelDelegate> delegate;

- (void)getItems:(NSNumber *)volume;


@end
