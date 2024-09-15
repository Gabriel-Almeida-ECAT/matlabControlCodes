clc; clear all;

s = tf('s'); j = sqrt(-1);
Ts = 0.2;

% planta original
delay_pade = -(s - (4/Ts))/(s + (4/Ts))  % exp(-S*t) ~ - ( s - 2*t ) / ( s + 2*t )
delay_filtro = (2*Ts) / (s + 2*Ts)
FTMA = 1 / (s^2 + s)
FTMA_delay = delay_pade * FTMA % acrescentar o delay (ou por 1 senão houver delay)

%especificações de desempenho desejadas:
trgt_Mp = 0.38; % Máximo Soberssinal
trgt_ts = 7; % Tempo de assentamento

[~,~,~,CONT] = simplified_rl_lead_controler(FTMA, trgt_Mp, trgt_ts)
[~,~,~,CONT_delay] = simplified_rl_lead_controler(FTMA_delay, trgt_Mp, trgt_ts)

%controlador discretizado
D_CONT = c2d(CONT, Ts, 'tustin')
D_CONT_delay = c2d(CONT_delay, Ts, 'tustin')
%plata discreta
FTMA_c2d = c2d(FTMA, Ts, 'tustin')

% FTs de malha fechada da planta original e da planta com o controlador
FTMF = feedback(FTMA, 1)
FTMF_C = feedback(FTMA*CONT, 1)
FTMF_c2d = feedback(FTMA_c2d*D_CONT,1)

%FTMF_delay = feedback(FTMA_delay, 1)
FTMF_C_delay = feedback(FTMA*CONT_delay, 1)
FTMF_c2d_delay = feedback(FTMA_c2d*D_CONT_delay,1)

% resposta
step(FTMF, FTMF_C, FTMF_c2d, FTMF_C_delay, FTMF_c2d_delay);
%step(FTMF, FTMF_C, FTMF_c2d);
legend('Original','Controlada', 'Controlada discretizada','Controlada [delay]', 'Controlada discretizada [delay]');