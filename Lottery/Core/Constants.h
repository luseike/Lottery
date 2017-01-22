//
//  Constants.h
//  impi
//
//  Created by Chris on 15/3/21.
//  Copyright (c) 2015年 Zoimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  订单cell的间距
 */
UIKIT_EXTERN CGFloat const OrderCellMargin;

//judge screen size 判断屏幕尺寸
#define IS_IPHONE4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6P  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2280), [[UIScreen mainScreen] currentMode].size) : NO)


//版本
#define IS_OS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

//obtain screen size(frame、width、height) 获取屏幕尺寸
#define __MainScreenFrame  [[UIScreen mainScreen] bounds]
#define __MainScreenWidth  __MainScreenFrame.size.width
#define __MainScreenHeight  __MainScreenFrame.size.height
//define color 颜色定义
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//UIColorFromRGB(0x067AB5)

#define CheckNetwork if(!isOnline){[PiClient HUDShowMessage:@"网络未连接" addedToView:[UIApplication sharedApplication].keyWindow];return;}

//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/db/BBCall.db"]


#define DEBUGMODE 0


typedef NS_ENUM(NSInteger, ResultCodeType){
    ResultCodeSuccess = 200,//操作成功
    ResultCodeFileTooLarge = 201,//上传文件超过大小
    ResultCodeInvalidParam = 202,//参数错误
    ResultCodeNoData = 203,//查询不到结果
    ResultCodeFail = 502//操作失败
};

//test address 测试地址
#if 0
//    #define kIP @"http://j2eeking.vicp.net:8012/"
//    #define kHost @"http://j2eeking.vicp.net:8012/bbcallV2.1/"
//    #define kIP @"http://192.168.10.30:8082/"
//    #define kHost @"http://192.168.10.30:8082/impi/"
#else
    #define kIP @"http://api.impi.me/"
    #define kHost @"http://api.impi.me/"
//#define kIP @"http://j2eeking.vicp.net:9012"
//#define kHost @"http://j2eeking.vicp.net:9012/impi/"
#endif

//备用地址

/**
 *API 接口
 *Author:Chris 接口分类
 **/

//////////////////////API/////////////////////////
//基础接口
#define API_VERSION @"ver3/version.c" //版本更新
#define API_FEEDBACK @"ver3/feedBack.c" //系统反馈
#define API_TOKEN @"ver3/token.c" //token请求
#define API_HEART_BEAT @"ver3/user/heartbeat.c" //心跳

//公用地址
//#define kIP @"http://app.impi.me/"
//#define kHost @"http://app.impi.me/"

//用户接口

//注册登录
#define API_SEND_MOBI_MSG @"ver3/user/sendMobiMsg.c" //请求手机校验码
#define API_VERIFY_PHONE_CODE @"ver3/user/verifyPhoneCode.c" //验证手机校验码
#define API_FIND_PASSWORD_MOBI_MSG @"ver3/password/sendMobiMsg.c" //请求手机校验码  (找回密码)
#define API_RESET_PASSWORD @"ver3/password/resetPass.c" //重置密码
#define API_LOGIN @"ver3/user/login.c" //登录
#define API_THIRD_PARTY_LOGIN @"ver3/account/login.c" //第三方登录
#define API_WEIBO_BIND @"ver3/account/bind.c" //微博绑定
#define API_PHONE_BIND @"ver3/account/updateUserPhone.c"//手机号绑定


//用户接口

#define API_BIND @"ver3/user/bind.c" //绑定

//#define API_UNREAD_MSG @"ver3/user/unreadmsg/reach.c" //收到离线消息
#define API_LOGOUT @"ver3/user/logout.c" //注销

#define API_MODIFY_PWD @"ver3/password/modifyPwd.c" //修改密码

//用户协议
#define API_AGREEMENT @"static/about.html"


#define API_PROFILE_MODIFY @"ver3/user/modify.c" //修改个人资料
#define API_UPLOAD_AVATAR @"ver3/user/uploadAvatar.c" //上传头像
#define API_UPLOAD_BACKGROUND @"ver3/user/uploadBackground.c" //上传背景图片
#define API_PERSONAL_DATA @"ver3/dynamic/changeDynamic.c" //个性签名
#define API_GET_MY_PROFILE @"ver3/user/getUser.c" //获取我的个人资料
#define API_GET_USERINFO @"ver3/user/getUserInfo.c" //获取个人资料
//#define API_GET_USER_PROFILE @"ver3/user/getOthersUserInfo.c" //获取对方个人资料

#define API_USER_ALBUM_LIST @"ver3/user/album/list.c" //获取具体某个人的相册
#define API_USER_ALBUM_ADD @"ver3/user/album/add.c" //添加相片
#define API_USER_ALBUM_DEL @"ver3/user/album/del.c" //删除相片

