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

% Testing: whether two sequence represent the same person
% process the first test seq
cd(personname1); % you set personname1
cd(seqid1);
namelist=dir();
A=[];
for i=3:(N+2)
    inputfilename = namelist(i).name;
    fileID = fopen(inputfilename, 'r');
    a = fscanf(fileID, '%f');
    fclose(fileID);
    A = [A a];
end

% process the second test seq 
cd(personname1); % you set this
cd(seqid2);
namelist=dir();
B=[];
for i=3:(N+2)
    inputfilename = namelist(i).name;
    fileID = fopen(inputfilename, 'r');        
    b = fscanf(fileID, '%f');
    fclose(fileID);
    B = [B b];
end

% project the test feature