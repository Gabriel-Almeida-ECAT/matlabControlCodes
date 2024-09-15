%IFAM ECAT51 - MODELAGEM DE SISTEMAS DINÂMICOS
%Alunos: Gabriel Almeida Santos de Oliveira - 2021000042; 
%Atividade prática Sistema Fluidos - Tanques de Estocagem - ABR 2023. 

% A = 10;
% Cv = 4.8628*exp(-4);
% g = 9.8;
% rho = 1000;

t = 1:size(out.H);

whos
hh=plot(t,out.H);
set(hh,"LineWidth",1.5);
xx=xlabel("Tempo t (s)");
yy=ylabel("Nível H (m)");
set(xx,"FontName","New Baskerville BT","FontSize",10);
set(yy,"FontName","New Baskerville BT","FontSize",10);
set(gca, "FontName","New Baskerville BT","FontSize",10,"LineWidth",1.5);
legend("Nível H1[m]","Nível H2[m]","2");
eval(["print -dpng fig_H1;"]);

