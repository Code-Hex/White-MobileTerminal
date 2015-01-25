// ColorMap.m
// MobileTerminal

#import "ColorMap.h"
#import "VT100Terminal.h"

#define CASE(str) if ([__s__ isEqualToString:(str)])
#define SWITCH(s) for (NSString *__s__ = (s); ; )
#define DEFAULT
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:1.0];



// 16 terminal color slots available
//static const int kNumTerminalColors = 16;

@implementation ColorMap

@synthesize background;
@synthesize foreground;
@synthesize foregroundBold;
@synthesize foregroundCursor;
@synthesize backgroundCursor;

- (void)initColorTable
{
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

- (id)init
{
    return [self initWithCoder:nil];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        [self initColorTable];
        
        NSUserDefaults *colorDefaults = [NSUserDefaults standardUserDefaults];
        NSString *colorMap = [colorDefaults objectForKey:@"colorMap"];
        //BOOL truth = NO;
        
        SWITCH (colorMap) {
            CASE (@"Basic") {
                background = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                foreground = [[UIColor alloc] initWithWhite:0.0f alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                foregroundCursor = [[UIColor alloc] initWithWhite:1.f alpha:0.95f];
                backgroundCursor = [[UIColor alloc] initWithWhite:0.f alpha:0.4f];
                break;
            }
            CASE (@"Grass") {
                background = [[UIColor alloc] initWithRed:19/255.0 green:119/255.0 blue:61/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithRed:255/255.0 green:240/255.0 blue:165/255.0 alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithRed:255/255.0 green:176/255.0 blue:59/255.0 alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:142/255.0 green:40/255.0 blue:0.f alpha:1.f];
                foregroundCursor = foreground;
                //truth = YES;
                break;
            }
            CASE (@"Homebrew") {
                background = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                foreground = [[UIColor alloc] initWithRed:19/255.0 green:119/255.0 blue:61/255.0 alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithRed:0.f green:255/255.0 blue:0.f alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:56/255.0 green:254/255.0 blue:39/255.0 alpha:1.f];
                foregroundCursor = foreground;
                //truth = YES;
                break;
            }
            CASE(@"Man Page") {
                background = [[UIColor alloc] initWithRed:254/255.0 green:244/255.0 blue:156/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.f];
                foregroundCursor = foreground;
                break;
            }
            CASE(@"Novel") {
                background = [[UIColor alloc] initWithRed:223/255.0 green:219/255.0 blue:195/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithRed:59/255.0 green:35/255.0 blue:34/255.0 alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithRed:127/255.0 green:42/255.0 blue:25/255.0 alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:58/255.0 green:35/255.0 blue:34/255.0 alpha:1.f];
                foregroundCursor = foreground;
                break;
            }
            CASE(@"Ocean") {
                background = [[UIColor alloc] initWithRed:34/255.0 green:79/255.0 blue:188/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.f];
                foregroundCursor = foreground;
                //truth = YES;
                break;
            }
            CASE(@"Pro") {
                background = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                foreground = [[UIColor alloc] initWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.f];
                foregroundCursor = foreground;
                //truth = YES;
                break;
            }
            CASE(@"Red Sands") {
                background = [[UIColor alloc] initWithRed:122/255.0 green:37/255.0 blue:30/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithRed:215/255.0 green:201/255.0 blue:167/255.0 alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithRed:223/255.0 green:189/255.0 blue:34/255.0 alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                foregroundCursor = foreground;
                //truth = YES;
                break;
            }
            CASE(@"Silver Aerogel") {
                background = [[UIColor alloc] initWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.f];
                foreground = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                foregroundBold = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
                backgroundCursor = [[UIColor alloc] initWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.f];
                foregroundCursor = foreground;
                break;
            }
            CASE(@"My Theme") {
                
                CGFloat red, green, blue;

                NSUserDefaults *colorDefaults = [NSUserDefaults standardUserDefaults];
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
                    term_background = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
                
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
                foregroundCursor = foreground;
                break;
            }
            DEFAULT {
                if ([decoder containsValueForKey:@"background"])
                    background = [[decoder decodeObjectForKey:@"background"] retain];
                else
                    background = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
        
                if ([decoder containsValueForKey:@"foreground"])
                    foreground = [[decoder decodeObjectForKey:@"foreground"] retain];
                else
                    foreground = [[UIColor alloc] initWithWhite:0.0f alpha:1.f];
        
                if ([decoder containsValueForKey:@"foregroundBold"])
                    foregroundBold = [[decoder decodeObjectForKey:@"foregroundBold"] retain];
                else
                    foregroundBold = [[UIColor alloc] initWithWhite:0.f alpha:1.f];
            
                if ([decoder containsValueForKey:@"foregroundCursor"])
                    foregroundCursor = [[decoder decodeObjectForKey:@"foregroundCursor"] retain];
                else
                    foregroundCursor = [[UIColor alloc] initWithWhite:1.f alpha:0.95f];
            
                if ([decoder containsValueForKey:@"backgroundCursor"])
                    backgroundCursor = [[decoder decodeObjectForKey:@"backgroundCursor"] retain];
                else
                    backgroundCursor = [[UIColor alloc] initWithWhite:0.f alpha:0.4f];
                break;
            }
        }
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:background];
        [colorDefaults setObject:colorData forKey:@"Background"];
        // [colorDefaults setBool:truth forKey:@"Statusbar"]; If you want to use statusbar
        [colorDefaults synchronize];
    }
    return self;
}

//Color settings
- (UIColor *)_colorFromArray:(NSArray *)array {
	if (!array || array.count != 3) {
		return nil;
	}
	
	return [UIColor colorWithRed:((NSNumber *)array[0]).floatValue / 255.f green:((NSNumber *)array[1]).floatValue / 255.f blue:((NSNumber *)array[2]).floatValue / 255.f alpha:1.f];
}


- (void) dealloc
{
    for (int i = 0; i < COLOR_MAP_MAX_COLORS; ++i) {
        [table[i] release];
    }
    [background release];
    [foreground release];
    [foregroundBold release];
    [foregroundCursor release];
    [backgroundCursor release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:background forKey:@"background"];
    [encoder encodeObject:foreground forKey:@"foreground"];
    [encoder encodeObject:foregroundBold forKey:@"foregroundBold"];
    [encoder encodeObject:foregroundCursor forKey:@"foregroundCursor"];
    [encoder encodeObject:backgroundCursor forKey:@"backgroundCursor"];
}

- (UIColor*) color:(unsigned int)index;
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