close all;
clc; clear all;

%% declaração matrizes discretas 

G = [0.6 0;...
        0 0.4];
H = [1;...
        5];
C = [1 3];
D = [];

%put Ts=-1 with sample time is indetermined
SS = ss(G,H,C, D,-1)

%% estabilidade
auto_val = eig(G)

%% FT
Gma = tf(SS)

%% Ganho
[num, den] = tfdata(Gma, 'v');
syms z;
sys_syms = poly2sym(num, z)/poly2sym(den, z)
gain = limit((1-z^-1)*sys_syms*(z/(1-z^-1)), z, 1)