% M-file to to perform parametric study of snubber
% É setado os valores iniciais da massa 'm' e da posição do conjunto K2 e B
X0 = 0.05; % posição inicial da massa m
Xsnub= -0.05; %posição inicial do conjunto K2, B
%
maxd=zeros(6,6);% uma matriz 6x6 inicializada com zeros
% for each run => para cada loop
kall=[1 10 20 30 40 50]; %lista contendo diferentes valores para constante 
                         %elástica k2
ball=[1 10 20 30 40 50]; %lista contendo diferentes valores para constante 
                         %de amortecimento b

%Em cada loop será realizada uma simulação e será armazando no indice ixj
%da matriz maxd os deslocamento do conjunto K2,B.
for i=1:6
    for j=1:6
        b=ball(j); %Cada coluna possui o resultado correnpondente a um b 
                   %diferente, permanecendo para a linha o mesmo k23
        k2=kall(i); %Cada linha possui o resultado correnpondente a um k2 
                    %diferente, permanecendo para a coluna o mesmo b
        [Y]=sim('algo2'); %executa a simulação correspondente ao diagrama 
                          %de blocos da questão 5, de onde são obtidos os resultados
                          %da posição do bloco
        maxd(i,j) = Xsnub - min(Y.Y(:,1)); %cálculo do deslocamento máximo 
                   %do conjunto k2,b. É subtraida da posição inicial do conjunto 
                   %o ponto mais baixoalcançado pela massa m (o mesmo do conjunto k2,b)
                   %dando assim o deslocamento máximo do conjunto k2, b.
    end
end

meshz(kall,ball,maxd); %Plota um gráfico tridimensional onde 