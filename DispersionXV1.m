function varargout = DispersionXV1(varargin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GUI para experimentar con el efecto compton
    %
    %  Material didactico para la clase de fisica IV/Moderna
    %
    %  G. Rodriguez-Morales 2016  FIME-UANL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all
    clc
    
    %timer
    FPS = 50;  % cuadros por segundo
    tmr = timer('Name','Timer',...
                  'Period',1/FPS,... % 1 second between moves time.
                  'StartDelay',1,... %
                  'ExecutionMode','fixedrate',...
                  'TimerFcn',@pasoJuego); % Function def. below.
    
    
    %  Datos experimentales
     % constantes fisicas
    hp = 6.625e-34; % Js
    e = 1.6e-19;   % C
    m = 9.1e-31;   % Kg
    c = 3e8;       %m/s
     
    Gcolor = [255 204 0]/255;
    Acolor = [0 0 150]/255;
  
    % Caracteristicas de la ventana

    scrsz = get(0,'ScreenSize');
    l = 750;
    h = 630;
    Wpos = [10  scrsz(4)-h-60 1.2*l h];
    f = figure('Visible','on','Name','Dispersion de rayos X','MenuBar','none','resize','off',...
               'Position',Wpos,'Units','Characters','Color',[0.8 0.8 0.6],'closereq',@fig_clsrqfcn);

   

   
    
    
    % Tubo Rayos x
    xTX = [0.15*cosd(0:10:180)        0.5*cosd(110:10:250)  0.15*cosd(180:10:360)        0.5*cosd(290:10:430)];
    yTX = [1-0.5*(1-sind(0:10:180))   0.5*sind(110:10:250) -1+0.5*(1+sind(180:10:360)) 0.5*sind(290:10:430)] ;
    
    % Colimador inferior
    xCLi = [1     1  1.02  1.02  1.04  1.04  1.06 1.06];
    yCLi = [-0.05 -1 -1   -0.8 -0.8 -1   -1   -0.05];
     % Colimador superior
    xCLs = [1   1  1.02  1.02  1.04  1.04  1.06 1.06];
    yCLs = [0.05 1  1   0.8 0.8 1   1   0.05];
    
    % blanco
    xBC = [2    2   2.01  2.01];
    yBC = [-0.5 0.5 0.5 -0.5];
    
    %sensor foton
    xSF = [2.90  2.90    2.88  2.88  2.98     2.98     2.88 2.88   2.9];
    ySF = [0 0.02 0.02 0.04 0.04 -0.04 -0.04 -0.02 -0.02];
    
    %sensor electron
    xSE = [2.90 2.90    2.88  2.88  2.98     2.98     2.88 2.88   2.9];
    ySE = [0 0.02 0.02 0.04 0.04 -0.04 -0.04 -0.02 -0.02];
    
    % anodo
    xAN = [-0.01 0.01 0.01  0.2  0.1 -0.2 -0.2 -0.01];
    yAN = [ -1  -1   -0.2  -0.2 -0.1 0.2    -0.2 -0.2];
    
    % catodo
    xCT = [-0.01 0.01 0.01 0.1 0.1 0.09  0.09 -0.09 -0.09 -0.1  -0.1 -0.01];
    yCT = [0.8     0.8    0.5 0.5  0.48 0.48 0.4  0.4    0.48  0.48  0.5 0.5]+0.2;
    
    % cable
    xCS = [0.01 -0.25  -0.25+0.2*cosd(90:10:180)   -0.45  -0.25+0.2*cosd(180:10:270)  0.01 0.01 -0.25  -0.25+0.17*cosd(270:-10:180)  -0.42 -0.25+0.17*cosd(180:-10:90) 0.01];
    yCS = [0.9   0.9    0.7+0.2*sind(90:10:180)    -0.7   -0.7+0.2*sind(180:10:270)  -0.9 -0.87 -0.87  -0.7+0.17*sind(270:-10:180)   0.7    0.7+0.17*sind(180:-10:90)  0.87];
    
%    % cable inferior
%     xCI = [-0.01 0.01 0.01 0.1 0.1 0.09  0.09 -0.09 -0.09 -0.1  -0.1 -0.01];
%     yCI = [0.8     0.8    0.5 0.5  0.48 0.48 0.4  0.4    0.48  0.48  0.5 0.5]+0.2;
    
 % grafica del espectro
     A2 = axes('Position',[0.53 0.06 0.45 0.1],'FontSize',8);
     xSpectro = zeros(size(-180:180));
     ySpectro = NaN*zeros(size(xSpectro));
     pltE = plot(A2,xSpectro,ySpectro,'o','MarkerFaceColor',[1 1 0],'MarkerEdgeColor',[0.7 0.3 0],'MarkerSize',3,'LineWidth',0.01);
    xlabel('\theta')
    set(A2,'Color',[0.8 0.8 0.6],'YTick',[],'box','off')
    % axis tight    
     A3 = axes('Position',[0.53 0.20 0.45 0.1],'FontSize',7);
     xElectron = zeros(size(-180:180));
     yElectron = NaN*zeros(size(xSpectro));
     plt = plot(A3,xElectron,yElectron,'o','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0.3 0.3 0],'MarkerSize',3,'LineWidth',0.1);
     set(A3,'Color',[0.8 0.8 0.6],'YTick',[],'box','off') 

    
    A1 = axes('Position',[0.05 0.3 0.9 0.55]);
    
     % animación electrones
     nElectrones = 50;
    vx = zeros(1,nElectrones);
    vy = zeros(1,nElectrones);
   % rebote = zeros(1,nElectrones);
   % vx = randi([-1e6 1e6],1,100);
   % vy = -randi([1e4 1e5],1,100);
    t = 0; 
    x = -0.035 + rand(1,nElectrones)/20;
    y = 0.6 + vx*t + vy*t;
   
    I = 100;
              
    %plt = plot(A1,x,y,'o','MarkerFaceColor','y','MarkerEdgeColor','r','MarkerSize',3);
    %plt2 = plot(A1,x,y,'*','MarkerFaceColor','y','MarkerEdgeColor','r','MarkerSize',3);
    %p4 = plot(1,0.15,'o','MarkerFaceColor','k','MarkerEdgeColor','w');
    
    
    for pt = 1:nElectrones
        sprite(pt) = rectangle('Position',[x(pt),0.6,0.02,0.02],'Curvature',[1,1],'FaceColor','y','EdgeColor','y','UserData',[0 0]);        
    end
    %get(sprite(1))
       thetaText = text(2.3,0,[sprintf('%6.1f',0),' °'],'Color','r','FontSize',16)
       phiText = text(2.3,0,[sprintf('%6.1f',0),' °'],'Color',[1 1 0],'FontSize',16)
    axis off
    bulbo = patch(xTX,yTX,[0 0 1],'FaceAlpha',0.2);
    colimadorI = patch(xCLi,yCLi,[0.7 0.7 0.5]);
    colimadorS = patch(xCLs,yCLs,[0.7 0.7 0.5]);
    blanco = patch(xBC,yBC,[0.7 0.7 0.5]);
    sensorF = patch(xSF,ySF,[1.0 0.5 0.5]);
    sensorE = patch(xSE,ySE,[1 1.0 0.]);
    anodo = patch(xAN,yAN,[0.7 1.0 0.5]);
    catodo = patch(xCT,yCT,[0.7 1.0 0.5]);
    cable = patch(xCS,yCS,[1 0.4 0.1]);
   % cableInf = patch(xCI,yCI,[0.7 1.0 0.5]);
    lineF = line([2,xSE(1)],[0,ySE(1)],'Color','r');
    lineE = line([2,xSE(1)],[0,ySE(1)],'Color','y');    
    lineAF = line([2,2],[0,0],'Color','r','LineStyle','-','LineWidth',3);
    lineAE = line([2,2],[0,0],'Color','y','LineStyle','-','LineWidth',2);
    lineR = line([1,3],[0,0],'Color','k');
     %plt = plot(A1,x,y,'o','MarkerFaceColor','y','MarkerEdgeColor','r');
     
     % sensores de referencia para giro
     xDF = get(sensorF,'XData');
     yDF = get(sensorF,'YData');
     xDE = get(sensorE,'XData');
     yDE = get(sensorE,'YData');
     
     
    
    iniciaJuego;
       
%     dato = date;
%     dato = datevec(dato);
%     a = num2str(dato(1)-2000);
%     b = num2str(dato(2));
%     if length(b)==1, b=strcat('0',b); end
%     c = num2str(dato(3));
%     if length(c)==1, c=strcat('0',c); end
%     auxiliar1 = [a(1) b(1) c(1)]; 
%     auxiliar2 = [c(2) b(2) a(2)]; 
%     cde = [auxiliar1 '000000000' auxiliar2];
%     cal = zeros(1,10);
     
     voltaje = 1300;
     lambda = 0.225e-10;
     theta = 0;
     phi = 0;
     thetaDispersion = round(1350*rand)/10 + 45;
     phiDispersion = 0;
     lambdaFinal = lambda*1e-9 + (hp/(m*c))*(1-cosd(thetaDispersion))
     phiDispersion = atand(lambda*1e-9*sind(thetaDispersion)/(lambdaFinal - lambda*1e-9*cosd(thetaDispersion)))
     %voltaje = hp*e/(m*c)
     vel = 0;

    % los sliders
    
     S1 = uicontrol(f,'Style','slider','Min',1242.2,'Max',5e5,'Sliderstep',[1000/(5e5-1242.2) 0],...
                      'Value',voltaje,'Position',[50 4.5*h/10 20 1*l/5],...
                      'UserData',1,...
                      'callback',@updateValues);
     S2 = uicontrol(f,'Style','slider','Min',0.001,'Max',1,'Sliderstep',[1/1000 0], ...
                       'Value',lambda/1e-9,'Position',[142 2.5*h/10 1.45*l/5 20],...
                       'UserData',2,...
                       'callback',@updateValues);
    
     S3 = uicontrol(f,'Style','slider','Min',-181,'Max',181,'Sliderstep',[1/360 0], ...
                      'Value',theta ,'Position',[142 2*h/10 1.45*l/5 20],...
                      'UserData',3,...
                      'callback',@updateValues);
     S4 = uicontrol(f,'Style','slider','Min',-181,'Max',181, 'Sliderstep',[1/360 0], ...
                      'Value',phi,'Position',[142 1.5*h/10 1.45*l/5 20],...
                      'UserData',4,...
                      'callback',@updateValues);
     S5 = uicontrol(f,'Style','slider','Min',1,'Max',180, 'Sliderstep',[1/180 0], ...
                      'Value',thetaDispersion,'Position',[512 9*h/10 1.45*l/5 20],...
                      'UserData',5,...
                      'enable','off',...
                      'callback',@updateValues);

    % el texto
     T1 = uicontrol(f,'Style','text','String','Dispersión de Rayos X',...
                      'Position',[10 0.94*h 340 35],'FontSize',18,...
                      'BackGroundColor','w','ForegroundColor',[0 0.7 0]);
     t11 = uicontrol(f,'Style','text','String','Longitud de onda',...
                       'Position',[10 2.5*h/10 130 20],'FontSize',12,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t21 = uicontrol(f,'Style','text','String','Voltaje',...
                       'Position',[10 10.4*h/15 100 20],'FontSize',12,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t31 = uicontrol(f,'Style','text','String','° Sensor fotón',...
                       'Position',[10 2*h/10 130 20],'FontSize',12,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t41 = uicontrol(f,'Style','text','String','° Sensor electron',...
                       'Position',[10 1.5*h/10 130 20],'FontSize',12,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t51 = uicontrol(f,'Style','text','String','dispersión fotón',...
                       'Position',[380 9*h/10 130 20],'FontSize',12,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t61 = uicontrol(f,'Style','text','String','Eof = ',...
                       'Position',[10 1*h/10 130 20],'FontSize',10,'HorizontalAlignment','center',...
                       'BackGroundColor',[0.2 0.2 1],'ForegroundColor','w');
     t71 = uicontrol(f,'Style','text','String','Eff = ',...
                       'Position',[150 1*h/10 130 20],'FontSize',10,'HorizontalAlignment','center',...
                       'BackGroundColor',[1 0.5 0.5],'ForegroundColor','w');
     t81 = uicontrol(f,'Style','text','String','Pof = ',...
                       'Position',[10 0.5*h/10 130 20],'FontSize',9,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.2 0.2 1],'ForegroundColor','w');
     t91 = uicontrol(f,'Style','text','String','Pff = ',...
                       'Position',[150 0.5*h/10 130 20],'FontSize',9,'HorizontalAlignment','left',...
                       'BackGroundColor',[1 0.5 0.5],'ForegroundColor','w');
     t101 = uicontrol(f,'Style','text','String','Ke = ',...
                       'Position',[300 1*h/10 130 20],'FontSize',10,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0],'ForegroundColor','w');
     t111 = uicontrol(f,'Style','text','String','ve = ',...
                       'Position',[300 0.6*h/10 130 20],'FontSize',10,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0],'ForegroundColor','w');
     t121 = uicontrol(f,'Style','text','String','pe = ',...
                       'Position',[300 0.2*h/10 130 20],'FontSize',9,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0],'ForegroundColor','w');
%      t131 = uicontrol(f,'Style','text','String','Eff = ',...
%                        'Position',[300 0.5*h/10 130 20],'FontSize',10,'HorizontalAlignment','left',...
%                        'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t141 = uicontrol(f,'Style','text','String','Ee = ',...
                       'Position',[200 7.7*h/10 150 15],'FontSize',8,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0.6],'ForegroundColor','y');
     t151 = uicontrol(f,'Style','text','String','ve = ',...
                       'Position',[200 7.4*h/10 150 15],'FontSize',8,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0.6],'ForegroundColor','y');
     t161 = uicontrol(f,'Style','text','String','pe = ',...
                       'Position',[200 7.1*h/10 150 15],'FontSize',8,'HorizontalAlignment','left',...
                       'BackGroundColor',[0.8 0.8 0.6],'ForegroundColor','y');

     t12 = uicontrol(f,'Style','text','String',[sprintf('%2.1f',lambda),' nm'],...
                       'Position',[362 2.5*h/10 80 20],...
                       'HorizontalAlignment','center','FontSize',10,...
                       'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
     t22 = uicontrol(f,'Style','text','String',[sprintf('%3.1f',theta),' °'],...
                       'Position',[362 2*h/10 80 20],...
                       'HorizontalAlignment','center','FontSize',12,...
                       'BackGroundColor','r','ForegroundColor','w');
     t32 = uicontrol(f,'Style','text','String',[sprintf('%3.1f',phi),' °'],...
                       'Position',[362 1.5*h/10 80 20],'HorizontalAlignment','center',...
                       'FontSize',12,'BackGroundColor','r','ForegroundColor','w');
     t42 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',voltaje),' V'],...
                       'Position',[10 6.2*h/15 80 20],'HorizontalAlignment','center',...
                       'FontSize',12,'BackGroundColor','r','ForegroundColor','w');
     t52 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',0),' °'],...
                       'Position',[732 9*h/10 80 20],'HorizontalAlignment','center',...
                       'FontSize',12,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');

    
                 
    P2 = uicontrol(f,'Style','push','String','Generar angulo',...
                      'BackGroundColor','b','Position',[520 535 200 30],...
                      'FontSize',18,'ForegroundColor','y',...
                      'callback',@generaAleatorio, 'userdata',15);
    P3 = uicontrol(f,'Style','push','String','limpia grafica',...
                      'BackGroundColor','g','Position',[800 190 80 20],...
                      'FontSize',7,'ForegroundColor','b',...
                      'callback',@resetGraficas, 'userdata',16);
    P4 = uicontrol(f,'Style','push','String','limpia grafica',...
                      'BackGroundColor','g','Position',[800 100 80 20],...
                      'FontSize',7,'ForegroundColor','b',...
                      'callback',@resetGraficas, 'userdata',17);
                  
     % introducir datos manualmente
     letreros = uicontrol(f,'Style','check','String','Introducir datos manualmente' , 'Position',[520 9.4*h/10 200 25],'FontSize',10,'BackGroundColor',Acolor,'ForegroundColor',Gcolor,'userdata',18,'callback',@updateValues);

  
    function generaAleatorio(hObject,eventdata)
        thetaDispersion = round(1800*rand)/10;
        lambdaFinal = lambda*1e-9 + (hp/(m*c))*(1-cosd(thetaDispersion));
        phiDispersion = atand(lambda*1e-9*sind(thetaDispersion)/(lambdaFinal - lambda*1e-9*cosd(thetaDispersion)));
        
        clr = abs(phi-phiDispersion)/360;                         
        set(t32,'BackGroundColor',[clr 1-clr clr])
        
         clr = abs(theta-thetaDispersion)/360;                         
         set(t22,'BackGroundColor',[clr 1-clr clr])
         
        % set(t61,'String',['Efo = ', sprintf('%2.3e',Efo),' J'])
         set(t71,'String',''); %['Eff = ', sprintf('%2.3e',Eff),' J'])
         %set(t81,'String',['Pof = ', sprintf('%2.2e',pof),' kg m/s'])
         set(t91,'String',''), %['Pff = ', sprintf('%2.2e',pff),' kg m/s'])
         set(t101,'String',''); %['Ke = ', sprintf('%2.3e',Ke),' J'])
         set(t111,'String',''); %['ve = ', sprintf('%2.3e',vel2),' m/s'])
         set(t121,'String',''); %['ve = ', sprintf('%2.3e',vel2),' m/s'])

