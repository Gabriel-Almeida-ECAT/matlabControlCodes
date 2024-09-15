clc; clear all;

%% FT Planta
s=tf('s');
Gma = (0.95*13.4) / ((0.5*s + 1)*(16*s + 1))

step_result = stepinfo(Gma); 
tsd = step_result.SettlingTime/3


%% Calculando Ts
Ts = tsd/25


%% discretização com casamento de polos e zeros:
Gma_z = zpk(c2d(Gma, Ts, 'matched'))


%% Cálculo do wn
zeta = 1; % nenhum sobressinal
% visto que se deseja 1/3 do tempo de assentamento de MA (~61s),
% se arredonda o ts desejada pra 20 para evitar parte complexa no
% polo desejado
wn = 4 / (20*zeta);


%% calculo da equação característica continua desejada
EC_d = s^2 + 2*wn*zeta*s + wn^2


%% Cálculo dos polos dominantes discretos desejados na MF
Pds = pole(1/EC_d)
Pdz1 = exp(Ts*Pds(1))
Pdz2 = exp(Ts*Pds(2))
z = tf('z', Ts);
EC_dz = (z - Pdz1) * (z - Pdz2)

EC_dz2 = z*(z - Pdz1) * (z - Pdz2)
step(1/EC_dz, 1/EC_dz2)
legend("ECd", "ECd + z")


%% calculo constantes do controlador
% A = 0.9488; B = 0.2654;
% syms Kc z1 z2;
% eq4 = B*Kc == 1;
% eq3 = 1 - B*Kc*z2 - B*Kc*z1 + B*Kc == -0.8451;
% eq2 = -1 - A - B*Kc*z1*z2 - B*Kc*z2 - B*Kc*z1 == -0.8451 + 0.7142;
% eq1 = A + B*Kc*z1*z2 == 0;
% sol = (vpasolve([eq1;eq2;eq3;eq4]));
% Kc = double(sol.Kc)
% zc_1 = double(sol.z1)
% zc_2 = double(sol.z2)

    
%% Teste Controladores

%z1 = 0.28 | z2 = 0.9
% kc = 0.4 -> ts = 28.6s ; Ovsh = 9.4
% kc = 0.5 -> ts = 25.2s ; Ovsh = 9.1
% kc = 0.6 -> ts = 22.7s ; Ovsh = 8.7
% kc = 0.7 -> ts = 20.2s ; Ovsh = 8.5
% kc = 0.9 -> ts = 17.6s ; Ovsh = 8.1
% kc = 1 -> ts = 15.9s ; Ovsh = 8.2

%z1 = 0.1859 | z2 = 0.92
% Kc = 0.1 -> ts = 63.1 ; Ovsh = 4
% kc = 0.36 -> ts = 29.9s ; Ovsh = 5.9
% Kc = 0.8 -> ts = 15.9 ; Ovsh = 6.8
Kc = 0.8
C_z = zpk(Kc*( (z - 0.1859)*(z - 0.92) ) / ( z*(z - 1) ))

GC_z = Gma_z*C_z;
 %rlocus(GC_z)


%% Calculado a FTMF resultante
GC_mf_z = feedback(GC_z, 1)
G_mf_z = feedback(Gma_z, 1);

pos_filt = 0.87;
F_z = (1-pos_filt) / (z - pos_filt)
GCF_mf_z = F_z*feedback(GC_mf_z, 1)

step(GC_mf_z, G_mf_z, GCF_mf_z)
legend("FTMF_CTRL", "FTMF", "F_FTMF_CTRL")
controled_step_result = stepinfo(GC_mf_z)
filtered_controled_step_result = stepinfo(GCF_mf_z)

