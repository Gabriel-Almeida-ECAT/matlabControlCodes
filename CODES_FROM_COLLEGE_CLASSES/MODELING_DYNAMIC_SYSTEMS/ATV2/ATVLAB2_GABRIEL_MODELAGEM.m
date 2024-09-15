%IFAM ECAT51 - MODELAGEM E SIMULA��O DE SISTEMAS DIN�MICOS
%Aluno: Gabriel Almeida Santos de Oliveira - 2021000042
%C�digo de simula��o do modelo de um sistema massa mola sob a influencia 
%de um atrito agindo como um amortecedor a partir de condi��es iniciais.
%para que os resultados obtidos n�o sejam iguais aos dos colegas de classe
%utilizarei valores diferentes para o coeficiente de amortecimento b.

clear all;
clc;

m = 1; %kg
Fi = 50; %N
b = [24 4 1 0.4 0]; %Ns/m
k = 10; %N/m
x0 = 0.05; %m
v0 = -0.5; %m/s

%Gr�ficos das fun��es transfer�ncia
for i=1:5
    %Em fun��o da posi��o
    num_func_x = [0.05 (0.05*b(i)+49.5)];   %0.05*S + b + 49.5
    den_func_x = [50 (50*b(i)) 500];        %50*S^2 + (50*b)*S + 500

    transFunc_x = tf(num_func_x, den_func_x);
    ampl_func_x = stepDataOptions("StepAmplitude", 50);
    [transFunc_x, t] = step(transFunc_x, ampl_func_x);
    str_graph_x = strcat("Graph of X(S)/F(S) for b = ",string(b(i)));   
    figure('Name',str_graph_x,'NumberTitle','off');
    plot(t, transFunc_x);
    legend('X(S)');
    xlabel('t');
    title(str_graph_x);
    ylabel('x(t)');
    
      
    %Em fun��o da velocidade   
    num_func_v = [49.5];                %49.5*S
    den_func_v = [50 (50*b(i)) 500];    %50*S^2 + (50*b)*S + 500
    
    transFunc_v = tf(num_func_v, den_func_v);
    ampl_func_v = stepDataOptions("StepAmplitude", 50);
    [transFunc_v, t] = step(transFunc_v, ampl_func_v);
    str_graph_v = strcat("Graph of V(S)/F(S) for b = ",string(b(i)));
    figure('Name',str_graph_v,'NumberTitle','off');
    plot(t, transFunc_v);
    legend('V(S)');
    xlabel('t');
    title(str_graph_v);
    ylabel('v(t)');
end