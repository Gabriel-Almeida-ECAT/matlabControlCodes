clc; clear all;

%% FT Planta
s=tf('s');
Gma = (0.95*13.4) / ((0.5*s + 1)*(16*s + 1))

poles = roots(Gma.denominator{1})

step_result = stepinfo(Gma); 
tsd = step_result.SettlingTime/3
% pela resposta ao step é observado que a FTMA 
%tem um tempo de assentamento
% de aproximadamente 61s.

%% Calculando Ts
Ts = tsd/25


%% discretização com casamento de polos e zeros:
Gma_z = zpk(c2d(Gma, Ts, 'matched'))
% step(Gma_z, Gma)


%% verificação polos discretos
disp('# FTMA_z Poles: ')
polos = pole(Gma_z)


%% Cálculo dos polos dominantes desejados
Pds = [-0.2 -0.2];
Pdz1 = exp(Ts*Pds(1))
Pdz2 = exp(Ts*Pds(2))


%% Calculo controlador
z = tf('z', Ts);
[faster_pole, ind] = max(polos)
pole2cancel = faster_pole;
%pole2cancel = 0.1859;
C_z = (z - pole2cancel) / (z - 1);
%rlocus(Gma_z*C_z)

%Kc = 0.208;
Kc = 0.4;
C_z = zpk(Kc*C_z)

%% Calculado a FTMF resultante
GC_z = minreal(Gma_z*C_z);
GC_mf_z = feedback(GC_z, 1)
G_mf_z = feedback(Gma_z, 1);
step(GC_mf_z, G_mf_z)
legend("FTMF_CTRL", "FTMF")
controled_step_result = stepinfo(GC_mf_z)
controled_step_result.SettlingTime
