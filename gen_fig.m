

file='/Users/Joel/Desktop/VO2/VO2_DATA/Spectra/VOx-InOx/VOx-InOx-1-400C-66.7ppm-1hr-Tseries.xlsx'
data = xlsread(file, 'Data');
x = data(2:2152);
y =data(1, 2:25);
z = data(2:2152, 2:25);

% generates figure with waterfall of data
fig=figure(1)
waterfall(y, x, z);
grid on

% colorizes axes, sets default font weights to bold, etc.
ax=gca;
c = ax.Color;
ax.FontName = 'Helvetica';
ylabel('Wavelength (nm)', 'FontWeight','bold');
xlabel('Temperature (C)', 'FontWeight','bold');
zlabel('% Transmittance', 'FontWeight','bold'); 

%h=get(gca,'xlabel');
%set(h,'rotation',20)

%i=get(gca,'ylabel');
%set(i,'rotation',-18)

az = 135;
el = 25;
view(az, el);
saveas(fig, 'InOxnewew.png');
