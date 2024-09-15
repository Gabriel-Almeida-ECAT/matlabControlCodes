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

%% Sistema aumentado (acrescentado integrador)
n = size(G,2); % ordem do modelo
m = size(H,2); % numero de entradas
p = size(C,1); % numero de saidas

G
G_aug = [G    zeros(n,p);...
        -Ts*C eye(p,p)]
H
H_aug = [H;...
         zeros(p,m)]
C
ref_mat = [zeros(n,p); Ts*eye(p)]

% Nova ordem do modelo
n_aug = size(G_aug,2);


%% verificacao controlabilidade
Co = ctrb(G_aug,H_aug);

if rank(Co) == n_aug
disp('Controlavel') 
end


%% polos desejados
Pd_z  = [0.6 + i*0.3; 0.6 - i*0.3];
Pd_z(end+1) = 0.9


%% Cáluclo Ganhos
[K,precision] = place(G_aug,H_aug,Pd_z);
disp(eig(G_aug-H_aug*K))

Ki = K(end); % ganho integrador
K = K(1:end-1);





