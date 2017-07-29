//
//  ViewController.m
//  GraphTraversal
//
//  Created by Douglas Voss on 7/29/17.
//  Copyright © 2017 VossWareLLC. All rights reserved.
//

#import "ViewController.h"
#import "Node.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define kGridHeight 3
#define kGridWidth 3

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *grid;
@property (strong, nonatomic) NSMutableArray *nodeGraph;

@property (strong, nonatomic) NSMutableArray *longestPathArr;
@property (assign, nonatomic) NSInteger maxDepth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Here is the grid.");

    self.grid = [NSMutableArray new];
    for (NSInteger r=0; r<kGridHeight; r++) {
        NSMutableArray *rowArr = [NSMutableArray new];
        for (NSInteger c=0; c<kGridWidth; c++) {
            NSInteger data = (((r+1)*78234)/(c+1)) % 10;
            NSNumber *num = [NSNumber numberWithInteger:data];
            [rowArr addObject:num];
        }
        [self.grid addObject:rowArr];
    }
    
    
    self.longestPathArr = [NSMutableArray new];
    self.maxDepth = 0;
    
    [self printGrid];
    
    [self createGraph];
    
    //[self traverseGraphFromRow:2 column:1];
    
    for (int r=0; r<self.nodeGraph.count; r++) {
        NSMutableArray *nodeGraphRowArr = self.nodeGraph[r];
        for (int c=0; c<nodeGraphRowArr.count; c++) {
            Node *root = (Node *)self.nodeGraph[r][c];
            
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nStarting search for root node %@", root);

            NSMutableArray *visitedNodeArr = [NSMutableArray new];
            NSInteger depth = 0;
            [self traverse:root visitedNodeArr:visitedNodeArr depth:depth];
        }
    }
//    Node *root = self.nodeGraph[2][1];
//    NSMutableArray *visitedNodeArr = [NSMutableArray new];
//    NSInteger depth = 0;
//    [self traverse:root visitedNodeArr:visitedNodeArr depth:depth];
    
    NSLog(@"\n\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\nLongest path found is of depth %d", self.maxDepth);
    for (Node *node in self.longestPathArr) {
        NSLog(@"%@", node);
    }
}


-(void)createGraph {
    
    // first pass just create nodes in the nodeGraph array
    self.nodeGraph = [NSMutableArray new];
    for (int r=0; r<self.grid.count; r++) {
        NSMutableArray *rowArr = self.grid[r];
        
        NSMutableArray *nodeRowArr = [NSMutableArray new];

        for (int c=0; c<rowArr.count; c++) {
            NSNumber *num = (NSNumber *)rowArr[c];
            //printf("%d", [num intValue]);
            
            Node *node = [Node new];
            node.data = [num integerValue];
            node.row = r;
            node.column = c;
            node.adjacentNodes = [NSMutableArray new];
            
            [nodeRowArr addObject:node];
        }
        [self.nodeGraph addObject:nodeRowArr];
    }
    
    //2nd pass need to hook up adjacent nodes
    for (int r=0; r<self.nodeGraph.count; r++) {
        
        NSMutableArray *nodeRowArr = self.nodeGraph[r];
        
        for (int c=0; c<nodeRowArr.count; c++) {
            
            Node *currentNode = (Node *)self.nodeGraph[r][c];
            
            if (c > 0) {
                Node *westNeighbor = self.nodeGraph[r][c-1];
                [currentNode.adjacentNodes addObject:westNeighbor];
            }
            if (r > 0 && c > 0) {
                Node *northWestNeighbor = self.nodeGraph[r-1][c-1];
                [currentNode.adjacentNodes addObject:northWestNeighbor];
            }
            if (r > 0) {
                Node *northNeighbor = self.nodeGraph[r-1][c];
                [currentNode.adjacentNodes addObject:northNeighbor];
            }
            if (r > 0 && c < nodeRowArr.count-1) {
                Node *northEastNeighbor = self.nodeGraph[r-1][c+1];
                [currentNode.adjacentNodes addObject:northEastNeighbor];
            }
            if (c < nodeRowArr.count-1) {
                Node *eastNeighbor = self.nodeGraph[r][c+1];
                [currentNode.adjacentNodes addObject:eastNeighbor];
            }
            if (r < self.nodeGraph.count-1 && c < nodeRowArr.count-1) {
                Node *southEastNeighbor = self.nodeGraph[r+1][c+1];
                [currentNode.adjacentNodes addObject:southEastNeighbor];
            }
            if (r < self.nodeGraph.count-1) {
                Node *southNeighbor = self.nodeGraph[r+1][c];
                [currentNode.adjacentNodes addObject:southNeighbor];
            }
            if (r < self.nodeGraph.count-1 && c > 0) {
                Node *southWestNeighbor = self.nodeGraph[r+1][c-1];
                [currentNode.adjacentNodes addObject:southWestNeighbor];
            }
        }
    }
}


