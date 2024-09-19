//
//  MKCHExcelDataManager.m
//  CommureGatewayPlus_Example
//
//  Created by aa on 2023/2/7.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKCHExcelDataManager.h"

#import <xlsxwriter/xlsxwriter.h>

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKExcelWookbook.h"

static NSString *const defaultKeyValueString = @"value:";

@implementation MKCHExcelDataManager

+ (void)exportAppExcel:(id <MKCHExcelAppProtocol>)protocol
              sucBlock:(void(^)(void))sucBlock
           failedBlock:(void(^)(NSError *error))failedBlock {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKCHExcelAppProtocol)]) {
        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
        return;
    }
//    if (![self checkExcelAppProtocol:protocol]) {
//        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
//        return;
//    }
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for APP.xlsx"];
    //创建新xlsx文件
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    //创建sheet
    lxw_sheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    //设置列宽
    /*
     五个参数分别是:
     worksheet          Pointer to a lxw_worksheet instance to be uodated.
     first_col          The zero indexed first column.
     last_col           The zero indexed last column.
     width              The width of the column(s).
     format             A pointer to a format instance or NULL.
     */
    worksheet_set_column(worksheet, 0, 2, 50, NULL);
    
    //添加格式
    lxw_format *format = workbook_add_format(workbook);
    //设置格式
    format_set_bold(format);
    //水平居中
//    format_set_align(format, LXW_ALIGN_CENTER);
    //垂直居中
    format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
    
    //写入数据
    /*
     第一个参数是工作表
     第二个参数是行数(索引从0开始)
     第三个参数是列数(索引从0开始)
     第四个参数是写入的内容
     第五个参数是单元格样式，可为NULL.
     */
    worksheet_write_string(worksheet, 0, 0, "Config_Item", NULL);
    worksheet_write_string(worksheet, 0, 1, "Config_value", NULL);
    worksheet_write_string(worksheet, 0, 2, "Remark", NULL);
    
    //Host
    worksheet_write_string(worksheet, 1, 0, "Host", NULL);
    NSString *hostString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.host)];
    worksheet_write_string(worksheet, 1, 1, [hostString UTF8String], NULL);
    worksheet_write_string(worksheet, 1, 2, "1-64 characters", NULL);
    
    //Port
    worksheet_write_string(worksheet, 2, 0, "Port", NULL);
    NSString *portString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.port)];
    worksheet_write_string(worksheet, 2, 1, [portString UTF8String], NULL);
    worksheet_write_string(worksheet, 2, 2, "Range: 1-65535", NULL);
    
    //Client id
    worksheet_write_string(worksheet, 3, 0, "Client id", NULL);
    NSString *clientIDString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.clientID)];
    worksheet_write_string(worksheet, 3, 1, [clientIDString UTF8String], NULL);
    worksheet_write_string(worksheet, 3, 2, "1-64 characters", NULL);
    
    //Subscribe Topic
    worksheet_write_string(worksheet, 4, 0, "Subscribe Topic", NULL);
    NSString *subscribeTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.subscribeTopic)];
    worksheet_write_string(worksheet, 4, 1, [subscribeTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 4, 2, "0-128 characters", NULL);
    
    //Publish Topic
    worksheet_write_string(worksheet, 5, 0, "Publish Topic", NULL);
    NSString *publishTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.publishTopic)];
    worksheet_write_string(worksheet, 5, 1, [publishTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 5, 2, "0-128 characters", NULL);
    
    //Clean Session
    const char *sessionMsg = "Range: 0/1 \n0:NO \n1:YES";
    worksheet_write_string(worksheet, 6, 0, "Clean Session", NULL);
    NSString *cleanSessionString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.cleanSession) {
        cleanSessionString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 6, 1, [cleanSessionString UTF8String], NULL);
    worksheet_write_string(worksheet, 6, 2, sessionMsg, format);
    
    //Qos
    const char *qosMsg = "Range: 0/1/2 \n0:qos0 \n1:qos1 \n2:qos2";
    NSString *qos = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)protocol.qos];
    worksheet_write_string(worksheet, 7, 0, "Qos", NULL);
    worksheet_write_string(worksheet, 7, 1, [qos UTF8String], NULL);
    worksheet_write_string(worksheet, 7, 2, qosMsg, format);
    
    //Keep Alive
    worksheet_write_string(worksheet, 8, 0, "Keep Alive", NULL);
    NSString *keepString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.keepAlive)];
    worksheet_write_string(worksheet, 8, 1, [keepString UTF8String], NULL);
    worksheet_write_string(worksheet, 8, 2, "Range: 10-120, unit: second", NULL);
    
    //MQTT Username
    worksheet_write_string(worksheet, 9, 0, "MQTT Username", NULL);
    NSString *usernameString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.userName)];
    worksheet_write_string(worksheet, 9, 1, [usernameString UTF8String], NULL);
    worksheet_write_string(worksheet, 9, 2, "0-128 characters", NULL);
    
    //MQTT Password
    worksheet_write_string(worksheet, 10, 0, "MQTT Password", NULL);
    NSString *passwordString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.password)];
    worksheet_write_string(worksheet, 10, 1, [passwordString UTF8String], NULL);
    worksheet_write_string(worksheet, 10, 2, "0-128 characters", NULL);
    
    //SSL/TLS
    const char *sslMsg = "Range: 0/1 \n0:Disable SSL (TCP mode) \n1:Enable SSL";
    worksheet_write_string(worksheet, 11, 0, "SSL/TLS", NULL);
    NSString *sslStatus = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.sslIsOn) {
        sslStatus = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 11, 1, [sslStatus UTF8String], NULL);
    worksheet_write_string(worksheet, 11, 2, sslMsg, format);
    
    //Certificate type
    const char *certlMsg = "Valid when SSL is enabled, range: 1/2/3 \n1: CA signed server certificate \n2: CA certificate file \n3: Self signed certificates";
    NSString *certValue = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)(protocol.certificate + 1)];
    worksheet_write_string(worksheet, 12, 0, "Certificate type", NULL);
    worksheet_write_string(worksheet, 12, 1, [certValue UTF8String], NULL);
    worksheet_write_string(worksheet, 12, 2, certlMsg, format);
    
