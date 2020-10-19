%%%%%%%%%%%%%% reborn %%%%%%%%%%%%%%
%%% Russian Equillibrium Balance of Payments with Rational Expectations

% This our balance of payments calculator.
% The basic idea is to decompose the balance of payments into financial and
% current account in order to model these two together and receive back the
% exchange rate that makes these consistent with each other.  I genuinely
% hope that these would not grow into a full scale open economy model, but
% would remain a rather compact calculator type model.

% TODO: 
% [] Move to the YoY framework... 
% [] correct the services equation for double inclusion of the exchange rate:     dSeB=a1_dSeB*dUR+a2_dSeB*dUR+a3_dSeB*y_h+e_dSeB;

% Log:
% v.0.3: i) switched to yoy, ii) error in the SeB 
% v.0.2 Oil exports are not non-linear now.
% v.0.1: Capital account is eliminated by an offsetting operation with the
% 'net assets aquisition' of the financial account
% v0.0: First version of the model

%%%%%%%% Notation %%%%%%%%
% _qq - quarterly change
% _yy - yearly change 
% e_ - shock
% o_ - observed
% ex_ - expectations
% _f - foreign variable



!transition_variables
% Balance of payments variables
'Current account' CuA 
    'Trade balance' TB
        'Goods balance' GoB
            'Goods export' GoX
                'Goods oil&gas export' GoXOG
                      'Goods oil&gas export, QoQ' dGoXOG
                'Goods non-oil&gas export' GoXNOG
                    'Goods non-oil&gas export, QoQ' dGoXNOG
            'Goods Import' GoM
                'Goods Import, QoQ' dGoM
        'Services balance' SeB
            'Services balance, QoQ' dSeB
   'Primary income account' PIA
        'Primary income account, QoQ' dPIA
    'Secondary income account' SIA
        'Secondary income account, QoQ' dSIA
'Financial account' FaA
    'Net incurrence of liabilities' NIL

    'Net acquisition of assets' NAA

'Change in international reserves' ReA
'Errors and omissions' ErrOm
       'Errors and omissions, QoQ' dErrOm
% Other variables
'Urals price' Oil
    'Urals price, QoQ' dOil
'Foreign output gap' y_f
'Russian output gap' y_h
'Foreign interest rate' ir_f
'Russian interest rate' ir_h
'Russian country specific risk premium' rho
'USDRUB, % YoY' dUR
 
%%  Fundamental identity of BoP
!transition_equations
% We divide BoP into four accounts: current account, capital account,
% financial account and reserve changes account. Using the BPM6 we define the BoP identity as follows 
CuA=FaA+ReA - ErrOm;
      
%%  I. Current account
!transition_equations
% Identities    
    CuA = TB + PIA + SIA;
    % Trade balance is a summary from trade in services and goods
    TB = GoB + SeB;
    %...and these are defined as:
    GoB=GoX-GoM;
    % The goods exports does decompose into oil and gas and non-oil&gas
    % exports:
    GoX=GoXOG+GoXNOG;
    
% Behavioural
    %  
    PIA=PIA{-4}+dPIA;
    dPIA=a1_pia*dUR + a2_pia*ir_f-a2_pia*ir_h+e_dPIA;
    
    SIA=SIA{-4}+dSIA;
    dSIA=a1_sia + a2_sia*dUR + e_dSIA;
    
    GoXOG = GoXOG{-4} + dGoXOG;
    dGoXOG= a1_dGoXOG + a2_dGoXOG*dOil  + e_dGoXOG;
    
    GoXNOG = GoXNOG{-4}+dGoXNOG;
    dGoXNOG= a3_dGoXNOG*dUR{-2} + a4_dGoXNOG*y_f+ a5_dGoXNOG*dOil + e_dGoXNOG;    

    GoM = GoM{-4}+dGoM;
    dGoM= a1_dGoM + a2_dGoM*dUR + a3_dGoM*y_h + e_dGoM;
    
    SeB = SeB{-4}+dSeB;
    dSeB=a0_dSeB+a1_dSeB*dUR+a3_dSeB*y_h+e_dSeB;
    
!parameters
    a1_pia = 150.226
    a2_pia = 295.844
    a3_pia = -169.936

    a1_sia
    a2_sia
    
    a1_dGoXOG= 955.797
    a2_dGoXOG= 698.163

    a3_dGoXNOG = -60.7906
    a4_dGoXNOG = 589.568 
    a5_dGoXNOG = 174.367 
   
    a1_dGoM = 0.0
    a2_dGoM = -429.821 
    a3_dGoM = 326.942 
    
    a0_dSeB
    a1_dSeB
    a3_dSeB
    
