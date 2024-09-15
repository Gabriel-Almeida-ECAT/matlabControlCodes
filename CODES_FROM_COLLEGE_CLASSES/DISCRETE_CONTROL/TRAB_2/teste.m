clc; clear all;

s = tf('s'); j = sqrt(-1);
Ts = 0.2;

% planta original
delay_pade = -(s - (4/Ts))/(s + (4/Ts))  % exp(-S*t) ~ - ( s - 2*t ) / ( s + 2*t )
delay_filtro = (2*Ts) / (s + 2*Ts)
FTMA = 1 / (s^2 + s)
FTMA_delay = delay_pade * FTMA % acrescentar o delay (ou por 1 senão houver delay)

%especificações de desempenho desejadas:
trgt_Mp = 0.38; % Máximo Soberssinal
trgt_ts = 7; % Tempo de assentamento

[~,~,~,CONT] = rl_lead_controler(FTMA, trgt_Mp, trgt_ts)
[~,~,~,CONT_delay] = rl_lead_controler(FTMA_delay, trgt_Mp, trgt_ts)

%controlador discretizado
D_CONT = c2d(CONT, Ts, 'tustin');
D_CONT_delay = c2d(CONT_delay, Ts, 'tustin');
%plata discreta
FTMA_c2d = c2d(FTMA, Ts, 'tustin');
FTMA_c2d_delay = c2d(FTMA_delay, Ts, 'tustin');

% FTs de malha fechada da planta original e da planta com o controlador
FTMF = feedback(FTMA, 1);
FTMF_C = feedback(FTMA*CONT, 1);
FTMF_c2d = feedback(FTMA_c2d*D_CONT,1);

FTMF_delay = feedback(FTMA_delay, 1);
FTMF_C_delay = feedback(FTMA_delay*CONT_delay, 1);
FTMF_c2d_delay = feedback(FTMA_c2d_delay*D_CONT_delay,1);

% resposta
step(FTMF, FTMF_C, FTMF_c2d, FTMF_delay, FTMF_C_delay, FTMF_c2d_delay);
%step(FTMF, FTMF_C, FTMF_c2d);
legend('Original','Controlada', 'Controlada discretizada','Original [delay]','Controlada [delay]', 'Controlada discretizada [delay]');



function [cont_zero, cont_pole, cont_gain, cont_tf] = rl_lead_controler(sys, trgt_Mp, trgt_st)
    % zeta calculation [Mp = exp(-zeta*pi / sqtr(1-zeta^2)  )]
    zeta = sqrt( log(trgt_Mp)^2 / ( (log(trgt_Mp)^2) + (pi^2) ) ) * 1.10 % increment 10% to give a margin of error
    %zeta = 0.7;

    % wn calculation [ts = 4 / zeta*wn] p/ 2%
    wn = 4 / (trgt_st*zeta)
    %wn = 3;

    % desired dominant pole:
    Re = zeta*wn;
    Img = wn*sqrt(1-zeta^2)

    trgt_Pd = -1*(Re) + 1i*(Img)

    % controller zero position chosen to be directly under the desired pole
    % to simplify calculations
    cont_zero = Re

    % controller Pole location calculated via phase condition
    % ang (G(S)*H(S)) = 180º(2n + 1)
    [num, den] = tfdata(sys, 'v')
    zeros = roots(num)
    poles = roots(den)

    teta_pd = 3*pi/2; % 180° of phase condition + 90° from the zero directly under the desired pole
    
    if ~ isempty(zeros)
        for ind = 1:length(zeros) % calculate the phase contribution of each Zero of the transfer function
            [~, zero_phase] = mag_phase(zpk([zeros(ind)],[],1), trgt_Pd, 'rad');
            fprintf("\n\ncontribuição de frase zero %f : %f", zeros(ind), (zero_phase*180)/pi)
            teta_pd = teta_pd + zero_phase;
        end    
    end

    if ~ isempty(poles)
        for ind = 1:length(poles) % calculate the phase contribution of each Pole of the transfer function
            [~, pole_phase] = mag_phase(zpk([],[poles(ind)],1), trgt_Pd, 'rad');
            fprintf("\n\ncontribuição de frase polo %f : %f", poles(ind), (pole_phase*180)/pi)
            teta_pd = teta_pd + pole_phase;
        end
    end

    fprintf("\n\nAngulo polo controlador: %f", (teta_pd*180)/pi)
    fprintf("\n\nAngulo polo controlador: %f", teta_pd)
    % knowing the angle contribution of the controller Pole it is calculated
    % its position on real axis
    cont_pole = Re + ( Img/tan(teta_pd) )
    fprintf("\n\nPosição polo controlador: %f", cont_pole)

    % knowing the position of both the Pero and Pole from the controller,
    % the gain is calculated with the magnitude condition
    % |kc*C(S)*G(S)| = 1
    %PZ_C = (s + cont_zero) / (s + cont_pole);
    PZ_Cont = zpk([-cont_zero], [-cont_pole], 1);
    INV = (PZ_Cont^(-1)) * (sys^(-1));
    [cont_gain,~] = mag_phase(INV, trgt_Pd)

    cont_pole = -cont_pole; cont_zero = -cont_zero;
    cont_tf = cont_gain * PZ_Cont
end