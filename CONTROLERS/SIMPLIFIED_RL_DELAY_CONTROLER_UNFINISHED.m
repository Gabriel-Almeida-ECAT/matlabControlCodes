%=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%
% Made by: Gabriel Almeida Santos de Oliveira
% Contact: gabriel.oliveira.ga76@gmail.com
%
% DEPENDENCIES:
%   • Control System Toolbox
%   • https://www.mathworks.com/matlabcentral/fileexchange/94115-magnitude-and-phase-of-a-transfer-function-mag_phase
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

function [cont_zero, cont_pole, cont_gain, cont_tf] = simplified_rl_lead_controler(sys, trgt_Mp, trgt_st)
    % zeta calculation [Mp = exp(-zeta*pi / sqtr(1-zeta^2)  )]
    zeta = sqrt( log(trgt_Mp)^2 / ( (log(trgt_Mp)^2) + (pi^2) ) ) * 1.10; % increment 10% to give a margin of error
    %zeta = 0.7;

    % wn calculation [ts = 4 / zeta*wn] p/ 2%
    wn = 4 / (trgt_st*zeta);
    %wn = 3;

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
            [~, zero_phase] = mag_phase(zpk([zeros(ind)],[],1), trgt_Pd, 'rad');
            teta_pd = teta_pd + zero_phase;
        end    
    end

    if ~ isempty(poles)
        for ind = 1:length(poles) % calculate the phase contribution of each Pole of the transfer function
            [~, pole_phase] = mag_phase(zpk([],[poles(ind)],1), trgt_Pd, 'rad');
            teta_pd = teta_pd + pole_phase;
        end
    end

    % knowing the angle contribution of the controller Pole it is calculated
    % its position on real axis
    cont_pole = Re + (  Img/tan(teta_pd) );

    % knowing the position of both the Pero and Pole from the controller,
    % the gain is calculated with the magnitude condition
    % |kc*C(S)*G(S)| = 1
    %PZ_C = (s + cont_zero) / (s + cont_pole);
    PZ_Cont = zpk([-cont_zero], [-cont_pole], 1);
    INV = (PZ_Cont^(-1)) * (sys^(-1));
    [cont_gain,~] = mag_phase(INV, trgt_Pd);

    cont_pole = -cont_pole; cont_zero = -cont_zero;
    cont_tf = cont_gain * PZ_Cont;
end