//
//  DataBase.h
//  UILesson19-Sqlite
//
//  Created by lanou3g on 16/1/8.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "sportmodel.h"
#import "usermodel.h"
#import "contactmodel.h"
#import "FindModel.h"
@interface DataBase : NSObject
+(DataBase *)startDB;
//打开数据库
-(void)openDB;
//关闭数据库
-(void)closeDB;
-(void)addcontact:(contactmodel *)contactmodel;

-(NSMutableArray *)selectaccount;

-(void)updatecontact:(contactmodel *)contactmodel;
//用户表的操作
/**
 *  创建用户唯一表
 *
 *  @param phone 用户名为表名
 */
-(void)createuserTable:(NSString *)username;
/**
 *  向用户表里添加唯一用户信息
 *
 *  @param usermodel 用户模型
 */
-(void)adduser:(usermodel *)usermodel;
/**
 *  查询唯一的用户信息
 */
-(usermodel *)selectuser:(NSString *)username;
/**
 *  更新用户信息
 *
 *  @param usermodel 用户模型
 */
-(void)updateuser:(usermodel *)usermodel;

//运动表的操作
/**
 *  创建运动表
 *
 *  @param phone 用户名为表名
 */
-(void)createsportTable:(NSString *)username;
/**
 *  向运动表里添加唯一用户信息
 *
 *  @param usermodel 运动模型
 */
-(void)addSport:(sportmodel *)sportmodel;
/**
 *  查询运动信息
 */
-(NSMutableArray *)selectsport:(NSString *)username;
/**
 *  删除运动信息
 *
 *  @param usermodel 用户模型
 */
-(void)deletesport:(sportmodel *)sportmodel;

//发现表的操作
/**
 *  创建发现表
 *
 *  @param phone 用户名为表名
 */
-(void)createFindActiveTable:(NSString *)username;
/**
 *  向发现表里添加唯一用户信息
 *
 *  @param usermodel 运动模型
 */
-(BOOL)addFindActive:(FindModel *)findmodel;
/**
 *  查询活动信息
 */
-(NSMutableArray *)selectFindActive:(NSString *)username;
/**
 *  删除活动信息
 *
 *  @param usermodel 用户模型
 */
-(BOOL)deleteFindActive:(FindModel *)findmodel;



@end
