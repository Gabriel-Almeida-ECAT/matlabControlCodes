clear all;
clc;

% num = [2];
% den =conv([0.5 -1],[0.1 1]);
% TF = tf(num,den) 
% nyquist(TF)

% Estabilidade de Nyquist: Exemplo 1
% % numerador da planta
% num=40;
% 
% % denominador da planta
% den=poly([2 -10]);
% 
% % funcao de transferencia da planta
% sys=tf(num,den);
% 
% %diagrama polar 
% nyquist(sys)
% set(gca, 'Fontsize',18)
% axis('equal')
% hold on
% 
% %diagrama polares para outros valores de ganho
% num=20;
% sys1=tf(num,den);
% nyquist(sys1)
% num=10;
% sys2=tf(num,den);
% nyquist(sys2)
% hold off


% Estabilidade de Nyquist: Exemplo 2
num=1;

den=[1 2 1 0];

sys=tf(num,den)

nyquist(sys)
set(gca, 'Fontsize',18)
axis('equal')
hold on

num=5;
sys1=tf(num,den);
nyquist(sys1)
num=10;
sys2=tf(num,den);
nyquist(sys2)
hold off