%         fi = fi/1e15;
%         fi = round(fi*100)/100;
%         fi = fi*1e15;
%         set(tA1,'String',['Frec. umbral = ',num2str(round(100*fu*1e-15)/100),' PHz'],'BackGroundColor',[0 0.7 0],'foreground','w')
%         set(tA2,'String',['Frec. incidente = ',num2str(round(100*fi*1e-15)/100),' PHz'],'BackGroundColor',[0 0.7 0],'foreground','w')
%         set(P2,'BackGroundColor',[0 0.7 0],'foreground','r','enable','off')
%         if letrero(3)
%             set(guia,'position',pos3,'string',paso3)
%             letrero(3) = 0;
%         end
        
    end
    function resetGraficas(hObject,eventdata)
        
         cual = get(hObject,'UserData');
         if cual == 16
            xSpectro = NaN*zeros(size(-180:180));
            ySpectro = NaN*zeros(size(xSpectro));
            set(plt,'Xdata',xSpectro,'Ydata',ySpectro)
         end
         if cual == 17
            xElectron = NaN*zeros(size(-180:180));
            yElectron = NaN*zeros(size(xElectron));
            set(pltE,'Xdata',xElectron,'Ydata',yElectron)         
         end
         
    end

             
    
        function updateValues(hObject,eventdata)
                % Parameters
                c = 3e8;
                hp = 6.625e-34;
                m = 9.1e-31;
             %   material

                S = get(hObject,'UserData');
               % material
               % elemento(material)
                switch S
                    case 1  % se modifica la longitud de onda incidente
                         voltaje = round(get(hObject,'Value')/1000)*1000;
                         if voltaje<1242.2
                             voltaje =1243;
                         end                         
                         set(S1,'value',voltaje)
                         set(t42,'BackGroundColor',[0 0.7 0])
                         vel = sqrt(2*e*voltaje/m);
                         Efo = 1.6e-19*voltaje;
                         
                         
                         lambda = hp*c/(e*voltaje);
                         lambda = lambda/1e-9;
                         lambdaFinal = lambda*1e-9 + (hp/(m*c))*(1-cosd(thetaDispersion));
                         phiDispersion = abs(atand(lambda*sind(thetaDispersion)/(lambdaFinal - lambda*cosd(thetaDispersion))));
                         
                         Eff = hp*c/lambdaFinal;
                         pof = hp/(lambda*1e-9);
                         pff = hp/lambdaFinal;
                         Ke = hp*c*(1/(lambda*1e-9) - 1/lambdaFinal);
                         vel2 = sqrt(2*Ke/m);
                         
                         
                         
                         
                         set(S2,'Value',lambda);
                         set(t141,'String',['Ee = ', sprintf('%2.3e',Efo),' J'])
                         set(t151,'String',['ve = ', sprintf('%2.3e',vel),' m/s'])
                         set(t161,'String',['pe = ', sprintf('%2.3e',m*vel),' kg m/s'])
                         set(t61,'String',['Eof = ', sprintf('%2.3e',Efo),' J'])
                         set(t71,'String',['Eff = ', sprintf('%2.3e',Eff),' J'])
                         set(t81,'String',['Pof = ', sprintf('%2.2e',pof),' kg m/s'])
                         set(t91,'String',['Pff = ', sprintf('%2.2e',pff),' kg m/s'])
                         set(t101,'String',['Ke = ', sprintf('%2.3e',Ke),' J'])
                         set(t111,'String',['ve = ', sprintf('%2.3e',vel2),' m/s'])
                         set(t121,'String',['pe = ', sprintf('%2.2e',m*vel2),' kg m/s'])
