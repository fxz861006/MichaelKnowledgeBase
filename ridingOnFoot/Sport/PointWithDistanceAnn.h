//
//  PointWithDistanceAnn.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/16.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface PointWithDistanceAnn : BMKPointAnnotation<BMKAnnotation>
@property(assign,nonatomic)CGFloat pointDistance;
@property(strong,nonatomic)NSString *distanceStr;
@end
