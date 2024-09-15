clc;
clear all;

Ts = 0.24;
CC = zpk(-0.5, -5, 8) % TF continua

% Euler Backward
CD_EB = tf([8.96 -8], [2.2 -1], Ts);

% Euler Foward
CD_EF = tf([8 -0.88*8], [1 0.2], Ts);

% Bilinear
CD_B = tf([16.96 -15.04], [3.2 -0.8], Ts)

% mapeamento polo zero
CD_MAPPZ = tf([4.905 -0.886*4.905], [1 -0.301], Ts)

% ZOH
CD_ZOH = tf([8 -7.51], [1 -0.301], Ts)

CD_c2d_bilinear = c2d(CC, Ts, 'tustin')
CD_c2d_zoh = c2d(CC, Ts, 'zoh')
CD_c2d_mappz = c2d(CC, Ts, 'matched')

% step(CC, '-');
% hold on;
% step(CD_EB, 'o');
% step(CD_EF, '+');
% step(CD_B, '*');
% step(CD_MAPPZ, 'x');
% step(CD_ZOH, 'square');
% step(CD_c2d_bilinear, ':');
% step(CD_c2d_zoh, '--');
% step(CD_c2d_mappz, '-.');
% hold off;
% legend('CC','CD_EB', 'CD_EF', 'CD_B', 'CD_MAPPZ', 'CD_ZOH', 'CD_c2d_bilinear', 'CD_c2d_zoh', 'CD_c2d_mappz')

bode(CC, CD_EB, CD_EF, CD_B, CD_MAPPZ, CD_ZOH, CD_c2d_bilinear, CD_c2d_zoh, CD_c2d_mappz);
legend('CC','CD_EB', 'CD_EF', 'CD_B', 'CD_MAPPZ', 'CD_ZOH', 'CD_c2d_bilinear', 'CD_c2d_zoh', 'CD_c2d_mappz')