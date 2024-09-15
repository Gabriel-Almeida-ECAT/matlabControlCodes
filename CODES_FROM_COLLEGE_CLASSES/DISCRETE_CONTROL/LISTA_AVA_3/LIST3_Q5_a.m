close all;
clc; clear all;

%% modelagem sistema
% x'' = 1000x + 20u
% S²X(S) = 1000 X(S) + 20 U(S)
% X(S)[S² - 1000] / U(S) = 20
% X(S)/U(S) = 20 / (S² - 1000)

num = [20];
den = [1 0 -1000];
Gma = tf(num, den)

SS1 = ss(Gma)


%% montando as matrizes SS
% as variaveis de estado são X1 = x e X2 = x'
% derivando: X1' = x' e X2' = x''
% X1' = X2 ; X2' = 1000 X1 + 20 U

A = [0 1;...
     1000 0];

B = [0;...
     20];

C = [1 0];

D = [];

SS2 = ss(A, B, C, D)

%step(SS1, 'r*', SS2, 'b')
% ambos os resultados de espaço de estados são iguais


%% discretizacao das matrizes
Ts = 0.01
SS2_z = c2d(SS2, Ts,'zoh')

G = SS2_z.A
H = SS2_z.B
C = SS2_z.C


%% verificacao controlabilidade
n = size(G,2); % ordem do modelo
Co = ctrb(G,H);

if rank(Co) == n
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

Pd  = roots([1 2*zeta*wn wn^2])
Pd_z  = exp(Pd*Ts)


%% Alocacao dos polos
%polos discretos deesjados
[K,precision] = place(G,H,Pd_z);

disp('Ganho K')
disp(K)

% Checar resposta
disp('Polos de malha fechada')
disp(eig(G-H*K))


%% verificacao resposta
step(ss((G-H*K), H, C, D, Ts))
stepinfo(ss((G-H*K), H, C, D, Ts))
