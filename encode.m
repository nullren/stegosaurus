function encode(imgFileName, dataFileName, outFileName)
% function encode(imgFileName, dataFileName, outFileName)
%
% imgFileName:  the path to the image file you want to use as a base
%               for the encoding.
%
% dataFileName: the path to the file containing the data you want to
%               encode inside `imgFileName`.
%
% outFileName:  the path to the resulting image.
%
% note that the size of file at the location of `dataFileName` needs
% to contain less bits (bytes/8) than the number of pixels in
% `imgFileName` in each available color. e.g., for black and white
% photos, there is only one channel; RGB photos have 3 channels; CMYK
% photos have 4 channels.

% read file
I = imread(imgFileName);

% set LSBs to 0
I = bitset(I, 1, 0);

% read payload data
dataFile = fopen(dataFileName);
[data, count] = fread(dataFile, Inf, 'uint8');
fclose(dataFile);

% makesure our payload will fit in our image
[x, y, channels] = size(I);
sizeOfSpace = x*y*channels;
sizeOfPayload = count*8;

if sizeOfPayload > sizeOfSpace
  error('encode', "payload is too large for this image")
end

% encode number of bits
dataBin = dec2bin(sizeOfPayload, 32)(:) - "0";
% encode actual bits
dataBin = [dataBin; dec2bin(data, 8)(:) - "0"];
% pad with zeros
dataBin = [dataBin ; zeros(sizeOfSpace - size(dataBin, 1), 1)];

% shape into matrix like the image
dataBin = reshape(dataBin, x, y, channels);

% this matrix contains the average bit value of each pixel
J = sum((dec2bin(I(:))-"0")')>3;
J = reshape(J, x, y, channels);

% xor everything and add it to the image. this creates a sort of
% 'ghost' of the original image in our LSBs
I = I + bitxor(J, dataBin);

% write file
imwrite(I, outFileName);
