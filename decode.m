function output = decode(imgData)
% reads first 32 LSBs to find out many bits we need to look up. then
% returns those decoded as a string.

% get LSBs
dataBin = bitget(imgData(:), 1);

% first 32 bits should be data
count = bin2dec(char(dataBin(1:32) + "0")');

% get the data
output = reshape(char(dataBin(33:32+count) + "0"), count/8, 8);
output = char(bin2dec(output));
output = output';
