% select samples
clear all;
% parameters
k = 9; % num of pose clusters
n = 3425; % num of sequences
outputName = 'index.txt'

% prepare for output
outputFile = fopen(outputName, 'w');

%load filenames; the pose are rotation angles of roll, pitch and yaw, respectively.
cd ('headpose_DB');
fid = fopen('filename.txt');
tline = fgets(fid);
% store the selected indexes
idxSet = zeros(n,k);
oneSet = zeros(1,k);
sampleSet = zeros(3,k,n);
sq_ct = 0; % count num of sequences
while ischar(tline)
	disp(tline);
    tline = fgets(fid);
    if tline == -1
        break;
    end
    sq_ct = sq_ct + 1;
    tstr = cellstr(tline);
    load(tstr{1,1});
    data=headpose';
    % k-means (randomness, so you won't get exactly the same result every run)
    [idx, cluster, ~, dist] = kmeans(data,k);
    % select samples using distances from each point to every centroid
    for i=1:k
        [~, minIdx] = min(dist(:,i));
        oneSet(i) = minIdx-1; % matlab starts from 1 while system indexes from 0
        sampleSet(:,i,sq_ct) = headpose(:,minIdx);
    end
    idxSet(sq_ct,:) = oneSet;
    fprintf(outputFile, '%s%d,%d,%d,%d,%d,%d,%d,%d,%d\n', tline, oneSet);
end
fclose(fid);
fclose(outputFile);
save('idxSet.mat','idxSet');
save('sampleSet.mat','sampleSet');
