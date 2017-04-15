function Charge=MyIntegration(f,a,b,M)

% This function will use the Composite Simpson rule to integrate the
% current as a function of timefor the charge calculation

% Input  -f is the integrand input as a string. In this case the Current
%        -a and b are the upper and lower limits of the integration. In this
%        case time 0 to XXX in seconds
%        -M is the number of sub intervals. In this case the length of the
%        time vector
% Output -Charge is the value of the charge that we recieve 

h=(b-a)/(2*M);
s1=0;
s2=0;
for k=1:M
    x=a+h*(2*k-1);
    s1=s1+feval(f,x);
end
for k=1:(M-1)
    x=a+h*2*k;
    s2=s2+feval(f,x);
end
Charge=h*(feval(f,a)+feval(f,b)+4*s1+2*s2)/3;