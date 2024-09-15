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

% To avoid a noticeable modification to the root locus, the phase
% contribution of the 

function [cont_zero, cont_pole, cont_gain, cont_tf] = RL_DELAY_CONTROLER(sys, trg_pos_static_err, cont_pole)
    % calculate the particular static error constant [ ep(inf) = 1 / (1 + kp) ]
    Kp = (1 / trg_pos_static_err) - 1;
    
    % get ratio between thge pole and the zero [Kp = limit as  s -> 0 of sys * (s + z)/(s + p)]
    temp_holder = limit(sys,s,0);
    ratio = kp/temp_holder; % z = ratio * P (in the delay controler the zero is slightly bigger than the pole)
    
    % choose  the position of the pole, must be close to the origin to not 
    % change the transient reponse of the system
    if nargin < 3 || isempty(pole_position)
        cont_pole = 0.01;
    end
    
    cont_zero = ratio * cont_pole;
        
    % get the dominant pole of the closed loop system
    CLTF = feedback(sys, 1);
    [num, den] = tfdata(CLTF, 'v');
    poles = roots(den);
    min_real = real(poles(1));
    min = poles(1);
    for ind = poles
        pole_re = real(ind);
        if abs(pole_re) < abs(min_real) 
            min_real = abs(min_real);
            trgt_Pd = ind; 
        end
    end
    
    % verify the phase contribution is bellow 5 degree
    phase_contribtion = phase(zpk([-cont_zero],[-cont_pole],1), trgt_Pd, 'deg');
    if phase_contribtion > 5
        disp("Atention, phase contribution is higher than 5 degrees, cotroler might significantly alter transient response.");
    end
    
    
    % adjust Kc by the magnitude condition
    % knowing the position of both the Pero and Pole from the controller,
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