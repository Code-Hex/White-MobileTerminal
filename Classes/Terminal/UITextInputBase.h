// UITextInputBase.h
// MobileTerminal
//
// This file contains a base view for implementing keyboard handling routines
// via the UITextInput protocol.  That protocol is a grab bag of other protocols
// that are mostly unused by the terminal keyboard handling code.

#import <UIKit/UIKit.h>

@interface TextPosition : UITextPosition
{
@private
  NSNumber* position;
}
@property (nonatomic, retain) NSNumber* position;
@end

@interface UITextInputBase : UIView <UITextInput> {
@private
  UITextRange *selectedTextRange;
  UITextRange *markedTextRange;
  NSDictionary *markedTextStyle;
  UITextPosition *beginningOfDocument;
  UITextPosition *endOfDocument;
  id <UITextInputDelegate> inputDelegate;
  id <UITextInputTokenizer> tokenizer;
  UIView *textInputView;
  UITextStorageDirection selectionAffinity;  
}

/* Text may have a selection, either zero-length (a caret) or ranged.  Editing operations are
 * always performed on the text from this selection.  nil corresponds to no selection. */

@property (readwrite, copy) UITextRange *selectedTextRange;

/* If text can be selected, it can be marked. Marked text represents provisionally
 * inserted text that has yet to be confirmed by the user.  It requires unique visual
 * treatment in its display.  If there is any marked text, the selection, whether a
 * caret or an extended range, always resides witihin.
 *
 * Setting marked text either replaces the existing marked text or, if none is present,
 * inserts it from the current selection. */ 

@property (nonatomic, readonly) UITextRange *markedTextRange;                       // Nil if no marked text.
@property (nonatomic, copy) NSDictionary *markedTextStyle;                          // Describes how the marked text

/* The end and beginning of the the text document. */
@property (nonatomic, readonly) UITextPosition *beginningOfDocument;
@property (nonatomic, readonly) UITextPosition *endOfDocument;

/* A system-provied input delegate is assigned when the system is interested in input changes. */
@property (nonatomic, assign) id <UITextInputDelegate> inputDelegate;

/* A tokenizer must be provided to inform the text input system about text units of varying granularity. */
@property (nonatomic, readonly) id <UITextInputTokenizer> tokenizer;

/* An affiliated view that provides a coordinate system for all geometric values in this protocol.
 * If unimplmeented, the first view in the responder chain will be selected. */
@property (nonatomic, readonly) UIView *textInputView;

/* Selection affinity determines whether, for example, the insertion point appears after the last
 * character on a line or before the first character on the following line in cases where text
 * wraps across line boundaries. */
@property (nonatomic) UITextStorageDirection selectionAffinity;
- (NSArray *)selectionRectsForRange:(UITextRange *)range;

@end
