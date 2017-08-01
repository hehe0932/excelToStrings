//
//  ViewController.m
//  TestDHlibxls
//
//  Created by David Hoerl on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "DHxlsReaderIOS.h"
int i = 1;
extern int xls_debug;
@implementation ViewController
{
    IBOutlet UITextView *textView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rowCount1.text=nil;
    self.rowCount2.text=nil;
    
}
- (void)viewIntt{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.xls"];
    //	NSString *path = @"/tmp/test.xls";
    
    // xls_debug = 1; // good way to see everything in the Excel file
    
    DHxlsReader *reader = [DHxlsReader xlsReaderFromFile:path];
    assert(reader);
    
    NSString *text = @"";
    
    text = [text stringByAppendingFormat:@"AppName: %@\n", reader.appName];
    text = [text stringByAppendingFormat:@"Author: %@\n", reader.author];
    text = [text stringByAppendingFormat:@"Category: %@\n", reader.category];
    text = [text stringByAppendingFormat:@"Comment: %@\n", reader.comment];
    text = [text stringByAppendingFormat:@"Company: %@\n", reader.company];
    text = [text stringByAppendingFormat:@"Keywords: %@\n", reader.keywords];
    text = [text stringByAppendingFormat:@"LastAuthor: %@\n", reader.lastAuthor];
    text = [text stringByAppendingFormat:@"Manager: %@\n", reader.manager];
    text = [text stringByAppendingFormat:@"Subject: %@\n", reader.subject];
    text = [text stringByAppendingFormat:@"Title: %@\n", reader.title];
    
    
    text = [text stringByAppendingFormat:@"\n\nNumber of Sheets: %u\n", reader.numberOfSheets];
    
#if 0
    [reader startIterator:0];
    
    while(YES) {
        DHcell *cell = [reader nextCell];
        if(cell.type == cellBlank) break;
        
        text = [text stringByAppendingFormat:@"\n%@\n", [cell dump]];
    }
#else
    int row = 2;
    while(YES) {
        DHcell *cell = [reader cellInWorkSheetIndex:0 row:row col:[self.rowCount1.text intValue]];
        if(cell.type == cellBlank) break;
        DHcell *cell1 = [reader cellInWorkSheetIndex:0 row:row col:[self.rowCount2.text intValue]];
        //        NSLog(@"\nCell:%@\nCell1:%@\n", [cell dump], [cell1 dump]);
        row++;
        
        /*
         例子:ios-- "offline measurements" = "mediciones sin conexión";
         安卓--<string name = "key">mediciones sin conexión</string>
         安卓key:<item>United Arab Emirates,AE</item>
         */
        NSString *iOSString =  [NSString stringWithFormat:@"\"%@\" = \"%@\";\n",[cell dump],[cell1 dump]];
//        NSString *androidString = [NSString stringWithFormat:@"<item>%@,%@</item>\n",[cell dump],[cell1 dump]];
        NSString *androidString = [NSString stringWithFormat:@"<item>%@,%@</item>\n",[cell dump],[cell1 dump]];
        if ([self.segmentString isEqualToString:@"android"]) {
            [self.contentArray addObject:androidString];
        }else
        {
            [self.contentArray addObject:iOSString];
        }
        
        //        self.contentStr = [NSString stringWithString:str];
    }
#endif
    
    
    //	textView.text = text;
    //    NSLog(@"%@",self.contentArray);
    //    [self createXml];
}
- (void)createXml{
    
    NSMutableString *myString= [[NSMutableString alloc]init];
    //将NSString类型转成NSUTF8String编码类型
    for (NSString *str in self.contentArray) {
        [myString appendString:str];
    }
    NSData *xlsData = [myString dataUsingEncoding:NSUTF16StringEncoding];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *strFilePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"myString%d.strings",i]];
    NSLog(@"文件地址:%@",strFilePath);
    textView.text = [NSString stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n复制控制台打印的地址,在桌面按command+shift+G前往查看文件"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strFilePath]) {
        [[NSFileManager defaultManager] createFileAtPath:strFilePath contents:nil attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:strFilePath];
        [fileHandle writeData:xlsData];
        [fileHandle closeFile];
    }else{
        [[NSFileManager defaultManager] removeItemAtPath:strFilePath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:strFilePath contents:nil attributes:nil];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:strFilePath];
        [fileHandle writeData:xlsData];
        [fileHandle closeFile];
    }

}

- (IBAction)OKButton:(id)sender {
    [self.contentArray removeAllObjects];
    if (self.rowCount1.text!=nil && self.rowCount2.text!=nil) {
        [self viewIntt];
        [self createXml];
        i++;
    }
}
- (IBAction)selectLanguageType:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        //ios
        self.segmentString = @"iOS";
    }else{
        //android
        self.segmentString = @"android";
    }
}


- (void)viewDidUnload
{
    textView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



@end
