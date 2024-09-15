close all;
clc; clear all;

% para fazer com que o sistema siga referência é preciso
% acrescentar um integrador ao mesmo

%% Leutura do sistema e discretização

A = [0 1;...
     1000 0];

B = [0;...
     20];

C = [1 0];

D = [];

SS2 = ss(A, B, C, D)

Ts = 0.01
SS2_z = c2d(SS2, Ts,'zoh')

G = SS2_z.A;
H = SS2_z.B;
C = SS2_z.C;

%% Sistema aumentado (acrescentado integrador)
n = size(A,2); % ordem do modelo
m = size(B,2); % numero de entradas
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
disp('Ordem do modelo')
disp(n_aug)


%% verificacao controlabilidade
Co = ctrb(G_aug,H_aug);

if rank(Co) == n_aug
    disp('Matriz de Cont. tem posto completo')
    disp('O par é controlavel.')
else
    disp('Nao controlavel')
end


%% calculo dos polos desejados

tsd = 0.25*0.95;
Mp = 0.2*0.95;
% 0.95 para dar uma margem de erro

zeta = sqrt( (log(Mp)^2) / (pi^2 + log(Mp)^2))
wn = 4 / (zeta*tsd)

Pd  = roots([1 2*zeta*wn wn^2]);
Pd_z  = exp(Pd*Ts);
Pd_z(end+1) = 0.7


%% Calculo ganho do integrador
[K,precision] = place(G_aug,H_aug,Pd_z);

disp('Ganho K')
disp(K)

% Checar resposta
disp('Polos de malha fechada')
disp(eig(G_aug-H_aug*K))

Ki = K(end);
K = K(1:end-1);


