clc; clear all;

s = tf('s'); j = sqrt(-1);
Ts = 0.2;

% original plant
delay_pade = -(s - (4/Ts))/(s + (4/Ts))  % exp(-S*t) ~ - ( s - 2*t ) / ( s + 2*t )
delay_filtro = (2*Ts) / (s + 2*Ts)
OLTF = 1 / (s^2 + s) % 'OLTF' stands for 'Open Loop Transfer Function'
OLTF_delay = delay_pade * OLTF % acrescentar o delay (ou por 1 senão houver delay)

% desired performance especifications:
trgt_Mp = 0.38; % Max Overshoot
trgt_ts = 7; % Settling Time

[~,~,~,CONT] = RL_LEAD_CONTROLER(OLTF, trgt_Mp, trgt_ts)
[~,~,~,CONT_delay] = RL_LEAD_CONTROLER(OLTF_delay, trgt_Mp, trgt_ts)

%controlador discretizado
D_CONT = c2d(CONT, Ts, 'tustin')
D_CONT_delay = c2d(CONT_delay, Ts, 'tustin')
%plata discreta
OLTF_c2d = c2d(OLTF, Ts, 'tustin')
OLTF_c2d_delay = c2d(OLTF_delay, Ts, 'tustin')

% FTs de malha fechada da planta original e da planta com o controlador
CLTF = feedback(OLTF, 1) % 'CLTF' stands for 'Closed Loop Transfer Function'
CLTF_C = feedback(OLTF*CONT, 1)
CLTF_c2d = feedback(OLTF_c2d*D_CONT,1)

CLTF_delay = feedback(OLTF_delay, 1)
CLTF_C_delay = feedback(OLTF_delay*CONT_delay, 1)
CLTF_c2d_delay = feedback(OLTF_c2d_delay*D_CONT_delay,1)

% resposta
step(CLTF, CLTF_C, CLTF_c2d, CLTF_delay, CLTF_C_delay, CLTF_c2d_delay);
%step(CLTF, CLTF_C, CLTF_c2d);
legend('Original','Controled', 'Controled Discretized','Original [delay]','Controled [delay]', 'Controled Discretized [delay]');