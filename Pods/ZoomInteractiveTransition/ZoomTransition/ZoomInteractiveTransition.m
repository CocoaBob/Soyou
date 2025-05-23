//
//  ZoomTransition.m
//  ZoomSegueExample
//
//  Created by Denys Telezhkin on 29.06.14.
//
//  Copyright (c) 2014 Denys Telezhkin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ZoomInteractiveTransition.h"
#import "UIView+Snapshotting.h"

@interface ZoomInteractiveTransition()

@property (nonatomic, weak) id <UINavigationControllerDelegate> previousDelegate;
@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) BOOL shouldCompleteTransition;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@end

@implementation ZoomInteractiveTransition

-(void)commonSetup
{
    self.transitionDuration = 0.3;
    self.handleEdgePanBackGesture = YES;
    self.transitionAnimationOption = UIViewKeyframeAnimationOptionCalculationModeCubic;
}

- (void)resetDelegate {
    self.navigationController.delegate = self.previousDelegate;
}

- (instancetype)initWithNavigationController:(UINavigationController *)nc
{
    if (self = [super init]) {
        self.navigationController = nc;
        self.previousDelegate = nc.delegate;
        nc.delegate = self;
        [self commonSetup];
    }
    return self;
}

-(instancetype)init
{
    if (self = [super init])
    {
        [self commonSetup];
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionDuration;
}

-(UIImageView *)snapshotImageViewFromView:(UIView *)view {
    UIImage * snapshot = [view dt_takeSnapshot];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:snapshot];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

-(UIImageView *)initialZoomSnapshotFromView:(UIView *)sourceView
                            destinationView:(UIView *)destinationView
{
    return [self snapshotImageViewFromView:(sourceView.bounds.size.width > destinationView.bounds.size.width) ? sourceView : destinationView];
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController <ZoomTransitionProtocol> * fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController <ZoomTransitionProtocol> *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = [fromVC view];
    UIView * toView = [toVC view];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    // fix for rotation bug in iOS 9
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    // original zoom view
    UIView * fromZoomView = [fromVC viewForZoomTransition:true];
    UIView * toZoomView = [toVC viewForZoomTransition:false];
    
    // prepare animating image view
    UIImageView * animatingImageView;
    if ([fromVC respondsToSelector:@selector(initialZoomViewSnapshotFromProposedSnapshot:)]) {
        animatingImageView = [fromVC initialZoomViewSnapshotFromProposedSnapshot:animatingImageView];
    } else {
        animatingImageView = [self initialZoomSnapshotFromView:fromZoomView destinationView:toZoomView];
    }
    animatingImageView.frame = CGRectIntegral([fromZoomView.superview convertRect:fromZoomView.frame toView:containerView]);
    
    // hide original zoom views
    fromZoomView.alpha = 0;
    toZoomView.alpha = 0;
    
    // add animating background view
    UIImageView *backgroundView = [self snapshotImageViewFromView:fromView];
    [containerView addSubview:backgroundView];
    
    // add animating image view
    [containerView addSubview:animatingImageView];
    
    // add edge pan gesture if it's going forward
    BOOL isGoingForward = [self.navigationController.viewControllers indexOfObject:fromVC] == (self.navigationController.viewControllers.count - 2);
    if (isGoingForward && self.handleEdgePanBackGesture) {
        BOOL wasAdded = NO;
        for (UIGestureRecognizer *gr in toView.gestureRecognizers) {
            if ([gr isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                wasAdded = YES;
                break;
            }
        }
        if (!wasAdded) {
            UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePan:)];
            edgePanRecognizer.edges = UIRectEdgeLeft;
            [toVC.view addGestureRecognizer:edgePanRecognizer];
        }
    }
    
    // animation
    [UIView animateKeyframesWithDuration:self.transitionDuration
                                   delay:0
                                 options:self.transitionAnimationOption
                              animations:^{
                                  animatingImageView.frame = CGRectIntegral([toZoomView.superview convertRect:toZoomView.frame toView:containerView]);
                                  backgroundView.alpha = 0;
                                  
                                  if ([fromVC respondsToSelector:@selector(animationBlockForZoomTransition)]) {
                                      ZoomAnimationBlock zoomAnimationBlock = [fromVC animationBlockForZoomTransition];
                                      if (zoomAnimationBlock) {
                                          zoomAnimationBlock(animatingImageView, fromZoomView, toZoomView);
                                      }
                                  }
                              } completion:^(BOOL finished) {
                                  void (^completion)(void) = ^void (void) {
                                      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                      
                                      [animatingImageView removeFromSuperview];
                                      [backgroundView removeFromSuperview];
                                      
                                      fromZoomView.alpha = 1;
                                      toZoomView.alpha = 1;
                                  };
                                  
                                  if ([fromVC respondsToSelector:@selector(completionBlockForZoomTransition)]) {
                                      ZoomCompletionBlock zoomCompletionBlock = [fromVC completionBlockForZoomTransition];
                                      if (zoomCompletionBlock) {
                                          zoomCompletionBlock(animatingImageView, fromZoomView, toZoomView, completion);
                                          return;
                                      }
                                  }
                                  completion();
                              }];
}

#pragma mark - edge back gesture handling

- (void) handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gr
{
    CGPoint point = [gr translationInView:gr.view];
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
            self.interactive = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = point.x / gr.view.frame.size.width;
            self.shouldCompleteTransition = (percent > 0.25);
            
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!self.shouldCompleteTransition || gr.state == UIGestureRecognizerStateCancelled)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
            self.interactive = NO;
            break;
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (!navigationController) {
        return  nil;
    }
    
    if (![fromVC conformsToProtocol:@protocol(ZoomTransitionProtocol)] ||
        ![toVC conformsToProtocol:@protocol(ZoomTransitionProtocol)])
    {
        navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)toVC;
        return nil;
    }
    
    // Force to load the views (loadView/viewDidLoad will be called)
    [fromVC view];
    [toVC view];
    
    if (![(id<ZoomTransitionProtocol>)fromVC viewForZoomTransition:YES] ||
        ![(id<ZoomTransitionProtocol>)toVC viewForZoomTransition:NO])
    {
        navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)toVC;
        return nil;
    }
    
    if (([fromVC respondsToSelector:@selector(shouldAllowZoomTransitionForOperation:fromViewController:toViewController:)] &&
         ![(id<ZoomTransitionProtocol>)fromVC shouldAllowZoomTransitionForOperation:operation fromViewController:fromVC toViewController:toVC]) ||
        ([toVC respondsToSelector:@selector(shouldAllowZoomTransitionForOperation:fromViewController:toViewController:)] &&
         ![(id<ZoomTransitionProtocol>)toVC shouldAllowZoomTransitionForOperation:operation fromViewController:fromVC toViewController:toVC]))
    {
        if ([fromVC respondsToSelector:@selector(animationControllerForTransitionToViewController:)]) {
            return [(id<ZoomTransitionProtocol>)fromVC animationControllerForTransitionToViewController:toVC];
        } else {
            navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)toVC;
            return nil;
        }
    }
    
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (!self.isInteractive) {
        return nil;
    }
    
    return self;
}

@end
