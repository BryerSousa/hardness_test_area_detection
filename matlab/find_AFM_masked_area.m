%  Find the total number of red pixels.
%  Have the user click several points on the scale bar and input how far apart they are,
%  take an average.

original = imread('/Users/platypus/Desktop/mse_4920/hardness_test_area_detection/data/afm/largest_10004_mask.jpg');
originalCopy = original;
secondCopy = original;
[width, height, z1] = size(originalCopy);

figure('name','Please click four consecutive points on the scale bar.');
imshow(originalCopy);
[x, y] = ginput(4);

prompt = {'Scale bar size in �m:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'10'};
answer = inputdlg(prompt, dlg_title, num_lines, defaultans);
scaleBarSize = str2double(answer);

close all;

difference1 = abs(y(3) - y(2));
difference2 = abs(y(2) - y(1));
difference3 = abs(y(4) - y(3));
average = (difference1 + difference2 + difference3) / 3;

micronsPerPixel = scaleBarSize / average;

rpcount = 0;
for i = 1:width
    for j = 1:height
        first = originalCopy(i, j, 1) <= 255 && originalCopy(i, j, 1) >= 190;
        second = originalCopy(i, j, 2) <= 100 && originalCopy(i, j, 2) >= 0;
        third = originalCopy(i, j, 3) <= 100 && originalCopy(i, j, 3) >= 0;
        if first && second && third
            secondCopy(i, j, 1) = 0;
            secondCopy(i, j, 2) = 255;
            secondCopy(i, j, 3) = 0;
            rpcount = rpcount + 1;
        end
    end
end

imshow(secondCopy);
areaOfRed = rpcount * micronsPerPixel * micronsPerPixel;
disp(areaOfRed);