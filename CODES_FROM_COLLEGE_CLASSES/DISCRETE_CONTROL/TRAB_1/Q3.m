clc;
clear all;

Ts = 0.008;

% Controlador continuo
C_S = zpk([-0.5], [-5], 8)

% controlador discreto Euler pra trás calculado manualmente
CD_ET = tf([(8 + 4*Ts) -8], [(1 + 5*Ts) -1], Ts)
% controlador discreto Euler pra frente calculado manualmente
CD_EF = tf([8 (4*Ts - 8)], [1 (5*Ts - 1)], Ts)

% controlador bilinear discreto matlab
CD_c2d_bilinear = c2d(C_S, Ts, 'tustin') 
% controlador segurador de ordem zero discreto matlab
CD_c2d_zoh = c2d(C_S, Ts, 'zoh') 
% controlador mapeamento polos zeros discreto matlab
CD_c2d_mappz = c2d(C_S, Ts, 'matched') 

%step(C_S, CD_EF, CD_ET, CD_c2d_bilinear, CD_c2d_zoh, CD_c2d_mappz);
bode(C_S, CD_EF, CD_ET, CD_c2d_bilinear, CD_c2d_zoh, CD_c2d_mappz);
legend('Original', 'Controlador Euler p/ frente', 'Controlador Euler  p/ tras', 'Controlador Bilinear', 'Controlador ZOH', 'Controlador pzmap')
