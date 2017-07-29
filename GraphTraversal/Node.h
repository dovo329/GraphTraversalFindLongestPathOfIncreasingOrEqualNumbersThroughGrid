//
//  Node.h
//  GraphTraversal
//
//  Created by Douglas Voss on 7/29/17.
//  Copyright © 2017 VossWareLLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

@interface Node : NSObject<NSCopying>

@property (strong, nonatomic) NSMutableArray *adjacentNodes;
@property (assign, nonatomic) NSInteger data;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;


-(BOOL)visitedMatchCheck:(Node *)compareNode;


@end
