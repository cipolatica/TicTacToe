//
//  AMPSquareButton.m
//  TicTacToe
//
//  Created by Alberto Plata on 8/8/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

#import "AMPSquareButton.h"

@implementation AMPSquareButton

#pragma mark - Init method

- (instancetype) initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col {
    
    if (self = [super initWithFrame:frame]) {
        _row = row;
        _col = col;
    }
    return self;
}

#pragma mark - Public method

- (void) updateImageWithName:(NSString *)name {
    
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

@end
