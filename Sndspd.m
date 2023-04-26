 function ssp=Sndspd(S,T,D,equation)
%  Sndspd = Speed of sound in seawater using various sound-speed equations.
%
%  Please NOTE: the different equations below input depth (D) as either meters
%  (Z) or pressure (P). Be sure to input the proper values. Corrections to 
%  kg/cm^2 or bars, etc. as may be required by the various equations will be 
%  made internally.
%
%          1) Sndspd(S,T,Z) returns the sound speed (m/sec) given vectors
%             of salinity (ppt), temperature (deg C) and DEPTH (m) using
%             the formula of Mackenzie:
%
%             Mackenzie, K.V. "Nine-term Equation for Sound Speed in the Oceans",
%             J. Acoust. Soc. Am. 70 (1981), 807-812.
%
%          2) Sndspd(S,T,P,'del grosso') returns the sound speed (m/sec) 
%             given vectors of salinity (ppt), temperature (deg C), and 
%             PRESSURE (dbar) using the Del Grosso equation:
%
%             Del Grosso, "A New Equation for the speed of sound in Natural
%             Waters", J. Acoust. Soc. Am. 56#4 (1974).
%
%          3) Sndspd(S,T,P,'chen') returns the sound speed (m/sec) given
%             given vectors of salinity (ppt), temperature (deg C), and 
%             PRESSURE (dbar) using the Chen and Millero equation:
%
%             Chen and Millero, "The Sound Speed in Seawater", J. Acoust. 
%             Soc. Am. 62 (1977), 1129-1135
%
%          4) Sndspd(S,T,P,'state') returns the sound speed (m/sec) given
%             given vectors of salinity (ppt), temperature (deg C), and 
%             PRESSURE (dbar) by using derivatives of the EOS80 equation of
%             state for seawater and the adiabatic lapse rate.
%
%          5) Sndspd(S,T,P,'wilson') returns the sound speed (m/sec) given
%             given vectors of salinity (ppt), temperature (deg C), and 
%             PRESSURE (dbar) by using the empirical formula derived by:
%
%            Wilson (1960). "Equation for the speed of sound in sea water"'
%            J. Acoust. Soc. Amer. V32, N10, p. 1357.
%
%  CHECKVALUE for 'chen':   SVEL=1731.995 M/S  @  S=40, T=40 DEG C, P=10000 DBAR
%  CHECKVALUE for 'del':    SVEL=1732.366 M/S  @  S=40, T=40 DEG C, P=10000 DBAR
%  CHECKVALUE for 'mac':    SVEL=1718.774 M/S  @  S=40, T=40 DEG C, Z=10000 M
%  CHECKVALUE for 'state':  SVEL=1734.112 M/S  @  S=40, T=40 DEG C, P=10000 DBAR
%  CHECKVALUE for 'wilson': SVEL=1735.009 M/S  @  S=40, T=40 DEG C, P=10000 DBAR


% Notes: RP (WHOI) 3/dec/91
%        Added state equation ss
%
%       ETP3 (MBARI) 2012-02-23
%        Added Wilson (1960) equation
%        Corrected dbar to kg/cm^2 calculation in Del Grosso

if (nargin<4), equation='mackenzie'; end;

if strcmp(equation(1:3),'mac'),

% Fixed a small typo with the salinity stuff in the T*(S-35) term
% --RP 15/11/91

     c= 1.44896e3;     t= 4.591e0; 
    t2=-5.304e-2;     t3= 2.374e-4;
     s= 1.340e0;       d= 1.630e-2;
    d2= 1.675e-7;     ts=-1.025e-2;
   td3=-7.139e-13;  

   ssp=c+t*T+t2*T.*T+t3*T.*T.*T+s*(S-35.0)+d*D+d2*D.*D+ts*T.*(S-35.0) ...
        +td3*T.*D.*D.*D;

    
elseif strcmp(equation(1:3),'del'),

% Del Grosso uses kg/cm^2 for pressure. To get to this from dbars we must 
% multiply by 0.101972:

     P = D.*0.101972;

% Note: earlier versions of Sndspd.m used a conversion involving the force
% of gravity calculated from UNESCO algorithms. This was an error and has
% been corrected.

