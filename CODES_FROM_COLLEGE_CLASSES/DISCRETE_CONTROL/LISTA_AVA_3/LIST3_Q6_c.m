close all;
clc; clear all;

%% sistema
G = [0.8815 0.4562;...
     -0.4562 0.7903];
H = [0.1185;...
     0.4562];
C = [1 0];
D = [];
Ts = 1;

%% verificacao observabilidade
Co = obsv(G,C);

n = size(G,2);
if rank(Co) == n
    disp('Observavel') 
end

%% polos desejados
Pd_z  = [0.6 + i*0.3; 0.6 - i*0.3];

%% Cáluclo ganho observador
%polos discretos deesjados
[Lt,precision] = place(G',C',Pd_z);
L = Lt';

disp(eig(G-L*C)) % verificação polos obtidos



