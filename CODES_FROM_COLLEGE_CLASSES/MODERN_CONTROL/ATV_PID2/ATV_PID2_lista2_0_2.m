clear all; %deletar todas as variaveis e seus valores previamente existentes.
clc; % apagar o texto atual da janela de comando.

% 2 <= Kc <= 50
min_search_kc = 2; % valor minimo de teste de kc
max_search_kc = 50; % valor máximo de teste de kc
step_kc = 0.2; % quanto k irá varia a cada iteração

% 0.05 <= a <= 2
min_search_a = 0.05; %valor minimo de teste de a
max_search_a = 2; %valor máximo de teste de kc
step_a = 0.2; % quanto k irá varia a cada iteração

min_Mp = 5; %valor minimo de Mp(máximo sobressinal) desejado (Entrada em porcentagem!!!)
max_Mp = 10; %valor máximo de Mp(máximo sobressinal) desejado (Entrada em porcentagem!!!)

max_ts = 7.9; % valor máximo do tempo de acomodação em segundos

        % entrada da FT pelos coeficientes equa. polinomial
%         num = [1]
%         den = [1 6 5 0]
%         Gp = tf(num, den)
        
        % entrada da FT pelos polos e zeros conhecidos
        Gp = zpk([],[0 -1 -5], 1);

S = tf('s');
flag_value_found = 0;
t = 0 : 0.01 : 8; %t é uma variavel de tempo contendo uma lista de 0 a 8 com intervalos de 0.01
for kc = max_search_kc : -step_kc : min_search_kc %realiza um loop onde k varia de 5 a 2 reduzindo -0.2 a cada iteração
    for a = max_search_a : -step_a : min_search_a %realiza um loop onde a varia de 1.5 a 0.5 reduzindo -0.2 a cada iteração
        Gc = kc*((S+a)^2)/S;
        G = Gc*Gp;
        FTMF = feedback(G,1);
        
        [num, den] = tfdata(FTMF, 'v');
        %y = step(num,den,t); %executa uma entrada degrau com a função de transferência armazenada em num e den nos intervalos da lista t e salva na variável y os resultados
        performance_espcs = stepinfo(FTMF); %obtem as especificações de desempenho da resposta a entrada degrau
        Mp = performance_espcs.Overshoot; %verifica o valor máximo atingido(máximo sobressinal) na resposta da entrada degrau.
        ts = performance_espcs.SettlingTime;
        
        if Mp <max_Mp && Mp > min_Mp && ts < max_ts%teste se a condição de máximo sobressinal e tempo de acomodação foi atendida
%         if Mp <max_Mp && Mp > min_Mp%teste se a condição de máximo sobressinal e tempo de acomodação foi atendida
            flag_value_found = 1;
            break; %atendida condição de máximo sobressinal, interrompe do loop interno que varia a
        end
        
    end
    
    if Mp <max_Mp && Mp > min_Mp && ts < max_ts %teste se a condição de máximo sobressinal e tempo de acomodação foi atendida
%     if Mp <max_Mp && Mp > min_Mp %teste se a condição de máximo sobressinal e tempo de acomodação foi atendida
        break; %atendida condição de máximo sobressinal, interrompe do loop externo que varia k
    end
end

if not(flag_value_found)
    disp("<! Não foi possível encontrar um valor 'Kc' e 'a' para as especificações pedidas !>\n");
else 
    fprintf("# Encontrados os seguintes valores: kc = %.3f ; a = %.3f\n", kc, a);
    step(FTMF);
    grid % acrescenta linhas de grade
    title('Resposta ao degrau unitário') % acrescenta titulo ao gráfico
    xlabel('t(s)') % acrescenta legenda do eixo x
    ylabel('Saída') % acrescenta legenda do eixo y
    str_k = num2str(kc); % valor de k em formato string prar impressão no gráfico
    str_a = num2str(a); % valor de a em formato string prar impressão no gráfico
    str_Mp = num2str(Mp); % valor do máximo sobresinal em formato string prar impressão no gráfico
    text(4.25, 0.54, 'kc = '), text(4.75, 0.54, str_k) % mostra o valor de K encontrado no gráfico
    text(4.25, 0.46, 'a = '), text(4.75, 0.46, str_a) % mostra o valor de a encontrado no gráfico
    text(4.25, 0.38, 'Mp = '), text(4.75, 0.38, str_Mp) % mostra o valor do máximo sobresinal encontrado no gráfico
    
    fprintf("\n# A função de transferência de malha fechada com controlador é: ")
    FTMF
    
    fprintf("# A equação caracteristica do sistema é:\n")
    size_den = size(den, 2);
    for ind = 1 : 1 : size_den
        if ind < size_den
            fprintf("%.2f*S^%d + ", den(ind), size_den-ind);
        else
            fprintf("%.2f", den(ind));
        end
    end
    
    poles = roots(den);
    real_poles = real(poles);
    flag_instable_system = 0;
    for ind = 1 : 1 : size(real_poles, 2)
        if real_poles(ind) >= 0 
            flag_instable_system = 1;
        end
    end
    
    if flag_instable_system
        fprintf("\n\n<! O sistema é instavel !>\n\n");
    else
        fprintf("\n\n<! O sistema é estavel !>\n\n");
    end
end

