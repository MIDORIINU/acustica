close all, clear all, clc;

%% AISLAMIENTO ACÚSTICO

V_emisora = 111.7;      %m^3 Volumen camara emisora
V_receptora = 113.9;    %m^3 Volumen camara receptora

S_muestra = 10;         %m^2 Superficie de muestra

Temp_ensayo = 20; %°C
Humedad_ensayo = 52; % %

% Espectros de ruido Normalizado
Espectros_ruido_normalizado = dlmread('TP1_Acustica.csv',',',[2 10 19 12]);
%Col1: Banda medida en Hz
%Col2: Espectro normalizado de ruido de tráfico, en dB
%Col3: Espectro normalizado de ruido ferroviario, en dB

Espectro_Rnorm_trafico = Espectros_ruido_normalizado(:,2);
Espectro_Rnorm_ferroviario = Espectros_ruido_normalizado(:,3);

Mediciones_aislamiento = dlmread('TP1_Acustica.csv',',',[2 0 22 4]);
%Col1: Banda medida en Hz
%Col2: L1: nivel sonoro continuo equivalente medido en cámara emisora, en dB
%Col3: L2: nivel sonoro continuo equivalente medido en cámara receptora, en
%dB (se le debe aplicar corrección por ruido de fondo) 
%Col4: RF_receptora: nivel sonoro continuo equivalente del ruido de fondo de la cámara receptora, en dB
%Col5: TR: Tiempos de reverberación medidos

Banda_freq = Mediciones_aislamiento(:,1);
L1 = Mediciones_aislamiento(:,2);
L2_sinCorreccion = Mediciones_aislamiento(:,3);
RF_receptora = Mediciones_aislamiento(:,4);
L2 = 10*log10(10.^(L2_sinCorreccion*0.1)-10.^(RF_receptora*0.1)); %Aplicamos corrección por Ruido de fondo
TR_receptor = (Mediciones_aislamiento(:,5)); %seg Tiempo de reverberación del recinto receptor

C = 332 + 0.608 * Temp_ensayo; % m/seg Velocidad del sonido
Aeq_receptor =  (55.3/C)*V_receptora./TR_receptor; % m^2 Area equivalente de absorción del recinto receptor.


% Calculo de la curva R:
R = L1 - L2 + (10* log10(S_muestra./Aeq_receptor)); % dB: Indice de reducción sonora R de la muestra

% Calculo de Índice de evaluación del aislamiento al ruido aéreo, DLR:
DL_R_ferroviario = -10* log10(sum((10.^(0.1*Espectro_Rnorm_ferroviario)).*(10.^(-0.1*R(4:end))))/sum(10.^(0.1*Espectro_Rnorm_ferroviario)))

DL_R_trafico = -10* log10(sum((10.^(0.1*Espectro_Rnorm_trafico)).*(10.^(-0.1*R(4:end))))/sum(10.^(0.1*Espectro_Rnorm_trafico )))



%% Graficos:

% Grafico de valores de nivel sonoro medidos en la cámara emisora y en la cámara receptora,
% incluyendo el ruido de fondo de la cámara receptora.

% Create figure
figure1 = figure('WindowState','maximized');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

semilogx1(1) = semilogx(Banda_freq,L1,'-bs', 'MarkerFaceColor','b' );
hold on;
grid on;
semilogx1(2) = semilogx(Banda_freq,L2,'-rs','MarkerFaceColor','r' );
%plot(Banda_freq,L2_sinCorreccion,'--go')
semilogx1(3) = semilogx(Banda_freq,RF_receptora,'-.rd','MarkerFaceColor','r' );


set(semilogx1(1),'DisplayName','Cámara emisora','MarkerFaceColor',[0 0 1],...
    'Color',[0 0 1]);
set(semilogx1(2),'DisplayName','Cámara receptora','MarkerFaceColor',[1 0 0],...
    'Color',[1 0 0]);

set(semilogx1(3),'DisplayName','Ruido de fondo cámara receptora',...
    'MarkerFaceColor',[0.466666666666667 0.674509803921569 0.188235294117647],...
    'Marker','diamond',...
    'LineStyle','-.',...
    'Color',[0.470588235294118 0.670588235294118 0.188235294117647]);


legend('Cámara emisora','Cámara receptora','Ruido de fondo cámara receptora', 'Location', 'southoutside')
xlabel('Banda [Hz]')
ylabel('Nivel sonoro continuo equivalente [dB]')
axis([100 5000 0 100])
title('Comparación de Leq')
hold off;

%% Grafico de la curva R (indice de reducción sonora de la muestra)

figure(2)


semilogx(Banda_freq,R,'-gs','MarkerFaceColor','g')
hold on;
grid on;




xlabel('Banda [Hz]')
ylabel('R [dB]')
title('Índice de reducción sonora')

set(axes1,'XMinorTick','on','XScale','log','XTick',...
    [100 200 300 400 500 600 700 800 900 1000 2000 3000 4000 10000],...
    'XTickLabel',...
    {'100','200','300','400','500','600','700','800','900','1000','2000','3000','4000','100'},...
    'YMinorGrid','on','YMinorTick','on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.743229168055889 0.832467984693114 0.119791663888221 0.0550363432704969]);


hold off;


%% ABSORCIÓN


Temp_ensayo = 26.7; %°C
Humedad_ensayo = 62; % %
C = 332 + 0.608 * Temp_ensayo; % m/seg Velocidad del sonido

V_reverberante = 189; % m^3 Volumen de sala reverberante
S_reverberante = 208; % m^2 Superficie sala reverberante

Mediciones_absorcion = dlmread('TP1_Acustica.csv',',',[2 6 19 8]);
%Col1: Banda medida en Hz
%Col2: Tiempo de Reverberacion Sala con muestra (T2)
%Col3: Tiempo de Reverberacion Sala vacía (T1)
Banda_freq = Mediciones_absorcion(:,1);
TR_2 = Mediciones_absorcion(:,2);
TR_1 = Mediciones_absorcion(:,3);

Area_eq = 55.3 * (V_reverberante/C) *(1./TR_2 - 1./TR_1);
%Area_eq: Área equivalente de absorción, en m2
%C: Velocidad del sonido en el aire, en m/s2
%V_reverberante: Volumen de la sala reverberante, en m3
%T1, T2: Tiempos de reverberación de la sala vacía y con muestra, en s

alfa = Area_eq' ./ 10;

DL_alfaTraf = -10* log10(1- sum(alfa*10.^(0.1*Espectro_Rnorm_trafico))/sum(10.^(0.1*Espectro_Rnorm_trafico)))
DL_alfaFerr = -10* log10(1- sum(alfa*10.^(0.1*Espectro_Rnorm_ferroviario))/sum(10.^(0.1*Espectro_Rnorm_ferroviario)))


figure(3)


semilogx(Banda_freq, TR_1,'-bs', 'MarkerFaceColor','b')
hold on;
semilogx(Banda_freq, TR_2,'-rs', 'MarkerFaceColor','r' )
grid on;
xlabel('Banda [Hz]')
ylabel('Tiempo de reverberación [seg]')
title('Tiempos de reverberación con y sin muestra')
axis([100 5000 0 15])
legend('Cámara vacía','Cámara con muestra')

hold off;

figure(4) 
%hold on;

semilogx(Banda_freq, alfa*100,'-gs', 'MarkerFaceColor','g' )
grid on;
axis([100 5000 30 100])
xlabel('Banda [Hz]')
ylabel('\alpha (%)')
title('Coeficiente de absorción sonora')
hold off;