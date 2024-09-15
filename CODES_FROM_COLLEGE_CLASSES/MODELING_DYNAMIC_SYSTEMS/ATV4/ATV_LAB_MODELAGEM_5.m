%IFAM ECAT51 - MODELAGEM DE SISTEMAS DINÂMICOS
%Alunos: Gabriel Almeida Santos de Oliveira - 2021000042;
%        Paulo Victor Vasconcelos Marajo - 2020008402
%Atividade prática Sistema Fluidos - Tanques de Estocagem - ABR 2023. 

% A = 10;
% Cv = 4.8628*exp(-4);
% g = 9.8;
% rho = 1000;

t = 1:size(H);

figure('Name','Graph tank 1','NumberTitle','off');
hh=plot(t,H);
hold on;
legend("H1");
xx=xlabel("Tempo t (s)");
yy=ylabel("Nível H (m)");
% set(xx,"FontName","New Baskerville BT","FontSize",10);
% set(yy,"FontName","New Baskerville BT","FontSize",10);
%set(gca, "FontName","New Baskerville BT","FontSize",10,"LineWidth",1.5);
eval(["print -dpng fig_H1;"]);

%figure('Name','Graph tank 2','NumberTitle','off');
hh1=plot(t,H1);
legend("H2");
hold off;
% set(xx,"FontName","New Baskerville BT","FontSize",10);
% set(yy,"FontName","New Baskerville BT","FontSize",10);
%set(gca, "FontName","New Baskerville BT","FontSize",10,"LineWidth",1.5);



