function micronetworkOptions=setMicronetworkDefaultParameters()

 micronetworkOptions.minLength=1;
 micronetworkOptions.maxLength=10;
 micronetworkOptions.stepLength=0.01;
 micronetworkOptions.minWidth=0.5;
 micronetworkOptions.maxWidth=4;
 micronetworkOptions.stepWidth=0.01;
 
micronetworkOptions.mul=1.13*10^-3; % Liquid dynamic viscosity
micronetworkOptions.mug=20*10^-8; % Gaz dynamic viscosity
micronetworkOptions.sigma=32*10^-3; % Water surface tension (N/m)
micronetworkOptions.theta_glass=25*(2*3.14/360); % Contact angle water/glass (degrees)
micronetworkOptions.theta_plast=80*(2*3.14/360); % Contact angle water/plastic (degrees)
micronetworkOptions.h=50*10^-6; %Channel height (m)
micronetworkOptions.Scale=0.001; %(meters to mm for length and width)
 
 
end
 
 
 