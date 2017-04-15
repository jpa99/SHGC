path="/Users/Joel/Desktop/VO2/VO2_DATA/Spectra/VOx-InOx/VOx-InOx-1-";
xtn="ppm-1hr-Tseries.xlsx";
samples=["375C-33.3", "375C-66.7", "375C-153", "400C-33.3", "400C-66.7", "400C-83.3"];
names={};
tic;
for i = 1:numel(samples)
    element=char(samples(i));
    file=strcat(path, element, xtn);
    if contains(element, '.')
        fin=element(9);
    else
        fin=element(8);
    end
    name=strcat('t', element(1:3), element(6:7), fin);
    names=[names, name];
    data = xlsread(file, 'Data');
    eval(strcat(name, '= data(2:2152, 2:13);'));
    eval(strcat(name, '_FULL = data(2:2152, 2:25);'));
end

file=strcat(path, samples(1), xtn);   
data_2 = xlsread(file, 'Data');
wl = data_2(2:2152);
Tseries = data_2(1, 2:13);
Tseries_FULL = data_2(1, 2:25);

clear data data_2 element file fin i name path xtn;

toc;
disp(toc);