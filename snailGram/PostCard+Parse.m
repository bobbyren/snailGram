//
//  PostCard+Parse.m
//  snailGram
//
//  Created by Bobby Ren on 3/3/14.
//  Copyright (c) 2014 SnailGram. All rights reserved.
//

#import "PostCard+Parse.h"
#import "Payment+Parse.h"

@implementation PostCard (Parse)

-(NSString *)className {
    return @"PostCard";
}

+(PostCard *)fromPFObject:(PFObject *)object {
    id parseID = object.objectId;
    NSArray *objectArray = [[PostCard where:@{@"id":parseID}] all];
    PostCard *obj;
    if ([objectArray count]) {
        obj = [objectArray firstObject];
    }
    else {
        obj = (PostCard *)[PostCard createEntityInContext:_appDelegate.managedObjectContext];
    }
    obj.pfObject = object;
    [obj updateFromParse];
    return obj;
}

-(void)updateFromParse {
    [super updateFromParse];

    self.image_url = self.pfObject[@"image_url"];
    self.image_url_back = self.pfObject[@"image_url_back"];
    self.text = self.pfObject[@"text"];
    self.message = self.pfObject[@"message"];
    self.parseID = self.pfObject.objectId;
    self.front_loaded = self.pfObject[@"front_loaded"];
    self.back_loaded = self.pfObject[@"back_loaded"];
    self.payment_id = self.pfObject[@"payment_id"];

    self.payment = self.pfObject[@"payment"];
}

-(void)saveOrUpdateToParseWithCompletion:(void (^)(BOOL))completion {
    if (!self.pfObject)
        self.pfObject = [PFObject objectWithClassName:self.className];

    if (self.image_url)
        self.pfObject[@"image_url"] = self.image_url;
    if (self.image_url_back)
        self.pfObject[@"image_url_back"] = self.image_url_back;
    if (self.text)
        self.pfObject[@"text"] = self.text;
    if (self.message)
        self.pfObject[@"message"] = self.message;
    if (self.front_loaded)
        self.pfObject[@"front_loaded"] = self.front_loaded;
    if (self.back_loaded)
        self.pfObject[@"back_loaded"] = self.back_loaded;
    if (self.payment_id)
        self.pfObject[@"payment_id"] = self.payment_id;
    if (_currentUser) {
        self.pfObject[@"user"] = _currentUser;
        self.pfObject[@"pfUserID"] = _currentUser.objectId;
    }
    
    // relationships
    if (self.payment)
        self.pfObject[@"payment"] = self.payment.pfObject;
    
    [self.pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            self.parseID = self.pfObject.objectId;
        if (completion)
            completion(succeeded);
    }];
}

@end
