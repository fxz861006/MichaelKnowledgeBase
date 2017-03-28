//
//  PointWithDistanceAnnView.h
//  ridingOnFoot
//
//  Created by 刘京涛 on 16/3/16.
//  Copyright © 2016年 刘京涛. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
@class DistanceCalloutView;
@interface PointWithDistanceAnnView : BMKPinAnnotationView
@property(assign,nonatomic)CGFloat pointDistance;
@property(readonly,nonatomic)DistanceCalloutView *calloutView;
@property(assign,nonatomic)CLLocationCoordinate2D coordinate;
@property(strong,nonatomic)NSString *distanceStr;
@end
