clc;
clear all;

i = sqrt(-1);
G = zpk([-2], [i -i], 1)

P = 24.9801;
I = 72.3989;
D = 0.084492;

% P = 12;
% I = 0.49;
% D = 0.122;
S = tf('s');
GC = P*(1 + (1/I*S) + D*S);

FTMF = feedback(G, 1)
FTMF_C = feedback(G*GC, 1);

%resposta ao degrau
% step(FTMF);
% hold on;
% step(FTMF_C);
% legend('Sistema não compensado', 'Sistema compensado');
% hold off;

%resposta a rampa
t = 0:0.1:50;
S = tf('s');
g1 = step(FTMF/S, t);
g2 = step(FTMF_C/S, t);
plot(t,g1,'.',t,g2,'--');