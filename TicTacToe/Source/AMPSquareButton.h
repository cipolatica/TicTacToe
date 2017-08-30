//
//  AMPSquareButton.h
//  TicTacToe
//
//  Created by Alberto Plata on 8/8/17.
//  Copyright © 2017 Alberto Plata. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * AMPSquareButton is the main view object used for this application. This object is used to display
 * both the X and O squares on the board. This class does not keep track of state to follow MVC design 
 * patterns. It merely contains row and col NSIntegers to identify its location within a matrix.
 *
 */
@interface AMPSquareButton : UIButton

@property NSInteger row;  // Used to identify this Button's row index within a matrix
@property NSInteger col;  // Used to identify this Button's col index within a matrix

#pragma mark - Init method
/**
 * Init method for AMPSquareButton. Does initial setup of its properties above.
 */
- (instancetype) initWithFrame:(CGRect)frame row:(NSInteger)row col:(NSInteger)col;

#pragma mark - Public method
/**
 * Updates the image for this button to be an X or O, depending on the name parameter.
 * If nil is passed in parameter, the image is removed (used for resetting the game).
 */
- (void) updateImageWithName:(NSString *)name;

@end
