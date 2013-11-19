function decode(imgFileName, outFileName)
% function decode(imgFileName, outFileName)
%
% imgFileName: the path to the image file you want to decode.
%
% outFileName: the path to the file you want the decoded information
%              to be stored in.
%

imgData = imread(imgFileName);
% reads first 32 LSBs to find out many bits we need to look up. then
% returns those decoded as a string.

% get LSBs
dataBin = bitget(imgData(:), 1);

% remove xor'd data
I = bitset(imgData, 1, 0);
J = (sum((dec2bin(I(:))-"0")')>3)';
dataBin = bitxor(J, dataBin);

% first 32 bits should be data
count = bin2dec(char(dataBin(1:32) + "0")');

% get the data
output = reshape(char(dataBin(33:32+count) + "0"), count/8, 8);
output = char(bin2dec(output));
output = output';

outfh = fopen(outFileName, "w");
outcnt = fwrite(outfh, output);
fclose(outfh);

if outcnt != size(output, 2)
  error('decode', "did not write the same bytes as output")
end
