clear all;close all;

%Consistent parts of file names
path ='/Users/Joel/Desktop/VO2_NC_Films/SpectralData/';
ext='.xlsx';

%Cell array of variable file Strings
filenames={'VOx-InOx-1-375C-33.3ppm-1hr-Tseries', 'VOx-InOx-1-375C-66.7ppm-1hr-Tseries', 'VOx-InOx-1-375C-153ppm-1hr-Tseries', 'VOx-InOx-1-400C-33.3ppm-1hr-Tseries', 'VOx-InOx-1-400C-83.3ppm-1hr-Tseries'};

%Loops through filenames array and outputs SHGC values for each file
for n=1:size(filenames, 2)
    data=untitled(strcat(path, filenames{n}, ext), 0);
    %xlswrite('/Users/Joel/Documents/MATLAB/CharacterizationData.xlsx', data, strcat('A', num2str(n)));
end