!transition_shocks
    'Primary income shock' e_dPIA
    'Secondary income shock' e_dSIA
    'Oil&gas export shock' e_dGoXOG
    'Non-oil&gas export shock' e_dGoXNOG
    'Import shock' e_dGoM
    'Services balance shock' e_dSeB

 %% III. Financial account
!transition_equations
    FaA = - NIL + NAA;
    
% Behavioural
    NIL = a1_NIL + a2_NIL*dUR+a3_NIL*ir_f+a4_NIL*ir_h+a5_NIL*rho+ e_NIL;

    NAA = a1_NAA + a2_NAA*dUR+a3_NAA*ir_f+a4_NAA*ir_h+a5_NAA*(rho-rho{-4})+ e_NAA;
        
    !parameters
    a1_NIL = 0.0
    a2_NIL = 201.681 
    a3_NIL = -4350.41 
    a4_NIL = -644.45 
    a5_NIL = 64.6839
    
    a1_NAA = 59070.8
    a2_NAA = 130.514 
    a3_NAA = -6598.92
    a4_NAA = -5034.21
    a5_NAA = 9.54708
    
    !transition_shocks
    e_NIL
    e_NAA
    
    
%% IV. International reserves
    !transition_equations
    ReA =  a3_ReA*ReA{-1} +e_ReA;
    
    ErrOm = ErrOm{-1}+dErrOm;
    dErrOm=a1_dErrOm*dUR+a2_dErrOm*y_h+e_ErrOm;

    !parameters
    a3_ReA = 0.95;

    a1_dErrOm = 264.9798
    a2_dErrOm =  1.4858

   !transition_shocks
    e_ReA
    e_ErrOm
    
    %% V. Exchange rate, interest rates oil and the rest.
    !transition_equations
    Oil= a_oil*Oil{-1}+(1-a_oil)*oil_ss+e_Oil; 
    dOil= Oil-Oil{-4};

    
   y_f = a_y_f*y_f{-1} + (1-a_y_f)*y_f_ss + e_y_f; 
   y_h =a_y_h*y_h{-1} + (1 -a_y_h)*y_h_ss + e_y_h; 

   ir_f = a_y_h*ir_f{-1} + (1 -a_y_h)*ir_f_ss +e_ir_f; 
   ir_h = a_ir_h*ir_h{-1} + (1 -a_ir_h)*ir_h_ss + e_ir_h; 

   rho = a_rho*rho{-1} + (1-a_rho)*rho_ss +e_rho; 

       
    !parameters
    a_oil = 0.9
    oil_ss = 50
    
    a_y_f  = 0.9
    y_f_ss = 0.0
    
    a_y_h = 0.8
    y_h_ss = 0.0
    
    a_ir_f = 0.8
    ir_f_ss = 2.75
    
    a_ir_h = 0.9
    ir_h_ss = 6.5
    
    a_rho = 0.8
    rho_ss=250
      
    !transition_shocks
    e_Oil
    e_y_f
    e_y_h
    e_ir_f
    e_ir_h
    e_rho
    

    
%% Measurement equations
!measurement_variables
% Balance of payments variables

'Goods oil&gas export' o_GoXOG
'Goods non-oil&gas export' o_GoXNOG
 'Goods Import' o_GoM
'Services balance' o_SeB
'Primary income account' o_PIA
'Secondary income account' o_SIA
'Net incurrence of liabilities' o_NIL
'Net aquisition of assets' o_NAA
'Change in international reserves' o_ReA
'Errors and ommisions' o_ErrOm
'Urals price' o_Oil
'Foreign output gap' o_y_f
'Russian output gap' o_y_h
'Foreign interest rate' o_ir_f
'Russian interest rate' o_ir_h
'Russian country specific risk premium' o_rho
'USDRUB, % YoY' o_dUR

!measurement_equations
o_GoXOG=GoXOG;
o_GoXNOG=GoXNOG;
o_GoM=GoM;
o_SeB=SeB;
 o_PIA=PIA;
o_SIA=SIA;
o_NIL=NIL;
o_NAA=NAA;
o_ReA=ReA;
o_ErrOm=ErrOm+e_o_ErrOm;
o_Oil=Oil;
o_y_f=y_f;
o_y_h=y_h;
o_ir_f=ir_f;
o_ir_h=ir_h;
o_rho=rho;
o_dUR=dUR;

!measurement_shocks
 'In order to make the BoP identity to hold exactly' e_o_ErrOm 
    