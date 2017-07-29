//
//  Node.m
//  GraphTraversal
//
//  Created by Douglas Voss on 7/29/17.
//  Copyright © 2017 VossWareLLC. All rights reserved.
//

#import "Node.h"

@implementation Node

-(NSString *)description {
    
    NSMutableString *desc = [NSMutableString new];
    //[desc appendFormat:@"%d adjacent nodes\n", self.adjacentNodes.count];
    //[desc appendFormat:@"data: %d\n", self.data];
    //[desc appendFormat:@"row: %d column: %d\n", self.row, self.column];
    [desc appendFormat:@"[%d][%d]:%d", self.row, self.column, self.data];
    
    return desc;
}


-(id)copyWithZone:(NSZone *)zone {
    Node *copiedNode = [[[self class] allocWithZone:zone] init];
    
    copiedNode.row = self.row;
    copiedNode.column = self.column;
    copiedNode.data = self.data;
    copiedNode.adjacentNodes = self.adjacentNodes;
    
    return copiedNode;
}


-(BOOL)visitedMatchCheck:(Node *)compareNode {
    return (self.data == compareNode.data &&
            self.row == compareNode.row &&
            self.column == compareNode.column);
}

@end
