%IFAM ECAT51 - MODELAGEM DE SISTEMAS DINÂMICOS
%Alunos: Gabriel Almeida Santos de Oliveira - 2021000042;
%        Paulo Victor Vasconcelos Marajo - 2020008402
%Atividade prática Sistema Fluidos - Tanques de Estocagem - ABR 2023. 

t = 1:size(out.H1);

plot(t,out.H1, t,out.H2, t,out.H3);
legend("H1");
xlabel("t (s)");
ylabel("H (m)");
title("Graph h(t)/q(t)");

legend("H1", "H2", "H3");




