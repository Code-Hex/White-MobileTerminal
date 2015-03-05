// ColorMap.m
// MobileTerminal

#import "ColorMap.h"
#import "VT100Terminal.h"

// 16 terminal color slots available
//static const int kNumTerminalColors = 16;

@implementation ColorMap

@synthesize background;
@synthesize foreground;
@synthesize foregroundBold;
@synthesize foregroundCursor;
@synthesize backgroundCursor;

- (instancetype)init
{

    if (self = [super init]) {
        
        background = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
        foreground = [[UIColor alloc] initWithWhite:0.0f alpha:1.f];
        foregroundBold = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
        backgroundCursor = [[UIColor alloc] initWithWhite:0.f alpha:0.4f];
        foregroundCursor = foreground;
        
        // System 7.5 colors, why not?
        table[0]  = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:1.f]; // black
        table[1]  = [[UIColor alloc] initWithRed:0.6f green:0.0f blue:0.0f alpha:1.f]; // dark red
        table[2]  = [[UIColor alloc] initWithRed:0.0f green:0.6f blue:0.0f alpha:1.f]; // dark green
        table[3]  = [[UIColor alloc] initWithRed:0.6f green:0.4f blue:0.0f alpha:1.f]; // dark yellow
        table[4]  = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.6f alpha:1.f]; // dark blue
        table[5]  = [[UIColor alloc] initWithRed:0.6f green:0.0f blue:0.6f alpha:1.f]; // dark magenta
        table[6]  = [[UIColor alloc] initWithRed:0.0f green:0.6f blue:0.6f alpha:1.f]; // dark cyan
        table[7]  = [[UIColor alloc] initWithRed:0.6f green:0.6f blue:0.6f alpha:1.f]; // dark white
        table[8]  = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:1.f]; // black
        table[9]  = [[UIColor alloc] initWithRed:1.0f green:0.0f blue:0.0f alpha:1.f]; // red
        table[10] = [[UIColor alloc] initWithRed:0.0f green:1.0f blue:0.0f alpha:1.f]; // green
        table[11] = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:0.0f alpha:1.f]; // yellow
        table[12] = [[UIColor alloc] initWithRed:0.0f green:0.0f blue:1.0f alpha:1.f]; // blue
        table[13] = [[UIColor alloc] initWithRed:1.0f green:0.0f blue:1.0f alpha:1.f]; // magenta
        table[14] = [[UIColor alloc] initWithRed:0.0f green:1.0f blue:1.0f alpha:1.f]; // light cyan
        table[15] = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1.f]; // white
        
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{

    if(self = [self init]){
        NSUserDefaults *colorDefaults = [NSUserDefaults standardUserDefaults];
        if ([dictionary[@"Theme"] isEqual:@"My Theme"]) {
            CGFloat red, green, blue;
            
            NSData *colorData1 = [colorDefaults objectForKey:@"Term_Background"];
            NSData *colorData2 = [colorDefaults objectForKey:@"Term_Text"];
            NSData *colorData3 = [colorDefaults objectForKey:@"Term_BoldText"];
            NSData *colorData4 = [colorDefaults objectForKey:@"Term_Cursor"];
            
            UIColor *term_background = [NSKeyedUnarchiver unarchiveObjectWithData:colorData1];
            UIColor *term_text = [NSKeyedUnarchiver unarchiveObjectWithData:colorData2];
            UIColor *term_bold = [NSKeyedUnarchiver unarchiveObjectWithData:colorData3];
            UIColor *term_cursor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData4];
            
            if (term_background) {
                const CGFloat *rgba = CGColorGetComponents(term_background.CGColor);
                red = rgba[0];
                green = rgba[1];
                blue = rgba[2];
                term_background = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.f];
            } else
                term_background = [[UIColor alloc] initWithWhite:0.f alpha:0.f];
            
            if (term_text) {
                const CGFloat *rgba = CGColorGetComponents(term_text.CGColor);
                red = rgba[0];
                green = rgba[1];
                blue = rgba[2];
                term_text = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.f];
            } else
                term_text = [[UIColor alloc] initWithRed:0.2 green:0.8 blue:0 alpha:1.f];
            
            if (term_bold) {
                const CGFloat *rgba = CGColorGetComponents(term_bold.CGColor);
                red = rgba[0];
                green = rgba[1];
                blue = rgba[2];
                term_bold = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.f];
            } else
                term_bold = [[UIColor alloc] initWithRed:0.6 green:0 blue:0 alpha:1.f];
            
            if (term_cursor) {
                const CGFloat *rgba = CGColorGetComponents(term_cursor.CGColor);
                red = rgba[0];
                green = rgba[1];
                blue = rgba[2];
                term_cursor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.f];
            } else
                term_cursor = [[UIColor alloc] initWithRed:0.6 green:0 blue:0 alpha:1.f];
            
            background = term_background;
            foreground = term_text;
            foregroundBold = term_bold;
            foregroundCursor = term_cursor;
            backgroundCursor = term_cursor;
            
        } else if ([dictionary[@"Theme"] isEqual:@"Solid Colors"]) {
            int c = (int)arc4random_uniform(10);
            
            NSArray *background_color = dictionary[@"background"];
            
            
            NSArray *foreground_color = dictionary[@"foreground"];
            NSArray *foregroundbold_color = dictionary[@"foregroundBold"];
            NSArray *cursor_color = dictionary[@"cursor"];
            
            background = [[UIColor alloc] initWithRed:[background_color[c][0] doubleValue]/255 green:[background_color[c][1] doubleValue]/255 blue:[background_color[c][2] doubleValue]/255 alpha:1.f];
            
            foreground = [[UIColor alloc] initWithRed:[foreground_color[0] doubleValue]/255 green:[foreground_color[1] doubleValue]/255 blue:[foreground_color[2] doubleValue]/255 alpha:1.f];
            
            foregroundBold = [[UIColor alloc] initWithRed:[foregroundbold_color[0] doubleValue]/255 green:[foregroundbold_color[1] doubleValue]/255 blue:[foregroundbold_color[2] doubleValue]/255 alpha:1.f];
            
            backgroundCursor = [[UIColor alloc] initWithRed:[cursor_color[0] doubleValue]/255 green:[cursor_color[1] doubleValue]/255 blue:[cursor_color[2] doubleValue]/255 alpha:1.f];
        } else {
            NSArray *background_color = dictionary[@"background"];
            NSArray *foreground_color = dictionary[@"foreground"];
            NSArray *foregroundbold_color = dictionary[@"foregroundBold"];
            NSArray *cursor_color = dictionary[@"cursor"];
            
            background = [[UIColor alloc] initWithRed:[background_color[0] doubleValue]/255 green:[background_color[1] doubleValue]/255 blue:[background_color[2] doubleValue]/255 alpha:1.f];
            
            foreground = [[UIColor alloc] initWithRed:[foreground_color[0] doubleValue]/255 green:[foreground_color[1] doubleValue]/255 blue:[foreground_color[2] doubleValue]/255 alpha:1.f];
            
            foregroundBold = [[UIColor alloc] initWithRed:[foregroundbold_color[0] doubleValue]/255 green:[foregroundbold_color[1] doubleValue]/255 blue:[foregroundbold_color[2] doubleValue]/255 alpha:1.f];
            
            backgroundCursor = [[UIColor alloc] initWithRed:[cursor_color[0] doubleValue]/255 green:[cursor_color[1] doubleValue]/255 blue:[cursor_color[2] doubleValue]/255 alpha:1.f];
        }
        foregroundCursor = foreground;
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:background];
        [colorDefaults setObject:colorData forKey:@"Background"];
        // [colorDefaults setBool:truth forKey:@"Statusbar"]; If you want to use statusbar
        [colorDefaults synchronize];

    }
    return self;
    
}

