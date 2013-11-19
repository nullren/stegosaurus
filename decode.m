function decode(imgFileName, outFileName)
% function decode(imgFileName, outFileName)
%
% imgFileName: the path to the image file you want to decode.
%
% outFileName: the path to the file you want the decoded information
%              to be stored in.
%

% read input image file
imgData = imread(imgFileName);

% get LSBs
dataBin = bitget(imgData(:), 1);

% remove our xor-ed ghost
I = bitset(imgData, 1, 0);
J = (sum((dec2bin(I(:))-"0")')>3)';
dataBin = bitxor(J, dataBin);


% first 32 bits should be a 32-bit integer telling us how many bits to
% read after
count = bin2dec(char(dataBin(1:32) + "0")');

% get the data if there is nothing to get, then might as well just
% leave
if count < 1
  error('decode', "we don't have any data to read")
end

% read output
output = reshape(char(dataBin(33:33+count-1) + "0"), count/8, 8);
output = char(bin2dec(output));
output = output';

% write to our file
outfh = fopen(outFileName, "w");
outcnt = fwrite(outfh, output);
fclose(outfh);

% let someone know if the file does not match the length of the
% contents
if outcnt != size(output, 2)
  error('decode', "did not write the same bytes as output")
end