%                          clr = abs(theta-thetaDispersion)/360;                         
%                          set(t71,'BackGroundColor',[clr 1-clr clr])
                         
                    case 2  % se modifica la longitud de onda incidente
                         lambda = get(hObject,'Value');
                         
                         if lambda<0.003
                             lambda=0.003;
                         end
                         
                         set(S2,'value',lambda)
                         set(t42,'BackGroundColor',[0 0.7 0])
                         lambdaFinal = lambda*1e-9 + (hp/(m*c))*(1-cosd(thetaDispersion));
                         phiDispersion = abs(atand(lambda*sind(thetaDispersion)/(lambdaFinal - lambda*cosd(thetaDispersion))))
                         voltaje = hp*c/(e*lambda*1e-9)
                         vel = sqrt(2*e*voltaje/m);
                         Efo = 1.6e-19*voltaje;
                         Eff = hp*c/lambdaFinal;
                         pof = hp/(lambda*1e-9);
                         pff = hp/lambdaFinal;
                         Ke = hp*c*(1/(lambda*1e-9) - 1/lambdaFinal);
                         vel2 = sqrt(2*Ke/m);
                          
                          
                         set(S1,'Value',voltaje);
                         set(t141,'String',['Ee = ', sprintf('%2.3e',Efo),' J'])
                         set(t151,'String',['ve = ', sprintf('%2.3e',vel),' m/s'])
                         set(t161,'String',['pe = ', sprintf('%2.3e',m*vel),' kg m/s'])
                         set(t61,'String',['Efo = ', sprintf('%2.3e',Efo),' J'])
                         set(t71,'String',['Eff = ', sprintf('%2.3e',Eff),' J'])
                         set(t81,'String',['Pof = ', sprintf('%2.2e',pof),' kg m/s'])
                         set(t91,'String',['Pff = ', sprintf('%2.2e',pff),' kg m/s'])
                         set(t101,'String',['Ke = ', sprintf('%2.3e',Ke),' J'])
                         set(t111,'String',['ve = ', sprintf('%2.3e',vel2),' m/s'])
                         set(t121,'String',['pe = ', sprintf('%2.2e',m*vel2),' kg m/s'])

                    case 3  % se modifica el angulo del sensor de fotones
                           theta = round(get(hObject,'Value'));
                           if theta>180,  theta = -180; end
                           if theta<-180, theta = 180;  end                           
                           set(hObject,'Value',theta)
                          
                            clr = abs(theta-thetaDispersion)/360;                         
                            set(t22,'BackGroundColor',[clr 1-clr clr])
                          
                            % Rotar sensor Foton 
                            R = [cosd(-theta) -sind(-theta); sind(-theta) cosd(-theta)];
                            tX = xDF(1);
                            tY = yDF(1);
                            xD = xDF - 2; %tX;
                            yD = yDF - 0*tY;
                            posSens = R*[xD';yD'];
                            posSens(1,:) = posSens(1,:) + 2;
                            posSens(2,:) = posSens(2,:) + 0*tY;
                            set(sensorF,'XData',posSens(1,:),'YData',posSens(2,:))            
                            set(lineF,'XData',[2 posSens(1,1)],'YData',[0 posSens(2,1)])
                            if theta>0
                                set(lineAF,'XData',2+0.3*cosd(0:theta),'YData',-0.3*sind(0:theta))
                                
                            else
                                set(lineAF,'XData',2+0.3*cosd(theta:0),'YData',-0.3*sind(theta:0))
                            end
                            set(thetaText,'Position',[2+0.35*cosd(-theta/2) 0.35*sind(-theta/2)],'string',[sprintf('%3.0f',theta),' °'])
                                  
                            
                            xSpectro(theta+181) = theta;
                            ySpectro(theta+181) = funcionEspectro(theta);
                            
                            set(plt,'Xdata',xSpectro,'Ydata',(ySpectro-min(ySpectro))/max(ySpectro-min(ySpectro)))
                    case 4  % se modifica la velocidad del electron
                           phi = round(get(hObject,'Value'));
                            if phi>180,   phi = -180;  end
                           if phi<-180, phi = 180;   end                           
                           set(hObject,'Value',phi)
                           
                           clr = abs(phi-phiDispersion)/360;                         
                            set(t32,'BackGroundColor',[clr 1-clr clr])
                           
                           % Rotar sensor Electron 
                            R = [cosd(phi) -sind(phi); sind(phi) cosd(phi)];
                            tX = xDE(1);
                            tY = yDE(1);
                            xD = xDE - 2; %tX;
                            yD = yDE - 0*tY;
                            posSens = R*[xD';yD'];
                            posSens(1,:) = posSens(1,:) + 2;
                            posSens(2,:) = posSens(2,:) + 0*tY;
                            set(sensorE,'XData',posSens(1,:),'YData',posSens(2,:))            
                            set(lineE,'XData',[2 posSens(1,1)],'YData',[0 posSens(2,1)])
                            
                            xElectron(phi+181) = phi;
                            yElectron(phi+181) = funcionElectron(phi);
                            
                            if phi>0
                                set(lineAE,'XData',2+0.3*cosd(0:phi),'YData',0.3*sind(0:phi))
                                
                            else
                                set(lineAE,'XData',2+0.3*cosd(phi:0),'YData',0.3*sind(phi:0))
                            end
                            
                            
                            set(pltE,'Xdata',xElectron,'Ydata',(yElectron-min(yElectron))/max(yElectron-min(yElectron)))
                             set(phiText,'Position',[2+0.35*cosd(phi/2) 0.35*sind(phi/2)],'string',[sprintf('%3.0f',phi),' °'])
                    case 5
                        thetaDispersion = round(get(hObject,'Value'))
                        set(hObject, 'Value',thetaDispersion)
                        
                        lambdaFinal = lambda*1e-9 + (hp/(m*c))*(1-cosd(thetaDispersion))
                        %lambda*1e-9*sind(thetaDispersion)/(lambdaFinal - lambda*1e-9*cosd(thetaDispersion))
                        phiDispersion = abs(atand(lambda*1e-9*sind(thetaDispersion)/(lambdaFinal - lambda*1e-9*cosd(thetaDispersion))))
                        
                         Eff = hp*c/lambdaFinal;
                         pof = hp/(lambda*1e-9);
                         pff = hp/lambdaFinal;
                         Ke = hp*c*(1/(lambda*1e-9) - 1/lambdaFinal);
                         vel2 = sqrt(2*Ke/m);

                        set(t52,'string',[sprintf('%3.2f',thetaDispersion),' °'])
                        
                        clr = abs(theta-thetaDispersion)/360;                         
                        set(t22,'BackGroundColor',[clr 1-clr clr])
                        clr = abs(phi-phiDispersion)/360;                         
                        set(t32,'BackGroundColor',[clr 1-clr clr])
                        
                        set(t71,'String',['Eff = ', sprintf('%2.3e',Eff),' J'])
                         set(t81,'String',['Pof = ', sprintf('%2.2e',pof),' kg m/s'])
                         set(t91,'String',['Pff = ', sprintf('%2.2e',pff),' kg m/s'])
                         set(t101,'String',['Ke = ', sprintf('%2.3e',Ke),' J'])
                         set(t111,'String',['ve = ', sprintf('%2.3e',vel2),' m/s'])
                        
                    case 18
                        manual = get(hObject,'Value');
                        
                        if manual
                            set(S5,'enable','on')
                            set(P2,'enable','off')
                        else
                            set(S5,'enable','off')
                            set(P2,'enable','on')
                        end
                end
                
                
                
                
                %Efo = 1.6e-19*voltaje
                
                 set(t42,'string',[sprintf('%2.1f',voltaje),' V'])
                 set(t12,'string',[sprintf('%3.4f',lambda),' A'])
                 set(t22,'string',[sprintf('%3.2f',theta),' °'])
                 set(t32,'string',[sprintf('%3.2f',phi),' °'])
                 %set(t121,'string',['Efo = ', sprintf('%3.2e',Efo),' J'])
                 
                 %set(anguloFTxT,'String',[sprintf('%3.2f',theta),' °'])
                 
                  %xSpectro(theta+181) = theta;
                            %ySpectro = ySpectro/max(ySpectro) + 0.1*rand;
                            
                 %set(plt,'Xdata',xSpectro,'Ydata',ySpectro/max(ySpectro) + 0.5*rand)

        end



   function ySpectro = funcionEspectro(theta)
        % funcion para evaluar el espectro de dispersión compton
        %ySpectro = 0.8*exp(-(theta/20)^2) + exp(-((theta-thetaDispersion)/30)^2);
        
        if vel~=0
            gmm = 20;
            thetaDispersion2 = 360+thetaDispersion;
            thetaDispersion3 = -360+thetaDispersion;
            ySpectro = (gmm/(2*pi))/(theta^2 + (gmm/2)^2) + ...
                4*(2.5*gmm/(2*pi))/((theta-thetaDispersion)^2 + (2.5*gmm/2)^2) +...
                4*(2.5*gmm/(2*pi))/((theta-thetaDispersion2)^2 + (2.5*gmm/2)^2) +...
                4*(2.5*gmm/(2*pi))/((theta-thetaDispersion3)^2 + (2.5*gmm/2)^2) +...
                0.002*(1-rand);
        else
            ySpectro = 0.002*(1-rand);
        end
   end

 function yElectron = funcionElectron(phi)
        % funcion para evaluar el espectro de dispersión compton
        %ySpectro = 0.8*exp(-(theta/20)^2) + exp(-((theta-thetaDispersion)/30)^2);
        
        if vel~=0
            gmm = 20;
            phiDispersion2 = 360+phiDispersion;
            phiDispersion3 = -360+phiDispersion;
            yElectron = 0*(gmm/(2*pi))/(phi^2 + (gmm/2)^2) + ...
                4*(2.5*gmm/(2*pi))/((phi-phiDispersion)^2 + (2.5*gmm/2)^2) +...
                4*(2.5*gmm/(2*pi))/((phi-phiDispersion2)^2 + (2.5*gmm/2)^2) +...
                4*(2.5*gmm/(2*pi))/((phi-phiDispersion3)^2 + (2.5*gmm/2)^2) +...
                0.002*(1-rand);
        else
            yElectron = 0.002*(1-rand);
        end
    end


    function [] = iniciaJuego()
        % Establece el callback y el times para una nueva corrida
            start(tmr)
    end

    function [] = pasoJuego(varargin)

            dt = 3e-9;
            t = t + dt;
            y = y + vy*dt;
            x = x + vx*dt;
            vax = vx;
            vay = vy;
            
            
           %set(p4,'facecolor','k')
            cnt = 0;
           
            for nn = 1:length(y)
                
                %y
                if vy(nn)==0  && vx(nn)==0 
