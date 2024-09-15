% Atividade Modelagem e Simulação de Sistemas Dinâmicos
% Sistemas de Segunda Ordem
% Aluno: Gabriel Almeida Santos de Oliveira

clear;
clc; 

num = [1 2 6 20];
den = {[1 2 17]; [1 4 21 34]; [1 8 29 102]; [1 22 57 340]};
for ind=1:4
    Y = tf(num(ind),den{ind});
    step(Y)
    hold on;
end
grid on;
hold off;






% Y3 = tf(num, den);
% raizes_dominantes = roots(den);
% step(Y3);
% hold on;
% 
% raizes_dominantes(2:3);
% den2 = poly(raizes_dominantes(2:3));
% Y2 = tf(5, den2);
% step(Y2);
% hold off;



% for ind=1:9
%     list_zeta = [0.1 0.2 0.4 0.7071 1 1.2 1.4 2 5];
%     den = [1 2*list_zeta(ind) 1];
%     Y = tf(num, den);
%     impulse(Y);
%     hold on;
% end

% hold off;