//Color settings
- (UIColor *)_colorFromArray:(NSArray *)array {
	
    return (!array || array.count != 3) ? nil : [UIColor colorWithRed:((NSNumber *)array[0]).floatValue / 255.f green:((NSNumber *)array[1]).floatValue / 255.f blue:((NSNumber *)array[2]).floatValue / 255.f alpha:1.f];
}


- (void)dealloc
{
    for(int i = 0; i < COLOR_MAP_MAX_COLORS; ++i)
        [table[i] release];

    [background release];
    [foreground release];
    [foregroundBold release];
    [foregroundCursor release];
    [backgroundCursor release];
    [super dealloc];
}


- (UIColor*)color:(unsigned int)index;
{
    // TODO(allen): The logic here is pretty ad hoc and could use some
    // some helpful comments describing whats its doing.  It seems to work?
    if (index & COLOR_CODE_MASK)
    {
        switch (index) {
            case CURSOR_TEXT:
                return foregroundCursor;
            case CURSOR_BG:
                return backgroundCursor;
            case BG_COLOR_CODE:
                return background;
            default:
                if (index & BOLD_MASK) {
                    if (index - BOLD_MASK == BG_COLOR_CODE) return background;
                    else return foregroundBold;
                } else return foreground;
        }
        
    } else {
        index &= 0xff; // 0xff = (1111 1111)
        if (index < 16) return table[index];
        else if (index < 232) {
            index -= 16;
            float components[] = {
                (index / 36) ? ((index / 36) * 40 + 55) / 256.0 : 0,
                (index % 36) / 6 ? (((index % 36) / 6) * 40 + 55 ) / 256.0 : 0,
                (index % 6) ? ((index % 6) * 40 + 55) / 256.0 : 0,
                1.0
            };
            return [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:1.0f];
        } else return foreground;
        
    }
}

@end