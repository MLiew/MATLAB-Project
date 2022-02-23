# MATLAB Image Enhancement and Transformation GUI
<b>A.	Planning the purpose of the program</b> <br>
Firstly, the main task that the program has to accomplished is to read image input and to process the image to the user’s preference. The overall functions are as follows:
1. Read in image;
2. Fourier transform image;
3. Encrypt image using Arnold transform;
4. Butterworth low and high pass filter;
5. Gaussian low and high pass filter;
6. Enhance image using Butterworth or Gaussian filter;
7. Save the processed image;
8. Reset the image canvas.
<br>

<b>B.	Design the MATLAB Graphical User Interface</b>  
In order to fulfil the requirements mentioned in part A, the MATLAB Graphical User Interface(GUI) is designed. Below are several elements used in the GUI design: <br>
1. Editable text field: display image file directory chosen and input filter threshold frequency;
2. Push button: choose file directory, Fourier transform, Arnold transform, Butterworth filter, Gaussian filter, process image, save image and clear image;
3. Pop up menu: select Butterworth or Gaussian filter and select low or high pass filter;
4. Axes: to show the original image and the processed image.
<br>

## CODE
This GUI includes 14 different subprograms, some main subprogram that are worth mentioning are: 
1. `ArnoldTransform.m` : Image Encryption
2. `ButterworthHighPassFilter.m` : Butterworth High Pass Filter
3. `ButterworthLowPassFilter.m` : Butterworth Low Pass Filter
4. `FourierTransform.m` : Perform fourier transform on image
5. `GaussianHighPassFilter.m` : Gaussian High Pass Filter
6. `GaussianLowPassFilter.m` : Gaussian Low Pass Filter
7. `ImageEnhancementGUI.fig` : GUI file
8. `ImageEnhancementGUI.m` : GUI program 
9. `my_fft2.m` : Self-coded fast fourier transform (2D) function
10. `my_ifft2.m` : Self-coded inverse fast fourier transform (2D) function
11. `SquareImg.m` : Squaring the input image function
<br>

## HOW TO USE? 
1. Choose an image to be processed, the chosen image will appear in the left canvas. 
2. Choose either one button for image enhancement, such as Arnold Transform button. To select functions in the Image Filter group, do press and select the filter, high/low pass filter, and also enter the threshold frequency. 
3. Press the "Process Image" button, wait till the processed image appeares in the canvas. 
4. Press the "Save Image" button to save the image, enter the file directory and file name of the image. 
5. Press the "Clear Image" button to clear up both canvases. 
<br>
The GUI of this program is as follow:  
<img src="https://user-images.githubusercontent.com/30465494/155069918-0b7ba204-8aae-4236-af3a-b805056836c4.png" width="600" height="400">