%                    vx(nn) = randi([-5 5],1)*3e4; 
%                    vy(nn) = -randi([1 10],1)*5e5;
                    vx(nn) = randi([-5 5],1)*vel/2000; 
                    vy(nn) = -randi([1 10],1)*vel/100;

                    
                    %select = vy(nn)<I;
                   %vy(nn) = select*(1 - 0.2*rand );
                   %y(nn) = y(nn) + vy(nn)*dt;
                end
                % choque con el blanco (metal)
                electronFoton = get(sprite(nn),'UserData');
                v= 7e6; %5*sqrt(vx(nn).^2 + vy(nn)^2);
                if y(nn)<-x(nn) && ~electronFoton(1) && x(nn)<max(xAN) && x(nn)>min(xAN)
                    v= 7e6;%5*sqrt(vx(nn).^2 + vy(nn)^2);
                    angulo = atan2(vy(nn),vx(nn));
                     vx(nn) = -v*sin(angulo);
                     vy(nn) = -v*cos(angulo);
                     spritePosition = get(sprite(nn),'position');
                     spritePosition(3) = 5*spritePosition(3);
%                         spritePosition(2) = y(nn) - spritePosition(4)/2;
                     set(sprite(nn),'position',spritePosition)
                     set(sprite(nn),'FaceColor','b','EdgeColor','b','UserData',[1 0])
                end
                 
                 % choque con el colimador
                 if x(nn)>0.96 && x(nn)<1.3 && (y(nn)>0.05 || y(nn)<-0.05) 
                    x(nn) = -0.025 + rand/20;
                    y(nn) = 0.6;
                    vx(nn) = 0;
                    vy(nn) = 0;
                    %rebote(nn) = 0;
                    spritePosition = get(sprite(nn),'position');
                    spritePosition(3) = spritePosition(4);
                    set(sprite(nn),'position',spritePosition)
                    set(sprite(nn),'FaceColor','y','EdgeColor','y','UserData',[0 0])                     
                 end
                 
                 % choque con el blanco
                 if x(nn)>2 && x(nn)<2.1 && ~electronFoton(2)
                     if rand>0.9
                         %lambda0 = 1e-10;
                         %theta = 20;
                         %lambdaf = lambda0 + (h/(m*c))*(1-cosd(30))
                         %phi = atand(lambda0*sind(theta)/(lambdaf - lambda0*cosd(theta)));

                        vx(nn) = v*cosd(-thetaDispersion + 30*(rand-0.5));
                        vy(nn) = v*sind(-thetaDispersion  + 30*(rand-0.5));

                         electronFoton(2) = 1;
                         set(sprite(nn),'FaceColor','r','EdgeColor','r','UserData',electronFoton);
                         %set(blanco,'FaceColor','r')
                         if x(nn)<2.03
                             set(blanco,'FaceColor','r')
                         else
                             set(blanco,'FaceColor','w')
                         end
                     else
                         if rand>0.9
                             electronFoton(2) = 1;
                             vx(nn) = v*cosd(phiDispersion + 30*(rand-0.5));
                             vy(nn) = v*sind(phiDispersion  + 30*(rand-0.5));
                             set(sprite(nn),'FaceColor','y','EdgeColor','y','UserData',electronFoton);
                             spritePosition = get(sprite(nn),'position');
                             spritePosition(3) = spritePosition(4);
                             set(sprite(nn),'position',spritePosition)
                         end
                     end
                 end            
                 
                 
                 


                 if x(nn)>2.9 || x(nn)<-0.45
                    x(nn) = -0.025 + rand/20;
                    y(nn) = 0.6;
                    vx(nn) = 0;
                    vy(nn) = 0;
                    %rebote(nn) = 0;
                    spritePosition = get(sprite(nn),'position');
                    spritePosition(3) = spritePosition(4);
                    set(sprite(nn),'position',spritePosition)
                    set(sprite(nn),'FaceColor','y','EdgeColor','y','UserData',[0 0])
                   
                 end
                 
                 if y(nn)>0.98 || y(nn)<-0.98
                     x(nn) = -0.025 + rand/20;
                    y(nn) = 0.6;
                    vx(nn) = 0;
                    vy(nn) = 0;
                    %rebote(nn) = 0;
                    spritePosition = get(sprite(nn),'position');
                    spritePosition(3) = spritePosition(4);
                    set(sprite(nn),'position',spritePosition)
                    set(sprite(nn),'FaceColor','y','EdgeColor','y','UserData',[0 0])
                 end
                 
            spritePosition = get(sprite(nn),'position');
            spritePosition(1) = x(nn) - spritePosition(3)/2;
            spritePosition(2) = y(nn) - spritePosition(4)/2;
            
            set(sprite(nn),'position',spritePosition)

            end
            %set(plt,'Xdata',x','Ydata',y')
            
            
            %set(plt,'XData',x,'Ydata',y')
           
          %set(plt,'Xdata',xSpectro,'Ydata',ySpectro/max(ySpectro) + 0.1*rand(1,size(ySpectro))) 
             xSpectro(theta+181) = theta;
             ySpectro(theta+181) = funcionEspectro(theta);
            set(plt,'Ydata',(ySpectro-min(ySpectro))/max(ySpectro-min(ySpectro))) 
            
             xElectron(phi+181) = phi;
             yElectron(phi+181) = funcionElectron(phi);
            set(pltE,'Ydata',(yElectron-min(yElectron))/max(yElectron-min(yElectron))) 
            %ySpectro-min(ySpectro)
            %min(ySpectro)

    end
    
    function [] = fig_clsrqfcn(varargin)
        % Clean-up if user closes figure while timer is running.
            try  % Try here so user can close after error in creation of GUI.
                warning('off','MATLAB:timer:deleterunning')
                delete(tmr)  % We always want the timer destroyed first.
                warning('on','MATLAB:timer:deleterunning')
            catch %#ok
            end

            delete(varargin{1})  % Now we can close it down.
        end


end