close all, clear all, clc;

%% Datos de sala:

H_sala = 3.4;       %m
L_sala = 13.9;      %m
W_sala = 7.5;       %m
V_sala = 346.8;     %m^3

Sup_puertas = 3 * 3; %9m^2

Sup_pisoyTecho = L_sala*W_sala; %104.25m^2 
Sup_paredes_frente_orador = (H_sala*L_sala + H_sala*W_sala*2)-Sup_puertas;   % 89.26m^2
Sup_pared_detras_orador = H_sala*L_sala;       %47.26m^2

Sup_total = H_sala*L_sala *2 +  W_sala*H_sala * 2+ Sup_pisoyTecho *2;    %354.02m^2



%% Datos de materiales: 
            % 125Hz, 250Hz, 500Hz, 1000Hz, 2000Hz, 4000Hz,
Alpha_piso = [ 0.01,0.02,0.02,0.03,0.03,0.04]; %Baldosa enlozada
Alpha_paredes_frente = [0.01,0.01,0.02,0.02,0.02,0.02]; % Ladrillo Pintado
Alpha_paredes_detras = [0.01,0.01,0.02,0.02,0.02,0.02]; % Ladrillo Pintado
Alpha_techo = [0.01,0.03,0.04,0.05,0.08,0.17];  % Enlucido

Alpha_puertas = [0.05,0.11,0.10,0.09,0.08,0.10]; %Puerta de madera maciza
Alpha_butacas = [0.12,0.20,0.28,0.30,0.31,0.37]; %Tapizado 1
Alpha_butaca_orador = [0.01,0.02,0.02,0.04,0.04,0.04]; %Butaca de madera

Alpha_adulto_butacasTap = [0.18,0.40,0.46,0.47,0.51,0.46]; % Tapizado 1

%Panel madera, aglomerado 6 mm, sobre 50 mm lana de vidrio
Alpha_fonoabsorbente_f = [0.61,0.65,0.24,0.12,0.10,0.06]; % Panel madera, aglomerado 6 mm, sobre 50 mm lana de vidrio

Cant_butacas = 120;





%% TR_optimos

TR_125 = 0.41 + 0.26 * log10(V_sala);
TR_250 = 0.32 + 0.21 * log10(V_sala);
TR_500 = 0.28 + 0.18 * log10(V_sala);

TR_optimos = [125, TR_125;
              250, TR_250;
              500, TR_500;
              1000,TR_500;
              2000,TR_500;
              4000,TR_500;];
          
xv = 1:length(TR_optimos(:,1));
          
          
figure(1)
hold on;

grid on;
 
plot(xv,TR_optimos(:,2));
set(gca, 'XTickLabel',TR_optimos(:,1));
plot(xv,TR_optimos(:,2)+TR_optimos(:,2).*0.2,'--');
plot(xv,TR_optimos(:,2)-TR_optimos(:,2).*0.2,'--');

legend('TR optimo','TR optimo + 20%','TR optimo - 20%')
hold off;

%% Sala con materiales (SIN MUEBLES)
% Empezamos por caracterizar la absorción del local, sin muebles ni personas.

% Area equivalente del local sin muebles ni personas A_L:
%

A_Local_vacio = Sup_pisoyTecho .* Alpha_piso + Sup_pisoyTecho .* Alpha_techo + Sup_pared_detras_orador .* Alpha_paredes_detras + Sup_paredes_frente_orador .* Alpha_paredes_frente + Sup_puertas .* Alpha_puertas;

TR_conMat_sinMuebles = (0.163 * V_sala)./A_Local_vacio;

figure(2)
hold on;
grid on;
 
plot(xv,TR_optimos(:,2));
plot(xv,TR_conMat_sinMuebles);

plot(xv,TR_optimos(:,2)+TR_optimos(:,2).*0.2,'--');
plot(xv,TR_optimos(:,2)-TR_optimos(:,2).*0.2,'--');
set(gca, 'XTickLabel',TR_optimos(:,1));
legend('TR optimo','TR con Materiales, sin muebles','TR optimo + 20%','TR optimo - 20%')
hold off;

%% Sala con muebles y materiales (SIN PERSONAS)
% El área equivalente del local con muebles y sin público, A1:

A1 = A_Local_vacio + Cant_butacas .* Alpha_butacas + 1 .* Alpha_butaca_orador;

TR_conMatyMueb = (0.163 * V_sala)./A1;

figure(3)
hold on;
grid on;
 
plot(xv,TR_optimos(:,2));
plot(xv,TR_conMat_sinMuebles);
plot(xv,TR_conMatyMueb);

plot(xv,TR_optimos(:,2)+TR_optimos(:,2).*0.2,'--');
plot(xv,TR_optimos(:,2)-TR_optimos(:,2).*0.2,'--');
set(gca, 'XTickLabel',TR_optimos(:,1));
legend('TR optimo','TR con Materiales y sin muebles','TR con Materiales y Muebles','TR optimo + 20%','TR optimo - 20%')
hold off;

%% Sala con personas
Butacas_ocupadas = Cant_butacas * 0.75;
Butacas_vacias = Cant_butacas - Butacas_ocupadas;

A2 = A_Local_vacio + Butacas_vacias .* Alpha_butacas + Butacas_ocupadas .* Alpha_adulto_butacasTap;

TR_conPersonas = (0.163 * V_sala)./A2;

figure(4)
hold on;
grid on;
 
plot(xv,TR_optimos(:,2));
plot(xv,TR_conMat_sinMuebles);
plot(xv,TR_conMatyMueb);
plot(xv,TR_conPersonas,'LineWidth', 3);

plot(xv,TR_optimos(:,2)+TR_optimos(:,2).*0.2,'--');
plot(xv,TR_optimos(:,2)-TR_optimos(:,2).*0.2,'--');
set(gca, 'XTickLabel',TR_optimos(:,1));
legend('TR optimo','TR con Materiales y sin muebles','TR con Materiales y Muebles','TR con Personas','TR optimo + 20%','TR optimo - 20%')
hold off;

%% Sala con fonoAbsorbentes

A3 = A2 - (Sup_paredes_frente_orador*0.4 .* Alpha_paredes_frente) + Sup_paredes_frente_orador*0.4 .* Alpha_fonoabsorbente_f;

TR_conFonoabsorbentes = (0.163 * V_sala)./A3;

figure(5)
hold on;
grid on;
 
plot(xv,TR_optimos(:,2));
%plot(xv,TR_conMat_sinMuebles);
%plot(xv,TR_conMatyMueb);
plot(xv,TR_conPersonas);
plot(xv,TR_conFonoabsorbentes,'LineWidth', 3);

plot(xv,TR_optimos(:,2)+TR_optimos(:,2).*0.2,'--');
plot(xv,TR_optimos(:,2)-TR_optimos(:,2).*0.2,'--');
set(gca, 'XTickLabel',TR_optimos(:,1));
legend('TR optimo','TR con Personas', 'TR con Fonoabsorbentes','TR optimo + 20%','TR optimo - 20%')
hold off;
