//
//  WACityCell.h
//  Weather
//
//  Created by Siyana Slavova on 9/5/13.
//  Copyright (c) 2013 Siyana Slavova. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WACityCellDelegate <NSObject>

- (void)deleteButtonTappedForCell:(id)cell;

@end

@interface WACityCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityDegreesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (assign, nonatomic) BOOL isInEditMode;
@property (strong, nonatomic) IBOutlet UIImageView *deleteButton;
@property (weak, nonatomic) id <WACityCellDelegate> delegate;


@end
