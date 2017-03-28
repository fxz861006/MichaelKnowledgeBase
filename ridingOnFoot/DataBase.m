//
//  DataBase.m
//  UILesson19-Sqlite
//
//  Created by lanou3g on 16/1/8.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "DataBase.h"
static DataBase *data=nil;
@implementation DataBase

+(DataBase*)startDB{

    @synchronized(self) {
        if (data==nil) {
            data=[[DataBase alloc] init];
        }
    }
    

    return data;

}

static sqlite3 *db=nil;
//打开数据库
-(void)openDB{
    if (db==nil) {
        NSString*filepath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"suixing.sqlite"];
        NSLog(@"%@",filepath);
     int result=sqlite3_open(filepath.UTF8String,&db);
   
        if (result==SQLITE_OK) {
            NSLog(@"打开数据库成功");
            NSString *sql=@"CREATE  TABLE  IF NOT EXISTS account (username TEXT , pwd TEXT , qqid TEXT, sinaid TEXT, wechatid TEXT,problem1 TEXT,problem2 TEXT)";
            //执行sql语句
        int  result1=sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
            if (result1==SQLITE_OK) {
                NSLog(@"创建account表格成功");
            }else{
            
                NSLog(@"创建表格失败");
            }
            
            
       
        }}
}
//关闭数据库
-(void)closeDB{

    if (db !=nil) {
        
       int result2=sqlite3_close(db);
        if (result2==SQLITE_OK) {
            NSLog(@"关闭数据库成功");
            db=nil;
        }else{
            NSLog(@"关闭数据库失败");
        }
        
    }
}


//username TEXT , phone TEXT , qqid TEXT, sinaid TEXT, wechatid
-(void)addcontact:(contactmodel *)contactmodel{
       NSString *sql=[NSString stringWithFormat:@"INSERT INTO account(username,pwd,qqid,sinaid,wechatid,problem1,problem2) VALUES ('%@','%@','%@','%@','%@','%@','%@')",contactmodel.username,contactmodel.pwd,contactmodel.qq,contactmodel.sina,contactmodel.wechat,contactmodel.problem1,contactmodel.problem2];
    
      int result= sqlite3_exec(db, sql.UTF8String, NULL,NULL, NULL);
    
        if (result==SQLITE_OK) {
            NSLog(@"添加数据成功");
        }else{
            NSLog(@"添加数据失败");
        }
    
    
    
    


}

-(NSMutableArray *)selectaccount{

    NSMutableArray *arr=[NSMutableArray array];
        NSString *sql=@"SELECT *FROM account ";
        sqlite3_stmt *stmt=nil;
     int result=sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
        if (result==SQLITE_OK) {
            NSLog(@"开始查找数据");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *name=(char *)sqlite3_column_text(stmt, 0);
               NSString *username= [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                char *pwd1=(char *)sqlite3_column_text(stmt, 1);
                NSString *pwd=[NSString stringWithCString:pwd1 encoding:NSUTF8StringEncoding];
                char *qq=(char *)sqlite3_column_text(stmt, 2);
                NSString *qqid=[NSString stringWithCString:qq encoding:NSUTF8StringEncoding];
                char *sina=(char *)sqlite3_column_text(stmt, 3);
                NSString *sinaid=[NSString stringWithCString:sina encoding:NSUTF8StringEncoding];
                char *wechat=(char *)sqlite3_column_text(stmt, 4);
                NSString *wechatid=[NSString stringWithCString:wechat encoding:NSUTF8StringEncoding];
                char *problem=(char *)sqlite3_column_text(stmt, 5);
                NSString *problem1=[NSString stringWithCString:problem encoding:NSUTF8StringEncoding];
                char *problem3=(char *)sqlite3_column_text(stmt, 6);
                NSString *problem2=[NSString stringWithCString:problem3 encoding:NSUTF8StringEncoding];
                contactmodel * model=[[contactmodel alloc] init];
                model.username=username;
                model.pwd=pwd;
                model.qq=qqid;
                model.sina=sinaid;
                model.wechat=wechatid;
                model.problem1=problem1;
                model.problem2=problem2;
                [arr addObject:model];
    
            }
    
    
    
        }else{
    
            NSLog(@"查找失败");
        }
        
        sqlite3_finalize(stmt);
        return arr;

 
}
//username TEXT , phone TEXT , qqid TEXT, sinaid TEXT, wechatid
-(void)updatecontact:(contactmodel *)contactmodel{
    NSString *sql=[NSString  stringWithFormat:@"UPDATE  account  SET pwd='%@',qqid='%@',sinaid='%@',wechatid='%@',problem1='%@',problem2='%@' WHERE  username='%@'",contactmodel.pwd,contactmodel.qq,contactmodel.sina,contactmodel.wechat,contactmodel.problem1,contactmodel.problem2,contactmodel.username];
        int result=sqlite3_exec(db, sql.UTF8String,NULL, NULL, NULL);
        if (result==SQLITE_OK) {
            NSLog(@"更新成功");
        }else{
    
            NSLog(@"更新失败");
        
        }

}
//用户表的操作
/**
 *  创建用户唯一表
 *
 *  @param phone 用户名为表名
 */
