%% Assymetric Gaussian Fit Routine
% Written by Eric Landahl 4/4/2011
% aguassfit.m
% based on symmetric gaussian fitting program gaussfit.m written circa 12/1/2009

function [M sigma_tot] = agaussfit(xi,yi,sigma)
% OUTPUTS are fit coefficients (m) and standard deviations of these
% coefficints (sigma_tot) coming from both residuals and data error bars
% Both m and sigma_tot are arrays of 5 fit parameters
% INPUTS are the x and y data and the corresponding y data standard
% deviations
% FIT PARAMETERS
%  M(1) amplitude
%  M(2) centroid
%  M(3) left width
%  M(4) offset
%  M(5) right width

numpts = length(xi);
dx = max(xi)/numpts;

f=0.1; %Shift factor determines speed of nolinear regression

VV=sigma.^2; %variance is sqaure of the standard deviation
Var=sum(sigma.^2);
V=diag(VV); % for uncorrelated errors, the variance is a diagonal matrix
W=inv(V).*Var;
%Part II: Guess the first curve fit and plot 
%% We have the functions
numparams=5; %M(1), M(2), M(3), M(4), M(5) for fit

X = (min(xi):dx:max(xi));                       % Numerical approximation of the FWHM of the infinite solution
AMP = interp1(xi,yi,X);                         % and the surface layer solution. Variables labeled with "0"
left = find(AMP > max(AMP)/2,1,'first');
AMP01 = fliplr(AMP);
right = find(AMP01 > max(AMP)/2,1,'first');
width = X(length(X) - right) - X(left);
cent = (X(length(X) - right) + X(left))/2;

M_guess(1) = max(yi) - min(yi);                 % Guess for the amplitude
M_guess(2) = cent;                              % Guess for the center
M_guess(3) = width/(sqrt(log(2))*2);            % Guess for the first width
M_guess(4) = min(yi);                           % Guess for the offset
M_guess(5) = M_guess(3);                        % Guess a symmetric gaussian

M=M_guess';

% Equation for the assymetric gaussian
for i = 1:numpts
    if xi(i) < M(2)
        Y_guess=(M(1))*exp(-((xi(i)-M(2)).^2/(M(3)^2)))+M(4);
    else
        Y_guess=(M(1))*exp(-((xi(i)-M(2)).^2/(M(5)^2)))+M(4);
    end
end

E_guess = yi - Y_guess;    % Difference between guess and actual data
E = E_guess;
S_guess = (E'*W*E);  % Weighted sum of squared residuals from guess
S = S_guess;

mmax=500;

for m=1:mmax
    for i=1:numpts
        if xi(i) < M(2)
            XX(i,1)=exp(-((-xi(i)+M(2)).^2/(M(3)^2)));
            XX(i,2)=(1/M(3)^2)*2*M(1)*(xi(i)-M(2))*exp(-((-xi(i)+M(2)).^2/(M(3)^2)));
            XX(i,3)=(1/M(3)^3)*2*M(1)*((xi(i)-M(2)).^2)*exp(-((-xi(i)+M(2)).^2/(M(3)^2)));
            XX(i,4)=1;
            XX(i,5)=0;
        else
            XX(i,1)=exp(-((-xi(i)+M(2)).^2/(M(5)^2)));
            XX(i,2)=(1/M(5)^2)*2*M(1)*(xi(i)-M(2))*exp(-((-xi(i)+M(2)).^2/(M(5)^2)));
            XX(i,3)= 0;
            XX(i,4)=1;
            XX(i,5)=(1/M(5)^3)*2*M(1)*((xi(i)-M(2)).^2)*exp(-((-xi(i)+M(2)).^2/(M(5)^2)));  
        end
    end
    
   P = inv(XX'*W* XX);  % Intermediate matrix calculated for least squares fit and error
   delta_M = P*XX'*W*E;
   M_guess = M+delta_M*f;
   
   for i= 1:numpts
    if xi(i) < M(2)
        Y_next(i)=(M_guess(1))*exp(-((xi(i)-M_guess(2)).^2/(M_guess(3)^2)))+M_guess(4);
    else
        Y_next(i)=(M_guess(1))*exp(-((xi(i)-M_guess(2)).^2/(M_guess(5)^2)))+M_guess(4);
    end
   end

   E=yi-Y_next';
   S=(E'*W*E);
   
   if S > S_guess;
       S = S_guess;
       E = E_guess;
       P = P_guess;
       Y_next = Y_guess;
       m
       break
   end
   
   S_guess = S;
   E_guess = E;
   P_guess = P;
   M = M_guess;
   
%%   Uncomment this section to show animation of fit convergence
%    figure(2);clf;hold on;
%    errorbar(xi,yi,sigma,'og')
%    plot(xi,Y_next)
%    title(num2str(m))
%    hold off;
   
end


sigma_res=(( S *diag(P))/(numpts-numparams)).^(0.5); % Error in parameters due to residuals
sigma_w  =((Var*diag(P))/(numpts-numparams)).^(0.5);  % Error in parameters due to error bars
sigma_tot=(sigma_res + sigma_w);%/sqrt(sum(yi));  % total error in each fit parameter

end