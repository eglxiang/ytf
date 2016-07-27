% same_pair_set = [];
% diff_pair_set = [];

initial_dir= cd();
feature_root = '/home/xiang/WS/YFW/feature_fc8/';

fea = zeros(2622,18,5000);
label = zeros(5000,1);
fid=fopen('splits.txt');
pair_count = 0;
tline=fgets(fid); % read the first line which is header file
while ischar(tline)
    pair_count = pair_count + 1;
    disp(tline);
    tline=fgets(fid);
    t=strsplit(tline, ',');
    
    dir1=t{1,3};
    dir1=strcat(feature_root, dir1(2:length(dir1)));
    cd(dir1);
    namelist=dir;
    [num_files,~]=size(namelist);
    if num_files ~= 11
        break;
    end
    for j=3:num_files
        current_file = namelist(j).name;
        fileID = fopen(current_file, 'r');
        fea(:,(j-2),pair_count) = fscanf(fileID, '%f');
        fclose(fileID);
    end
    
    dir2=t{1,4};
    dir2=strcat(feature_root, dir2(2:length(dir2)));
    cd(dir2);
    namelist=dir;
    [num_files,~]=size(namelist);
    if num_files ~= 11
        break;
    end
    for j=3:num_files
        current_file = namelist(j).name;
        fileID = fopen(current_file, 'r');
        fea(:,(j+7),pair_count) = fscanf(fileID, '%f');
        fclose(fileID);
    end
    
    label(pair_count)=str2num(t{1,5});
end
fclose(fid);
