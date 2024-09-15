%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%
% Made by: Gabriel Almeida Santos de Oliveira
% Contact: gabriel.oliveira.ga76@gmail.com
%
% DEPENDENCIES:
%   • Control System Toolbox
%
% ATENTION: 
%   Viable only for 2nd order systems
%---------------------------------------------------------------------------------------------------------
% INPUT:
%   sys           - (1×1 tf, zpk, or ss) continuous or discrete-time linear system
%   trgt_Mp  - (1×1 double) intended maximum overshoot of controlled system
%   trgt_ts    - (1×1 double) intended setling time of controlled system
%
% -------
% OUTPUT:
%   cont_zero  - (1×1 double) lead controller zero
%   cont_pole   - (1×1 double) lead controller pole
%   cont_gain   - (1×1 double) lead controller gain
%   cont_tf      - (1x1 zpk) lead controller transfer function
%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

function [cont_zero, cont_pole, cont_gain, cont_tf] = RL_LEAD_CONTROLER(sys, trgt_Mp, trgt_st)
    % zeta calculation [Mp = exp(-zeta*pi / sqtr(1-zeta^2)  )]
    zeta = sqrt( log(trgt_Mp)^2 / ( (log(trgt_Mp)^2) + (pi^2) ) ) * 1.10; % increment 10% to give a margin of error

    % wn calculation [ts = 4 / zeta*wn] p/ 2%
    wn = 4 / (trgt_st*zeta);

    % desired dominant pole:
    Re = zeta*wn;
    Img = wn*sqrt(1-zeta^2);

    trgt_Pd = -1*(Re) + 1i*(Img);

    % controller zero position chosen to be directly under the desired pole
    % to simplify calculations
    cont_zero = Re;

    % controller Pole location calculated via phase condition
    % ang (G(S)*H(S)) = 180º(2n + 1)
    [num, den] = tfdata(sys, 'v');
    zeros = roots(num);
    poles = roots(den);

    teta_pd = 3*pi/2; % 180° of phase condition + 90° from the zero directly under the desired pole
    
    if ~ isempty(zeros)
        for ind = 1:length(zeros) % calculate the phase contribution of each Zero of the transfer function
            zero_phase = phase(zpk([zeros(ind)],[],1), trgt_Pd, 'rad');
            teta_pd = teta_pd + zero_phase;
        end    
    end

    if ~ isempty(poles)
        for ind = 1:length(poles) % calculate the phase contribution of each Pole of the transfer function
            pole_phase = phase(zpk([],[poles(ind)],1), trgt_Pd, 'rad');
            teta_pd = teta_pd + pole_phase;
        end
    end

    % knowing the angle contribution of the controller Pole it is calculated
    % its position on real axis
    cont_pole = Re + (  Img/tan(teta_pd) );

    % knowing the position of both the Zero and Pole from the controller,
    % the gain is calculated with the magnitude condition
    % |kc*C(S)*G(S)| = 1
    %PZ_C = (s + cont_zero) / (s + cont_pole);
    PZ_Cont = zpk([-cont_zero], [-cont_pole], 1);
    INV = (PZ_Cont^(-1)) * (sys^(-1));
    cont_gain = mag(INV, trgt_Pd);

    cont_pole = -cont_pole; cont_zero = -cont_zero;
    cont_tf = cont_gain * PZ_Cont;
end

function mag = mag(sys,x)
    mag = norm(evalfr(sys,x));
end

function phase = phase(sys,x,units)
    if nargin < 3 || isempty(units)
        units = 'deg';
    end
    
    phase = atan2d(imag(evalfr(sys,x)),real(evalfr(sys,x)));
    
    if strcmpi(units,'rad')
        phase = phase*(pi/180);
    end
end