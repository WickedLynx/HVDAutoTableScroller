//
//  HVDAutoTableScroller.h
//
//  Created by Harshad on 01/08/14.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HVDAutoTableScrollerDelegate;

/*!
 * Automatically adjusts content insets of table views to avoid text fields hidden behind the keyboard.
 */
@interface HVDAutoTableScroller : NSObject

/*!
 * Initialises the receiver with a table view
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/*!
 * Calling this causes the receiver to adjust the content inset if the table if needed
 */
- (void)scrollIfNeeded;

/*!
 * Reset the content inset and offset of the table
 */
- (void)reset;

/*!
 * The table view of the receiver
 */
@property (weak, nonatomic) UITableView *tableView;

/*!
 * The delegate of the receiver
 */
@property (weak, nonatomic) id <HVDAutoTableScrollerDelegate> delegate;

/*!
 * Use this to specify any extra gap between the bottom of the text field and the top of the keyboard.
 *
 * Default is 0.0.
 */
@property (nonatomic) CGFloat bottomPadding;

@end

@protocol HVDAutoTableScrollerDelegate <NSObject>

/*!
 * Asks the receiver for the text field for which the keyboard is currently showing
 */
- (UITextField *)activeTextFieldForAutoScroller:(HVDAutoTableScroller *)autoScroller;

@end
