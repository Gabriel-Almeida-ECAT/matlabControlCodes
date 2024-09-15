clc; clear all;

S = tf('s');
Gma = zpk((1.59) / ((S + 2)*(S + 0.0625)) )

tsd = 19;
Mp = 0.2;

zeta = sqrt( (log(Mp)^2) / (pi^2 + log(Mp)^2))
wn = 4 / (zeta*tsd)

%Ts = 2*pi/(wn*30) %0.4536
% resultou em polo bem alto (>0.97)
Ts = tsd/25

Gma_z = c2d(Gma, Ts, 'matched')

%% Controlador
z = tf('z', Ts)
Kc = 1.7433;
%Kc = 2.1;
z1 = 0.75; z2 = 0.75;
%z1 = 0.6521; z2 = 0.4896;
C_z = Kc*((z - z1)*(z - z2))/(z*(z-1))


%% Resposta do sistema da referência
GC_mf_z_ref = feedback(Gma_z*C_z, 1)

%% Resposta do sistema ao disturbio
G_mf_z_dist = (0.23051*z*(z+1)*(z-1)) / (z*(z-1)*(z-0.2187)*(z-0.9536) + Kc*0.23051*(z-z1)*(z-z1)*(z+1));

%% Diagrama de polos e zeros e Reposta ao degrau
figure(1)
subplot(2,2,1)
pzmap(GC_mf_z_ref)
title('GCmf z ref')

subplot(2,2,2)
pzmap(G_mf_z_dist)
title('GCmf z dist')

subplot(2,2,3)
step(GC_mf_z_ref, feedback(Gma_z,1))
legend('FTMF_CONT', 'FTMF')
title('Gmf z ref C1')
grid on; box on;

subplot(2,2,4)
step(G_mf_z_dist, feedback(Gma_z,1))
legend('FTMF_CONT', 'FTMF')
title('Gmf z dist C1')
grid on; box on;