-(void)createuserTable:(NSString *)username{
    NSString *sql=[NSString  stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS sx%@userTable (imgpic TEXT ,username TEXT , address TEXT ,sex TEXT, age TEXT, height TEXT, weight TEXT, phone TEXT, email TEXT, totaldistance TEXT)",username];
    //执行sql语句
    int  result1=sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (result1==SQLITE_OK) {
        NSLog(@"创建user表格成功");
    }else{
        
        NSLog(@"创建表格失败");
    }
}
/**
 *  向用户表里添加唯一用户信息
 *
 *  @param usermodel 用户模型
 */
-(void)adduser:(usermodel *)usermodel{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO sx%@userTable(imgpic, username, address ,sex, age , height , weight , phone , email , totaldistance ) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",usermodel.username,usermodel.imgpic, usermodel.username,usermodel.address,usermodel.sex,usermodel.age,usermodel.height,usermodel.weight,usermodel.phone,usermodel.email,usermodel.totaldistance];
    
    int result= sqlite3_exec(db, sql.UTF8String, NULL,NULL, NULL);
    
    if (result==SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else{
        NSLog(@"添加数据失败");
    }


    
    
}
/**
 *  查询唯一的用户信息
 */
//username TEXT , address TEXT , age TEXT, height TEXT, weight TEXT, phone TEXT, email TEXT, totaldistance TEXT
-(usermodel *)selectuser:(NSString *)username{
    usermodel *model=[[usermodel alloc] init];
    NSString *sql=[NSString stringWithFormat:@"SELECT *FROM sx%@userTable",username];
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"开始查找数据");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *imgpic1=(char *)sqlite3_column_text(stmt, 0);
            NSString *imgpic= [NSString stringWithCString:imgpic1 encoding:NSUTF8StringEncoding];
            char *name=(char *)sqlite3_column_text(stmt, 1);
            NSString *username= [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            char *address1=(char *)sqlite3_column_text(stmt, 2);
            NSString *address=[NSString stringWithCString:address1 encoding:NSUTF8StringEncoding];
            char *sex1=(char *)sqlite3_column_text(stmt, 3);
            NSString *sex=[NSString stringWithCString:sex1 encoding:NSUTF8StringEncoding];
            char *age1=(char *)sqlite3_column_text(stmt, 4);
            NSString *age=[NSString stringWithCString:age1 encoding:NSUTF8StringEncoding];
            char *height1=(char *)sqlite3_column_text(stmt, 5);
            NSString *height=[NSString stringWithCString:height1 encoding:NSUTF8StringEncoding];
            char *weight1=(char *)sqlite3_column_text(stmt, 6);
            NSString *weight=[NSString stringWithCString:weight1 encoding:NSUTF8StringEncoding];
            char *phone1=(char *)sqlite3_column_text(stmt, 7);
            NSString *phone=[NSString stringWithCString:phone1 encoding:NSUTF8StringEncoding];
            char *email1=(char *)sqlite3_column_text(stmt, 8);
            NSString *email=[NSString stringWithCString:email1 encoding:NSUTF8StringEncoding];
            char *totaldistance1=(char *)sqlite3_column_text(stmt, 9);
            NSString *totaldistance=[NSString stringWithCString:totaldistance1 encoding:NSUTF8StringEncoding];
            model.imgpic=imgpic;
            model.username=username;
            model.address=address;
            model.sex=sex;
            model.age=age;
            model.height=height;
            model.weight=weight;
            model.phone=phone;
            model.email=email;
            model.totaldistance=totaldistance;
   
        }

    }else{
        
        NSLog(@"查找失败");
    }
    
    sqlite3_finalize(stmt);

    return model;
}
/**
 *  更新用户信息
 *
 *  @param usermodel 用户模型
 */
-(void)updateuser:(usermodel *)usermodel{

    NSString *sql=[NSString  stringWithFormat:@"UPDATE  sx%@userTable  SET imgpic='%@', address='%@',sex='%@', age='%@' , height='%@' , weight='%@' , phone='%@' , email='%@' , totaldistance='%@' WHERE  username='%@'",usermodel.username,usermodel.imgpic,usermodel.address,usermodel.sex,usermodel.age,usermodel.height,usermodel.weight,usermodel.phone,usermodel.email,usermodel.totaldistance,usermodel.username];
    int result=sqlite3_exec(db, sql.UTF8String,NULL, NULL, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"更新成功");
    }else{
        
        NSLog(@"更新失败");
        
    }



}

