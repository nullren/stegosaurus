function outFile = encode(imgFile, dataFile)

% read file
I0 = imread(imgFile);

% set LSB to 0
I1 = bitset(I, 1, 0);


