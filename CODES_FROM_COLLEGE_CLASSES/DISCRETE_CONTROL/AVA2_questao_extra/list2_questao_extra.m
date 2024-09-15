clc; clear all;

S = tf('s');
G1 = 0.5 / (1 + 0.5*S);
G2 = 4 / (1 + 0.1*S);
Gma = zpk( G1*G2 )

tsd = 0.2 * 0.9; % considerar 90% para dar uma margem de erro
Mp = 0.05 * 0.9; % considerar 90% para dar uma margem de erro

zeta = sqrt( (log(Mp)^2) / (pi^2 + log(Mp)^2))
wn = 4 / (zeta*tsd)

% resultou em polo bem alto (>0.97)
Ts = tsd/25 %

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

model_controler = stepinfo(model_controler)
model_controler_z = stepinfo(model_controler_z)

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


%% Rlocus - verificação posicionamento polos/zeros:
% perc = 0.5;
% z1 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd*perc))
% z2 = real(Pdz1) - (imag(Pdz1)/tan(teta_pd*(1-perc)))

%0.93 não deu certo, resp ao dist ficou horrivel
pos = 0.9; z1 = pos; z2 = pos; %em 0.9 fico bom, explicar o pq
C_z = ((Z - z1)*(Z - z2))/(Z*(Z-1))

rlocus(Gma_z*C_z)


%% Cálcuclo condição de ganho
INV = C_z^(-1) * Gma_z^(-1);
Kc = norm(evalfr(INV,Pdz1))
C_z = zpk(Kc*C_z)


%% Verificação desempenho do controlador
GC_z = zpk(C_z*Gma_z)
GC_mf_z = feedback(GC_z, 1)
G_mf_z = feedback(Gma_z, 1);

%step(GC_mf_z, G_mf_z)
legend("FTMF_CTRL", "FTMF")

si_GC_mf_z = stepinfo(GC_mf_z)


%% Teste resposta com filtro de referência
%pzmap(GC_mf_z)
pos_pf1 = 0.905;
z = tf('z', Ts);
F_z = (1 - pos_pf1)/(z - pos_pf1)

f_GC_mf_z = F_z*GC_mf_z;
resp_f_GC_mf_z = stepinfo(f_GC_mf_z)


%% verificação resposta ao disturbio

G1_z = c2d(G1, Ts, 'matched')
G2_z = c2d(G2, Ts, 'matched')

Gmf_z_dist = minreal(1*G1_z / (1 + C_z*G1_z*G2_z))

%pzmap(Gmf_z_dist);
grid on;
resp_dist = stepinfo(Gmf_z_dist)


%% Plotagem
figure(1)

subplot(2,1,1)
step(GC_mf_z, G_mf_z, f_GC_mf_z);
grid on; box on;
legend("FTMF_CTRL", "FTMF", "FILT_FTMF_CONT")
title('Y - Ref')

subplot(2,1,2)
for ind = 0:5
    %step_config = RespConfig('Amplitude',2^ind); %não existe na minha versão
    step_config = stepDataOptions('StepAmplitude',2^ind);
    step(Gmf_z_dist, step_config);
    hold on;
    grid on; box on;
    title('Y- Dist')
end
 hold off;

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