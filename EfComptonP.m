function varargout = EfComptonP(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI para experimentar con la dispersión Compton en rayos X
%
%  Material didactico para la clase de fisica IV/Moderna
%
%  G. Rodriguez-Morales 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  Initialization tasks
% Caracteristicas de la ventana
close all
clc
scrsz = get(0,'ScreenSize');
l = 750;
h = 630;
Wpos = [10  scrsz(4)-h-60 l h];
f = figure('Visible','on','Name','Dispersión Comptón','MenuBar','none',...
           'Position',Wpos,'Units','Characters','Color',[0.5 0.5 0]);
       
% inicialización con datos aleatorios

xi = -5;
xf = linspace(-0.5,0.5,500);
xg = xf + xi;
m = (xg(end)+xg(1))/2;
yf = exp(-((xg - m)/0.4).^2).*sin(15*(xg));

c = 3e8;
hp = 6.625e-34;
m0 = 9.1e-31;

l0 = 2.25e-11;
thetaf = randi(360);
lf = (hp/(m0*c))*(1-cosd(thetaf)) + l0;
E0 = hp*c/l0;
Ef = hp*c/lf;
K = E0 - Ef;
ve = sqrt(2*K/m0);
phi = atand(l0*sind(thetaf)./(lf - l0*cosd(thetaf)));

%  Construct the components
% los ejes
A1 = axes('Position',[0.1 0.4 0.8 0.55]);

% elementos de animación
foton = plot(xf,exp(-(xf/0.4).^2).*sin(15*(xf)),'Color',[0 0 1],'LineWidth',2);
E = rectangle('Position',[-0.25,-0.25,0.5,0.5],'Curvature',[1,1],'FaceColor','y','EdgeColor','w');
line([-10 10 NaN 0 0],[0 0 NaN -10 10],'Color','k');
text(-xi,-0.5,'x')
text(-0.5,-xi,'y')


% grafica las trayectorias despues del choque y el arco que forma el angulo
tt = linspace(0,thetaf);
pp = linspace(0,-phi);
xat = 0.9*cosd(tt);
yat = 0.9*sind(tt);
xap = cosd(pp);
yap = sind(pp);
pt = 0;
ptt = 0;
arc1 = line(xat,yat,'Color','r');
arc2 = line(xap,yap,'Color','b');
tr1 = line([0 pt*cosd(0)],[0 pt*sind(0)]);
tr2 = line([0 pt*cosd(0)],[0 pt*sind(0)]);

set(arc1,'Visible','off')
set(arc2,'Visible','off')

%axis([-10 10 -10 10])
% Elementos de la animación
%set(foton,'Xdata',xg','Ydata',yf')
ex = 0;
ey = 0;

set(foton,'Xdata',xg','Ydata',yf')
set(E,'Position',[ex-0.5 ey-0.5 1 1])


axis([xi-4 -xi+4 xi-1 -xi+1])
axis off

% los sliders
S1 = uicontrol(f,'Style','slider','Min',1e-4,'Max',10,'Sliderstep',[1e-5 0], ...
                 'Value',l0/1e-10,'Position',[l/5 5*h/15 3*l/5 20],...
                 'UserData',1,...
                 'callback',@updateValues);
S2 = uicontrol(f,'Style','slider','Min',1e-4,'Max',10,'Sliderstep',[1e-5 0],...
                 'Value',lf/1e-10,'Position',[l/5 4*h/15 3*l/5 20],...
                 'UserData',2,...
                 'callback',@updateValues);
S3 = uicontrol(f,'Style','slider','Min',1e-4,'Max',3e7,'Sliderstep',[1e-7/3 0], ...
                 'Value',(c/l0)/1e15 ,'Position',[l/5 3*h/15 3*l/5 20],...
                 'UserData',3,...
                 'callback',@updateValues);
S4 = uicontrol(f,'Style','slider','Min',1e-4,'Max',3e7, 'Sliderstep',[1e-7/3 0], ...
                 'Value',(c/lf)/1e15,'Position',[l/5 2*h/15 3*l/5 20],...
                 'UserData',4,...
                 'callback',@updateValues);
S5 = uicontrol(f,'Style','slider','Min',0,'Max',360,'Sliderstep',[1/360 0],...
                 'Value',thetaf,'Position',[l/5 h/15 3*l/5 20],...
                 'UserData',5,...
                 'callback',@updateValues);
             

% el texto
T1 = uicontrol(f,'Style','text','String','Dispersión Comptón',...
                 'Position',[10 0.94*h 240 35],'FontSize',18,...
                 'BackGroundColor','w','ForegroundColor',[0 0.7 0]);
T2 = uicontrol(f,'Style','text','String','Copyright: FIME-UANL.       Dr. G. Rodríguez-Morales',...
                 'Position',[400 0.96*h 350 20],'FontSize',10,...
                 'BackGroundColor','w','ForegroundColor',[1 0.7 0]);
t11 = uicontrol(f,'Style','text','String','Longitud de onda 0',...
                  'Position',[10 5*h/15 130 20],'FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t21 = uicontrol(f,'Style','text','String','Longitud de onda f',...
                  'Position',[10 4*h/15 130 20],'FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t31 = uicontrol(f,'Style','text','String','Frecuencia 0',...
                  'Position',[10 3*h/15 130 20],'FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t41 = uicontrol(f,'Style','text','String','Frecuencia f',...
                  'Position',[10 2*h/15 130 20],'FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t51 = uicontrol(f,'Style','text','String','Angulo Fotón',...
                  'Position',[10 1*h/15 130 20],'FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t61 = uicontrol(f,'Style','text','String','Angulo electrón',...
                  'Position',[l-280 0.1*h/15 130 20],'FontSize',12,...
                  'BackGroundColor','y','ForegroundColor',[0 0.7 0]);
t12 = uicontrol(f,'Style','text','String',[sprintf('%6.4f',l0/1e-10),' A'],...
                  'Position',[l-140 5*h/15 130 20],...
                  'HorizontalAlignment','left','FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t22 = uicontrol(f,'Style','text','String',[sprintf('%6.4f',lf/1e-10),' A'],...
                  'Position',[l-140 4*h/15 130 20],...
                  'HorizontalAlignment','left','FontSize',10,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t32 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',(c/l0)/1e15),' PHz'],...
                  'Position',[l-140 3*h/15 130 20],'HorizontalAlignment','left',...
                  'FontSize',10,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t42 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',(c/lf)/1e15),' PHz'],...
                  'Position',[l-140 2*h/15 130 20],'HorizontalAlignment','left',...
                  'FontSize',10,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t52 = uicontrol(f,'Style','text','String',[sprintf('%5.2f',thetaf),'°'],...
                  'Position',[l-140 1*h/15 130 20],'HorizontalAlignment','left',...
                  'FontSize',10,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
t62 = uicontrol(f,'Style','text','String',[sprintf('%5.2f',phi),'°'],...
                  'Position',[l-140 0.1*h/15 130 25],'HorizontalAlignment','center',...
                  'FontSize',14,'BackGroundColor',[0.5 0.7 0],...
                  'ForegroundColor',[0.6 0 0]);


% el push bottom
P1 = uicontrol(f,'Style','push','String','Simular',...
                 'BackGroundColor','r','Position',[220 5 200 30],...
                 'FontSize',14,'ForegroundColor','g',...
                 'callback',@simulateDispersion);
             
             
P2 = uicontrol(f,'Style','push','String','Genéra angulo',...
                 'BackGroundColor','r','Position',[20 0.4*h 100 30],...
                 'FontSize',10,'ForegroundColor','g',...
                 'callback',@despliegaAngulo);
% despliega el angulo
a1 = uicontrol(f,'Style','text','String','angulo',...
                  'Position',[130 0.4*h 70 30],'FontSize',14,...
                  'BackGroundColor',[0 0.7 0],'ForegroundColor','w');


    function updateValues(hObject,eventdata)
            % Parameters
            c = 3e8;
            h = 6.625e-34;
            m0 = 9.1e-31;
            
            S = get(hObject,'UserData');
            
            switch S
                case 1  % se modifica la longitud de onda incidente
                     l0 = 1e-10*get(hObject,'Value');
                     thetaf = get(S5,'Value');
                     % calculo de longitud de onda final
                     lf = (h/(m0*c))*(1-cosd(thetaf)) + l0;
                     % actualiza los otros sliders
                     if lf/1e-10>get(S2,'Min') && lf/1e-10<get(S2,'Max'),       set(S2,'Value',lf/1e-10),    end
                     if (c/l0)/1e15>get(S3,'Min') && (c/l0)/1e15<get(S3,'Max'), set(S3,'Value',(c/l0)/1e15), end
                     if (c/lf)/1e15>get(S4,'Min') && (c/lf)/1e15<get(S4,'Max'), set(S4,'Value',(c/lf)/1e15), end
                     if thetaf>get(S5,'Min') && thetaf<get(S5,'Max'),            set(S5,'Value',thetaf),      end
                case 2  % se modifica la longitud de onda dispersada
                     lf = 1e-10*get(hObject,'Value');
                     thetaf = get(S5,'Value');
                     % calculo de longitud de onda final
                     l0 = lf - (h/(m0*c))*(1-cosd(thetaf));
                     % actualiza los otros sliders
                     if l0/1e-10>get(S1,'Min') && l0/1e-10<get(S1,'Max'),       set(S1,'Value',l0/1e-10),    end
                     if (c/l0)/1e15>get(S3,'Min') && (c/l0)/1e15<get(S3,'Max'), set(S3,'Value',(c/l0)/1e15), end
                     if (c/lf)/1e15>get(S4,'Min') && (c/lf)/1e15<get(S4,'Max'), set(S4,'Value',(c/lf)/1e15), end
                     if thetaf>get(S5,'Min') && thetaf<get(S5,'Max'),           set(S5,'Value',thetaf),      end
                case 3  % se modifica la frecuancia incidente
                     l0 = 1e15*get(hObject,'Value');
                     l0 = c/l0;
                     thetaf = get(S5,'Value');
                     lf = (h/(m0*c))*(1-cosd(thetaf)) + l0;
                     % actualiza los otros sliders
                     if l0/1e-10>get(S1,'Min') && l0/1e-10<get(S1,'Max'),       set(S1,'Value',l0/1e-10),    end
                     if lf/1e-10>get(S2,'Min') && lf/1e-10<get(S2,'Max'),       set(S2,'Value',lf/1e-10),    end
                     if (c/lf)/1e15>get(S4,'Min') && (c/lf)/1e15<get(S4,'Max'), set(S4,'Value',(c/lf)/1e15), end
                     if thetaf>get(S5,'Min') && thetaf<get(S5,'Max'),           set(S5,'Value',thetaf),      end
                case 4  % se modifica la longitud de onda incidente
                     lf = 1e15*get(hObject,'Value');
                     lf = c/lf;
                     thetaf = get(S5,'Value');
                     l0 = lf - (h/(m0*c))*(1-cosd(thetaf));
                     % actualiza los otros sliders
                     if l0/1e-10>get(S1,'Min') && l0/1e-10<get(S1,'Max'),       set(S1,'Value',l0/1e-10),    end
                     if lf/1e-10>get(S2,'Min') && lf/1e-10<get(S2,'Max'),       set(S2,'Value',lf/1e-10),    end
                     if (c/l0)/1e15>get(S3,'Min') && (c/l0)/1e15<get(S3,'Max'), set(S3,'Value',(c/l0)/1e15), end
                     if thetaf>get(S5,'Min') && thetaf<get(S5,'Max'),           set(S5,'Value',thetaf),      end
                case 5  % se modifica el angulo del fotón
                     thetaf = get(hObject,'Value');
                     l0 = 1e-10*get(S1,'Value');
                     lf = (h/(m0*c))*(1-cosd(thetaf)) + l0;
                     % actualiza los otros sliders
                     if l0/1e-10>get(S1,'Min') && l0/1e-10<get(S1,'Max'),       set(S1,'Value',l0/1e-10),    end
                     if lf/1e-10>get(S2,'Min') && lf/1e-10<get(S2,'Max'),       set(S2,'Value',lf/1e-10),    end
                     if (c/l0)/1e15>get(S3,'Min') && (c/l0)/1e15<get(S3,'Max'), set(S3,'Value',(c/l0)/1e15), end
                     if (c/lf)/1e15>get(S4,'Min') && (c/lf)/1e15<get(S4,'Max'), set(S4,'Value',(c/lf)/1e15), end
            end
                     
                     % Angulo del electrón
                     phi = atand(l0*sind(thetaf)./(lf - l0*cosd(thetaf)));
                     % energías
                     E0 = h*c/l0;
                     Ef = h*c/lf;
                     K = E0 - Ef;
                     % velocidad
                     ve = sqrt(2*K/m0);
                     % momentums
                     p0 = h/l0;
                     pf = h/lf;
                     pe = p0-pf;
                     pe = m0*ve;
                     % actualiza textos
                     set(t12,'String',[sprintf('%6.4f',l0/1e-10),' A'])
                     set(t22,'String',[sprintf('%6.4f',lf/1e-10),' A'])
                     set(t32,'String',[sprintf('%7.0f',(c/l0)/1e15),' PHz'])
                     set(t42,'String',[sprintf('%7.0f',(c/lf)/1e15),' PHz'])
                     set(t52,'String',[sprintf('%3.2f',thetaf),'°'])
                     if isnan(phi)
                         phi = 0;                        
                     end
                     set(t62,'String',[sprintf('%3.2f',phi),'°'])
    end


%  Callbacks for MYGUI
function simulateDispersion(hObject,eventdata)

t = 0;
dt = 0.02;
xi = -5;
xf = linspace(-0.5,0.5,500);
xg = xf + xi;
m = (xg(end)+xg(1))/2;
%yf = exp(-((xg - m)/0.4).^2).*sin(15*(xg));
%f = [xg; yf];

ex = 0;
ey = 0;



% rotación de acuerdo al ángulo de dispersión del fotón
thetaf = get(S5,'Value');
%handles.thetaf = thetaf;
R = [cosd(thetaf) -sind(thetaf); sind(thetaf) cosd(thetaf)];

% calculo del angulo de dispersión para el electrón
c = 3e8;
h = 6.625e-34;
m0 = 9.1e-31;

%l0 = handles.l0; %2.25e-12;
l0 = 1e-10*get(S1,'Value');
lf = 1e-10*get(S2,'Value'); %; (h/(m0*c))*(1-cosd(thetaf)) + l0;
E0 = h*c/l0;
Ef = h*c/lf;
K = E0 - Ef;
ve = sqrt(2*K/m0);

%phi = get(phi,'Value'); %atand(l0*sind(thetaf)./(lf - l0*cosd(thetaf)));

% arcos de los angulos
tt = linspace(0,thetaf);
pp = linspace(0,-phi);
xat = 0.9*cosd(tt);
yat = 0.9*sind(tt);

xap = cosd(pp);
yap = sind(pp);

pt = 0;
ptt = 0;

% grafica del sistema
%figure(1)
foton = plot(xf,exp(-(xf/0.4).^2).*sin(15*(xf)),'Color',[0 0 1],'LineWidth',2);
E = rectangle('Position',[-0.25,-0.25,0.5,0.5],'Curvature',[1,1],'FaceColor','y','EdgeColor','r');
%foton = plot(xf,exp(-(xf/0.4).^2).*sin(15*(xf)),'r');
%E = rectangle('Position',[-0.25,-0.25,0.5,0.5],'Curvature',[1,1],'FaceColor','y');
line([-10 10 NaN 0 0],[0 0 NaN -10 10],'Color','k');
text(-xi+0.5,-0.5,'x')
text(0.5,-xi,'y')

% grafica las trayectorias despues del choque y el arco que forma el angulo
arc1 = line(xat,yat,'Color','r');
arc2 = line(xap,yap,'Color','b');
tr1 = line([0 pt*cosd(0)],[0 pt*sind(0)],'LineStyle','--','Color','w');
tr2 = line([0 pt*cosd(0)],[0 pt*sind(0)],'LineStyle','--','Color','w');

set(arc1,'Visible','off')
set(arc2,'Visible','off')

% despliega los valores de los angulos
tx1 = text(xat(end/2)+ 0.1,yat(end/2)+0.1,[sprintf('%4.1f',thetaf),'°']);
tx2 = text(xap(end/2)+ 0.1,yap(end/2)+0.1,[sprintf('%4.1f',phi),'°']);
set(tx1,'Visible','off')
set(tx2,'Visible','off')
 
% Despliega las energías
txE1 = text(xi-4,-1,['E_0 = {hc}/{\lambda_0} = ', sprintf('%4.2e',E0),' Joules']);
txE2 = text(pt*cos(thetaf),-pt*sind(thetaf),['E_f = {hc}/{\lambda_f} = ', sprintf('%4.2e',Ef),' Joules']);
txEe = text(pt*cos(phi),-pt*sind(phi),['K = E_0 - E_f = ', sprintf('%4.2e',K),' Joules']);
txV = text(pt*cos(phi),-pt*sind(phi),['v_e = (2*K/m_e)^{1/2} = ', sprintf('%4.2e',ve),' m/s']);
set(txE2,'Visible','off')
set(txEe,'Visible','off')
set(txV,'Visible','off')

% despliega texto con datos de la simulación
%lmb0  = text(1.8*xi,-xi+0.7,['\lambda_0 = ', sprintf('%4.2e',l0),' m']);
%lmbf  = text(xi+0.5,-xi+0.7,['\lambda_f = ', sprintf('%4.2e',lf),' m']);
%frq0  = text(1.8*xi,-xi+0.0,['f_0 = ', sprintf('%4.2e',c/l0),' Hz']);
%frqf  = text(xi+0.5,-xi+0.0,['f_f = ', sprintf('%4.2e',c/lf),' Hz']);
% Ef0 =   text(1.8*xi,-xi-0.7,['E_0 = ', sprintf('%4.2e',E0),' J']);
% Eff =   text(xi+0.5,-xi-0.7,['E_f = ', sprintf('%4.2e',Ef),' J']);
Ke  =   text(1.8*xi,-xi-0.7,['K_e = ', sprintf('%4.2e',K),' J'],'Color','w');
ve  =   text(xi+0.5,-xi-0.7,['v_e = ', sprintf('%4.2e',ve),' m/s'],'Color','w');
Pf0  =   text(1.8*xi,-xi-1.4,['p_{f0} = ', sprintf('%4.2e',h/l0),' kg m/s'],'Color','w');
Pff  =   text(xi+0.5,-xi-1.4,['p_{ff} = ', sprintf('%4.2e',h/lf),' kg m/s'],'Color','w');
Pe0  =   text(1.8*xi,-xi-2.1,['p_{e0} = ', sprintf('%4.2e',0),' kg m/s'],'Color','w');
Pef  =   text(xi+0.5,-xi-2.1,['p_{ef} = ', sprintf('%4.2e',m0*ve),' kg m/s'],'Color','w');


while (t<20 && m<-xi)
    t = t+dt;
    
    xg = xf + xi + t;
    m = (xg(end)+xg(1))/2;
    yf = exp(-((xg - m)/0.4).^2).*sin(15*(xg));
    f = [xg; yf];
    
    
    if m >0
      fR = (R*f)';
      xg =fR(:,1)';
      yf = fR(:,2)';
     % ptt
      if phi~=0
          ex = m*cosd(-phi);
          ey = m*sind(-phi);
          ptt = 1;
      end
    %  ptt
%       set(arc1,'Visible','on')
%       set(arc2,'Visible','on')
% %       set(tr1,'Visible','on')
% %       set(tr2,'Visible','on')
%       set(tx1,'Visible','on')
      pt = m; 

    end
if m>1
    set(txE2,'Visible','on')
    set(arc1,'Visible','on')
    set(tr2,'Visible','on')
    
    set(arc2,'Visible','on')   
    set(txEe,'Visible','on')
    set(txV,'Visible','on')
    if phi ~= 0
        set(tx1,'Visible','on')
        set(tx2,'Visible','on')   
    end
end

    
set(foton,'Xdata',xg','Ydata',yf')
set(tr1,'Xdata',[0 pt*cosd(thetaf)],'Ydata',[0 pt*sind(thetaf)])
set(tr2,'Xdata',[0 pt*cosd(-phi)],'Ydata',[0 pt*sind(-phi)])
set(txE2,'Position',[pt*cosd(thetaf),pt*sind(thetaf)+1])
set(txEe,'Position',[ptt*pt*cosd(phi)-3,-pt*sind(phi)+1])
set(txV,'Position',[ptt*pt*cosd(phi)-3,-pt*sind(phi)-1])
set(E,'Position',[ex-0.5 ey-0.5 1 1])
 
axis([xi-4 -xi+4 xi-1 -xi+1])
axis off
pause(eps)
end

end

    function despliegaAngulo(hObject,eventdata)
        
        a = randi(359);
        set(a1,'string',[sprintf('%4.1f',a),'°'])
    end
        



end