-(void)traverse:(Node *)node visitedNodeArr:(NSMutableArray *)visitedNodeArr depth:(NSInteger)depth {
    
    NSLog(@"\ndepth is %d", depth);
    NSLog(@"visiting node:\n%@", node);
    
    NSMutableArray *visitedNodeArrCopy = [visitedNodeArr mutableCopy];
    [visitedNodeArrCopy addObject:node];
    
    // base case is where there are no more adjacent nodes that have not been visited
    BOOL areUnvisitedValidNodes = NO;
    
    for (Node *adjacent in node.adjacentNodes) {
        
        // check if adjacent is already visited or not
        BOOL isAdjacentVisited = NO;
        for (Node *visitedNode in visitedNodeArrCopy) {
            if ([adjacent visitedMatchCheck:visitedNode]) {
                isAdjacentVisited = YES;
            }
        }
        if (!isAdjacentVisited) {
            if (adjacent.data >= node.data) {
                areUnvisitedValidNodes = YES;
                [self traverse:adjacent visitedNodeArr:visitedNodeArrCopy depth:(depth + 1)];
            }
        }
    }
    
    if (!areUnvisitedValidNodes) {
        NSLog(@"\n\nbase case, depth is: %d", depth);
        NSLog(@"visited node set:");
        for (Node *visitedNode in visitedNodeArrCopy) {
            NSLog(@"%@", visitedNode);
        }
        
        if (depth > self.maxDepth) {
            self.maxDepth = depth;
            NSLog(@"new max depth found");
            self.longestPathArr = visitedNodeArrCopy;
        }
        
        NSLog(@"*********************************\n\n");
        
    }
}

//-(void)traverseGraphFromRow:(NSInteger)startRow column:(NSInteger)startColumn {
//    
//    Node *root = (Node *)self.nodeGraph[startRow][startColumn];
//    
//    NSMutableArray *depthFirstSearchStack = [NSMutableArray new];
//    //BFS uses queue instead of stack to traverse
//    NSMutableArray *visitedNodes = [NSMutableArray new];
//    
//    [depthFirstSearchStack addObject:root];
//    
//    while (depthFirstSearchStack.count > 0) {
//        
//        Node *visitingNode = (Node *)[depthFirstSearchStack lastObject];
//        [depthFirstSearchStack removeLastObject];
//        
//        NSLog(@"visiting %@", visitingNode);
//        
//        for (Node *adjacent in visitingNode.adjacentNodes) {
//            
//            BOOL isAdjacentVisited = [self checkIfVisited:adjacent visitedSet:visitedNodes];
//            
//            if (!isAdjacentVisited) {
//                
//                NSLog(@"adding adjacent node: %@", adjacent);
//                [visitedNodes addObject:adjacent];
//                
//                [depthFirstSearchStack addObject:adjacent];
//            }
//        }
//    }
//}


-(BOOL)checkIfVisited:(Node *)node visitedSet:(NSMutableArray *)visitedSet {
    
    for (Node *visitedNode in visitedSet) {
        
        if (node.row == visitedNode.row &&
            node.column == visitedNode.column) {
            
            return YES;
        }
    }
    
    return NO;
}


-(void)printGrid {
    
    //NSLog(@"%@", self.grid);
    printf("{\n");
    for (int r=0; r<self.grid.count; r++) {
        NSMutableArray *rowArr = self.grid[r];
        for (int c=0; c<rowArr.count; c++) {
            if (c == 0) {
                printf("{");
            }
            NSNumber *num = (NSNumber *)rowArr[c];
            printf("%d", [num intValue]);
            if (c<rowArr.count-1) {
                printf(", ");
            }
            else {
                printf("}\n");
            }
        }
    }
    printf("}\n");
}

@end