//    const char *noteMsg = "Tips:\n1. Users just need fill the config_value column.\n2. If SSL/TLS is enabled, please manually upload the certificates from your phone.";
//
//    lxw_format *format1 = workbook_add_format(workbook);
//    //设置格式
//    format_set_bold(format1);
//    //垂直居中
//    format_set_align(format1, LXW_ALIGN_VERTICAL_CENTER);
//    format_set_font_color(format1, LXW_COLOR_RED);
//    worksheet_write_string(worksheet, 13, 0, noteMsg, format1);
    
    
    //关闭，保存文件
    lxw_error errorCode = workbook_close(workbook);
    if (errorCode != LXW_NO_ERROR) {
        //写失败
        [self operationFailedBlockWithMsg:@"Export Failed" block:failedBlock];
        return;
    }
    //写成功
    if (sucBlock) {
        sucBlock();
    }
}

+ (void)parseAppExcel:(NSString *)excelName
             sucBlock:(void (^)(NSDictionary *returnData))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelWookbook *workbook = [[MKExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //根据横竖坐标，获取单元格
    //Host
    MKExcelCell *hostCell = [sheet getCellWithColumn:@"B" row:2 error:nil];
    NSString *host = [SafeStr(hostCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(host) forKey:@"host"];
    //Port
    MKExcelCell *portCell = [sheet getCellWithColumn:@"B" row:3 error:nil];
    NSString *port = [SafeStr(portCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    port = [port stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic setObject:SafeStr(port) forKey:@"port"];
    //Client id
    MKExcelCell *clientIDCell = [sheet getCellWithColumn:@"B" row:4 error:nil];
    NSString *clientID = [SafeStr(clientIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientID) forKey:@"clientID"];
    //Subscribe Topic
    MKExcelCell *subTopicCell = [sheet getCellWithColumn:@"B" row:5 error:nil];
    NSString *subTopic = [SafeStr(subTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(subTopic) forKey:@"subscribeTopic"];
    //Publish Topic
    MKExcelCell *pubTopicCell = [sheet getCellWithColumn:@"B" row:6 error:nil];
    NSString *pubTopic = [SafeStr(pubTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(pubTopic) forKey:@"publishTopic"];
    //Clean Session
    MKExcelCell *cleanSessionCell = [sheet getCellWithColumn:@"B" row:7 error:nil];
    NSString *sessionString = [SafeStr(cleanSessionCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    sessionString = [sessionString stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL cleanSession = ([sessionString isEqualToString:@"1"]);
    [dic setObject:@(cleanSession) forKey:@"cleanSession"];
    //Qos
    MKExcelCell *qosCell = [sheet getCellWithColumn:@"B" row:8 error:nil];
    NSString *tempQos = [SafeStr(qosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    tempQos = [tempQos stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger qosValue = [tempQos integerValue];
    if (qosValue < 0 || qosValue > 2) {
        //默认值
        qosValue = 1;
    }
    [dic setObject:@(qosValue) forKey:@"qos"];
    //Keep Alive
    MKExcelCell *keepAliveCell = [sheet getCellWithColumn:@"B" row:9 error:nil];
    NSString *keepAlive = [SafeStr(keepAliveCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    keepAlive = [keepAlive stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSInteger keepValue = [keepAlive integerValue];
//    if (keepValue < 10 || keepValue > 120) {
//        //默认值
//        keepValue = 60;
//    }
    [dic setObject:keepAlive forKey:@"keepAlive"];
    //MQTT Username
    MKExcelCell *usernameCell = [sheet getCellWithColumn:@"B" row:10 error:nil];
    NSString *username = [SafeStr(usernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(username) forKey:@"userName"];
    //MQTT Password
    MKExcelCell *passwordCell = [sheet getCellWithColumn:@"B" row:11 error:nil];
    NSString *password = [SafeStr(passwordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(password) forKey:@"password"];
    //SSL/TLS
    MKExcelCell *sslCell = [sheet getCellWithColumn:@"B" row:12 error:nil];
    NSString *sslString = [SafeStr(sslCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    sslString = [sslString stringByReplacingOccurrencesOfString:@" " withString:@""];
    BOOL ssl = ([sslString isEqualToString:@"1"]);
    [dic setObject:@(ssl) forKey:@"sslIsOn"];
    //Certificate type
    MKExcelCell *certificateCell = [sheet getCellWithColumn:@"B" row:13 error:nil];
    NSString *certString = [SafeStr(certificateCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    certString = [certString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger certValue = [certString integerValue] - 1;
    if (certValue < 0 || certValue > 2) {
        certValue = 0;
    }
    [dic setObject:@(certValue) forKey:@"certificate"];
    if (sucBlock) {
        sucBlock(dic);
    }
}

+ (void)exportDeviceExcel:(id <MKCHExcelDeviceProtocol>)protocol
                 sucBlock:(void(^)(void))sucBlock
              failedBlock:(void(^)(NSError *error))failedBlock {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKCHExcelDeviceProtocol)]) {
        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
        return;
    }
//    if (![self checkExcelDeviceProtocol:protocol]) {
//        [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
//        return;
//    }
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"Settings for device.xlsx"];
    //创建新xlsx文件
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    //创建sheet
    lxw_sheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    //设置列宽
    /*
     五个参数分别是:
     worksheet          Pointer to a lxw_worksheet instance to be uodated.
     first_col          The zero indexed first column.
     last_col           The zero indexed last column.
     width              The width of the column(s).
     format             A pointer to a format instance or NULL.
     */
    worksheet_set_column(worksheet, 0, 2, 50, NULL);
    
    //添加格式
    lxw_format *format = workbook_add_format(workbook);
    //设置格式
    format_set_bold(format);
    //水平居中
//    format_set_align(format, LXW_ALIGN_CENTER);
    //垂直居中
    format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
    
    //写入数据
    /*
     第一个参数是工作表
     第二个参数是行数(索引从0开始)
     第三个参数是列数(索引从0开始)
     第四个参数是写入的内容
     第五个参数是单元格样式，可为NULL.
     */
    worksheet_write_string(worksheet, 0, 0, "Config_Item", NULL);
    worksheet_write_string(worksheet, 0, 1, "Config_value", NULL);
    worksheet_write_string(worksheet, 0, 2, "Remark", NULL);
    
    //Host
    worksheet_write_string(worksheet, 1, 0, "Host", NULL);
    NSString *hostString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.host)];
    worksheet_write_string(worksheet, 1, 1, [hostString UTF8String], NULL);
    worksheet_write_string(worksheet, 1, 2, "1-64 characters", NULL);
    
    //Port
    worksheet_write_string(worksheet, 2, 0, "Port", NULL);
    NSString *portString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.port)];
    worksheet_write_string(worksheet, 2, 1, [portString UTF8String], NULL);
    worksheet_write_string(worksheet, 2, 2, "Range: 1-65535", NULL);
    
    //Client id
    worksheet_write_string(worksheet, 3, 0, "Client id", NULL);
    NSString *clientIDString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.clientID)];
    worksheet_write_string(worksheet, 3, 1, [clientIDString UTF8String], NULL);
    worksheet_write_string(worksheet, 3, 2, "1-64 characters", NULL);
    
    //Subscribe Topic
    worksheet_write_string(worksheet, 4, 0, "Subscribe Topic", NULL);
    NSString *subscribeTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.subscribeTopic)];
    worksheet_write_string(worksheet, 4, 1, [subscribeTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 4, 2, "1-128 characters", NULL);
    
    //Publish Topic
    worksheet_write_string(worksheet, 5, 0, "Publish Topic", NULL);
    NSString *publishTopicString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.publishTopic)];
    worksheet_write_string(worksheet, 5, 1, [publishTopicString UTF8String], NULL);
    worksheet_write_string(worksheet, 5, 2, "1-128 characters", NULL);
    
    //Clean Session
    const char *sessionMsg = "Range: 0/1 \n0:NO \n1:YES";
    worksheet_write_string(worksheet, 6, 0, "Clean Session", NULL);
    NSString *cleanSessionString = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.cleanSession) {
        cleanSessionString = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 6, 1, [cleanSessionString UTF8String], NULL);
    worksheet_write_string(worksheet, 6, 2, sessionMsg, format);
    
    //Qos
    const char *qosMsg = "Range: 0/1/2 \n0:qos0 \n1:qos1 \n2:qos2";
    NSString *qos = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)protocol.qos];
    worksheet_write_string(worksheet, 7, 0, "Qos", NULL);
    worksheet_write_string(worksheet, 7, 1, [qos UTF8String], NULL);
    worksheet_write_string(worksheet, 7, 2, qosMsg, format);
    
    //Keep Alive
    worksheet_write_string(worksheet, 8, 0, "Keep Alive", NULL);
    NSString *keepString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.keepAlive)];
    worksheet_write_string(worksheet, 8, 1, [keepString UTF8String], NULL);
    worksheet_write_string(worksheet, 8, 2, "Range: 10-120, unit: second", NULL);
    
    //MQTT Username
    worksheet_write_string(worksheet, 9, 0, "MQTT Username", NULL);
    NSString *usernameString = @"";
    if (ValidStr(protocol.userName)) {
        usernameString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.userName)];
    }
    worksheet_write_string(worksheet, 9, 1, [usernameString UTF8String], NULL);
    worksheet_write_string(worksheet, 9, 2, "0-128 characters", NULL);
    
    //MQTT Password
    worksheet_write_string(worksheet, 10, 0, "MQTT Password", NULL);
    NSString *passwordString = @"";
    if (ValidStr(protocol.password)) {
        passwordString = [defaultKeyValueString stringByAppendingString:SafeStr(protocol.password)];
    }
    worksheet_write_string(worksheet, 10, 1, [passwordString UTF8String], NULL);
    worksheet_write_string(worksheet, 10, 2, "0-128 characters", NULL);
    
    //SSL/TLS
    const char *sslMsg = "Range: 0/1 \n0:Disable SSL (TCP mode) \n1:Enable SSL";
    worksheet_write_string(worksheet, 11, 0, "SSL/TLS", NULL);
    NSString *sslStatus = [defaultKeyValueString stringByAppendingString:@"0"];
    if (protocol.sslIsOn) {
        sslStatus = [defaultKeyValueString stringByAppendingString:@"1"];
    }
    worksheet_write_string(worksheet, 11, 1, [sslStatus UTF8String], NULL);
    worksheet_write_string(worksheet, 11, 2, sslMsg, format);
    
    //Certificate type
    const char *certlMsg = "Valid when SSL is enabled, range: 1/2/3 \n1: CA signed server certificate \n2: CA certificate file \n3: Self signed certificates";
    NSString *certValue = [NSString stringWithFormat:@"%@%ld",defaultKeyValueString,(long)(protocol.certificate + 1)];
    worksheet_write_string(worksheet, 12, 0, "Certificate type", NULL);
    worksheet_write_string(worksheet, 12, 1, [certValue UTF8String], NULL);
    worksheet_write_string(worksheet, 12, 2, certlMsg, format);
    
    //关闭，保存文件
    lxw_error errorCode = workbook_close(workbook);
    if (errorCode != LXW_NO_ERROR) {
        //写失败
        [self operationFailedBlockWithMsg:@"Export Failed" block:failedBlock];
        return;
    }
    //写成功
    if (sucBlock) {
        sucBlock();
    }
}

+ (void)parseDeviceExcel:(NSString *)excelName
                sucBlock:(void (^)(NSDictionary *returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelWookbook *workbook = [[MKExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //根据横竖坐标，获取单元格
    //Host
    MKExcelCell *hostCell = [sheet getCellWithColumn:@"B" row:2 error:nil];
    NSString *host = [SafeStr(hostCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(host) forKey:@"host"];
    //Port
    MKExcelCell *portCell = [sheet getCellWithColumn:@"B" row:3 error:nil];
    NSString *port = [SafeStr(portCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(port) forKey:@"port"];
    //Client id
    MKExcelCell *clientIDCell = [sheet getCellWithColumn:@"B" row:4 error:nil];
    NSString *clientID = [SafeStr(clientIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientID) forKey:@"clientID"];
    //Subscribe Topic
    MKExcelCell *subTopicCell = [sheet getCellWithColumn:@"B" row:5 error:nil];
    NSString *subTopic = [SafeStr(subTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(subTopic) forKey:@"subscribeTopic"];
    //Publish Topic
    MKExcelCell *pubTopicCell = [sheet getCellWithColumn:@"B" row:6 error:nil];
    NSString *pubTopic = [SafeStr(pubTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(pubTopic) forKey:@"publishTopic"];
    //Clean Session
    MKExcelCell *cleanSessionCell = [sheet getCellWithColumn:@"B" row:7 error:nil];
    NSString *sessionString = [SafeStr(cleanSessionCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL cleanSession = ([sessionString isEqualToString:@"1"]);
    [dic setObject:@(cleanSession) forKey:@"cleanSession"];
    //Qos
    MKExcelCell *qosCell = [sheet getCellWithColumn:@"B" row:8 error:nil];
    NSString *tempQos = [SafeStr(qosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger qosValue = [tempQos integerValue];
    if (qosValue < 0 || qosValue > 2) {
        //默认值
        qosValue = 1;
    }
    [dic setObject:@(qosValue) forKey:@"qos"];
    //Keep Alive
    MKExcelCell *keepAliveCell = [sheet getCellWithColumn:@"B" row:9 error:nil];
    NSString *keepAlive = [SafeStr(keepAliveCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    keepAlive = [keepAlive stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSInteger keepValue = [keepAlive integerValue];
//    if (keepValue < 10 || keepValue > 120) {
//        //默认值
//        keepValue = 60;
//    }
    [dic setObject:keepAlive forKey:@"keepAlive"];
    //MQTT Username
    MKExcelCell *usernameCell = [sheet getCellWithColumn:@"B" row:10 error:nil];
    NSString *username = [SafeStr(usernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(username) forKey:@"userName"];
    //MQTT Password
    MKExcelCell *passwordCell = [sheet getCellWithColumn:@"B" row:11 error:nil];
    NSString *password = [SafeStr(passwordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(password) forKey:@"password"];
    //SSL/TLS
    MKExcelCell *sslCell = [sheet getCellWithColumn:@"B" row:12 error:nil];
    NSString *sslString = [SafeStr(sslCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL ssl = ([sslString isEqualToString:@"1"]);
    [dic setObject:@(ssl) forKey:@"sslIsOn"];
    //Certificate type
    MKExcelCell *certificateCell = [sheet getCellWithColumn:@"B" row:13 error:nil];
    NSString *certString = [SafeStr(certificateCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger certValue = [certString integerValue] - 1;
    if (certValue < 0 || certValue > 2) {
        certValue = 0;
    }
    [dic setObject:@(certValue) forKey:@"certificate"];
    
    if (sucBlock) {
        sucBlock(dic);
    }
}

+ (void)parseBeaconExcel:(NSString *)excelName
                sucBlock:(void (^)(NSArray <NSDictionary *>*beaconInfoList))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelWookbook *workbook = [[MKExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableArray *macList = [NSMutableArray array];
    NSMutableArray *passwordList = [NSMutableArray array];
    //根据横竖坐标，获取单元格
    for (NSInteger i = 0; i < list.count; i ++) {
        MKExcelCell *cell = list[i];
        if ([cell.column isEqualToString:@"A"]) {
            //MAC地址列
            [macList addObject:cell];
        }
    }
    //去掉每一列第一行说明性文字
    [macList removeObjectAtIndex:0];
    NSMutableArray *resultList = [NSMutableArray array];
    NSInteger totalNum = macList.count;
    for (NSInteger i = 0; i < totalNum; i ++) {
        MKExcelCell *macCell = macList[i];
        NSString *macAddress = [macCell.stringValue stringByReplacingOccurrencesOfString:@":" withString:@""];
        macAddress = [macAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (macAddress.length == 12 && [macAddress regularExpressions:isHexadecimal]) {
            //必须是有效的mac地址
            NSDictionary *dic = @{
                @"macAddress":SafeStr(macCell.stringValue),
            };
            [resultList addObject:dic];
        }
    }
    if (sucBlock) {
        sucBlock(resultList);
    }
}

+ (void)parseBeaconOtaExcel:(NSString *)excelName
                   sucBlock:(void (^)(NSArray <NSString *>*beaconList))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidStr(excelName)) {
        [self operationFailedBlockWithMsg:@"File Name Cannot be empty" block:failedBlock];
        return;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:excelName];
    NSURL *excelUrl = [[NSURL alloc] initFileURLWithPath:path];
    if (!excelUrl) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelWookbook *workbook = [[MKExcelWookbook alloc] initWithExcelFilePathUrl:excelUrl];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSArray *list = sheet.cellArray;
    NSMutableArray *macList = [NSMutableArray array];
    //根据横竖坐标，获取单元格
    for (NSInteger i = 0; i < list.count; i ++) {
        MKExcelCell *cell = list[i];
        if ([cell.column isEqualToString:@"A"]) {
            //MAC地址列
            NSString *macAddress = [cell.stringValue stringByReplacingOccurrencesOfString:@":" withString:@""];
            macAddress = [macAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (macAddress.length == 12 && [macAddress regularExpressions:isHexadecimal]) {
                //必须是有效的mac地址
                [macList addObject:macAddress];
            }
        }
    }
    
    if (sucBlock) {
        sucBlock(macList);
    }
}

+ (void)parseDeviceAllParams:(NSURL *)filePath
                    sucBlock:(void (^)(NSDictionary *returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!filePath || ![filePath isKindOfClass:NSURL.class]) {
        [self operationFailedBlockWithMsg:@"File Path Error" block:failedBlock];
        return;
    }
    
    MKExcelWookbook *workbook = [[MKExcelWookbook alloc] initWithExcelFilePathUrl:filePath];
    if (!workbook || workbook.sheetArray.count == 0) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    MKExcelSheet *sheet = workbook.sheetArray.firstObject;
    if (![sheet isKindOfClass:MKExcelSheet.class]) {
        [self operationFailedBlockWithMsg:@"Load Excel Data Failed" block:failedBlock];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //根据横竖坐标，获取单元格
    //Host
    MKExcelCell *hostCell = [sheet getCellWithColumn:@"B" row:2 error:nil];
    NSString *host = [SafeStr(hostCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(host) forKey:@"host"];
    
    //Port
    MKExcelCell *portCell = [sheet getCellWithColumn:@"B" row:3 error:nil];
    NSString *port = [SafeStr(portCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(port) forKey:@"port"];
    
    //Client id
    MKExcelCell *clientIDCell = [sheet getCellWithColumn:@"B" row:4 error:nil];
    NSString *clientID = [SafeStr(clientIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientID) forKey:@"clientID"];
    
    //Subscribe Topic
    MKExcelCell *subTopicCell = [sheet getCellWithColumn:@"B" row:5 error:nil];
    NSString *subTopic = [SafeStr(subTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(subTopic) forKey:@"subscribeTopic"];
    
    //Publish Topic
    MKExcelCell *pubTopicCell = [sheet getCellWithColumn:@"B" row:6 error:nil];
    NSString *pubTopic = [SafeStr(pubTopicCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(pubTopic) forKey:@"publishTopic"];
    
    //Clean Session
    MKExcelCell *cleanSessionCell = [sheet getCellWithColumn:@"B" row:7 error:nil];
    NSString *sessionString = [SafeStr(cleanSessionCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL cleanSession = ([sessionString isEqualToString:@"1"]);
    [dic setObject:@(cleanSession) forKey:@"cleanSession"];
    
    //Qos
    MKExcelCell *qosCell = [sheet getCellWithColumn:@"B" row:8 error:nil];
    NSString *tempQos = [SafeStr(qosCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger qosValue = [tempQos integerValue];
    if (qosValue < 0 || qosValue > 2) {
        //默认值
        qosValue = 1;
    }
    [dic setObject:@(qosValue) forKey:@"qos"];
    
    //Keep Alive
    MKExcelCell *keepAliveCell = [sheet getCellWithColumn:@"B" row:9 error:nil];
    NSString *keepAlive = [SafeStr(keepAliveCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    keepAlive = [keepAlive stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic setObject:keepAlive forKey:@"keepAlive"];
    
    //MQTT Username
    MKExcelCell *usernameCell = [sheet getCellWithColumn:@"B" row:10 error:nil];
    NSString *username = [SafeStr(usernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(username) forKey:@"userName"];
    
    //MQTT Password
    MKExcelCell *passwordCell = [sheet getCellWithColumn:@"B" row:11 error:nil];
    NSString *password = [SafeStr(passwordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(password) forKey:@"password"];
    
    //SSL/TLS
    MKExcelCell *sslCell = [sheet getCellWithColumn:@"B" row:12 error:nil];
    NSString *sslString = [SafeStr(sslCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL ssl = ([sslString isEqualToString:@"1"]);
    [dic setObject:@(ssl) forKey:@"sslIsOn"];
    
    //CA cert file URL
    MKExcelCell *caCell = [sheet getCellWithColumn:@"B" row:13 error:nil];
    NSString *caPath = [SafeStr(caCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(caPath) forKey:@"caPath"];
    
    //Client cert file URL
    MKExcelCell *clientCertCell = [sheet getCellWithColumn:@"B" row:14 error:nil];
    NSString *clientCertPath = [SafeStr(clientCertCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientCertPath) forKey:@"clientCertPath"];
    
    //Client key file URL
    MKExcelCell *clientKeyCell = [sheet getCellWithColumn:@"B" row:15 error:nil];
    NSString *clientKeyPath = [SafeStr(clientKeyCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(clientKeyPath) forKey:@"clientKeyPath"];
    
    //Certificate type
    MKExcelCell *certificateCell = [sheet getCellWithColumn:@"B" row:16 error:nil];
    NSString *certString = [SafeStr(certificateCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger certValue = [certString integerValue] - 1;
    if (certValue < 0 || certValue > 2) {
        certValue = 0;
    }
    [dic setObject:@(certValue) forKey:@"certificate"];
    
    //Security
    MKExcelCell *securityCell = [sheet getCellWithColumn:@"B" row:17 error:nil];
    NSString *securityString = [SafeStr(securityCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(securityString) forKey:@"security"];
    
    //EAP type
    MKExcelCell *eapCell = [sheet getCellWithColumn:@"B" row:18 error:nil];
    NSString *eapString = [SafeStr(eapCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(eapString) forKey:@"eap"];
    
    //SSID
    MKExcelCell *wifiSSIDCell = [sheet getCellWithColumn:@"B" row:19 error:nil];
    NSString *wifiSSID = [SafeStr(wifiSSIDCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(wifiSSID) forKey:@"wifiSSID"];
    
    //Password
    MKExcelCell *wifiPasswordCell = [sheet getCellWithColumn:@"B" row:20 error:nil];
    NSString *wifiPassword = [SafeStr(wifiPasswordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(wifiPassword) forKey:@"wifiPassword"];
    
    //Domain ID
    MKExcelCell *domainIdCell = [sheet getCellWithColumn:@"B" row:21 error:nil];
    NSString *domainID = [SafeStr(domainIdCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(domainID) forKey:@"domainID"];
    
    //EAP Username
    MKExcelCell *eapUsernameCell = [sheet getCellWithColumn:@"B" row:22 error:nil];
    NSString *eapUsername = [SafeStr(eapUsernameCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(eapUsername) forKey:@"eapUsername"];
    
    //EAP Password
    MKExcelCell *eapPasswordCell = [sheet getCellWithColumn:@"B" row:23 error:nil];
    NSString *eapPassword = [SafeStr(eapPasswordCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(eapPassword) forKey:@"eapPassword"];
    
    //Verify server
    MKExcelCell *verifyServerCell = [sheet getCellWithColumn:@"B" row:24 error:nil];
    NSString *verifyServerString = [SafeStr(verifyServerCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL verifyServer = ([verifyServerString isEqualToString:@"1"]);
    [dic setObject:@(verifyServer) forKey:@"verifyServer"];
    
    //wifi CA cert file URL
    MKExcelCell *wifiCaCell = [sheet getCellWithColumn:@"B" row:25 error:nil];
    NSString *wifiCaPath = [SafeStr(wifiCaCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(wifiCaPath) forKey:@"wifiCaPath"];
    
    //wifi Client cert file URL
    MKExcelCell *wifiClientCertCell = [sheet getCellWithColumn:@"B" row:26 error:nil];
    NSString *wifiClientCertPath = [SafeStr(wifiClientCertCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(wifiClientCertPath) forKey:@"wifiClientCertPath"];
    
    //wifi Client key file URL
    MKExcelCell *wifiClientKeyCell = [sheet getCellWithColumn:@"B" row:27 error:nil];
    NSString *wifiClientKeyPath = [SafeStr(wifiClientKeyCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(wifiClientKeyPath) forKey:@"wifiClientKeyPath"];
    
    
    //Network Settings
    //DHCP
    MKExcelCell *dhcpCell = [sheet getCellWithColumn:@"B" row:28 error:nil];
    NSString *dhcpString = [SafeStr(dhcpCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    BOOL dhcp = ([dhcpString isEqualToString:@"1"]);
    [dic setObject:@(dhcp) forKey:@"dhcp"];
    
    //IP
    MKExcelCell *ipCell = [sheet getCellWithColumn:@"B" row:29 error:nil];
    NSString *ip = [SafeStr(ipCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(ip) forKey:@"ip"];
    
    //Mask
    MKExcelCell *maskCell = [sheet getCellWithColumn:@"B" row:30 error:nil];
    NSString *mask = [SafeStr(maskCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(mask) forKey:@"mask"];
    
    //Gateway
    MKExcelCell *gatewayCell = [sheet getCellWithColumn:@"B" row:31 error:nil];
    NSString *gateway = [SafeStr(gatewayCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(gateway) forKey:@"gateway"];
    
    //DNS
    MKExcelCell *dnsCell = [sheet getCellWithColumn:@"B" row:32 error:nil];
    NSString *dns = [SafeStr(dnsCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(dns) forKey:@"dns"];
    
    //NTP Server
    MKExcelCell *ntpServerCell = [sheet getCellWithColumn:@"B" row:33 error:nil];
    NSString *ntpServer = [SafeStr(ntpServerCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    [dic setObject:SafeStr(ntpServer) forKey:@"ntpServer"];
    
    //Timezone
    MKExcelCell *timezoneCell = [sheet getCellWithColumn:@"B" row:34 error:nil];
    NSString *timezoneString = [SafeStr(timezoneCell.stringValue) stringByReplacingOccurrencesOfString:defaultKeyValueString withString:@""];
    NSInteger timezoneValue = [timezoneString integerValue];
    [dic setObject:@(timezoneValue) forKey:@"timezone"];
    
    if (sucBlock) {
        sucBlock(dic);
    }
}

#pragma mark - Private method
+ (BOOL)checkExcelAppProtocol:(id <MKCHExcelAppProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKCHExcelAppProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.host) || protocol.host.length > 64 || ![protocol.host isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.port) || [protocol.port integerValue] < 1 || [protocol.port integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (protocol.publishTopic.length > 128 || (ValidStr(protocol.publishTopic) && ![protocol.publishTopic isAsciiString])) {
        return NO;
    }
    if (protocol.subscribeTopic.length > 128 || (ValidStr(protocol.subscribeTopic) && ![protocol.subscribeTopic isAsciiString])) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (!ValidStr(protocol.keepAlive) || [protocol.keepAlive integerValue] < 10 || [protocol.keepAlive integerValue] > 120) {
        return NO;
    }
    if (protocol.userName.length > 128 || (ValidStr(protocol.userName) && ![protocol.userName isAsciiString])) {
        return NO;
    }
    if (protocol.password.length > 128 || (ValidStr(protocol.password) && ![protocol.password isAsciiString])) {
        return NO;
    }
    if (protocol.sslIsOn) {
        if (protocol.certificate < 0 || protocol.certificate > 2) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkExcelDeviceProtocol:(id <MKCHExcelDeviceProtocol>)protocol {
    if (!protocol || ![protocol conformsToProtocol:@protocol(MKCHExcelDeviceProtocol)]) {
        return NO;
    }
    if (!ValidStr(protocol.host) || protocol.host.length > 64 || ![protocol.host isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.port) || [protocol.port integerValue] < 1 || [protocol.port integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(protocol.clientID) || protocol.clientID.length > 64 || ![protocol.clientID isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.publishTopic) || protocol.publishTopic.length > 128 || ![protocol.publishTopic isAsciiString]) {
        return NO;
    }
    if (!ValidStr(protocol.subscribeTopic) || protocol.subscribeTopic.length > 128 || ![protocol.subscribeTopic isAsciiString]) {
        return NO;
    }
    if (protocol.qos < 0 || protocol.qos > 2) {
        return NO;
    }
    if (!ValidStr(protocol.keepAlive) || [protocol.keepAlive integerValue] < 10 || [protocol.keepAlive integerValue] > 120) {
        return NO;
    }
    if (protocol.userName.length > 128 || (ValidStr(protocol.userName) && ![protocol.userName isAsciiString])) {
        return NO;
    }
    if (protocol.password.length > 128 || (ValidStr(protocol.password) && ![protocol.password isAsciiString])) {
        return NO;
    }
    if (protocol.sslIsOn) {
        if (protocol.certificate < 0 || protocol.certificate > 2) {
            return NO;
        }
    }
    return YES;
}

+ (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"excelOperation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

@end
