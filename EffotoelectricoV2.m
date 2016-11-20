function varargout = EffotoelectricoV2(varargin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % GUI para experimentar con el efecto fotoelectrico
    %
    %  Material didactico para la clase de fisica IV/Moderna
    %
    %  G. Rodriguez-Morales 2014  FIME-UANL
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
    fu = 0;
    fi = 0;
    material=1;
    V00=0;
    
    Gcolor = [255 204 0]/255;
    Acolor = [0 0 150]/255;

    elemento = {'Ag','Al','As','Au','Ba','Be','Bi','C','Ca','Cd','Ce','Co','Cr',...
                'Cs','Cu','Fe','Ga','Hg','K','La','Li','Mg','Mn','Mo','Na','Nb',...
                'Ni','Os','Pb','Pd','Pt','Rb','Re','Sb','Sc','Se','Si','Sn','Sr',...
                'Te','Ti','U','V','W','Zn','Zr'};

    phie = [4.730 4.090 3.750 5.100 2.700 4.980 4.340 5.000 2.870 4.080 2.900,...
            5.000 4.500 2.140 4.700 4.810 4.320 4.470 2.290 3.500 2.930 3.660,...
            4.100 4.950 2.360 4.300 5.350 5.930 4.250 5.600 5.930 2.260 4.720,...
            4.700 3.500 5.900 4.850 4.420 2.590 4.950 4.330 3.900 4.300 5.220,...
            4.300 4.050];
        aaa = {};
        for n=1:length(phie)
            aaa(n) = strcat(elemento(n),' ----- ',num2str(phie(n)),'eV');
        end
    %   max(phie)
    %    min(phie)
        % xe-19
    phiJ = [7.580 6.540 6.010 8.200 4.300 7.980 6.950 8.000 4.600 6.540 4.700,...
            8.000 7.200 3.430 7.500 7.710 6.920 7.170 3.670 5.600 4.690 5.860,...
            6.600 7.930 3.780 6.900 8.570 9.500 6.810 9.000 9.500 3.623 7.560,...
            7.500 5.600 9.500 7.770 7.080 4.150 7.930 6.940 6.250 6.900 8.360,...
            6.900 6.490]*1e-19;
        % e-9
    Lambda = [262 304 331 243 459 249 286 248 432 304 428 248 276 579 264 258,...
              287 277.1 541 354 423 339 302 250 525 288 232 209 292 221 209 548.4,...
              263 263 354 210 256 281 479 250 286 318 288 238 288 306]*1e-9;
          %e14
      nu = phie*e/hp;
      nu = nu/1e15;
      nu = round(nu*100)/100;
      nu = nu*1e15;
      
      
      % espectro
      rojo = [6    84    90    82    91    92    83    88    89    88    89    89    90    90    89    90    92    91    92    91    91    91    90    91    92    92    92    93    92,...
      93    94    93    91    92    92    92    93    94    92    93    94    94    94    94    94    95    96    94    95    95    95    95    96    94    94    95    95    94    95,...
      96    97    99    98    99    98   100   102   103   104   104   107   109   107   109   110   110   109   110   112   112   113   114   115   115   117   119   119   120   122,...
     123   124   123   122   122   125   126   125   127   129   130   130   132   132   134   133   135   135   136   136   137   139   140   139   140   141   141   142   144   143,...
     143   146   147   147   148   148   149   150   149   152   152   153   153   154   153   154   154   155   156   156   157   157   157   157   157   153   151   147   144   141,...
     138   136   133   130   128   125   122   120   117   114   110   108   105   101    97    93    88    83    80    78    73    67    63    56    52    46    41    32    23    11,...
       1     0     0     1     2     0     0     0     0     1     0     0     0     1     1     0     0     0     1     0     0     0     0     1     1     1     1     0     1     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     0     0     0     0     1     1     1     1     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     0     5    18    33    43    44    47    57    65    70    72    74    81    85    90    95    97   100   103   107   111   114,...
     119   122   126   132   133   135   140   145   149   151   154   158   160   163   164   168   170   174   177   182   183   187   191   194   197   201   203   208   210   213,...
     216   218   222   225   228   233   233   235   239   242   244   245   248   247   248   248   247   249   248   249   249   248   247   248   247   246   247   247   246   248,...
     248   248   248   248   247   248   248   246   246   247   246   246   246   245   247   247   247   246   247   246   247   246   246   245   245   246   246   246   245   244,...
     245   243   243   242   244   243   243   242   242   244   244   244   243   244   243   242   242   241   241   240   241   240   240   239   239   241   240   240   239   240,...
     239   238   239   239   239   238   238   238   238   237   237   235   235   236   235   235   234   235   234   235   235   234   235   234   234   233   233   234   232   231,...
     233   233   235   233   232   232   231   231   231   231   231   230   230   230   229   230   229   229   228   228   227   227   225   224   225   225   226   226   224   224,...
     225   225   224   222   222   224   225   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224,...
     224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224,...
     224   224   224   224   224   224   224   224   224   224   224   225   225   225   225   225   225   225   225   223   223   223   223   223   223   223   223   223   223   223,...
     223   223   223   223   223   223   223   223   223   223   223   223   223   222   222   222   222   222   222   222   222   224   224   224   224   224   224   224   224   224,...
     224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224,...
     224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   224   223   223   223   223   223   223   223   223   221   221   221   221   221,...
     221   221   221   219   219   218   217   217   215   214   214   213   213   211   209   208   207   209   209   203   204   204   202   198   196   195   196   194   192   191,...
     188   185   184   181   181   176   175   173   170   168   164   162   160   157   155   152   148   143   139   137   134   129   127   123   118   114   110   105   101   101,...
      88    83    84    74     6]/255;
  
  verde = [0    12     9    14     7    13    15    13    17    18    19    22    24    26    28    29    32    32    33    35    37    38    40    41    42    42    44    45    47,...
      48    49    49    52    53    53    54    55    56    57    58    59    59    61    61    63    64    65    65    66    66    66    68    69    70    70    71    70    71    72,...
      73    76    78    80    81    85    87    89    92    93    94    98   100   100   102   105   108   109   111   113   116   119   120   121   123   125   127   129   130   132,...
     133   136   138   139   141   144   147   146   148   150   153   153   155   158   160   161   163   166   167   167   169   171   172   176   177   178   180   181   183   185,...
     185   188   189   191   192   194   195   196   197   201   201   202   203   204   206   207   207   210   211   211   212   212   212   212   212   210   208   207   206   206,...
     205   203   202   202   200   199   199   199   198   195   195   193   192   190   190   190   190   188   187   187   184   183   183   183   183   181   179   180   179   177,...
     176   176   175   174   172   172   173   171   171   170   170   168   169   166   166   165   164   164   163   163   163   162   162   160   161   160   160   160   159   159,...
     159   159   159   159   159   159   159   159   159   160   160   160   160   161   161   162   162   162   162   164   164   164   164   165   166   167   167   168   170   170,...
     170   171   172   172   173   174   176   176   176   178   177   176   177   181   183   183   181   184   185   185   186   187   188   189   189   190   192   193   195   194,...
     195   197   199   201   200   201   202   204   204   204   205   209   209   210   211   211   213   215   216   217   219   221   221   222   222   223   225   224   227   228,...
     229   230   232   235   237   237   237   238   239   241   242   243   243   243   242   242   241   240   239   238   237   236   235   235   233   232   230   230   229   227,...
     227   227   225   224   223   222   222   220   220   218   217   216   215   214   214   211   211   210   209   208   206   205   205   202   202   200   200   198   197   196,...
     195   193   193   192   191   190   188   187   187   184   184   182   181   179   178   177   175   173   173   172   170   169   167   166   166   163   162   160   159   157,...
     156   155   154   151   151   150   147   147   145   143   143   140   140   138   137   134   133   131   130   127   126   125   123   122   120   119   119   115   112   109,...
     108   106   105   103   100   100    98    96    93    91    88    87    85    83    82    80    77    74    71    69    68    64    62    59    55    53    49    46    44    39,...
      37    30    22    13     5     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     1     1     1     1     0     0     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     0     0     0     1     0     0     0     0     0     1     2     3     6     8    11    14    18    21    23    26    29    30    32    33    34,...
      35    37    37    39    39    40    41    42    43    45    45    46    45    47    46    48    48    48    48    49    49    50    50    48    49    50    50    48    47    42,...
      46    45    41    44     2]/255;
  
  azul = [4   114   112   117   121   105   116   116   117   117   117   119   121   120   121   122   122   122   123   124   125   126   127   128   129   129   130   131   132,...
     133   134   134   135   136   136   137   138   139   139   140   141   141   142   142   143   144   145   145   146   146   146   147   148   148   148   149   151   151   152,...
     151   153   153   154   155   157   159   161   161   162   163   165   167   167   169   171   173   173   175   177   179   181   182   183   185   187   189   190   191   191,...
     192   194   195   195   197   200   202   199   201   203   205   205   207   209   211   209   211   213   214   214   216   218   219   221   222   223   223   224   224   225,...
     225   226   227   228   229   230   231   232   233   234   234   235   236   237   238   239   239   241   242   242   243   243   243   243   243   237   235   231   227   226,...
     222   219   217   214   212   208   205   203   199   196   192   190   186   184   182   179   177   173   171   168   165   162   158   156   152   149   146   144   142   139,...
     137   136   131   128   125   122   120   118   115   111   108   106   104   100    98    96    93    91    87    84    84    79    79    76    73    70    67    64    64    59,...
      59    59    59    59    59    59    59    59    59    60    60    60    60    61    61    61    61    59    59    59    59    57    57    55    56    56    54    55    55    55,...
      55    53    54    52    52    51    52    51    51    50    51    52    52    51    47    48    48    44    45    44    42    43    43    43    42    40    40    40    39    35,...
      34    34    34    33    32    31    29    28    25    24    24    20    19    16    11     7     2     1     1     0     0     2     1     0     0     0     2     1     1     1,...
       1     0     0     0     0     2     0     1     1     1     1     0     1     0     0     0     0     1     0     0     1     0     0     0     0     0     0     0     0     0,...
       0     0     0     0     0     1     1     0     0     0     0     0     0     0     0     1     1     0     2     1     0     1     1     0     0     0     0     0     0     0,...
       0     0     0     0     1     0     0     0     0     0     0     1     0     1     0     0     0     2     2     1     2     1     0     1     1     1     0     1     0     0,...
       0     0     0     1     1     1     4     6     6     7     9    10    12    13    14    16    17    18    19    19    21    20    21    22    23    23    23    25    25    23,...
      24    25    27    27    25    28    29    28    28    29    28    29    28    31    31    30    30    30    30    30    29    31    31    31    30    31    33    32    30    34,...
      36    36    34    34    34    36    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37,...
      37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    37    39    39    39    39    39,...
      39    39    39    41    41    41    41    41    41    41    41    42    42    42    42    42    42    42    42    42    42    42    42    42    42    42    42    44    44    44,...
      44    44    44    44    44    45    45    45    45    45    45    45    45    47    47    47    47    47    47    47    47    50    50    50    50    50    50    50    50    52,...
      52    52    52    52    52    52    52    52    52    52    52    52    52    52    52    54    54    54    54    54    54    54    54    55    55    55    55    55    55    55,...
      55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    55    54    54    54    54    54,...
      54    54    54    54    54    53    53    53    53    52    52    56    54    53    53    51    52    53    54    52    52    55    54    52    52    51    52    53    53    53,...
      53    53    53    53    53    50    50    50    50    50    49    49    48    50    49    49    48    46    45    45    44    45    44    42    42    41    42    39    37    36,...
      34    32    34    36     0]/255;
      
%     nu = [11.4 9.87 9.07 12.0 6.50 12.0 10.5 12.0 6.94 9.87 7.00 12.0 11.0 5.17,...
%           11.0 11.6 10.4 10.82 5.54 8.5 7.08 8.85 9.90 12.0 5.71 10.0 12.9 14.3,...
%           10.3 14.0 14.3 5.467 11.4 11.0 8.5 14.0 11.7 10.7 6.26 12.0 10.5 9.43,...
%           10.0 12.6 10.0 9.79]*1e14;

    data = struct('elemento',{elemento},'phie',phie,'phiJ',phiJ,'lambda',Lambda,'nu',nu);
    %a = data.elemento
    %whos

    % Caracteristicas de la ventana

    scrsz = get(0,'ScreenSize');
    l = 750;
    h = 630;
    Wpos = [10  scrsz(4)-h-60 1.8*l h];
    f = figure('Visible','on','Name','Efecto fotoeléctrico','MenuBar','none','resize','off',...
               'Position',Wpos,'Units','Characters','Color',[0.4 0.5 0.4],'closereq',@fig_clsrqfcn);

   

    % valores con el primer elemento de la lista de materiales
    % Kmax = hpg - phi
    phi = 2; %phie(1)           % funcion de trabajo

    gamma0 = nu(1);          % frecuencia de umbral
    lambda0 = Lambda(1);     % longitud de onda de umbral
    lambda = 100e-9;             % longitud de onda incidente
    gamma = c/lambda;               % frecuencia incidente
    I = 0;                   % intensidad
    kmax = hp*gamma - phi*e;   % energia cinetica maxima
    V0 = 0;             % potencial de frenado
    a = V0/10;          % aceleración debido al potencial
    %if 2*kmax/m >0     % velocidad máxima de los electrones 
        V = sqrt(2*kmax/m);
    %else
    %    V = 0;
    %end

    
    
    % placa izquierda
    xc = [0.3 0.3 0.4 0.4 0.3 0.3];
    yc = [0.5 0.3 0.3 0.8 0.8 0.6];
    %cable ida
    xc = [xc 0.1 0.1 1.9 1.9 1.7];
    yc = [yc 0.6 0.1 0.1 0.6 0.6];
    % placa derecha
    xc = [xc 1.7 1.6 1.6 1.7 1.7];
    yc = [yc 0.8 0.8 0.3 0.3 0.5];
    % cable regreso
    xc = [xc 1.8 1.8 0.2 0.2];
    yc = [yc 0.5 0.2 0.2 0.5];

    % Lampara
    xl = [0.9 0.9 1.0 0.9 0.8 0.7];
    yl = [0.9 1.0 1.1 1.2 1.1 1.1];

    % luz
    xz = [0.4 0.9 0.7 0.4];
    yz = [0.32 0.9 1.1 0.78];
    
    %foco
    tf = linspace(0,2*pi,10);
    r = 0.05;
    xf = r*cos(tf) + 1.5; %[0   0.1 0.1 0   0] + 1.5
    yf = r*sin(tf) + 3*r; %[0.1 0.1 0.2 0.2 0.1]
    %xv = [0.7 0.7]
    %yv = [4.5 1.5]

    A1 = axes('Position',[0.05 0.4 0.5 0.55]);
    
     % animación electrones
    vx = zeros(1,1000);
    t = 0;
    x = 0.39 + vx*t;
    y = 0.32 + rand(1,1000)/2.2;
    I = 0;
              
    plt = plot(A1,x,y,'o','MarkerFaceColor','y','MarkerEdgeColor','r');
    %p4 = plot(1,0.15,'o','MarkerFaceColor','k','MarkerEdgeColor','w');
    iniciaJuego;   
    %axis off
    p1 = patch(xc,yc,[0.7 0.7 0.5]);
   % p4 = patch(xf,yf,[1 1 1],'facealpha',1, 'edgealpha',1);
    p2 = patch(xl,yl,[0.2 0.2 0.5]);
    p3 = patch(xz,yz,[1 0 0],'facealpha',0, 'edgealpha',0);
    %p4 = patch(xf,yf,[1 1 1],'facealpha',1, 'edgealpha',1);
    %p4 = patch([],[])
    p4 = rectangle('Position',[1.5,0.1,0.25/2,0.25/2],'Curvature',[1,1],'FaceColor','k','EdgeColor','w');
    %plot(xc,yc,xb,yb,xv,yv)
   

    
     axis off
     
     
    dato = date;
    dato = datevec(dato);
    a = num2str(dato(1)-2000);
    b = num2str(dato(2));
    if length(b)==1, b=strcat('0',b); end
    c = num2str(dato(3));
    if length(c)==1, c=strcat('0',c); end
    auxiliar1 = [a(1) b(1) c(1)]; 
    auxiliar2 = [c(2) b(2) a(2)]; 
    cde = [auxiliar1 '000000000' auxiliar2];
    cal = zeros(1,10);
     
     

    % los sliders
     S1 = uicontrol(f,'Style','slider','Min',100e-9,'Max',1000e-9,'Sliderstep',[(1e-2)/9 0], ...
                      'Value',lambda,'Position',[450 8.9*h/10 1*l/5 20],...
                      'UserData',1,...
                      'callback',@updateValues);
    S2 = uicontrol(f,'Style','slider','Min',3e14,'Max',3e15,'Sliderstep',[1/270 0],...
                     'Value',gamma,'Position',[l/5 4*h/15 2*l/5 20],...
                     'UserData',2,...
                     'callback',@updateValues);
    S3 = uicontrol(f,'Style','slider','Min',2,'Max',6,'Sliderstep',[0.0025 0], ...
                     'Value',phi ,'Position',[l/5 3*h/15 2*l/5 20],...
                     'UserData',3,...
                     'callback',@updateValues);
    S4 = uicontrol(f,'Style','slider','Min',0,'Max',3e7, 'Sliderstep',[1e-7/3 0], ...
                     'Value',1,'Position',[l/5 2*h/15 2*l/5 20],...
                     'UserData',4,...
                     'callback',@updateValues, 'enable','off');
    S5 = uicontrol(f,'Style','slider','Min',-10,'Max',10,'Sliderstep',[1/2000 0],...
                     'Value',0,'Position',[l/5 h/15 2*l/5 20],...
                     'UserData',5,...
                     'callback',@updateValues);
    S6 = uicontrol(f,'Style','slider','Min',0,'Max',100,'Sliderstep',[0.005 0],...
                     'Value',1,'Position',[450 8.2*h/10 1*l/5 20],...
                     'UserData',6,...
                     'callback',@updateValues);

    % el texto
    T1 = uicontrol(f,'Style','text','String','Efecto fotoeléctrico',...
                     'Position',[10 0.94*h 240 35],'FontSize',18,...
                     'BackGroundColor','w','ForegroundColor',[0 0.7 0]);
    t11 = uicontrol(f,'Style','text','String','Longitud de onda',...
                      'Position',[600 8.9*h/10 130 20],'FontSize',12,...
                      'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t21 = uicontrol(f,'Style','text','String','Frecuencia',...
                      'Position',[10 4*h/15 130 20],'FontSize',12,...
                      'BackGroundColor','r','ForegroundColor','w');
    t31 = uicontrol(f,'Style','text','String','Función de trabajo',...
                      'Position',[10 3*h/15 130 20],'FontSize',10,...
                      'BackGroundColor','r','ForegroundColor','w');
    t41 = uicontrol(f,'Style','text','String','Velocidad',...
                      'Position',[10 2*h/15 130 20],'FontSize',12,...
                      'BackGroundColor','r','ForegroundColor','w');
    t51 = uicontrol(f,'Style','text','String','Voltage',...
                      'Position',[10 1*h/15 130 20],'FontSize',12,...
                      'BackGroundColor','r','ForegroundColor','w');
    t61 = uicontrol(f,'Style','text','String','Intensidad',...
                      'Position',[600 08.2*h/10 130 20],'FontSize',12,...
                      'BackGroundColor','r','ForegroundColor','w');

    t12 = uicontrol(f,'Style','text','String',[sprintf('%6.4f',gamma*1e-15),' PHz'],...
                      'Position',[460 4*h/15 130 20],...
                      'HorizontalAlignment','left','FontSize',12,...
                      'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t22 = uicontrol(f,'Style','text','String',[sprintf('%6.4f',phi),' eV'],...
                      'Position',[460 3*h/15 130 20],...
                      'HorizontalAlignment','left','FontSize',12,...
                      'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t32 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',V),' m/s'],...
                      'Position',[460 2*h/15 130 20],'HorizontalAlignment','left',...
                      'FontSize',12,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t42 = uicontrol(f,'Style','text','String',[sprintf('%6.2f',V0),' V'],...
                      'Position',[460 1*h/15 130 20],'HorizontalAlignment','left',...
                      'FontSize',12,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t52 = uicontrol(f,'Style','text','String',[sprintf('%6.1f',lambda*1e9),' nm'],...
                      'Position',[370 8.9*h/10 80 20],'HorizontalAlignment','center',...
                      'FontSize',12,'BackGroundColor',[0 0.7 0],'ForegroundColor','w');
    t62 = uicontrol(f,'Style','text','String',[sprintf('%6.1f',I),' %'],...
                      'Position',[370 8.2*h/10 80 20],'HorizontalAlignment','center',...
                      'FontSize',12,'BackGroundColor',[0 0.7 0],...
                      'ForegroundColor','w');

    t72 = uicontrol(f,'Style','text','String',['K máxima = ',sprintf('%g',kmax),'J'],...
                      'Position',[100 3.7*h/10 280 25],'HorizontalAlignment','center',...
                      'FontSize',14,'BackGroundColor',[0 0.7 0],...
                      'ForegroundColor','y');
    


    % el popup
    P1 = uicontrol(f,'Style','pop','String',data.elemento,'UserData',7,...
                     'BackGroundColor','g','Position',[500 220 200 30],...
                     'FontSize',12,'ForegroundColor','r',...
                     'callback',@updateValues);
                 % verificación
    PV1 = uicontrol(f,'Style','pop','String',aaa,'UserData',8,...
                      'BackGroundColor','r','Position',[1160 426 150 30],...
                      'FontSize',12,'ForegroundColor','y',...
                      'callback',@updateValues);
                 
    P2 = uicontrol(f,'Style','push','String','Generar datos',...
                     'BackGroundColor','r','Position',[30 550 200 30],...
                     'FontSize',18,'ForegroundColor','y',...
                     'callback',@generaAleatorio, 'userdata',15);
                 
    tA1 = uicontrol(f,'Style','text','String','Frec. umbral = ',...
                       'Position',[30 520 200 20],'HorizontalAlignment','left',...
                       'FontSize',12,'BackGroundColor','r',...
                       'ForegroundColor','w');
    tA2 = uicontrol(f,'Style','text','String','Frec. incidente  = ',...
                       'Position',[30 500 200 20],'HorizontalAlignment','left',...
                       'FontSize',12,'BackGroundColor','r',...
                       'ForegroundColor','w');
    plus = uicontrol(f,'Style','text','String',' +',...
                       'Position',[612 330 30 30],'HorizontalAlignment','left',...
                       'FontSize',21,'BackGroundColor','g',...
                       'ForegroundColor','r','visible','on');
   minus = uicontrol(f,'Style','text','String',' -',...
                       'Position',[172 330 30 30],'HorizontalAlignment','left',...
                       'FontSize',20,'BackGroundColor','g',...
                       'ForegroundColor','r','visible','off');
    %tt9 = uicontrol(f,'Style','text','String',sprintf('Potencial: V = %2.3f, Corriente: I= %1.3f, Vcodigo              ' , 'Position',[870 1.10*h/10 400 35],'HorizontalAlignment','center','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);                   
                   
                   
    %A2 = axes('Position',[0.05 0.4 0.5 0.55]);
    A2 = axes('Position',[0.6 0.1 0.04 0.8]);
    
    dcheck =  0.5;
    rcheck = dcheck/2;
    
    pt1 = rectangle('Position',[0,1-   dcheck,dcheck,dcheck],'Curvature',[0.1],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt2 = rectangle('Position',[0,1- 2*dcheck,dcheck,dcheck],'Curvature',[0.2],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt3 = rectangle('Position',[0,1- 3*dcheck,dcheck,dcheck],'Curvature',[0.3],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt4 = rectangle('Position',[0,1- 5*dcheck,dcheck,dcheck],'Curvature',[0.5],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt5 = rectangle('Position',[0,1- 6*dcheck,dcheck,dcheck],'Curvature',[0.6],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt6 = rectangle('Position',[0,1- 7*dcheck,dcheck,dcheck],'Curvature',[0.7],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt7 = rectangle('Position',[0,1- 8*dcheck,dcheck,dcheck],'Curvature',[0.8],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt8 = rectangle('Position',[0,1-10*dcheck,dcheck,dcheck],'Curvature',[1],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt9 = rectangle('Position',[0,1- 4*dcheck,dcheck,dcheck],'Curvature',[0.4],'FaceColor','r','EdgeColor','w','LineWidth',3);
    pt10 = rectangle('Position',[0,1-9*dcheck,dcheck,dcheck],'Curvature',[0.9],'FaceColor','r','EdgeColor','w','LineWidth',3);
    axis off
                   

   tt1 = uicontrol(f,'Style','text','String','Frec. de umbral (PHz)' , 'Position',[870 8.35*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt2 = uicontrol(f,'Style','text','String','Función de trabajo'   , 'Position',[870 7.57*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt3 = uicontrol(f,'Style','text','String','Material usado', 'Position',[870 6.75*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt4 = uicontrol(f,'Style','text','String','Letrero'              , 'Position',[870 5.90*h/10 480 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor',[0 0.7 0],'userdata',0);
   tt5 = uicontrol(f,'Style','text','String','Frecuencia incidente' , 'Position',[870 5.13*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt6 = uicontrol(f,'Style','text','String','Energía '             , 'Position',[870 4.35*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt7 = uicontrol(f,'Style','text','String','Velocidad'            , 'Position',[870 3.55*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt8 = uicontrol(f,'Style','text','String','Potencial de frenado' , 'Position',[870 2.70*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tt9 = uicontrol(f,'Style','text','String','codigo              ' , 'Position',[870 1.10*h/10 400 35],'HorizontalAlignment','center','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   
   
   ttT1 = uicontrol(f,'Style','text','String','Introduce el valor' , 'Position',[1160 9*h/10 180 35],'HorizontalAlignment','left','FontSize',15,'BackGroundColor',[1 0.1 0],'ForegroundColor','y');
   tte1 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 8.35*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',9,'callback',@updateValues); %,'BackGroundColor',[1 0.1 0],'ForegroundColor','y','userdata',0);
   tte2 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 7.57*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',10,'callback',@updateValues); %,'BackGroundColor',[1 0.7 0],'ForegroundColor','y','userdata',0);
   %tte3 = uicontrol(f,'Style','text','String','Material identific do', 'Position',[870 6.75*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   %tte4 = uicontrol(f,'Style','text','String','Letrero satisfacción' , 'Position',[1160 5.90*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','y','userdata',0);
   tte5 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 5.13*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',11,'callback',@updateValues);%,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tte6 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 4.35*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',12,'callback',@updateValues); %,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tte7 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 3.55*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',13,'callback',@updateValues); %,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   tte8 = uicontrol(f,'Style','edit','String','' , 'Position',[1160 2.70*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',14,'callback',@updateValues); %,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   %tte8 = uicontrol(f,'Style','text','String','codigo              ' , 'Position',[1160 1.10*h/10 280 35],'HorizontalAlignment','left','FontSize',20,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
                  
   %Amp = uicontrol(f,'Style','text','String','I = 0.0 ', 'Position',[490 4.4*h/10 80 23],'HorizontalAlignment','left','FontSize',14); %,'BackGroundColor',[0 0.7 0],'ForegroundColor','r','userdata',0);
   
   matricula = uicontrol(f,'Style','text','String','Introduce tu matricula' , 'Position',[560 9.4*h/10 200 35],'HorizontalAlignment','left','FontSize',16,'BackGroundColor',[1 0.1 0],'ForegroundColor','y');
   placa = uicontrol(f,'Style','edit','String','' , 'Position',[770 9.4*h/10 150 35],'HorizontalAlignment','left','FontSize',20,'userdata',16,'callback',@updateValues);
  % psT1 = 
  intro = {'     Introducción',...
           ' ',...
           '  Vamos a experimentar con el efecto fotoeléctrico',...
           ' ',...
           '  El fenomeno consiste en la liberación de electrones por algún material al ser iluminado con radiación electromagnetica.',...
           ' ',...
           'Los electrones en el material absorben la energía de los fotones y esta energía les permite liberarse del material cuando las condiciones lo permiten  ',...
           ' ',...
           ' ',...
           ' Para conocer la energía que adquiere un electrón se realiza un balance de energía tal como: ',...
           ' ',...
           '                                   Kmax = hf - w',...
           ' ',...
           ' Kmax: Energía cinetica máxima del electrón una vez liberado'...
           ' h: constante de Planck (6.625e-34 Js)' ,...
           ' f: frecuencia de la luz que incide en el material', ...
           ' w: funcion de trabajo, ó la energía necesaria para que el material libere el electrón',...
           ' ',...
           ' Por favor introduce tu matrícula en la parte de arriba, (7 digitos)'}
  
  letreros = uicontrol(f,'Style','check','String','Sin letreros' , 'Position',[920 9.4*h/10 100 25],'FontSize',12,'BackGroundColor',Acolor,'ForegroundColor',Gcolor,'userdata',17,'callback',@updateValues);
  guia = uicontrol(f,'Style','text','String',intro , 'Position',[300 0.09*h/10 900 580],'HorizontalAlignment','left','FontSize',17,'BackGroundColor',Acolor,'ForegroundColor',Gcolor);
   
  paso1 = {'1.- Aumenta la intensidad de la iluminación'};
  pos1 = [500 5*h/10 400 180];
  paso2 = {'2.- Genera datos para que realices el experimento'};
  pos2 = [100 5*h/10 400 180];
  paso3 = {'3.- Establece la frecuencia como la de umbral'};
  pos3 = [100 1*h/10 600 100];
  paso4 = {'4.- Introduce el valor de la frecuencia de umbral'};
  pos4 = [1100 5*h/10 200 210];
  paso5 = {'5.- Establece la función de trabajo de acuerdo a la frecuencia de umbral'};
  pos5 = [100 0.4*h/10 600 100];
  paso6 = {'6.- Introduce el valor de la función de trabajo'};
  pos6 = [1100 4*h/10 200 210];
  paso7 = {'7.- Selecciona el elemento'};
  pos7 = [500 1.9*h/10 200 100];
  paso8 = {'8.-  Selecciona el elemento correspondente'};
  pos8 = [1150 5*h/10 200 110];  
  paso9 = {'9.-  Continua hasta que sean verdes todas las figuras de esta columna'};
  pos9 = [750 1*h/10 170 200];
  paso10 = {'10.-  Haz concluido satisfactoriamente el experimento',' ','Copia el código de la ventana de comando y envialo a tu instructor'};
  pos10 = [300 0.1*h/10 500 370];
  letrero = ones(1,10);
  %letrero(1) = 1;
  
    function generaAleatorio(hObject,eventdata)
        %fu = (round(100*(4*rand+2))/100)*e/hp
        %round((0.3 + 1.13*rand)*100)*0.01*1e15;
        material = randi(46);
        fu = phie(material)*e/hp;
        fu = fu/1e15;
        fu = round(fu*100)/100;
        fu = fu*1e15;
        fi = 0;
        while fu>fi
            fi = (0.3 + 2.7*rand)*1e15;
        end
        fi = fi/1e15;
        fi = round(fi*100)/100;
        fi = fi*1e15;
        set(tA1,'String',['Frec. umbral = ',num2str(round(100*fu*1e-15)/100),' PHz'],'BackGroundColor',[0 0.7 0],'foreground','w')
        set(tA2,'String',['Frec. incidente = ',num2str(round(100*fi*1e-15)/100),' PHz'],'BackGroundColor',[0 0.7 0],'foreground','w')
        set(P2,'BackGroundColor',[0 0.7 0],'foreground','r','enable','off')
        if letrero(3)
            set(guia,'position',pos3,'string',paso3)
            letrero(3) = 0;
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
                         lambda = get(hObject,'Value');
                         gamma = c/lambda;
                         kmax = hp*gamma - phi*e;
                         V = sqrt(2*(kmax + e*V0)/m);
                    case 2  % se modifica la frecuencia incidente
                         gamma = get(hObject,'Value');
                         gamma = 1e15*round(100*gamma*1e-15)/100;
                         lambda = c/gamma;
                         kmax = hp*gamma - phi*e;
                         V = sqrt(2*(kmax + e*V0)/m);
                         
                         set(t21,'Backgroundcolor',[0 0.7 0]) 
                         if letrero(4)
                             set(guia,'position',pos4,'string',paso4,'FontSize',20)
                             letrero(4) = 0;
                         end
                    case 3  % se modifica la funcion de trabajo
                          phi = get(hObject,'Value');
                          phi = round(100*phi)/100;
                          % material mas cercano
                          [aa,bb] = max(-abs(phie-phi));
                          %phie(bb)
                          dd = 10*abs(phie(bb) - phi);
                          ddd = 0;
                          if dd>1, dd=1; end
                          if dd == 0, ddd=1; end
                          set(P1,'Value',bb,'Background',[dd,1-dd,ddd],'foreground',[1-dd,dd,ddd])
                          kmax = hp*gamma - phi*e;
                          V = sqrt(2*(kmax + e*V0)/m);  
                          
                          set(t31,'Backgroundcolor',[0 0.7 0])
                          if letrero(6)
                              set(guia,'position',pos6,'string',paso6,'FontSize',20)
                              letrero(6) = 0;
                          end
                    case 4  % se modifica la velocidad del electron
                           V = get(hObject,'Value');
                    case 5  % se modifica el potencial de frenado
                         V0 = get(hObject,'Value');
                         V0 = round(100*V0)/100;
                         V = sqrt(2*(kmax + e*V0)/m);
                    case 6  % se modifica la intensidad de la luz
                         I = get(hObject,'Value');
                         set(t61,'Backgroundcolor',[0 0.7 0]) 
                         %V0 = get(s5,'value');}
                         if letrero(2)
                             set(guia,'position',pos2,'string',paso2)
                             letrero(2) = 0;
                         end
                    case 7  % cambia el material
                        gamma = get(S2,'Value');
                        Lst = get(P1,'string');
                        Mtr = get(P1,'value');
                        
                        if phi == phie(Mtr)
                            set(pt3,'facecolor','g')
                        end
                            
                        
                        phi = phie(Mtr);
                        kmax = hp*gamma - phi*e;
                        V = sqrt(2*(kmax + e*V0)/m);
                        if letrero(8)
                            set(guia,'position',pos8,'string',paso8,'FontSize',20)
                            letrero(8) = 0;
                        end
                    case 8 % Introduce material
                        
                         usr = get(PV1,'String');
                         usrV = get(PV1,'value');
                         elemento(material)
                         bbb = usr{usrV};
                         size(bbb,2)
                        if strcmp(elemento(material),bbb(1:2))
                            set(pt3,'edgecolor','g')
                            set(tt3,'foregroundcolor','w')
                        else
                            set(pt3,'edgecolor','r')
                            set(tt3,'foregroundcolor','r')
                        end
                        
                        % prueba primera parte
                        cpt1 = get(pt1,'facecolor');
                        cpt2 = get(pt2,'facecolor');
                        cpt3 = get(pt3,'facecolor');
                        cept1 = get(pt1,'edgecolor');
                        cept2 = get(pt2,'edgecolor');
                        cept3 = get(pt3,'edgecolor');
                        
                        if cpt3(1)==0 && cpt3(2)==1 && cpt3(3)==0 && cept3(1)==0 && cept3(2)==1 && cept3(3)==0 
                           cal(3)=1; 
                        end
                        
                        if cpt1(1)==0 && cpt1(2)==1 && cpt1(3)==0 && cpt2(1)==0 && cpt2(2)==1 && cpt2(3)==0 && cpt3(1)==0 && cpt3(2)==1 && cpt3(3)==0 && cept1(1)==0 && cept1(2)==1 && cept1(3)==0 && cept2(1)==0 && cept2(2)==1 && cept2(3)==0 && cept3(1)==0 && cept3(2)==1 && cept3(3)==0 
                           set(tt4,'string','Felicidades has identificado el material','foreground','y')
                           set(pt9,'edgecolor','g','FaceColor','g')
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                        if letrero(9)
                            set(guia,'position',pos9,'string',paso9,'FontSize',20)
                            letrero(9) = 0;
                        end
                    case 9 % introduce frec umbral
                        usr = get(tte1,'String');
                        if fu == str2double(usr)*1e15
                            set(pt1,'edgecolor','g')
                            set(tt1,'foregroundcolor','w')
                        else
                            set(pt1,'edgecolor','r')
                            set(tt1,'foregroundcolor','r')
                        end
                        % prueba primera parte
                        cpt1 = get(pt1,'facecolor');
                        cpt2 = get(pt2,'facecolor');
                        cpt3 = get(pt3,'facecolor');
                        cept1 = get(pt1,'edgecolor');
                        cept2 = get(pt2,'edgecolor');
                        cept3 = get(pt3,'edgecolor');
                        
                       
                        
                        if cpt1(1)==0 && cpt1(2)==1 && cpt1(3)==0 && cpt2(1)==0 && cpt2(2)==1 && cpt2(3)==0 && cpt3(1)==0 && cpt3(2)==1 && cpt3(3)==0 && cept1(1)==0 && cept1(2)==1 && cept1(3)==0 && cept2(1)==0 && cept2(2)==1 && cept2(3)==0 && cept3(1)==0 && cept3(2)==1 && cept3(3)==0 
                           set(tt4,'string','Felicidades has identificado el material','foreground','y')
                           set(pt9,'edgecolor','g','FaceColor','g')
                        end
                        
                         if cpt1(1)==0 && cpt1(2)==1 && cpt1(3)==0 && cept1(1)==0 && cept1(2)==1 && cept1(3)==0 
                           cal(1) = 1;
                        else
                            cal(1) = 0;
                         end
                         
                         calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                        if letrero(5)
                            set(guia,'position',pos5,'string',paso5,'FontSize',20)
                            letrero(5) = 0;
                        end
                        
                    case 10 % Introduce func trabajo
                      
                        usr = get(tte2,'String');
                        if phi == str2double(usr)
                            set(pt2,'edgecolor','g')
                            set(tt2,'foregroundcolor','w')
                        else
                            set(pt2,'edgecolor','r')
                            set(tt2,'foregroundcolor','r')
                        end
                        
                        % prueba primera parte
                        cpt1 = get(pt1,'facecolor');
                        cpt2 = get(pt2,'facecolor');
                        cpt3 = get(pt3,'facecolor');
                        cept1 = get(pt1,'edgecolor');
                        cept2 = get(pt2,'edgecolor');
                        cept3 = get(pt3,'edgecolor');
                        
                        if cpt1(1)==0 && cpt1(2)==1 && cpt1(3)==0 && cpt2(1)==0 && cpt2(2)==1 && cpt2(3)==0 && cpt3(1)==0 && cpt3(2)==1 && cpt3(3)==0 && cept1(1)==0 && cept1(2)==1 && cept1(3)==0 && cept2(1)==0 && cept2(2)==1 && cept2(3)==0 && cept3(1)==0 && cept3(2)==1 && cept3(3)==0 
                           set(tt4,'string','Felicidades has identificado el material','foreground','y')
                           set(pt9,'edgecolor','g','FaceColor','g')
                        end
                        
                        if cpt2(1)==0 && cpt2(2)==1 && cpt2(3)==0 && cept2(1)==0 && cept2(2)==1 && cept2(3)==0 
                           cal(2)=1;
                        else
                            cal(2)=0;
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                        if letrero(7)
                            set(guia,'position',pos7,'string',paso7,'FontSize',20)
                            letrero(7)=0;
                        end
                        
                    case 11 % Introduce Frec incidente
                        usr = get(tte5,'String');
                        if fi == str2double(usr)*1e15
                            set(pt4,'edgecolor','g')
                            set(tt5,'foregroundcolor','w')
                        else
                            set(pt4,'edgecolor','r')
                            set(tt6,'foregroundcolor','r')
                        end
                        set(t41,'foregroundcolor','w')
                        
                        % prueba verdes
                        cpt4 = get(pt4,'facecolor');
                        cept4 = get(pt4,'edgecolor');
                                                
                        if cpt4(1)==0 && cpt4(2)==1 && cpt4(3)==0 && cept4(1)==0 && cept4(2)==1 && cept4(3)==0 
                           cal(4)=1;
                        else
                            cal(4)=0;
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                        sum(letrero)
                        set(guia,'visible','off')
                        
                    case 12 % Introduce Energia
                        
                        usr = str2double(get(tte6,'String'));

                        
                        if (kmax - usr)<1e-21
                            set(pt5,'edgecolor','g','facecolor','g')
                            set(tt6,'foregroundcolor','w')
                        else
                            set(pt5,'edgecolor','r','facecolor','r')
                            set(tt6,'foregroundcolor','r')
                        end
                        
                        % prueba verdes
                        cpt5 = get(pt5,'facecolor');
                        cept5 = get(pt5,'edgecolor');
                                                
                        if cpt5(1)==0 && cpt5(2)==1 && cpt5(3)==0 && cept5(1)==0 && cept5(2)==1 && cept5(3)==0 
                           cal(5) = 1; 
                        else
                            cal(5) = 0;
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                       
                    case 13 % Introduce velocidad
                        usr = str2double(get(tte7,'String'));

                       if abs(V-usr)<1
                            set(pt6,'edgecolor','g','facecolor','g')
                            set(tt7,'foregroundcolor','w')
                            set(t41,'backgroundcolor',[0 0.7 0])
                        else
                            set(pt6,'edgecolor','r','facecolor','r')
                            set(tt7,'foregroundcolor','r')
                        end
                        
                        % prueba verdes
                        cpt6 = get(pt6,'facecolor');
                        cept6 = get(pt6,'edgecolor');
                                                
                        if cpt6(1)==0 && cpt6(2)==1 && cpt6(3)==0 && cept6(1)==0 && cept6(2)==1 && cept6(3)==0 
                           cal(6)=1; 
                        else
                            cal(6)=0; 
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                        
                    case 14 % introduce Voltage
                        usr = str2double(get(tte8,'String'));

                       if abs(V00+usr)<0.01
                            set(pt7,'edgecolor','g','facecolor','g')
                            set(tt8,'foregroundcolor','w')
                            set(t51,'backgroundcolor',[0 0.7 0])
                        else
                            set(pt7,'edgecolor','r','facecolor','r')
                            set(tt8,'foregroundcolor','r')
                        end
                        
                        % prueba verdes
                        cpt7 = get(pt7,'facecolor');
                        cept7 = get(pt7,'edgecolor');
                                                
                        if cpt7(1)==0 && cpt7(2)==1 && cpt7(3)==0 && cept7(1)==0 && cept7(2)==1 && cept7(3)==0 
                           cal(7)=1; 
                        else
                            cal(7)=0; 
                        end
                        
                        calstr = num2str(sum(cal));
                        if length(calstr)==1, calstr=['0',calstr]; end
                        
                        cde(7:8)= calstr;
                    case 16
                        usr = get(placa,'String');
                        if sum(isletter(usr)) == 0 && length(usr)==7
                           cde(4:6)=usr(7:-1:5);
                           cde(9:12)=usr(4:-1:1);
                           set(matricula,'backgroundcolor',[0 0.7 0])
                        else
                            set(matricula,'string','Matricula: 7 digitos')
                            set(placa,'string','')
                        end
                        if letrero(1)
                            set(guia,'position',pos1,'string',paso1,'FontSize',30)
                            letrero(1) = 0;
                        end
                    case 17
                        vlu = get(hObject,'value');
                        if vlu
                            set(guia,'visible','off')
                        else
                            set(guia,'visible','on')
                        end
                end
                V00 = round(100*kmax/e)/100;
                 d = 0.3;
                 E = V0/d;
                 a = e*V0/(d*m);
                 potF = kmax/e;
                 

                icolor = round(((lambda*1e9)-99)*length(rojo)/901);

                set(t52,'string',[sprintf('%2.1f',lambda*1e9),' nm'])
                set(t62,'string',[sprintf('%6.1f',I),' %'])
                set(t12,'string',[sprintf('%1.2f',gamma*1e-15),' PHz'])
                set(t32,'string',[sprintf('%6.1f',V),' m/s'])
                set(t22,'string',[sprintf('%2.3f',phi),' eV'])
                set(p3,'facealpha',I/105, 'facecolor',[rojo(icolor) verde(icolor) azul(icolor)])
                set(t42,'string',[sprintf('%2.3f',V0),' V'])

                set(t72,'string',['K máxima = ',sprintf('%g',kmax),'J'])
                
                if abs(V0)
                    if V0>0
                        set(plus,'string',' +', 'visible','on')
                        set(minus,'string',' -', 'visible','on')
                    else
                        set(plus,'string',' -', 'visible','on')
                        set(minus,'string',' +', 'visible','on')
                    end
                else
                    set(plus,'visible','off')
                    set(minus,'visible','off')
                end
                %if lf/1e-10>get(S2,'Min') && lf/1e-10<get(S2,'Max')
                    set(S1,'Value',lambda)
                    set(S2,'Value',gamma)
                    set(S4,'Value',real(V))
                    set(S3,'Value',phi)
                %end
                
                % frecuencia de umbral
                if abs(gamma-fu)<9e12
                    set(pt1,'facecolor','g')
                else
                    if cal(1)==0
                        set(pt1,'facecolor','r')
                    end
                end
                % frecuencia incidente
                if abs(gamma-fi)<9e12
                    set(pt4,'facecolor','g')
                else
                    set(pt4,'facecolor','r')
                end
                % funcion de trabajotcxf
                if phie(material)==phi %ftr==gamma %(phi-hp*gamma/e)<0 %&& phie(material)==phi
                   set(pt2,'facecolor','g')
                else
                   set(pt2,'facecolor','r')                        
                end
                if abs(V0+V00)<0.001
                   set(pt7,'facecolor','g')
                else
                   set(pt7,'facecolor','r')                        
                end
                set(tt9,'string',cde)
                
                if sum(cal)==7
                    set(pt10,'facecolor','g','edgecolor','g')
                    set(pt8,'facecolor','g','edgecolor','g')
                    set(tt9,'foregroundcolor','y')
                    fprintf('Codigo a enviar: %s\n', cde)
                    if strcmp(get(guia,'visible'),'on')
                        set(guia,'position',pos10,'string',paso10,'FontSize',30,'visible','on')
                    end
                else
                    set(pt8,'facecolor','r','edgecolor','g')
                    set(tt9,'foregroundcolor','r')
                end
                
        end



%    function simulateDispersion(hObject,eventdata)
% funcion para el efecto compton
%    end


    function [] = iniciaJuego()
        % Establece el callback y el times para una nueva corrida
            start(tmr)
    end

    function [] = pasoJuego(varargin)

            dt = 1e-8;
            t = t + dt;
            x = x + vx*dt;
           set(p4,'facecolor','k')
           cnt = 0;
           for nn = 1:length(x)
               if vx(nn)==0 && rand<(I/20000)
                  vx(nn) = randi(100,1);
                  select = vx(nn)<I;
                  vx(nn) = real(V)*select*(1 - 0.2*rand );
                  x(nn) = x(nn) + vx(nn)*dt/5;
               end
                   if x(nn)>0.39 && x(nn)<1.595
                       vx(nn) = vx(nn) + 0.5*a*dt;
                       x(nn) = x(nn) + vx(nn)*dt;
                   end
                   if x(nn)>1.60 || x(nn)<0.39
                      x(nn) = 0.39;
                      vx(nn) = 0;
                      cnt = cnt+1;
                   end
                   if x(nn)>=1.595  
                      set(p4,'facecolor','w')
                   end
           end
           set(plt,'Xdata',x','Ydata',y')
                    

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