//
//  AMPGameModel.m
//  TicTacToe
//
//  Created by Alberto Plata on 8/8/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

#import "AMPGameModel.h"

CGFloat const AMPGameRowColLength = 3.0;
NSInteger const AMPGameBoardSize = AMPGameRowColLength * AMPGameRowColLength;
NSInteger const AMPGameLeastWinMoves = AMPGameRowColLength * 2 - 1;

@implementation AMPGameModel

#pragma mark - Init method

- (instancetype) init {
    
    if (self = [super init]) {
        _squareMatrix = [NSMutableArray new];
        for (NSInteger i = 0; i < AMPGameRowColLength; i++) {
            [_squareMatrix addObject:[NSMutableArray new]];
            for (NSInteger j = 0; j < AMPGameRowColLength; j++) {
                [(NSMutableArray *)_squareMatrix[i] addObject:@(AMPGameOwnershipStateNone)];
            }
        }
        _movesCounter = 0;
        _isPlayerXMove = YES;
    }
    return self;
}

#pragma mark - Public methods

- (BOOL) updateStateForRow:(NSInteger)row col:(NSInteger)col {
    
    if ([self getStateForRow:row col:col] != AMPGameOwnershipStateNone) {
        return NO;
    }
    ++self.movesCounter;
    NSNumber *squareState = self.isPlayerXMove ? @(AMPGameOwnershipStateX) : @(AMPGameOwnershipStateO);
    [(NSMutableArray *)self.squareMatrix[row] replaceObjectAtIndex:col withObject:squareState];
    return YES;
}

- (AMPGameOwnershipState) getStateForRow:(NSInteger)row col:(NSInteger)col {
    
    NSNumber *squareState = (NSNumber *)[(NSMutableArray *)self.squareMatrix[row] objectAtIndex:col];
    return [squareState integerValue];
}

- (BOOL) isWinnerAtRow:(NSInteger)row col:(NSInteger)col {
    
    if (self.movesCounter >= AMPGameLeastWinMoves) {
        
        AMPGameOwnershipState currentSquareState = [self getStateForRow:row col:col];
        return  [self hasVerticalOrHorizontalWinAtRow:row col:col state:currentSquareState] ||
                [self hasDiagonalWinWinAtRow:row col:col state:currentSquareState];
    }
    return NO;
}

- (void) toggleCurrentPlayer {
    
    self.isPlayerXMove = !self.isPlayerXMove;
}

- (void) resetGame {
    
    for (NSInteger i = 0; i < AMPGameRowColLength; i++) {
        for (NSInteger j = 0; j < AMPGameRowColLength; j++) {
            [(NSMutableArray *)self.squareMatrix[i] replaceObjectAtIndex:j withObject:@(AMPGameOwnershipStateNone)];
        }
    }
    self.movesCounter = 0;
    self.isPlayerXMove = YES;
}

#pragma mark - Helper methods

// This helper method checks for a vertical and horizontal win of a newly selected square
- (BOOL) hasVerticalOrHorizontalWinAtRow:(NSInteger)row col:(NSInteger)col state:(AMPGameOwnershipState)state {
    
    // Preset vertical and horizontal BOOLs to YES
    BOOL hasVerticalWin = YES;
    BOOL hasHorizontalWin = YES;
    
    // Check both vertical and horizontal directions to see if there is a win
    for (NSInteger index = 0; index < AMPGameRowColLength; index++) {
        if ([self getStateForRow:index col:col] != state) {
            hasVerticalWin = NO;
        }
        if ([self getStateForRow:row col:index] != state) {
            hasHorizontalWin = NO;
        }
    }
    
    // Return YES if either BOOL is YES
    return hasVerticalWin || hasHorizontalWin;
}

// This helper method checks for a diagonal win of a newly selected square
- (BOOL) hasDiagonalWinWinAtRow:(NSInteger)row col:(NSInteger)col state:(AMPGameOwnershipState)state {
    
    // Preset diagonal BOOLs to YES if they are in a diagonal sqaure cell
    BOOL hasDiagonalWin1 = row == col ? YES : NO;
    BOOL hasDiagonalWin2 = row + col == AMPGameRowColLength - 1 ? YES : NO;
    
    // If the current row and col location is not in a diagonal square cell, return NO
    if (!hasDiagonalWin1 && !hasDiagonalWin2) {
        return NO;
    }
    
    // Check both diagonals to see if there is a win
    NSInteger j = AMPGameRowColLength - 1;
    for (NSInteger i = 0; i < AMPGameRowColLength; i++) {
        if ([self getStateForRow:i col:i] != state){
            hasDiagonalWin1 = NO;
        }
        if ([self getStateForRow:i col:j--] != state){
            hasDiagonalWin2 = NO;
        }
    }
    
    // Return YES if either diagonal BOOL is YES
    return hasDiagonalWin1 || hasDiagonalWin2;
}

@end
