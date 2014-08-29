#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FontFun : NSObject
@end

@implementation FontFun
- (UIImage *)imageFor:(NSString *)txt atSize:(NSInteger)size
{
	// register the font
	NSData *inData = [NSData dataWithContentsOfFile:@"/var/root/FontAwesome.ttf"];
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
	CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
	CFErrorRef error;
	CTFontManagerRegisterGraphicsFont(newFont, &error);
	if (error != nil) {
		NSLog(@"%@", error);
	}

	// size
	UIFont *font = [UIFont fontWithName:@"FontAwesome" size:size];
	CGSize imageSize = CGSizeMake(size, size);
	CGSize txtSize = [txt sizeWithFont:font];

	// scale
	CGFloat x = imageSize.width / txtSize.width;
	CGFloat y = imageSize.height / txtSize.height;
	CGFloat ratio = MIN(x, y);

	// new font size
	CGFloat oldFontSize = font.pointSize;
	CGFloat newFontSize = floor(oldFontSize * ratio);
	font = [font fontWithSize:newFontSize];
	txtSize = [txt sizeWithFont:font];

	// write the image
	UIGraphicsBeginImageContext(imageSize);
	CGPoint textOrigin = CGPointMake((imageSize.width - txtSize.width) / 2, (imageSize.height - txtSize.height) / 2);
	[txt drawAtPoint:textOrigin withFont:font];

	// return the image
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return result;
}
@end

int main(int argc, const char *argv[])
{
	// init font fun with the unicode for a heart - awesome fontawesome is awesome
	FontFun *ff = [[FontFun alloc] init];
	UIImage *img = [ff imageFor:@"\uf08a" atSize:100];

	// save the image to a file for testing
	NSString *output = @"/var/root/test.png";
	[UIImagePNGRepresentation(img) writeToFile:output atomically:YES];
}