% This is from VSOUND.f:
    
      C000 = 1402.392;
      DCT = (0.501109398873e1-(0.550946843172e-1 - 0.221535969240e-3*T).*T).*T;
      DCS = (0.132952290781e1 + 0.128955756844e-3*S).*S;
      DCP = (0.156059257041e0 + (0.244998688441e-4 - 0.883392332513e-8*P).*P).*P;
      DCSTP = -0.127562783426e-1*T.*S + 0.635191613389e-2*T.*P +0.265484716608e-7*T.*T.*P.*P ...
 - 0.159349479045e-5*T.*P.*P+0.522116437235e-9*T.*P.*P.*P - 0.438031096213e-6*T.*T.*T.*P;
      DCSTP=DCSTP - 0.161674495909e-8*S.*S.*P.*P + 0.968403156410e-4*T.*T.*S+ ...
   0.485639620015e-5*T.*S.*S.*P - 0.340597039004e-3*T.*S.*P;
   ssp= C000 + DCT + DCS + DCP + DCSTP;


elseif strcmp(equation(1:3),'che'),
      P0=D;
      
% This is copied directly from the UNESCO algorithmms, with some minor changes
% (like adding ";" and changing "*" to ".*") for Matlab.

%   SCALE PRESSURE TO BARS
      P=P0/10.;
%**************************
      SR = sqrt(abs(S));
% S**2 TERM
      D = 1.727E-3 - 7.9836E-6*P;
% S**3/2 TERM
      B1 = 7.3637E-5 +1.7945E-7*T;
      B0 = -1.922E-2 -4.42E-5*T;
      B = B0 + B1.*P;
% S**1 TERM
      A3 = (-3.389E-13*T+6.649E-12).*T+1.100E-10;
      A2 = ((7.988E-12*T-1.6002E-10).*T+9.1041E-9).*T-3.9064E-7;
      A1 = (((-2.0122E-10*T+1.0507E-8).*T-6.4885E-8).*T-1.2580E-5).*T+9.4742E-5;
      A0 = (((-3.21E-8*T+2.006E-6).*T+7.164E-5).*T-1.262E-2).*T+1.389;
      A = ((A3.*P+A2).*P+A1).*P+A0;
% S**0 TERM
      C3 = (-2.3643E-12*T+3.8504E-10).*T-9.7729E-9;
      C2 = (((1.0405E-12*T-2.5335E-10).*T+2.5974E-8).*T-1.7107E-6).*T +3.1260E-5;
      C1 = (((-6.1185E-10*T+1.3621E-7).*T-8.1788E-6).*T+6.8982E-4).*T +0.153563;
      C0 = ((((3.1464E-9*T-1.47800E-6).*T+3.3420E-4).*T-5.80852E-2).*T+5.03711).*T+1402.388;
      C = ((C3.*P+C2).*P+C1).*P+C0;
% SOUND SPEED RETURN
      ssp = C + (A+B.*SR+D.*S).*S;

      
elseif strcmp(equation(1:3),'sta'),
     P=D;
     
% (Copied somewhat from program EOSSPEED.F)
     [~,sigma]=SWstate(S,T,P);
     VOL=(1.)./(1000.+sigma);
%     DV/DP|ADIA = (DV/DP) AT CONSTANT T + ADIA.LAPSE RATE *
%                  (DV/DT) AT CONSTANT P
%     Note: factor of 10 is convert pressure from dB to Bars
     dVdP=SWstate(S,T,P,'dP');
     dVdT=SWstate(S,T,P,'dT');
     dVdPad=(dVdP+Adiabat(S,T,P).*dVdT)*10;
%     C = V * SQRT ( 1/DV/DP| ADIA)
     ssp=VOL.*sqrt(abs( (1.e5)./dVdPad ));

     
elseif strcmp(equation(1:3),'wil')

% Wilson uses kg/cm^2 for pressure. To get to this from dbars we must 
% multiply by 0.101972:

     P=D.*0.101972;
     
     c0 = 1449.14;
     
     DcS = 1.39799*(S-35) - 1.69202e-3*(S-35).^2;
     DcT = 4.5721*T - 4.4532e-2*T.^2 - 2.6045e-4*T.^3 + 7.9851e-6*T.^4;
     DcP = 1.60272e-1*P + 1.0268e-5*P.^2 + 3.5216e-9*P.^3 - 3.3603e-12*P.^4;
     DcSTP = (S-35).*(-1.1244e-2*T + 7.7711e-7*T.^2 + 7.7016e-5*P ...
               - 1.2943e-7*P.^2 + 3.1580e-8*P.*T + 1.5790e-9*P.*T.^2) ...
               + P.*(-1.8607e-4*T + 7.4812e-6*T.^2 + 4.5283e-8*T.^3) ...
               + P.^2.*(-2.5294e-7*T + 1.8563e-9*T.^2) - 1.9646e-10*P.^3.*T;

	 ssp = c0 + DcS + DcT + DcP + DcSTP;

else
   error('soundspeed: Unrecognizable equation specified!');
end
