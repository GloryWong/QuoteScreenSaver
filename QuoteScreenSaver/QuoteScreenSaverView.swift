//
//  QuoteScreenSaverView.swift
//  QuoteScreenSaver
//
//  Created by 王昭辉 on 2021/2/28.
//

import ScreenSaver;

class QuoteScreenSaverView: ScreenSaverView {
    private var ballPosition: CGPoint = .zero;
    private var ballVelocity: CGVector = .zero;
    private var ballRadius: CGFloat = 0;
    private var ballHue: CGFloat = 0;
    private var quoteHue: CGFloat = 0;
    private var bgHue: CGFloat = 0.999;
    
    // MARK: - Initialization
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview);
//        self.animationTimeInterval = 1 / 60.0;
        
        ballPosition = CGPoint(x: frame.width / 2, y: frame.height / 2);
        ballRadius = (min(frame.width, frame.height)) / 2 * 0.3;
        ballVelocity = initialBallVelocity();
        ballHue = 0.5;
        quoteHue = 0.2;
    }
    
    private func initialBallVelocity() -> CGVector {
        let desiredVelocityMagnitude: CGFloat = 10;
        let xVelocity = CGFloat.random(in: 2.5...7.5);
        let xSign: CGFloat = Bool.random() ? 1 : -1;
        let yVelocity = sqrt(pow(desiredVelocityMagnitude, 2) - pow(xVelocity, 2));
        let ySign: CGFloat = Bool.random() ? 1 : -1;
        
        return CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign);
    }
    
    private func ballIsOOB() -> (xAxisOOB: Bool, yAxisOOB: Bool) {
        let xAxisOOB = ballPosition.x - ballRadius <= 0 ||
            ballPosition.x + ballRadius >= bounds.width;
        let yAxisOOB = ballPosition.y - ballRadius <= 0 ||
            ballPosition.y + ballRadius >= bounds.height;
        
        return (xAxisOOB, yAxisOOB);
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) ahs not been implemented");
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: NSRect) {
        drawBackground();
        drawQuote();
        drawBall();
    }
    
    private func drawBackground() {
        let background = NSBezierPath(rect: bounds);
        getColor(hue: getNextBgHue(), alpha: 1) .setFill();
        background.fill();
    }
    
    private func drawBall() {
        let ballRect = NSRect(x: ballPosition.x - ballRadius,
                              y: ballPosition.y - ballRadius,
                              width: ballRadius * 2,
                              height: ballRadius * 2);
        let ball = NSBezierPath(roundedRect: ballRect, xRadius: ballRadius, yRadius: ballRadius);
        getColor(hue: getNextBallHue(), alpha: 0.7).setFill();
        ball.fill();
    }
    
    private func drawQuote() {
        let text: NSString = "Are you really OK?";
        let size: CGFloat = min(bounds.width, bounds.height) * 0.1;
        let attr = [
            NSAttributedString.Key.font: NSFont(descriptor: NSFontDescriptor()
                          ,size: size)!,
            NSAttributedString.Key.foregroundColor: NSColor.white
        ];
        let nsSize = text.size(withAttributes: attr);
        
        text.draw(at: NSPoint(x: bounds.width / 2 - nsSize.width / 2, y: bounds.height / 2 - nsSize.height / 2),
                  withAttributes: attr);
    }
    
    private func getNextBallHue() -> CGFloat {
        ballHue += 0.001;
        if (ballHue > 1.0) {
            ballHue = 0;
        }
        
        return ballHue;
    }
    
    private func getNextBgHue() -> CGFloat {
        bgHue += 0.001;
        if (bgHue > 1.0) {
            bgHue = 0;
        }
        
        return bgHue;
    }
    
    private func getColor(hue: CGFloat, alpha: CGFloat) -> NSColor {
        let color: NSColor = NSColor(hue: hue, saturation: 1.0, brightness: 0.5, alpha: alpha);
        
        return color;
    }
    
    override func animateOneFrame() {
        super.animateOneFrame();
        
        let oobAxes = ballIsOOB();
        if (oobAxes.xAxisOOB) {
            ballVelocity.dx *= -1;
        }
        if (oobAxes.yAxisOOB) {
            ballVelocity.dy *= -1;
        }
        
        ballPosition.x += ballVelocity.dx;
        ballPosition.y += ballVelocity.dy;
        
        setNeedsDisplay(bounds);
    }
}