//运动表的操作
/**
 *  创建运动表
 *
 *  @param phone 用户名为表名
 */
-(void)createsportTable:(NSString *)username{
    NSString *sql=[NSString  stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS sx%@sportTable (timeDate TEXT,  startpoint TEXT , stoppoint TEXT , distance INTEGER , time INTEGER ,type INTEGER)",username];
    //执行sql语句
    int  result1=sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (result1==SQLITE_OK) {
        NSLog(@"创建表格成功");
    }else{
        
        NSLog(@"创建表格失败");
    }




}
/**
 *  向运动表里添加运动信息
 *
 *  @param usermodel 运动模型
 */
-(void)addSport:(sportmodel *)sportmodel{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO sx%@sportTable(timeDate,startpoint, stoppoint , distance , time , type ) VALUES ('%@','%@','%@','%ld','%ld','%ld')",sportmodel.username,sportmodel.timeDate,sportmodel.startpoint,sportmodel.stoppoint,sportmodel.distance,sportmodel.time,sportmodel.type];
    
    int result= sqlite3_exec(db, sql.UTF8String, NULL,NULL, NULL);
    
    if (result==SQLITE_OK) {
        NSLog(@"添加数据成功");
    }else{
        NSLog(@"添加数据失败");
    }



}
/**
 *  查询运动信息
 */
-(NSMutableArray *)selectsport:(NSString *)username{
    NSMutableArray *arr=[NSMutableArray array];

        NSString *sql=[NSString  stringWithFormat:@"SELECT *FROM sx%@sportTable",username];
        sqlite3_stmt *stmt=nil;
     int result=sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
        if (result==SQLITE_OK) {
            NSLog(@"开始查找数据");
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                char *time1=(char *)sqlite3_column_text(stmt, 0);
                NSString *timeDate= [NSString stringWithCString:time1 encoding:NSUTF8StringEncoding];
                char *start=(char *)sqlite3_column_text(stmt, 1);
               NSString *startpoint= [NSString stringWithCString:start encoding:NSUTF8StringEncoding];
                char *stop=(char *)sqlite3_column_text(stmt, 2);
                NSString *stoppoint=[NSString stringWithCString:stop encoding:NSUTF8StringEncoding];
                int distance=sqlite3_column_int(stmt, 3);
                int time=sqlite3_column_int(stmt, 4);
                int type=sqlite3_column_int(stmt, 5);
                sportmodel *model=[[sportmodel alloc] init];
                model.username=username;
                model.timeDate=timeDate;
                model.startpoint=startpoint;
                model.stoppoint=stoppoint;
                model.distance=distance;
                model.time=time;
                model.type=type;
                [arr addObject:model];
    
            }
        }else{
    
            NSLog(@"查找失败");
        }
        
        sqlite3_finalize(stmt);
    

    return arr;
}
/**
 *  删除运动信息
 *
 *  @param usermodel 用户模型
 */
-(void)deletesport:(sportmodel *)sportmodel{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM sx%@sportTable WHERE timeDate ='%@'",sportmodel.username,sportmodel.timeDate];
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_exec(db, sql.UTF8String, NULL,&stmt, NULL);
    if (result ==SQLITE_OK) {
        
        NSLog(@"删除成功");
        
        
        
    }else{
        
        NSLog(@"删除失败");
    }

}

//发现表的操作
/**
 *  创建发现表
 *
 *  @param phone 用户名为表名
 */
