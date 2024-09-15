close all;
clc; clear all;

%% sistema

G = [0.8815 0.4562;...
     -0.4562 0.7903]
H = [0.1185;...
     0.4562]
C = [1 0]
D = [];
Ts = 1


%% polos desejados
Pd_z  = [0.6 + i*0.3; 0.6 - i*0.3]


%% Cáluclo ganhos
[K,precision] = place(G,H,Pd_z); %calculo do ganho que leva ao polo desejado
disp(eig(G-H*K)) %mostrar os polos  obtidos com o ganho calculado


%% verificacao resposta
step(ss((G-H*K), H, C, D, Ts))

