clear all; close all;

% Calculates  SHGC for different levels of solar transmittance 

% Input:
%   onData= Optical transperancy of the ON state (nm,Fraction)
%   offData= Optical transperancy of the OFF state (nm,Fraction)

% Output:
%   Tsolar_ON= Tsolar of the on state (Fraction)
%   Tsolar_OFF= Tsolar of the OFF state (Fraction)
%   Tsolar_ON_NIR= Tsolar_NIR of the ON state (Fraction)
%   Tsolar_OFF_NIR= Tsolar_NIR of the OFF state (Fraction)
%   Tlum_ON= Tlum of the ON state (Fraction)
%   Tlum_OFF= Tlum of the OFF state (Fraction)

%% READ INPUT

% Import Optical Spectra
    path ='/Users/Joel/Desktop/VO2_NC_Films/SpectralData/VOx-InOx-1-';
    ext='ppm-1hr-Tseries.xlsx';
    filenames={'375C-33.3', '375C-66.7', '375C-83.3', '375C-153', '400C-33.3', '400C-83.3'};
         
    filename='/Users/Joel/Desktop/VO2_NC_Films/Spectra/VOx-InOx/0.93_VIn/VOx-InOx-1-400C-66.7ppm-1hr-Tseries.xlsx'
   
    x=reshape(xlsread(filename, 'Data', 'A2:A2152'), [2151,1]);
    y1=reshape(xlsread(filename, 'Data', 'C2:C2152'), [2151,1]);
    y2=reshape(xlsread(filename, 'Data', 'M2:M2152'), [2151,1]);
    
    onData=horzcat(x, y2);
    offData=horzcat(x, y1);
 %% PLoting Optical Traces
 
    Wavelength=xlsread('wavelength.xlsx','A1:A2151');
 
    % Plotting All optical Spectra on the same plot
        figure ('name','Optical Spectra','NumberTitle','off')
        plot(Wavelength,offData, 'r',Wavelength,onData,'b')
        xlabel('Wavelength (nm)')
        ylabel('Transmittance')
        axis([350 2500 0 1])
        legend('monoclinic','rutile')

    %% Calculating the T solar Change in spectra

    % Importing the AM 1.5 Spectra 
    AM1_5g=xlsread('/Users/Joel/Documents/MATLAB/ASTMG173.xlsx','SMARTS2', 'C143:C1704');
    %AM1_5g=reshape(AM1_5gFULL(143:1704, 3), [1562, 1]);
    
    AMlambda=xlsread('/Users/Joel/Documents/MATLAB/ASTMG173.xlsx','SMARTS2', 'A143:A1704');
    %AMlambda= reshape(AMlambdaFULL(143:1704), [1562, 1]);
    
    % Integrate the Solar Spectrum

        % Establishing a Curve Fitting for TOTAL Solar Spectrum
         [curve_fit,gof] = fit(AMlambda, AM1_5g,'cubicinterp');
         
        %Plotting Total Spectra with Curve Fit
        figure ('name','Solar Spectrum with Fit','NumberTitle','off')
        plot(curve_fit,'x',AMlambda,AM1_5g,'r')
        xlabel('Wavelength (nm)')
        ylabel('Solar Irradiance (mA)')
        legend('Data','Fitting')
        title('AM 1.5g vs Fitting')
        
        
        % Integrating Total Spectra
        M=length(AMlambda);
        a=AMlambda(1);
        b=AMlambda(M);
        AM1_5g_int=MyIntegration(curve_fit,a,b,M);  %(W/m^2)
        
        % Establishing a Curve Fitting for NIR Solar Spectrum
        for j=1:1080
        AM1_5g_NIR(j)=AM1_5g(431+j);
        AMlambda_NIR(j)= AMlambda(431+j);
        end
         [curve_fit,gof] = fit(AMlambda_NIR',AM1_5g_NIR','cubicinterp');
         
        % Plotting Total Spectra with Curve Fit
        figure ('name','NIR Solar Spectrum with Fit','NumberTitle','off')
        plot(curve_fit,'x',AMlambda_NIR,AM1_5g_NIR,'r')
        xlabel('Wavelength (nm)')
        ylabel('NIR Solar Irradiance (mA)')
        legend('Data','Fitting')
        title('AM 1.5g vs Fitting')
        
        
        % Integrating Total Spectra
        M=length(AMlambda_NIR);
        a=AMlambda_NIR(1);
        b=AMlambda_NIR(M);
        AM1_5g_NIR_int=MyIntegration(curve_fit,a,b,M);  %(W/m^2)
        
    % Calculating Tsol for ON State
    
            %Calculate Tsolar from range of 350-400
             Tsolprod_ON(1,1)=AM1_5g(1)*onData(1,2);
             for j=1:48
                Tsolprod_ON(j+1,1)=AM1_5g(j+2)*onData(j+1,2);    
             end
    
            %Calculate Tsolar from range of 400-1700
            for j=50:1350
                Tsolprod_ON(j,1)=onData(j+1,2)*AM1_5g(j+51);
            end
    
            %Calculate Tsolar from range of 1705-2500
            g=5;
            z=0;
            for j=1351:1510
                g=g+z;
                z=4;
                Tsolprod_ON(j+1,1)=onData(j+g,2)*AM1_5g(j+52);
            end 
    
                % Make Wavelength Scale
                for k=1:1351
                    TsolLambda(k,1)=349+k;
                end
                for k=1403:1562
                    TsolLambda(k-51,1)=AMlambda(k);
                end
    
            % Integrate Tsolar product as a function of Lambda
            
                % Establishing a Curve Fitting
                 [curve_fit,gof] = fit(TsolLambda,Tsolprod_ON,'cubicinterp');
         
                % Integrating 
                M=length(TsolLambda);
                a=TsolLambda(1);
                b=TsolLambda(M);
                Tsolprod_int_ON=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
        
            % Solve for Solar Transmittance as of the ON state
            Tsolar_ON=Tsolprod_int_ON/AM1_5g_int; % Percentage
            
            % Integrate Tsolar product as a function of Lambda for NIR
            
                % Establishing a Curve Fitting
                for j=1:1080;
                    TsolLambda_NIR(j)=TsolLambda(431+j);
                    Tsolprod_ON_NIR(j)=Tsolprod_ON(431+j);
                end
                 [curve_fit,gof] = fit(TsolLambda_NIR',Tsolprod_ON_NIR','cubicinterp');
        
                % Integrating 
                M=length(TsolLambda_NIR);
                a=TsolLambda_NIR(1);
                b=TsolLambda_NIR(M);
                Tsolprod_int_ON_NIR=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
        
            % Solve for Solar Transmittance as of the ON state
            Tsolar_NIR_ON=Tsolprod_int_ON_NIR/AM1_5g_NIR_int; % Percentage
         
     % Calculating Tsol for OFF State
    
            %Calculate Tsolar from range of 350-400
             Tsolprod_OFF(1,1)=AM1_5g(1)*offData(1,2);
             for j=1:48
                Tsolprod_OFF(j+1,1)=AM1_5g(j+2)*offData(j+1,2);    
             end
    
            %Calculate Tsolar from range of 400-1700
            for j=50:1350
                Tsolprod_OFF(j,1)=offData(j+1,2)*AM1_5g(j+51);
            end
    
            %Calculate Tsolar from range of 1705-2500
            g=5;
            z=0;
            for j=1351:1510
                g=g+z;
                z=4;
                Tsolprod_OFF(j+1,1)=offData(j+g,2)*AM1_5g(j+52);
            end
    
                % Make Wavelength Scale
                for k=1:1351
                    TsolLambda(k,1)=349+k;
                end
                for k=1403:1562
                    TsolLambda(k-51,1)=AMlambda(k);
                end
    
            % Integrate Tsolar product as a function of Lambda
            
                % Establishing a Curve Fitting
                 [curve_fit,gof] = fit(TsolLambda,Tsolprod_OFF,'cubicinterp');
        
                % Integrating 
                M=length(TsolLambda);
                a=TsolLambda(1);
                b=TsolLambda(M);
                Tsolprod_int_OFF=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
        
            % Solve for Solar Transmittance as of the OFF state
            Tsolar_OFF=Tsolprod_int_OFF/AM1_5g_int; % Fraction
            
            % Integrate Tsolar product  of NIR as a function of Lambda for NIR
            
                % Establishing a Curve Fitting
                for j=1:1080;
                    TsolLambda_NIR(j)=TsolLambda(431+j);
                    Tsolprod_OFF_NIR(j)=Tsolprod_OFF(431+j);
                end
                 [curve_fit,gof] = fit(TsolLambda_NIR',Tsolprod_OFF_NIR','cubicinterp');
  
                % Integrating 
                M=length(TsolLambda_NIR);
                a=TsolLambda_NIR(1);
                b=TsolLambda_NIR(M);
                Tsolprod_int_OFF_NIR=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
        
            % Solve for Solar Transmittance as of the ON state
            Tsolar_NIR_OFF=Tsolprod_int_OFF_NIR/AM1_5g_NIR_int; % Percentage
            
            %% Calculating T luminous

    % Importing the Eye Luminous 
    EyeLum=xlsread('EyeLuminous.xlsx','Data', 'B1:B43');
    %EyeLum=rshape(EyeLumFULL(1:40,2), [40, 1]);
    
    EyeLambda=xlsread('EyeLuminous.xlsx','Data', 'A1:B43');
    %EyeLambda=reshape(EyeLambdaFULL(1:40, 1), [40, 1]);
    
    %Plot the Eye Photic Spectrum
    figure ('name','Luminous Spectrum','NumberTitle','off')
    plot(EyeLambda,EyeLum)
    xlabel('Wavelength (nm)')
    ylabel('Percentage')
    title('Photic Eye Luminous')
    
    
    %Calculate Product of  Solar Spectrum with Luminesance and integral
    
    
            %Calculate Tlumprod from range of 350-380
             for j=1:3
                Tlumprod(j,1)=0;    
             end
            % Calculate from 380 to 400
            Tlumprod(4,1)=AM1_5g(61)*EyeLum(1);
            Tlumprod(5,1)=AM1_5g(82)*EyeLum(2);
            
            %Calculate Tlum from range of 400-770
            g=91;
            for j=6:43
                Tlumprod(j,1)=AM1_5g(g+10)*EyeLum(j-3);
                g=g+10;
            end
    
            %Calculate Tsolar from range of 770-2500
            for j=44:216
                Tlumprod(j,1)=0;
            end
            
           % Calculate TlumLambda 
            TlumLambda=[350:10:2500]';
            
            % Integrate Tlum as a function of Lambda
            
                % Establishing a Curve Fitting
                 [curve_fit,gof] = fit(TlumLambda,Tlumprod,'cubicinterp');
                
                % Integrating 
                M=length(TlumLambda);
                a=TlumLambda(1);
                b=TlumLambda(M);
                Tlumprod_int=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
                
    % Calculating Tlum for ON State
        
            %Calculate Tlum from range of 350-380
             for j=1:3
                Tlumprod_ON(j,1)=0;    
             end
            
            % Calculate from 380 to 400
            Tlumprod_ON(4,1)=onData(31,2)*AM1_5g(61)*EyeLum(1);
            Tlumprod_ON(5,1)=onData(41,2)*AM1_5g(81)*EyeLum(2);
            
            %Calculate Tlum from range of 400-770
            g=41;
            gg=91;
            for j=6:43
                Tlumprod_ON(j,1)=onData(g+10,2)*AM1_5g(gg+10)*EyeLum(j-3);
                g=g+10;
                gg=gg+10;
            end
    
            %Calculate Tsolar from range of 770-2500
            for j=44:216
                Tlumprod_ON(j,1)=0;
            end
            
            % Integrate Tsolar product as a function of Lambda
            
                % Establishing a Curve Fitting
                 [curve_fit,gof] = fit(TlumLambda,Tlumprod_ON,'cubicinterp');
        
                % Integrating 
                M=length(TlumLambda);
                a=TlumLambda(1);
                b=TlumLambda(M);
                Tlumprod_int_ON=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
            
            % Solve for Tlum Transmittance as of the ON state
            Tlum_ON=Tlumprod_int_ON/Tlumprod_int; % Percentage
            
    % Calculating Tlum for OFF State
        
            %Calculate Tlum from range of 350-380
             for j=1:3
                Tlumprod_OFF(j,1)=0;    
             end
            
            % Calculate from 380 to 400
            Tlumprod_OFF(4,1)=offData(31,2)*AM1_5g(61)*EyeLum(1);
            Tlumprod_OFF(5,1)=offData(41,2)*AM1_5g(82)*EyeLum(2);
            
            %Calculate Tlum from range of 400-770
            g=41;
            gg=91;
            for j=6:43
                Tlumprod_OFF(j,1)=offData((g+10),2)*AM1_5g(gg+10)*EyeLum(j-3);
                g=g+10;
                gg=gg+10;
            end
    
            %Calculate Tsolar from range of 770-2500
            for j=44:216
                Tlumprod_OFF(j,1)=0;
            end
         
                % Establishing a Curve Fitting
                 [curve_fit,gof] = fit(TlumLambda,Tlumprod_OFF,'cubicinterp');
       
                % Integrating 
                M=length(TlumLambda);
                a=TlumLambda(1);
                b=TlumLambda(M);
                Tlumprod_int_OFF=MyIntegration(curve_fit,a,b,M);  %(W/m^2*nm)
            
        % Solve for Tlum Transmittance as of the ON state
            Tlum_OFF=Tlumprod_int_OFF/Tlumprod_int; % Percentage
            
            
%% Create dataset
    disp(strcat('Tsolar_ON: '+ Tsolar_ON(1)))
    disp('Tsolar_OFF: '+ Tsolar_OFF)
    disp('Tsolar_NIR_ON: '+ Tsolar_NIR_ON)
    disp('Tsolar_NIR_OFF: '+ Tsolar_NIR_OFF)
    disp('Tlum_ON: '+ Tlum_ON)
    disp('Tlum_OFF: '+ Tlum_OFF)
    export(dataset(Tsolar_ON, Tsolar_OFF, Tsolar_NIR_ON, Tsolar_NIR_OFF, Tlum_ON, Tlum_OFF),'file','VO2-250ppm-356C-sum.txt')