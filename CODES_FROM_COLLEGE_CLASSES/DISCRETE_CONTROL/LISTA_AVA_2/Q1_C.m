clc; clear all;

%% FT Planta
s=tf('s');
Gma = zpk((0.95*13.4) / ((0.5*s + 1)*(16*s + 1)))


%% Ts
step_result = stepinfo(Gma); 
tsd = step_result.SettlingTime/3
Ts = tsd/25


%% discretização com casamento de polos e zeros:
Gma_z = c2d(Gma, Ts, 'matched')


%% Controladores
z = tf('z', Ts);

% controlador 1 [PI]
C_z_1 = zpk(0.208*(z - 0.9488) / (z - 1))
%C_z_1 = zpk(0.4*(z - 0.9488) / (z - 1))

% controlador 2 [PID]
C_z_2 = zpk(0.8*( (z - 0.92)*(z - 0.1859) ) / ( z*(z - 1) ))


%% FTMFs / ref
Gmf_z_ref_C1 = feedback(minreal(Gma_z*C_z_1), 1);
Gmf_z_ref_C2 = feedback(minreal(Gma_z*C_z_2), 1);

%% FTMFs / Dist.
Gmf_z_dist_C1 = (0.26547*(z+1)*(z-1)) / ((z-1)*(z-0.9488)*(z-0.1859) + 0.05521*(z-0.9488)*(z+1)); 
zpk(Gmf_z_dist_C1)

Gmf_z_dist_C2 = (0.26547*z*(z+1)*(z-1)) / (z*(z-1)*(z-0.9488)*(z-0.1859) + 0.2123*(z-0.1859)*(z-0.92)*(z+1));
zpk(Gmf_z_dist_C2)

%% diagramas polos e zeros
% figure(1)
% subplot(2,2,1)
% pzmap(Gmf_z_ref_C1)
% title('Gmf z ref C1')
% subplot(2,2,2)
% pzmap(Gmf_z_ref_C2)
% title('Gmf z ref C2')
% subplot(2,2,3)
% pzmap(Gmf_z_dist_C1)
% title('Gmf z dist C1')
% subplot(2,2,4)
% pzmap(Gmf_z_dist_C2)
% title('Gmf z dist C2')
% 
% sgtitle('Diagrama Polos e Zeros')


%% Reposta ao degrau com filtro de referência
pos_pf2 = 0.87;
F_C2 = (1 - pos_pf2) / (z - pos_pf2)

f_Gmf_z_ref_C2 = F_C2*Gmf_z_ref_C2;

figure(1)
subplot(2,2,1)
step(Gmf_z_ref_C1, feedback(Gma_z,1))
legend('FTMF_CONT', 'FTMF')
title('Gmf z ref C1')
grid on; box on;
si_c1 = stepinfo(Gmf_z_ref_C1)

subplot(2,2,2)
step(Gmf_z_ref_C2, feedback(Gma_z,1), f_Gmf_z_ref_C2)
legend('FTMF_CONT', 'FTMF', 'FILT_FTMF_CONT')
title('Gmf z ref C2')
grid on; box on;
si_c2 = stepinfo(Gmf_z_ref_C2)
si_fc2 = stepinfo(f_Gmf_z_ref_C2)

subplot(2,2,3)
step(Gmf_z_dist_C1, feedback(Gma_z,1))
legend('FTMF_CONT', 'FTMF')
title('Gmf z dist C1')
grid on; box on;

subplot(2,2,4)
step(Gmf_z_dist_C2, feedback(Gma_z,1))
legend('FTMF_CONT', 'FTMF')
title('Gmf z dist C2')
grid on; box on;

sgtitle('Respostas ao degrau')
