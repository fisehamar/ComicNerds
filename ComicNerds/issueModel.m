//
//  issueModel.m
//  MyComics
//
//  Created by Michael Thomas on 8/7/14.
//
//

#import "issueModel.h"
#import "issueInfo.h"

@implementation issueModel
{
    NSMutableData *retrievedData;
}

- (void)getItems:(NSNumber *)volume
{
    NSString *url = [NSString stringWithFormat:@"http://www.comicvine.com/api/issues/?api_key=83e9c317513c910e43056bd5c694a7b91619388e&format=JSON&filter=volume:%@", volume];
    
    NSLog(@"URL %@",url);
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:url];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    retrievedData = [[NSMutableData alloc] init];
    NSLog(@"retrieved Data %@", retrievedData);
    NSLog(@"URL Respons %@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [retrievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableDictionary *_objects = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *_comics = [[NSMutableArray alloc]init];
    
    //NSLog(@"did recieve data%@", retrievedData);
    
    // Parse the JSON that came in
    NSError *error;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:retrievedData  options:NSJSONReadingMutableLeaves error:&error];
    
    //NSLog(@"Json %@", jsonArray);
    
    _objects = [jsonArray objectForKey:@"results"];
    
    //NSLog(@"%@", _objects);
    
    // Create a new team object and set its props to JsonElement properties
    for (int i = 0; i < _objects.count; i++)
    {
        issueInfo *info = [[issueInfo alloc]init];
        
        NSDictionary *images = (NSDictionary *)[[_objects valueForKey:@"image"]objectAtIndex:i];
        
        //NSLog(@"%@", images);
        info.issueID = [[_objects valueForKey:@"id"]objectAtIndex:i];
        
        info.issueNumber = [[_objects valueForKey:@"issue_number"]objectAtIndex:i];
        
        info.imageIconURL = [images valueForKey:@"icon_url"];
        
        info.imageMediumURL = [images valueForKey:@"medium_url"];
        
        info.coverDate = [[_objects valueForKey:@"cover_date"]objectAtIndex:i];
        
        info.issueName = [[_objects valueForKey:@"name"]objectAtIndex:i];
        
        info.comicDescription = [[_objects valueForKey:@"description"]objectAtIndex:i];
        
        info.issueAPIURL = [NSString stringWithFormat:@"%@?api_key=83e9c317513c910e43056bd5c694a7b91619388e&format=JSON",[[_objects valueForKey:@"api_detail_url"]objectAtIndex:i]];
        
        //NSLog(@"Issue api url%@",info.issueAPIURL);
        
        [_comics addObject:info];
    }
    
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsRetrieved:_comics];
    }
}


@end
