//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import "DSIOConfig.h"

static BOOL showLogs = NO;

// Logging

void DSIOSetShowDebugLogs(BOOL showDebugLogs) {
    showLogs = showDebugLogs;
}

void DSIOLog(NSString *format, ...) {
    if (!showLogs) return;
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
}