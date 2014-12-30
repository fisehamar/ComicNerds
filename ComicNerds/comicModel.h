//
//  comicModel.h
//  MyComics
//
//  Created by Michael Thomas on 8/1/14.
//
//

#import <Foundation/Foundation.h>

@protocol comicModelDelegate <NSObject>

- (void)itemsRetrieved:(NSArray *)items;

@end

@interface comicModel : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<comicModelDelegate> delegate;

- (void)getItems:(NSString *)searchQuery;

@end
