function I = encode(imgFileName, dataFileName)
% if there are errors, we'll let functions throw them then catch them
% outside of this encode function. or else, we should throw extra
% errors for things. lol

% read file
I = imread(imgFileName);

% set LSB to 0
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

% now put data into a matrix with same dimensions as I1
dataBin = dec2bin(data, 8)(:) - "0";
countBin = dec2bin(count, 32)(:) - "0";
% out of memory
dataBin = [countBin; dataBin ; zeros(sizeOfSpace - size(dataBin, 1) - size(countBin,1), 1)];

I = I + reshape(dataBin, x, y, channels);
