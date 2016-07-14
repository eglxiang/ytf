% Xiang Xiang (eglxiang@gmail.com), Jan. 15, 2016, MIT license.

clc;
close all; 
clear all;

addpath(cd());

%%%%%%%%%%%%%%%%%%%%%%% TRAINING PHASE
%% Set Training and Testing Indices  
fprintf('Generating Train and Test Indices \n');
initial_directory= cd();
video_directory='../feature/';
cd(video_directory);
exterior_folders=dir; % for reference of label starting with 3
[num_exterior_folders,~]=size(exterior_folders);  
num_class=num_exterior_folders-2; % num of persons in total
num_train=ceil(num_exterior_folders/2)-1; % num of training sequences
num_test=num_class-num_train; % num of testing sequences
train_index_set=randperm(num_class,num_train); % training sample index
train_index_set = sort(train_index_set);
full_index_set = [1:num_class]; % index of full set's sequences
test_index_set = setdiff(full_index_set,train_index_set); % testing sample index
test_index_set = sort(test_index_set);

%% Generate Data Matrix
% training data
A=[];
y=[];
count_train=0;
count_seq=0;
for n=1:num_train
    label = train_index_set(n)+2;
    current_exterior_folder = exterior_folders(label).name;
    cd(current_exterior_folder);
    interior_folders=dir;
    [num_interior_folders,~]=size(interior_folders);
    for i=3:num_interior_folders % interior with the same label
        count_seq = count_seq + 1;
        current_interior_folder = interior_folders(i).name;
        cd(current_interior_folder);
        namelist=dir;
        [num_files,~]=size(namelist);
        if num_files ~= 11
            break;
        end
        for j=3:num_files
            current_file = namelist(j).name;
            fileID = fopen(current_file, 'r');
            a = fscanf(fileID, '%f');
            fclose(fileID);
            A = [A; a'];
            y = [y; label];
            count_train = count_train + 1;
        end
        cd ..
    end
    cd ..
end

% learning a projection
cd(initial_directory);
[ L b info ] = ldml_learn(A,y);
% save the projection matrix to txt
fileID = fopen('ProjectTo650Mat.txt','w');
fprintf(fileID, [repmat('%f ',1,size(L,2)) '\n'], L');
fclose(fileID);

%% Testing: whether two sequence represent the same person
% process the first test seq
personname1 = exterior_folders( test_index_set(1)+2 ).name;
cd(video_directory);
cd(personname1); % you set personname1
interior_folders=dir;

if num_interior_folders > 3
    seqid1 = interior_folders(3).name;
    cd(seqid1);
    namelist=dir();
    [num_files,~]=size(namelist);
    if num_files == 11
        B1 = [];
        for i=3:num_files
            inputfilename = namelist(i).name;
            fileID = fopen(inputfilename, 'r');
            b = fscanf(fileID, '%f');
            fclose(fileID);
            B1 = [B1; b'];
        end
    end
    
    cd ..
    % process the second test seq with the same subject
    seqid2 = interior_folders(4).name;
    cd(seqid2);
    namelist=dir();
    [num_files,~]=size(namelist);
    if num_files == 11
        B2 = [];
        for i=3:num_files
            inputfilename = namelist(i).name;
            fileID = fopen(inputfilename, 'r');
            b = fscanf(fileID, '%f');
            fclose(fileID);
            B2 = [B2; b'];
        end
    end
    
    %B1 = B1*L; %projection
    %B1 = normr(B1); % normalize rows
    %B2 = B2*L;
    %B2 = normr(B2);
    
    % correlation
    corr = B1*B2';
    corr_max = max(corr(:));
    if corr_max > 0.85
        disp('Same person.');
    else
        disp('Different person.');
    end
end
