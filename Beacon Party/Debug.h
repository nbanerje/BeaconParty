#ifdef DEBUG_LOGS
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
dispatch_async(dispatch_get_main_queue(), ^{\
if(self.debugTextView) {\
self.debugTextView.text = [self.debugTextView.text stringByAppendingString:\
[NSString stringWithFormat:(@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]];\
NSRange bottom = NSMakeRange(self.debugTextView.text.length -1, 1);\
[self.debugTextView scrollRangeToVisible:bottom];\
}\
});
#else
#   define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)