//发现
#define API_USER_LOCATION @"ver3/user/location.c" //更新地理位置
#define API_USER_SEARCH @"ver3/user/search.c" //搜索附近的人
#define API_USER_RANDOM @"ver3/user/random.c" //推荐人
#define API_USER_NEARBY @"ver3/user/recommendAttention.c" //推荐附近的人

//联系人
#define API_CONTACT_LIST @"ver3/contact/list.c"//我的联系人列表
//#define API_CONTACT_FANS @"ver3/contact/fans.c"//我的粉丝
//#define API_CONTACT_FRIENDS @"ver3/contact/friends.c"//我的好友
//#define API_CONTACT_GROUPS @"ver3/note/dialog/groups.c"//群组
#define API_CONTACT_SEARCH @"ver3/contact/search.c"//搜图拍号
#define API_CONTACT_CREATE @"ver3/contact/create.c"//添加关注
#define API_CONTACT_DESTORY @"ver3/contact/destory.c"//取消关注
#define API_CONTACT_ADD_BLACK @"ver3/contact/destoryandaddblack.c"//加入黑名单

#define API_CONTACT_NEW_FRIEND @"ver3/contact/newfriend.c"//新的朋友

#define API_CONTACT_PHONE_MATCH @"ver3/contact/phone/match.c"//通讯里匹配
#define API_CONTACT_REMARK @"ver3/contact/remark.c"//添加备注
#define API_GET_REMARK @"ver3/contact/findRemark.c"//获取备注

//图拍
//#define API_NOTE_DIALOG_LASTCONTACTS @"ver3/note/dialog/lastContactUsers.c" //获取最近联系人

#define API_NOTE_DIALOG_NEW_CONTACTS @"ver3/note/dialog/newContact.c" //获取最近联系人

#define API_NOTE_DIALOG_LIST @"ver3/note/dialog/list.c" //我的会话列表
#define API_NOTE_DIALOG_CREATE @"ver3/note/dialog/create.c" //创建会话
#define API_NOTE_DIALOG_DELETE @"ver3/note/dialog/delete.c" //删除会话
#define API_NOTE_DIALOG_DESTORY @"ver3/note/dialog/destory.c" //解散群，退出群

//#define API_CALL_CONTENT_REACH @"ver3/note/content/reach.c" //消息送达
//#define API_CALL_CONTENT_READ @"ver3/note/content/read.c" //消息已读

#define API_NOTE_CONTENT_CREATE @"ver3/note/content/create.c" //发布消息
#define API_NOTE_CONTENT_GET @"ver3/note/content/getNotes.c" //我和某个联系人的消息
#define API_NOTE_CONTENT_UNREAD @"ver3/note/content/unreadNotes.c" //我和某个联系人未送达的消息
#define API_NOTE_CONTENT_GETMSG @"ver3/note/content/getMsgById.c" //根据ID获取具体消息内容
#define API_NOTE_CONTENT_DESTORY @"ver3/note/content/destory.c" //删除一条消息
#define API_NOTE_CONTENT_CLEAN @"ver3/note/content/clean.c" //清空和某个联系人消息

#define API_NOTE_CONTENT_SENDMSG @"ver3/note/content/sendMsg.c"

//快捷回复
#define API_QUICKREPLY_CREATE @"ver3/note/content/quickReply/create.c" //创建快捷回复
#define API_QUICKREPLY_LIST @"ver3/note/content/quickReply/list.c" //快捷回复列表
#define API_QUICKREPLY_FIND @"ver3/note/content/quickReply/find.c" //获取快捷回复单条信息

//现场
#define API_LOCALE_DIALOG_LIST @"ver3/locale/dialog/listDefault.c"
#define API_LOCALE_DIALOG_REPLY_LIST @"ver3/localeReply/list.c"
#define API_LOCALE_DIALOG_REPLY_ADD @"ver3/localeReply/add.c"
#define API_LOCALE_DIALOG_MYLIST @"ver3/locale/dialog/mylist.c"
#define API_LOCALE_DIALOG_LISTONEDAY @"ver3/locale/dialog/listOneDay.c"
#define API_LOCALE_CONTENT_LIST @"ver3/locale/content/getNotes.c"
#define API_LOCALE_DELETE @"ver3/locale/dialog/delete.c"

#define API_LOCALE_MYLOCALEPAGER @"ver3/locale/dialog/myLocalePager.c"

//消息通知
#define API_FOLLOWED_NOTICE @"ver3/note/adcontent/findListByUserId.c"
//现场通知
#define API_SPOT_NOTICE_LIST @"ver3/note/adcontent/findLocOrAct.c"



