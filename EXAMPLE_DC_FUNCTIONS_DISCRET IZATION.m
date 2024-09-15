clc; clear all;

Ts = 0.24;

% FT continua
G_S = tf([1], [1 0 0])
% Controlador continuo
C_S = zpk([-0.5], [-5], 8)

% GS discreto matlab
G_c2d = c2d(G_S, Ts, 'tustin')

CD_c2d_bilinear = c2d(C_S, Ts, 'tustin') % controlador bilinear discreto matlab
CD_c2d_zoh = c2d(C_S, Ts, 'zoh') % controlador segurador de ordem zero discreto matlab
CD_c2d_mappz = c2d(C_S, Ts, 'matched') % controlador mapeamento polos zeros discreto matlab

% GS discreto calculado manualmente
G_Z = tf([Ts^2 2*Ts^2 Ts^2], [4 -8 4], Ts)
% controlador discreto calculado manualmente
C_Z_B = tf([(16 + 4*Ts) (4*Ts - 16)], [(2 + 5*Ts) (5*Ts - 2)], Ts)

%  equações de malha fechada
FTMF = feedback(G_S*C_S, 1);
FTMF_Z = feedback(G_Z*C_Z_B, 1);
FTMF_c2d_B = feedback(G_c2d*CD_c2d_bilinear, 1);
FTMF_c2d_Z = feedback(G_c2d*CD_c2d_zoh, 1);
FTMF_c2d_M = feedback(G_c2d*CD_c2d_mappz, 1);

step(FTMF, FTMF_c2d_B, '-.', FTMF_c2d_Z, '--', FTMF_c2d_M, '--', FTMF_Z);
legend('Original','Controlador Bilinear', 'Controlador ZOH', 'Controlador pzmap', 'Controlador calculado manualmente')
