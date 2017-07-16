% Jackie Loven
% 14 July 2017



original = imread('/Users/platypus/Desktop/mse_4920/hardness_test_area_detection/images/1.png');
originalCopy = original;
imshow(originalCopy);

% 1. Convert to grayscale
grayscaleImage = rgb2gray(originalCopy);

% 2. Gaussian blur
% OpenCV uses standard dev of 0.3*((ksize-1)*0.5 - 1) + 0.8
% see http://docs.opencv.org/2.4/modules/imgproc/doc/filtering.html#getgaussiankernel
kernel = 7;
sigma = 0.3 * ((kernel - 1) * 0.5 - 1) + 0.8;
gaussianBlurImage1 = imgaussfilt(grayscaleImage, sigma);
%imshow(gaussianBlurImage);

% 3. Erode and dilate
kernel = strel('square', 7);
erodeImage1 = imerode(gaussianBlurImage1, kernel);
dilateImage1 = imdilate(erodeImage1, kernel);
%imshow(erodeImage1);
%imshow(dilateImage1);

% 4. CLAHE
%claheImage = adapthisteq(dilateImage1, 'clipLimit', 0.055, 'Distribution', 'uniform', 'NumTiles', [8,8]);
%imshow(claheImage);

% 5. Erode, dilate, and erode
erodeImage2 = imerode(dilateImage1, kernel);
dilateImage2 = imdilate(erodeImage2, kernel);
erodeImage3 = imerode(dilateImage2, kernel);
dilateImage3 = imdilate(erodeImage3, kernel);
%imshow(dilateImage3);

% 6. Binarize image
binaryImage = imbinarize(dilateImage3,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
%imshow(binaryImage);

% 7. Canny edge detect
cannyImage = edge(binaryImage, 'canny');
%imshow(cannyImage);
cannyImageCast = +cannyImage;

% 8. Gaussian blur
gaussianBlurImage2 = imgaussfilt(cannyImageCast, sigma);
imshow(imcomplement(gaussianBlurImage2));

% 9. Contour search
title('Please click on the edge of the indent', 'FontSize', 20);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
[x,y] = ginput(1);
% Put a cross where they clicked.
hold on;
plot(x, y, 'w+', 'MarkerSize', 50);
% Get the location they click on.
row = double(uint8(y));
column = double(uint8(x));
disp(row)
disp(column)
close all;

% Now, given a location on the contour
contour = bwtraceboundary(gaussianBlurImage2, [row column], 'W', 8, Inf, 'counterclockwise');
hold on;
plot(contour(:,2),contour(:,1),'g','LineWidth',2);


