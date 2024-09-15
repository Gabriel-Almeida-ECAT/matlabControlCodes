clc;
clear all;

% 1.a)
num1 = 2;
den1 = [1 0 4]; 
G = tf(num1, den1);

step(G);

% 1.b)
[num,den] = pade(1, 2)
e = tf(num, den);

step(e);


% 1.c)
Gp = G*e


% 1.d)
step(Gp);


% 1.e)
% O sistema é instavel. 


% 1.f) Sim, era esperado pois ao se resolver  a equação polinomial do
% denominador se obtem dois polos no eixo complexo (parte real nula).
% O que caracteriza sistema oscilatório;



% 1.g,h,i,j)
T = 1.2;
L = 1.07;

%PI
Kp = 0.9*(T/L);
Ti = L/0.3;

S = tf('s');
Gc = Kp*(1 + 1/(Ti*S));
Gg = Gc*Gp;


%PID
Kp = 1.2*(T/L);
Ti = 2*L;
Td = L/2;

Gc = Kp*(1 + 1/(Ti*S) + Td*S/(0.1*S + 1));
Gg = Gc*Gp;


% 1.L,m,n,o,p) Não tem como aplicar o segundo método de ZN pois depende do ganho
% crítico, porém o mesmo para este sistema é zero.

% 1.q)


CteT = 1.9;
Theta = L;




