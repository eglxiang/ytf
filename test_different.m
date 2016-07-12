%% Testing: whether two sequence represent the same person
% process the first test seq
personname1 = exterior_folders( test_index_set(1)+2 ).name;
video_directory='../feature/';
cd(video_directory);
cd(personname1); % you set personname1
interior_folders=dir;
[num_interior_folders,~]=size(interior_folders);
if num_interior_folders > 2
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
    B1 = B1*L; %projection
    B1 = normr(B1); % normalize rows 
end

    cd ..
    cd ..

personname2 = exterior_folders( test_index_set(2)+2 ).name;
cd(personname2); % you set personname1
interior_folders=dir;
[num_interior_folders,~]=size(interior_folders);
if num_interior_folders > 2    
    seqid2 = interior_folders(3).name;
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
    B2 = B2*L;
    B2 = normr(B2);
end

% correlation
corr = B1*B2';
corr_max = max(corr(:))
if corr_max > 0.85
    disp('Same person.');
else
    disp('Different person.');
end
% [counts, binLocs] = imhist(corr);
% [~,idx] = max(counts);
% corr_majority = binLocs(idx);
% if corr_majority > 0.8
%     disp('Same peson.');
% else
%     disp('Different person. ');
% end