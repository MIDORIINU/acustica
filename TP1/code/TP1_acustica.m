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


% Graficos:

images_directory= '../informe/img';


%% Grafico de valores de nivel sonoro medidos en la cámara emisora y en la cámara receptora,
% incluyendo el ruido de fondo de la cámara receptora.

% Create figure
figure1 = figure('WindowState','maximized');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
hold on;
grid on;

semilogx1(1) = semilogx(axes1, Banda_freq,L1,'-bs', 'MarkerFaceColor','b' );
semilogx1(2) = semilogx(axes1, Banda_freq,L2,'-rs','MarkerFaceColor','r' );
semilogx1(3) = semilogx(axes1, Banda_freq,RF_receptora,'-.rd','MarkerFaceColor','r' );


set(semilogx1(1),'DisplayName','Cámara emisora','MarkerFaceColor',[0 0 1],...
    'Color',[0 0 1]);
set(semilogx1(2),'DisplayName','Cámara receptora','MarkerFaceColor',[1 0 0],...
    'Color',[1 0 0]);

set(semilogx1(3),'DisplayName','Ruido de fondo cámara receptora',...
    'MarkerFaceColor',[0.466666666666667 0.674509803921569 0.188235294117647],...
    'Marker','diamond',...
    'LineStyle','-.',...
    'Color',[0.470588235294118 0.670588235294118 0.188235294117647]);


legend(axes1, 'Cámara emisora','Cámara receptora','Ruido de fondo cámara receptora', 'Location', 'southoutside')
xlabel(axes1, 'Banda [Hz]')
ylabel(axes1, 'Nivel sonoro continuo equivalente [dB]')
title(axes1, 'Comparación de Leq')

grid(axes1,'on');

set(axes1,'XMinorTick','on','XMinorGrid','on','XScale','log','XTick',...
    Banda_freq,...
    'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),...
    'YMinorGrid','on','YMinorTick','on');

xlim(axes1,[0 5000]);

xtickangle(axes1,45);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.699479168055889 0.861543789469853 0.119791663888221 0.0550363432704969]);

hold off;


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure1, fullfile(images_directory, ...
    'Comparacion_Leq.png'));

% Generación completa.
fprintf('Listo\n\n');




%%

figure1b = figure('WindowState','maximized');

% Create axes
axes1b = axes('Parent',figure1b);
hold(axes1b,'on');

% Create multiple lines using matrix input to bar
bar1 = bar(axes1b, [L1, L2, RF_receptora]);
set(bar1(1),'DisplayName','Cámara emisora', 'FaceColor', [0 0 1]);
set(bar1(2),'DisplayName','Cámara receptora', 'FaceColor', [1 0 0]);
set(bar1(3),'DisplayName','Ruido de fondo cámara receptora',...
    'FaceColor',[0.466666666666667 0.674509803921569 0.188235294117647]);

% Create ylabel
ylabel(axes1b, 'Nivel sonoro continuo equivalente [dB]');

% Create xlabel
xlabel(axes1b, 'Banda [Hz]');
title(axes1b, 'Comparación de Leq')

ylim(axes1b,[0 100]);
box(axes1b, 'on');

% Set the remaining axes properties
set(axes1b,'XGrid','on','XMinorGrid','off','XTick',...
    ( 1: size(L1,1) ),'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),'YGrid','on','YMinorGrid',...
    'on');

xtickangle(axes1b,45);

% Create legend
legend1b = legend(axes1b,'show');

set(legend1b,...
    'Position',[0.779861142492734 0.865686088457835 0.119791663888221 0.0550363432704969]);


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure1b, fullfile(images_directory, ...
    'Comparacion_Leq_bars.png'));

% Generación completa.
fprintf('Listo\n\n');



%% Grafico de la curva R (indice de reducción sonora de la muestra)

figure2 = figure('WindowState','maximized');

% Create axes
axes2 = axes('Parent',figure2);
hold(axes2,'on');
hold on;
grid on;


semilog2 = semilogx(axes2,Banda_freq,R);
hold on;
grid on;

set(semilog2,...
    'MarkerFaceColor',[0.3 0.1 0.3],...
    'Marker','diamond',...
    'LineStyle','-.',...
    'Color',[0.3 0.1 0.3]);

xlabel(axes2,'Banda [Hz]')
ylabel(axes2,'R [dB]')
title(axes2,'Índice de reducción sonora')


grid(axes2,'on');

set(axes2,'XMinorTick','on','XMinorGrid','on','XScale','log','XTick',...
    Banda_freq,...
    'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),...
    'YMinorGrid','on','YMinorTick','on');


xlim(axes2,[0 5000]);

ylim(axes2,[0 40]);


xtickangle(axes2,45);

hold off;


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure2, fullfile(images_directory, ...
    'Indice_reduccion_sonora.png'));

% Generación completa.
fprintf('Listo\n\n');


%%

figure2b = figure('WindowState','maximized');

% Create axes
axes2b = axes('Parent',figure2b);
hold(axes2b,'on');

% Create multiple lines using matrix input to bar
bar2 = bar(axes2b, R, 'FaceColor',[0.3 0.1 0.3]);

% Create ylabel
ylabel(axes2b, 'R [dB]');

% Create xlabel
xlabel(axes2b, 'Banda [Hz]');

title(axes2b,'Índice de reducción sonora')

ylim(axes2b,[0 40]);
box(axes2b, 'on');

