var={'375C-33.3','375C-50','375C-66.7', '375C-83.3', '375C-153','400C-33.3', '400C-66.7','400C-83.3'};
for a=1:length(var)
    tempvar=var(a)
    file=strcat('/Users/Joel/Desktop/VO2_NC_Films/Spectra/VOx-InOx/VOx-InOx-1-',tempvar, 'ppm-1hr-Tseries.xlsx')

    data = xlsread(file, 'Data');
    x=data(2:2152);
    y=data(1, 2:25);
    z=data(2:2152, 2:25);

    len=2151*24;
    x2=repmat(x, 1, 24);
    y2=reshape(kron(y, ones(2151, 1)), [1, len]);
    z2=reshape(z, [1, len]);

    fig=figure(1)
    waterfall(y, x, z);

    ax = gca;
    c = ax.Color;
    ax.FontName = 'Baskerville';

    ylabel('Wavelength (nm)');
    xlabel('Temperature (C)');
    zlabel('% Transmittance'); 

    %h=get(gca,'xlabel');
    %set(h,'rotation',20)

    %i=get(gca,'ylabel');
    %set(i,'rotation',-18)

    az = 135;
    el = 25;
    view(az, el);
    saveas (fig, 'InOx.png');

    %figure (2)
    %for n=2:24
    %    plot(x, data(2:2152, n));
    %end
    %hold off

    %figure (3)
    %comet3(x2, y2, z2);
end

