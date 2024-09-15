clc;
clear all;

s = tf('s'); j = sqrt(-1);

% planta original
FTMA = 1 / (s^2 + s)

%especificações de desempenho desejadas:
trgt_err_pos = 0.1;
trgt_Mp = 0.38;
trgt_ts = 7;

% Calculo de zeta [Mp = exp(-zeta*pi / sqtr(1-zeta^2)  )]
zeta = sqrt( log(trgt_Mp)^2 / (log(trgt_Mp)^2 + pi^2)) * 1.10 % aumentar em 10% para dar uma margem de erro

%calculando wn [ts = 4 / zeta*wn] p/ 2%
wn = 4 / (trgt_ts*zeta);

%polo dominante desejado:
Re = zeta*wn;
Img = wn*sqrt(1-zeta^2);

trgt_Pd = -1*(Re) + j*(Img) %para os calculos se utiliza apenas a parte real dos polos conjugados

% se ecolhe a posição do zero diretamente abaixo do polo desejado para
% simplificação dos calculos
z_c = Re;

% se calcula a posição do polo pela condição de fase
[num, den] = tfdata(FTMA, 'v');
zeros = roots(num);
poles = roots(den);

teta_pd = 3*pi/2; % 180 da cond. de fase + 90 do zero diretamente abaixo do polo desejado

if ~ isempty(zeros)
    for ind = 1:length(zeros) % calcular a contribuição de fase de cada zero
        if abs(zeros(ind)) > Re
            auxiliar_teta = atan( Img / ( Re - abs(zeros(ind)) ) );
        else
            auxiliar_teta = pi - atan( Img / ( Re - abs(zeros(ind)) ) );
        end
        teta_pd = teta_pd + auxiliar_teta;
    end    
end

if ~ isempty(poles)
    for ind = 1:length(poles) % calcular a contribuição de fase de cada polo
        if abs(poles(ind)) > Re
            auxiliar_teta = atan( Img / ( Re - abs(poles(ind)) ) );
        else
            auxiliar_teta = pi - atan( Img / ( Re - abs(poles(ind)) ) );
        end
        teta_pd = teta_pd - auxiliar_teta;
    end
end

%sabendo o angulo do polo desejado se calcula sua posição no eixo real
p_c = Re + Img/tan(teta_pd);

%tendo a posição do polo e do zero do controlador se calcula agora o ganho pela condição de modulo
CONT = (s + z_c) / (s + p_c);
INV = CONT^(-1) * FTMA^(-1);
[mag,phase] = mag_phase(INV, trgt_Pd)

% C(S) = Kc * (S + Zc) / (S + Pc)
CONT = mag * CONT

% FTs de malha fechada da planta original e com o controlador
FTMF = feedback(FTMA, 1)
FTMF_C = feedback(FTMA*CONT, 1)

step(FTMF,  FTMF_C);
legend('Planta original','Planta Controlada');