% Set the remaining axes properties
set(axes2b,'XGrid','on','XMinorGrid','off','XTick',...
    ( 1: size(R,1) ),'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),'YGrid','on','YMinorGrid',...
    'on');

xtickangle(axes2b,45);

fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure2b, fullfile(images_directory, ...
    'Indice_reduccion_sonora_bars.png'));

% Generación completa.
fprintf('Listo\n\n');


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


%%
% Create figure
figure3 = figure('WindowState','maximized');

% Create axes
axes3 = axes('Parent',figure3);
hold(axes3,'on');
hold on;
grid on;

semilogx3(1) = semilogx(axes3, Banda_freq,TR_1,'-bs', 'MarkerFaceColor','b' );
semilogx3(2) = semilogx(axes3, Banda_freq,TR_2,'-rs','MarkerFaceColor','r' );


set(semilogx3(1),'DisplayName','TR sala vacía (T1)','MarkerFaceColor',[0 0 1],...
    'Color',[0 0 1]);
set(semilogx3(2),'DisplayName','TR sala con muestra (T2)','MarkerFaceColor',[1 0 0],...
    'Color',[1 0 0]);


legend(axes3, 'TR sala vacía (T1)','TR sala con muestra (T2)','Location', 'southoutside')
xlabel(axes3, 'Banda [Hz]')
ylabel(axes3, 'Tiempo de reverberación [seg]')
title(axes3, 'Tiempos de reverberación con y sin muestra')

grid(axes3,'on');

set(axes3,'XMinorTick','on','XMinorGrid','on','XScale','log','XTick',...
    Banda_freq,...
    'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),...
    'YMinorGrid','on','YMinorTick','on');

xlim(axes3,[0 5000]);

xtickangle(axes3,45);

% Create legend
legend3 = legend(axes3,'show');
set(legend3,...
    'Position',[0.699479168055889 0.861543789469853 0.119791663888221 0.0550363432704969]);

hold off;


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure3, fullfile(images_directory, ...
    'Tiempos_reverberacion.png'));

% Generación completa.
fprintf('Listo\n\n');


%%

figure3b = figure('WindowState','maximized');

% Create axes
axes3b = axes('Parent',figure3b);
hold(axes3b,'on');

% Create multiple lines using matrix input to bar
bar3 = bar(axes3b, [TR_1, TR_2]);
set(bar3(1),'DisplayName','TR sala vacía (T1)', 'FaceColor', [0 0 1]);
set(bar3(2),'DisplayName','TR sala con muestra (T2)', 'FaceColor', [1 0 0]);

% Create ylabel
ylabel(axes3b, 'Tiempo de reverberación [seg]');

% Create xlabel
xlabel(axes3b, 'Banda [Hz]');
title(axes3b, 'Tiempos de reverberación con y sin muestra')

ylim(axes3b,[0 15]);
box(axes3b, 'on');

% Set the remaining axes properties
set(axes3b,'XGrid','on','XMinorGrid','off','XTick',...
    ( 1: size(TR_2,1) ),'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),'YGrid','on','YMinorGrid',...
    'on');

xtickangle(axes3b,45);

% Create legend
legend3b = legend(axes3b,'show');

set(legend3b,...
    'Position',[0.779861142492734 0.865686088457835 0.119791663888221 0.0550363432704969]);


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure3b, fullfile(images_directory, ...
    'Tiempos_reverberacion_bars.png'));

% Generación completa.
fprintf('Listo\n\n');



%%
figure4 = figure('WindowState','maximized');

% Create axes
axes4 = axes('Parent',figure4);
hold(axes4,'on');
hold on;
grid on;


semilog2 = semilogx(axes4,Banda_freq,alfa);
hold on;
grid on;

set(semilog2,...
    'MarkerFaceColor',[0.3 0.3 0.1],...
    'Marker','diamond',...
    'LineStyle','-.',...
    'Color',[0.3 0.3 0.1]);

xlabel(axes4,'Banda [Hz]')
ylabel(axes4,'\alpha')
title(axes4,'Coeficiente de absorción sonora')


grid(axes4,'on');

set(axes4,'XMinorTick','on','XMinorGrid','on','XScale','log','XTick',...
    Banda_freq,...
    'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),...
    'YMinorGrid','on','YMinorTick','on');


xlim(axes4,[0 5000]);

ylim(axes4,[0 1]);


xtickangle(axes4,45);

hold off;


fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure4, fullfile(images_directory, ...
    'Coef_absorcion_sonora.png'));

% Generación completa.
fprintf('Listo\n\n');


%%


figure4b = figure('WindowState','maximized');

% Create axes
axes4b = axes('Parent',figure4b);
hold(axes4b,'on');

% Create multiple lines using matrix input to bar
bar4 = bar(axes4b, alfa);
set(bar4,'DisplayName','Coeficiente de absorción sonora', 'FaceColor', [0.3 0.3 0.1]);
% 
% Create ylabel
ylabel(axes4b, '\alpha');

% Create xlabel
xlabel(axes4b, 'Banda [Hz]');
title(axes4b, 'Coeficiente de absorción sonora')

ylim(axes4b,[0 1]);
box(axes4b, 'on');

% Set the remaining axes properties
set(axes4b,'XGrid','on','XMinorGrid','off','XTick',...
    ( 1: size(Banda_freq,1) ),'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),'YGrid','on','YMinorGrid',...
    'on');

xtickangle(axes4b,45);

fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure4b, fullfile(images_directory, ...
    'Coef_absorcion_sonora_bars.png'));

% Generación completa.
fprintf('Listo\n\n');






















