close all;
clc; clear all;

G = [1 1;...
     0 1];

H = [0.5; ...
     1];

%% letra a) controlabilidade do sistema

% ordem do modelo
n = size(G,2);
disp('Ordem do modelo')
disp(n)

mat_ctrlb = ctrb(G, H) %obtendo matriz de controlabilidade

if rank(mat_ctrlb) == n
    disp('Matriz de Obs. tem posto completo')
    disp('matriz é controlavel.')
else
    disp('Nao controlavel')
end

%% letra b) observabilidade

C1 = [0 1];
C2 = [1 0];

disp(' ')
mat_ob1 = obsv(G,C1);
if rank(mat_ob1) == n
    disp('Matriz de controlabilidade C1 tem posto completo')
    disp('Mat com C1 é observavel.')
else
    disp('Mat com C1 nao e observavel')
end

disp(' ')
mat_ob2 = obsv(G,C2);
if rank(mat_ob2) == n
    disp('Matriz de Obs. C2 tem posto completo')
    disp('Mat com C2 é observavel.')
else
    disp('Mat com C2 nao e observavel')
end

%% c) pq o posto da matriz de observabilidade não é igual a ordem da matriz

%% d) controle por realimentação de estados
syms k1 k2
eq1 = -2 + k2 + 0.5*k1 == -1.8;
eq2 = 1 - k2 + 0.5*k1 == 0.82;
solution = (vpasolve([eq1;eq2]));
k1 = double(solution.k1)
k2 = double(solution.k2)

K = [k1 k2];
% Checar resposta
disp('Polos de malha fechada')
disp(eig(G-H*K))


%% e) MF de estimação
syms L1 L2
eq1 = -2 + L1 == -1.2;
eq2 = 1 + L2 - L1 == 0.45;
solution = (vpasolve([eq1;eq2]));
L1 = double(solution.L1)
L2 = double(solution.L2)

L = [L1; L2];
disp('Polos de malha fechada da dinamica do erro de estimacao')
disp(eig(G-L*C2))









