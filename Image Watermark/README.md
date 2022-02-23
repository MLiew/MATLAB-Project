# MATLAB Image Watermark
This program adds watermark image into the base image for encryption purpose. This folder contains 3 files, which are:
1. `watermark_main.m` : main function for embedding the watermark, 
2. `ArnoldTransform.m` : arnold transform,
3. `InverseArnoldTransform.m` : inverse arnold transform.

The input arguments are: 
1. `base_img_path`: base image filepath, 
2. `watermark_img_path`: watermark image filepath, 
3. `save_img1_path`: save filepath for the watermarked image, 
4. `save_img2_path`: save filepath for the extracted watermark image. 

This program takes a base image, which is the image that wanted to be encrypted with watermark and a watermark image that wants to be embedded into the base image. During the watermark embedding process, the base image and the watermark image will be converted from rgb to grayscale, the watermark image will also be resized into 64*64 pixels.

The output images from this program are a watermarked image and an extracted watermark image from the watermarked image.  
<img src="https://user-images.githubusercontent.com/30465494/155265652-cb470611-ec5a-4728-b637-3436fd48592e.png" width="600" height="400">

For chinese explanation, please visit my [csdn](https://blog.csdn.net/qq_39560620/article/details/123087970) blog.
