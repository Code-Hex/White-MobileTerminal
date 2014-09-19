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
    if (self != nil) {
        [self initColorTable];
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