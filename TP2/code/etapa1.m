close all, clear all, clc;

% Graficos:

images_directory= '../informe/img';

%modos_resonancia = dlmread('modos_resonancia_sub.txt',' ');
Temp_ensayo = 20;
C = 332 + 0.608 * Temp_ensayo;



L =13.9;
W = 7.5;
H =3.4;
i = 1;
for p = 0:5
    for r = 0:5
        for q = 0:5
        f(i) = (C/2) * sqrt((p/L)^2 + (q/W)^2 + (r/H)^2); 
        i= i+1;
        end
    end
end

f = f';
f = sort(f);
%Valores nominales: 16,20,25,31.5,40,50,63 ,80,100 ,125,160,200,250

fcentre = 10.^(0.1.*[12:43]);
fd = 10^0.05;
fupper = fcentre * fd;
flower = fcentre / fd;

fcentre = fcentre';
fd=fd';
fupper=fupper';
flower= flower';

num12_5 = sum(11.1 < f(:) & f(:) < 14.1);
num16 = sum(14.1 < f(:) & f(:) < 17.8);
num20 = sum(17.8 < f(:) & f(:) < 22.4);
num25 = sum(22.4 < f(:) & f(:) < 28.2);
num31_5 = sum(28.2 < f(:) & f(:) < 35.5);
num40 = sum(35.5 < f(:) & f(:) < 44.7);
num50 = sum(44.7 < f(:) & f(:) < 56.2);
num63 = sum(56.2 < f(:) & f(:) < 70.8);
num80 = sum(70.8 < f(:) & f(:) < 89.1);
num100 = sum(89.1 < f(:) & f(:) < 112);
num125 = sum(112 < f(:) & f(:) < 141);
num160 = sum(141 < f(:) & f(:) < 178);
num200 = sum(178 < f(:) & f(:) < 224);
num250 = sum(224 < f(:) & f(:) < 229);
%12.5,16,20,25,31.5,40,50,63 ,80,100 ,125,160,200,250
prices = [num12_5,num16,num20,num25,num31_5,num40,num50,num63 ,num80,num100 ,num125,num160,num200];


Banda_freq = [12.5, 16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200];

figure1 = figure('WindowState','maximized');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');


bar1 = bar(axes1, prices);


% Create ylabel
ylabel('Cantidad de modos');

% Create xlabel
xlabel('Frecuencia central de tercio de octava');

title(axes1, 'Densidad de modos');

ylim(axes1,[0 40]);
box(axes1, 'on');

% Set the remaining axes properties
set(axes1,'XGrid','on','XMinorGrid','off','XTick',...
    ( 1: length(Banda_freq) ),'XTickLabel',...
    cellfun(@num2str,num2cell(Banda_freq),'uni',false),'YGrid','on','YMinorGrid',...
    'on');

xtickangle(axes1,45);




fprintf(...
    'Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(figure1, fullfile(images_directory, ...
    'modos_resonancia.png'));

% Generación completa.
fprintf('Listo\n\n');







