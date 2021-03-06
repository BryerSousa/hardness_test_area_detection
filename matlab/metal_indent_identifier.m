% Jackie Loven
% 3 August 2017
% Metal Indent Identifier. All Rights Reserved.
% Need a high-contrast image of an indent in metal.
% Also need to image a reticule using Reticle Measurer to find microns per
% pixel.
original = imread('/Users/platypus/Desktop/mse_4920/images/700_HV_test/2942_4.png');
originalCopy = original;
originalCopy2 = original;

% 1. Convert to grayscale
grayscaleImage = rgb2gray(originalCopy);
kernel = strel('square', 2);
dilateImage = imdilate(grayscaleImage, kernel);

% 2. Erode, dilate image
% kernel = strel('square', 8);
% erodeImage = imerode(grayscaleImage, kernel);
% kernel2 = strel('square', 8);
% dilateImage1 = imdilate(erodeImage, kernel2);

kernel = 3;
sigma = 0.3 * ((kernel - 1) * 0.5 - 1) + 0.8;
gaussianBlurImage1 = imgaussfilt(dilateImage, sigma);

% 3. Binarize image
binaryImage = imbinarize(gaussianBlurImage1,'adaptive','ForegroundPolarity','dark','Sensitivity',0.35);

kernel = strel('square', 3);
dilateImage1 = imdilate(binaryImage, kernel);
kernel2 = strel('square', 2);
erodeImage1 = imerode(dilateImage1, kernel);
dilateImage2 = imdilate(erodeImage1, kernel);



% 4. Canny edge detect
cannyImage = edge(dilateImage2, 'canny');
cannyImageCast = +cannyImage;

% 5. Binarize image again
binaryImage2 = imbinarize(cannyImageCast,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);

% 6. https://stackoverflow.com/questions/28614074/how-to-select-the-largest-contour-in-matlab
% Select the largest contour in the selected area.
im = binaryImage2;
im_fill = imfill(im, 'holes');
s = regionprops(im_fill, 'Area', 'PixelList');
[~,ind] = max([s.Area]);
pix = sub2ind(size(im), s(ind).PixelList(:,2), s(ind).PixelList(:,1));
pixelArea = s(ind).Area;

% 7. Color the indent green on the image.
for i = 1:pixelArea
    x = s(ind).PixelList(i, 2);
    y = s(ind).PixelList(i, 1);
    originalCopy2(x, y, 1) = 0;
    originalCopy2(x, y, 2) = 255;
    originalCopy2(x, y, 3) = 0;
end

imshow(originalCopy2);

% 8. Calculate indent area based on previous measurements of a reticle.
micronsPerPixel = 0.18694;
indentArea = pixelArea * micronsPerPixel * micronsPerPixel;
totalString = strcat(num2str(indentArea), ' sq. �m');
disp(totalString);
