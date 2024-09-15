%% PI control para PH

%% Condicoes Iniciais

close all;
clear; clc;
y0 = 10.3;
u0 = 1;
q0 = 8;

%% **** Parametros de controle (PID Discreto) ****
Ts = 0.1;

%% *****   initialization *****  

nIter = 400;        % Numero de iteracoes

r_k = 10 % referencia
y_k = y0; % Saida inicial
u_k = u0;
q_k = q0; % disturbio inicial

e_k = r_k - y_k;

prev_u_k = u_k;       % referencia com atraso de -1
prev_e_k = 0;         % erro atrasado em -1

tspan = [0 Ts]; % Step time da planta


for sim_k = 1:nIter

  [t,y] = ode45(@(t,y) ControlePH(t,y,u_k,q_k),tspan,y_k);
   y_k = y(end);
        
  % **** Save Measurements ****
  %valores armazenados
   meas.y(:,sim_k) = y_k;
   meas.q(:,sim_k) = q_k;
   meas.u(:,sim_k) = u_k;
  
   
    %  --------- PID --------- 
    %obtido pela anti transoformada z do controlador via lei do atraso
   u_k = prev_u_k + 0.85*prev_e_k - e_k;
    
   prev_e_k = e_k;
   e_k = r_k - y_k;
   prev_u_k = u_k;

   %  --------- Fim PID --------- 
   
    
    
% %  --------- Mudancas ---------

    if sim_k == 100
        u_k = 1.3;
    end

    if sim_k == 300
        q_k = 6;
    end

end

meas.t = [0:Ts:(nIter-1)*Ts];


%%
figure(1)
subplot(2,1,1);
plot(meas.t,meas.y,'b','Linewidth',1.2)
title('Saida e Setpoints')

%%
subplot(2,1,2);
plot(meas.t/3600,meas.u(1,:)','c','Linewidth',1.2)
title('Ação de controle')


