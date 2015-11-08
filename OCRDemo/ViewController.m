//
//  ViewController.m
//  OCRDemo
//
//  Created by ADMIN on 11/8/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)GetImageAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *_Indicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetImageAction:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.editing = true;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imgView.image = image;
    
    [picker dismissViewControllerAnimated:true completion:nil];
    self._Indicator.hidden = false;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
        
        G8Tesseract *analyzer = [[G8Tesseract alloc] init];
        analyzer.language = @"eng";
        analyzer.engineMode = G8OCREngineModeTesseractCubeCombined;
        analyzer.pageSegmentationMode =G8PageSegmentationModeAuto;
        analyzer.maximumRecognitionTime = 60.0;
        analyzer.image = image.g8_blackAndWhite;
        [analyzer recognize];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
        
            self._Indicator.hidden = true;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:[analyzer recognizedText] preferredStyle:UIAlertControllerStyleAlert];
            id OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:OK];
            [self presentViewController:alert animated:true completion:nil];
        
        });
    
    
    });
    
    
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}
@end
