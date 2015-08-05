//
//  TMWCustomLogs.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#ifdef DEBUG
// Turn ON custom logs
#define TMWLog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
// Turn OFF custom logs
#define TMWLog(...) do {} while(0)
#endif
