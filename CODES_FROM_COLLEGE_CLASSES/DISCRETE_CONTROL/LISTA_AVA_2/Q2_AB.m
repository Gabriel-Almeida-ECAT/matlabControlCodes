clc; clear all;

S = tf('s');
Gma = zpk((1.59) / ((S + 2)*(S + 0.0625)) )

tsd = 19;
Mp = 0.2;

zeta = sqrt( (log(Mp)^2) / (pi^2 + log(Mp)^2))
wn = 4 / (zeta*tsd)

%Ts = 2*pi/(wn*30) %0.4536
% resultou em polo bem alto (>0.97)
Ts = tsd/25 %0.76

Gma_z = c2d(Gma, Ts, 'matched')


%% Calculo dos polos desejados
j = sqrt(-1);
real_pd = wn*zeta;
cmpl_pd = j*wn*sqrt(1-zeta^2);

Pd1 = real_pd + cmpl_pd
Pd2 = real_pd -1*cmpl_pd 

Pdz1 = exp(Ts*(-real_pd + cmpl_pd))
Pdz2 = exp(Ts*(-real_pd - cmpl_pd))

Z = tf('z', Ts);
model_controler = 1 / ( (S + Pd1)*(S + Pd2) );
model_controler_z = 1 / ( (Z - Pdz1)*(Z - Pdz2) );

stepinfo(model_controler)
stepinfo(model_controler_z)

% step(model_controler_z)
% hold on
% step(model_controler)
% hold off

%% Cálculo contribuições de fase

teta_pd = -pi; %-180° da condição de fase

% é dada a entrada manual nos zeros do sistema G*C
zeros = [-1];
cont_zeros = [];
if ~ isempty(zeros)
    for ind = 1:length(zeros)
        zero_phase= phase(zpk([zeros(ind)],[],1), Pdz1, 'rad');
        cont_zeros = [cont_zeros, rad2deg(zero_phase)];
        teta_pd = teta_pd - zero_phase;
    end
end

% é dada a entrada manual nos polos do sistema G*C
poles = [0.2187 0.9536 0 1]; % Ts = 0.76
cont_polos = [];
if ~ isempty(poles)
    for ind = 1:length(poles)
        pole_phase = phase(zpk([],[poles(ind)],1), Pdz1, 'rad');
        cont_polos = [cont_polos, rad2deg(pole_phase)];
        teta_pd = teta_pd - pole_phase; 
    end
end

%% Dividindo igualmente a contribuição de fase de ambos os zeros do controlador:
% teta_pd = teta_pd/2;
% z1 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd))
% z2 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd));

%% Dividindo assimétricamente contribuição de fase:
%perc = 0.9; % 0.8024 ; -0.70 => ts = 28.2 | Mp = 46.3
%perc = 0.8; % 0.7569 ; 0.1436 => ts = 17.4 | Mp = 40.9
%perc = 0.7; % 0.7081 ; 0.3459 => ts = 16.7 | Mp = 37.2
%perc = 0.6; % 0.6521 ; 0.4896 => ts = 16.7 | Mp = 34.4
%perc = 0.5; % 0.5831 ; 0.5831 => ts = 16.7 | Mp = 33.5 % o mesmo que igualar os zeros
% abaixo de 0.5 irá repetir os casos anteriores
% perc = 0.4;
%z1 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd*perc))
%z2 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd*(1-perc)))

%% Cálcuclo condição de ganho
z1 = 0.75; z2 = 0.75;
C_z = ((Z - z1)*(Z - z2))/(Z*(Z-1))
INV = C_z^(-1) * Gma_z^(-1);
Kc = norm(evalfr(INV,Pdz1))
C_z = zpk(Kc*C_z)


%% Verificação desempenho do controlador
GC_z = zpk(C_z*Gma_z)
GC_mf_z = feedback(GC_z, 1)
G_mf_z = feedback(Gma_z, 1);

%figure(1)
%subplot(1,2,1)
%rlocus(GC_z)

%subplot(1,2,2)
step(GC_mf_z, G_mf_z)
legend("FTMF_CTRL", "FTMF")

si_GC_mf_z = stepinfo(GC_mf_z)


%% Teste resposta com filtro de referência
%pzmap(GC_mf_z)
%pos_pf1 = 0.652; %zero dominante da MF
    % ts = 19s | Mp = 23.26
pos_pf1 = 0.7; 
    % ts = 19s | Mp = 19.5
z = tf('z', Ts);
F_z = (1 - pos_pf1)/(z - pos_pf1)

f_GC_mf_z = F_z*GC_mf_z;
step(GC_mf_z, G_mf_z, f_GC_mf_z);
legend("FTMF_CTRL", "FTMF", "FILT_FTMF_CONT")

si_f_GC_mf_z = stepinfo(f_GC_mf_z)


%% Função para calculo da contribuição de fase 
function phase = phase(sys,x,units)
    if nargin < 3 || isempty(units)
        units = 'deg';
    end
    
    phase = atan2d(imag(evalfr(sys,x)),real(evalfr(sys,x)));
    
    if strcmpi(units,'rad')
        phase = phase*(pi/180);
    end
end