//#define API_CALL_DIALOG_MODIFYNAME @"ver3/note/dialog/modifyName.c" //修改群名称 群主改

#define API_GROUP_LIST @"ver3/note/dialog/groups.c" //群列表
#define API_GROUP_INFO @"ver3/note/dialog/info.c" //群详情 参数 dialogId 返回结果 notedialog
#define API_GROUP_INFO2 @"ver3/note/dialog/userDialogInfo.c"
//参数 userId 用户ID dialogId 会话ID  userDialogId 用户会话Id  name 群名称  doNotDisturb 消息免打扰  hasSaveContact 保存到通讯录
#define API_GROUP_UPDATE @"ver3/note/dialog/update.c" //消息免打扰、保存到通讯录、修改群聊名称
#define API_GROUP_MEMBERS @"ver3/note/dialog/members.c" //群成员管理(增加删除群成员)

//投诉
#define API_REPOERT_USER @"ver3/report.c" //举报用户
#define API_REPOERT_MSG @"ver3/note/content/report.c" //举报图片
#define API_REPORT_LOCALE @"ver3/locale/content/report.c" //举报现场


//个人设置

//黑名单
#define API_BLACKLIST_ADD @"ver3/user/blackList/addBlackList.c" //加入黑名单
#define API_BLACKLIST_LIST @"ver3/user/blackList/blackList.c" //黑名单列表
#define API_BLACKLIST_DELETE_USER @"ver3/user/blackList/delBlackIds.c" //移出黑名单


//用户协议
#define API_AGREEMENT @"static/about.html"

//找回密码

//第三方帐号
#define API_ACCOUNT_LOGIN @"ver3/account/login.c" //注册和登录
//微博匹配
#define API_WEIBO_MATCH @"ver3/contact/weibo/match.c"


//系统帐号
#define API_SYSTEM_MESSAGE_LIST @"ver3/note/dialog/system/list.c"  //userId
#define API_SYSTEM_MESSAGE_GET @"ver3/note/content/getSysMsgNotes.c" //

#define API_CALL_DIALOG_LIST2 @"ver3/note/dialog/list/V2.c" //会话混排

#define API_UPDATE_LOCATION @"ver3/dynamic/updateLatLon.c" //更新经纬度


//联系人

//用户之间的会话

//名称： 图拍
//Icon：
//ID：2192823
//API Key：MQhGuHxTzKNne8e0TWSyzURC
//Secret Key：mF6FTII1GaynTEeIIqKOetbRWAQdcdYT

//微博
#define WeiboAppKey @"2266746809"
#define WeiboAppSecret @"59d8ff29193b994a38a8ce04e5dadce6"
#define WeiboRedirectUri @"http://sns.whalecloud.com/sina2/callback"

//微信
#define WeixinAppID @"wxe805bd822ffda698"
#define WeixinAppSecret @"b7f7e3f4dfc06c461e83cb64a4681f14"

//QQ
#define QQAppID @"1104221936"
#define QQAppSecret @"PMsKDF6GZDf6wGWs"

//Umeng
#define UmengAppKey @"514197cc56240b4dbd000aae"

//Baidu SDK
#define BaiduAppKey @"4yQmyfikdd3ikpIZY92HW4Ky"

//ShareSDK
#define ShareSDKAppKey @"6b712a584141"
#define ShareSDKAppSecret @"735a2713b2d91de59650956a2b4384ba"


static NSMutableArray *nameAndPhoneArray;//手机联系人名称和电话数组
static NSMutableArray *weiboListArray;//微博联系人数组
static NSMutableArray *gMyContactArray;//联系人

/**
 *third-party App Key 第三方key
 **/

static BOOL isOnline;
static NSString *QNToken;


typedef enum {
    PushTypeLoginBind = 10,//关联人登录（手机、微博等）
    PushTypeLoginByThird = 11,//第三方登录（强制退出）
    PushTypeAddRelation = 12,//添加关注推送
    PushTypeNewMsg = 20,//新个聊消息
    PushTypeSysMsg = 21,//系统消息
    PushTypeQuickReply = 22//快捷回复
} PushType;

//现场发送状态
enum LocaleSendStatus {
    LocaleSendStatusWait = 0,
    LocaleSendStatusSending = 1,
    LocaleSendStatusFailure = 2,
    LocaleSendStatusSuccess = 3,
    LocaleSendStatusDelete = 4
};

//
#define PiVoiceDidFinishPlayingNotification               @"PiVoiceDidFinishPlayingNotification"

//#define DEFAULT_FONT @"FZLanTingHeiS-R-GB"

@interface Constants : NSObject


@end
