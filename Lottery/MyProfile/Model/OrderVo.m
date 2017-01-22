//
//  OrderVo.m
//  Lottery
//
//  Created by 蒋远路 on 16/6/13.
//  Copyright © 2016年 Chris Deng. All rights reserved.
//

#import "OrderVo.h"
#import "OrderItemVo.h"
#import "Constants.h"

@implementation OrderVo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"items":[OrderItemVo class]};
}


//-(CGFloat)orderCellHeight{
//    if (!_orderCellHeight) {
//        
//        CGFloat norMalH = 16;
//        //datasLabel的高度
//        
//        CGFloat maxWidth = KScreenWidth - 70;
//        
//        NSMutableString *dataStr = [NSMutableString string];
//        if (self.items.count == 1) {
//            dataStr.string = [[self.items firstObject] dataStr];
//        }else{
////            NSMutableString *dataStr = [NSMutableString string];
//            for (NSInteger i = 0; i < self.items.count; i++) {
//                OrderItemVo *item = self.items[i];
//                
//                [dataStr appendString:[NSString stringWithFormat:@"%@\r\n",item.dataStr]];
//            }
////            dataStr = dataStr;
//        }
//        CGSize size = [dataStr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//        
//        
//        
//        CGFloat dataH = size.height;//self.items.count * norMalH + (self.items.count - 1) * OrderCellMargin;
////        self.dateViewH = _dateViewH;
//        
//        _orderCellHeight = dataH + norMalH * 2 + OrderCellMargin * 4;
//    }
//    return _orderCellHeight;
//}

@end
