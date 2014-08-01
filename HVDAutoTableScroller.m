//
//  HVDAutoTableScroller.m
//
//  Created by Harshad on 01/08/14.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import "HVDAutoTableScroller.h"

@implementation HVDAutoTableScroller {
    CGRect _keyboardFrame;
    UIEdgeInsets _defaultContentInset;
    BOOL _didUpdateKeyboardFrame;
}

// MARK: Initialisation

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [super init];
    if (self != nil) {
        _tableView = tableView;
        _defaultContentInset = tableView.contentInset;
        [self registerForNotifications];
    }

    return self;
}

// MARK: Public methods

- (void)scrollIfNeeded {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    CGRect convertedKeyboardFrame = [window convertRect:_keyboardFrame toView:window];
    UITextField *activeField = [self.delegate activeTextFieldForAutoScroller:self];
    CGRect convertedFieldFrame = [activeField.superview convertRect:activeField.frame toView:window];

    if (CGRectIntersectsRect(convertedFieldFrame, convertedKeyboardFrame)) {
        CGFloat deltaY = ((convertedFieldFrame.origin.y + convertedFieldFrame.size.height) - convertedKeyboardFrame.origin.y) + self.bottomPadding;
        __weak UITableView *tableView = self.tableView;
        [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            [tableView setContentInset:UIEdgeInsetsMake(tableView.contentInset.top -  deltaY, 0, 0, 0)];
        } completion:nil];
    } else {
        [self reset];
    }

}

- (void)reset {
    __weak UITableView *tableView = self.tableView;
    UIEdgeInsets defaultInset = _defaultContentInset;
    [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [tableView setContentInset:defaultInset];
        [tableView setContentOffset:CGPointZero];
    } completion:nil];
}

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _defaultContentInset = tableView.contentInset;
}

// MARK: Private methods

- (void)registerForNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSOperationQueue *notificationQueue = [NSOperationQueue mainQueue];
    __weak typeof(self) wself = self;

    [notificationCenter addObserverForName:UIKeyboardWillShowNotification object:nil queue:notificationQueue usingBlock:^(NSNotification *note) {
        if (wself != nil) {
            typeof(self) sself = wself;
            [sself updateKeyboardFrame:note];
            if (!sself->_didUpdateKeyboardFrame) {
                [sself scrollIfNeeded];
                sself->_didUpdateKeyboardFrame = YES;
            }
        }
    }];

    [notificationCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:notificationQueue usingBlock:^(NSNotification *note) {
        if (wself != nil) {
            typeof(self) sself = wself;
            [sself reset];
        }
    }];
}

- (void)updateKeyboardFrame:(NSNotification *)notification {
    NSValue *frameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (![frameValue isKindOfClass:[NSNull class]]) {
        _keyboardFrame = [frameValue CGRectValue];
    }
}

// MARK: Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