-(void)createFindActiveTable:(NSString *)username{

    NSString *sql=[NSString  stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS sx%@ActiveTable (username TEXT, activityType TEXT, activityTitle TEXT, activityAddress TEXT, activityStartTime INTEGER, activityEndTime INTEGER, activityUsersCount INTEGER, activityUserMaxCount INTEGER, activityMiles INTEGER, activityCoverPic TEXT, activityContent TEXT, activityId INTEGER, activityCost INTEGER, activityContactMobile TEXT)",username];
    //执行sql语句
    int  result1=sqlite3_exec(db, sql.UTF8String, NULL, NULL, NULL);
    if (result1==SQLITE_OK) {
        NSLog(@"创建表格成功");
    }else{
        
        NSLog(@"创建表格失败");
    }


}
/**
 *  向发现表里添加活动信息
 *
 *  @param usermodel 活动模型
 */
-(BOOL)addFindActive:(FindModel *)findmodel{

    NSString *sql=[NSString stringWithFormat:@"INSERT INTO sx%@ActiveTable(username, activityType,activityTitle, activityAddress, activityStartTime, activityEndTime, activityUsersCount, activityUserMaxCount, activityMiles, activityCoverPic, activityContent, activityId, activityCost, activityContactMobile) VALUES ('%@','%ld','%@','%@','%ld','%ld','%ld','%ld','%ld','%@','%@','%ld','%ld','%@')",findmodel.username,findmodel.username,findmodel.activityType,findmodel.activityTitle,findmodel.activityAddress,findmodel.activityStartTime,findmodel.activityEndTime,findmodel.activityUsersCount,findmodel.activityUserMaxCount,findmodel.activityMiles,findmodel.activityCoverPic,findmodel.activityContent,findmodel.activityId,findmodel.activityCost,findmodel.activityContactMobile];
    
    int result= sqlite3_exec(db, sql.UTF8String, NULL,NULL, NULL);
    
    if (result==SQLITE_OK) {
        return YES;
    }else{
        return NO;
    }
   

}
/**
 *  查询活动信息
 */
-(NSMutableArray *)selectFindActive:(NSString *)username{
    NSMutableArray *arr=[NSMutableArray array];
    
    NSString *sql=[NSString  stringWithFormat:@"SELECT *FROM sx%@ActiveTable",username];
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result==SQLITE_OK) {
        NSLog(@"开始查找数据");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            char *time1=(char *)sqlite3_column_text(stmt, 0);
//            NSString *timeDate= [NSString stringWithCString:time1 encoding:NSUTF8StringEncoding];
//            char *start=(char *)sqlite3_column_text(stmt, 1);
//            NSString *startpoint= [NSString stringWithCString:start encoding:NSUTF8StringEncoding];
            char *username1=(char *)sqlite3_column_text(stmt, 0);
            NSString *username2=[NSString stringWithCString:username1 encoding:NSUTF8StringEncoding];
            int activityType=sqlite3_column_int(stmt, 1);
            char *activityTitle1=(char *)sqlite3_column_text(stmt, 2);
            NSString *activityTitle=[NSString stringWithCString:activityTitle1 encoding:NSUTF8StringEncoding];
            char *activityAddress1=(char *)sqlite3_column_text(stmt, 3);
            NSString *activityAddress=[NSString stringWithCString:activityAddress1 encoding:NSUTF8StringEncoding];
            int activityStartTime=sqlite3_column_int(stmt, 4);
            int activityEndTime=sqlite3_column_int(stmt, 5);
            int activityUsersCount=sqlite3_column_int(stmt, 6);
            int activityUserMaxCount=sqlite3_column_int(stmt, 7);
            int activityMiles=sqlite3_column_int(stmt, 8);
            char *activityCoverPic1=(char *)sqlite3_column_text(stmt, 9);
            NSString *activityCoverPic=[NSString stringWithCString:activityCoverPic1 encoding:NSUTF8StringEncoding];
            char *activityContent1=(char *)sqlite3_column_text(stmt, 10);
            NSString *activityContent=[NSString stringWithCString:activityContent1 encoding:NSUTF8StringEncoding];
            
            int activityId=sqlite3_column_int(stmt, 11);
            int activityCost=sqlite3_column_int(stmt, 12);
            char *activityContactMobile1=(char *)sqlite3_column_text(stmt, 13);
            NSString *activityContactMobile=[NSString stringWithCString:activityContactMobile1 encoding:NSUTF8StringEncoding];
//            int time=sqlite3_column_int(stmt, 4);
//            int type=sqlite3_column_int(stmt, 5);
            FindModel *model=[[FindModel alloc] init];
            model.username=username2;
            model.activityId=activityId;
            model.activityType=activityType;
            model.activityTitle=activityTitle;
            model.activityAddress=activityAddress;
            model.activityStartTime=activityStartTime;
            model.activityEndTime=activityEndTime;
            model.activityUsersCount=activityUsersCount;
            model.activityUserMaxCount=activityUserMaxCount;
            model.activityMiles=activityMiles;
            model.activityCoverPic=activityCoverPic;
            model.activityContent=activityContent;
            model.activityCost=activityCost;
            model.activityContactMobile=activityContactMobile;
            [arr addObject:model];
            
        }
    }else{
        
        NSLog(@"查找失败");
    }
    
    sqlite3_finalize(stmt);
    
    
    return arr;


}
/**
 *  删除活动信息
 *
 *  @param usermodel 用户模型
 */
-(BOOL)deleteFindActive:(FindModel *)findmodel{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM sx%@ActiveTable WHERE activityId ='%ld'",findmodel.username,findmodel.activityId];
    sqlite3_stmt *stmt=nil;
    int result=sqlite3_exec(db, sql.UTF8String, NULL,&stmt, NULL);
    if (result ==SQLITE_OK) {
        
        NSLog(@"删除成功");
        return YES;
        
        
    }else{
        
        NSLog(@"删除失败");
        return NO;
    }



}




@end
