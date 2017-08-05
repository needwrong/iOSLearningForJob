//
//  NETouchDrawView.m
//  NEJobLearning
//
//  Created by east on 2017/8/5.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NETouchDrawView.h"
#import <objc/runtime.h>

@implementation NETouchDrawView

- (id)initWithCoder:(NSCoder *)c {
    self = [super initWithCoder:c];
    if (self) {
        self.lineList = [[NSMutableArray alloc] init];
        
        self.currentColor = [UIColor blackColor];
        self.lineWidth = 5.0;
        [self becomeFirstResponder];
    }
    return self;
}

//  It is a method of UIView called every time the screen needs a redisplay or refresh.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    [self.currentColor set];
    for (NELineWrap *line in self.lineList) {
        [[line color] set];
        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
}

- (void)undo {
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.undoManager beginUndoGrouping];
    for (UITouch *t in touches) {
        // Create a line for the value
        CGPoint loc = [t locationInView:self];
        NELineWrap *newLine = [[NELineWrap alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        [newLine setColor:self.currentColor];
        self.currentLine = newLine;
    }
}

- (void)addLine:(NELineWrap *)line {
    [[self.undoManager prepareWithInvocationTarget:self] removeLine:line];
    [self.lineList addObject:line];
}

- (void)removeLine:(NELineWrap *)line {
    if ([self.lineList containsObject:line])
        [self.lineList removeObject:line];
}

- (void)removeLineByEndPoint:(CGPoint)point {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NELineWrap *evaluatedLine = (NELineWrap *)evaluatedObject;
        return evaluatedLine.end.x == point.x &&
        evaluatedLine.end.y == point.y;
    }];
    
    NSArray *result = [self.lineList filteredArrayUsingPredicate:predicate];
    if (result && result.count > 0) {
        [self.lineList removeObject:result[0]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint loc = [t locationInView:self];

        if (self.currentLine) {
            [self.currentLine setColor:self.currentColor];
            [self.currentLine setEnd:loc];
            [self addLine:self.currentLine];
        }
        NELineWrap *newLine = [[NELineWrap alloc] init];
        [newLine setBegin:loc];
        [newLine setEnd:loc];
        [newLine setColor:self.currentColor];
        self.currentLine = newLine;
    }
    [self setNeedsDisplay];
}

- (void)endTouches:(NSSet *)touches {
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
    [self.undoManager endUndoGrouping];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTouches:touches];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didMoveToWindow {
    [self becomeFirstResponder];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
