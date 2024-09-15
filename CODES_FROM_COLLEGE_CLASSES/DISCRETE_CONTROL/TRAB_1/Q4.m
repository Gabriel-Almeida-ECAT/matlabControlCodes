clc;
clear all;

C_S = tf([4], [1 1.2 4])
step(C_S);
hold on;    

disp('Função transferência discreta para f = 1');
CD_c2d_mappz = c2d(C_S, 1, 'matched') 
step(CD_c2d_mappz);

%f = [10 100 1*10^3 100*10^3 10*10^6]; %meu pc sofre tadinho
f = [10 100 1*10^3];
for ind = f
    Ts = 1/ind;
    fprintf('\n\nFunção transferência discreta para f = %d', ind);
    CD_c2d_mappz = c2d(C_S, Ts, 'matched')
    step(CD_c2d_mappz);
end

legend('continuous', 'f = 1', 'f = 10', 'f = 100', 'f = 1 KHz', 'f = 100 KHz', 'f = 10 MHz')