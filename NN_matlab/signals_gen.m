clc
clear all
%% SNR Problem
uintyRandomVectorEnergy = 2.497702391949678e+02;
getSDfromSNR(-13)
%% Ploting the Half Sine shape.

%format long;

Tc = 1/(2e6);
Time_Axes_number_of_points = (Tc/5)^-1;
Time_Axes_of_the_half_sine = linspace(0, 2*Tc, Time_Axes_number_of_points);

Positive_Half_Sine = sin(pi * 1/(2*Tc) * Time_Axes_of_the_half_sine);
Negative_Half_Sine = -1.*Positive_Half_Sine;

I_1_HALF = Positive_Half_Sine(length(Positive_Half_Sine)/2 +1 : length(Positive_Half_Sine));
I_0_HALF = Negative_Half_Sine(length(Negative_Half_Sine)/2 +1 : length(Negative_Half_Sine));

Q_1_HALF = Positive_Half_Sine(1 : length(Positive_Half_Sine)/2);
Q_0_HALF = Negative_Half_Sine(1 : length(Negative_Half_Sine)/2);

%%

    A  = 1;
    Fc = 2.455e9 - 2.445e9;
    ph_offset = 0;
    fr_offset = 0;
    
    
    cosine_wave = A * cos((2*pi*(Fc+fr_offset)*Time_Axes_of_the_half_sine) +  ph_offset);
    positive_half_sine_by_cosine = Positive_Half_Sine.*cosine_wave;
    valueH = positive_half_sine_by_cosine(length(positive_half_sine_by_cosine)/2 +1 : length(positive_half_sine_by_cosine));
    zeroH = zeros(size(valueH));
    half_positive_half_sine_by_cosine = [zeroH valueH];

    negative_half_sine_by_cosine = Negative_Half_Sine.*cosine_wave;
    valueH = negative_half_sine_by_cosine(length(negative_half_sine_by_cosine)/2 +1 : length(negative_half_sine_by_cosine));
    zeroH = zeros(size(valueH));
    half_negative_half_sine_by_cosine = [zeroH valueH];
    
    
    sine_wave = A * sin((2*pi*(Fc+fr_offset)*Time_Axes_of_the_half_sine) +  ph_offset);  
    positive_half_sine_by_sine = Positive_Half_Sine.*sine_wave;
    valueH = positive_half_sine_by_sine(1 : length(positive_half_sine_by_sine)/2);
    zeroH = zeros(size(valueH));
    half_positive_half_sine_by_sine = [zeroH valueH];

    negative_half_sine_by_sine = Negative_Half_Sine.*sine_wave;
    valueH = negative_half_sine_by_sine(1 : length(negative_half_sine_by_sine)/2);
    zeroH = zeros(size(valueH));
    half_negative_half_sine_by_sine = [zeroH valueH];

%%
%%
%%
%%
noiseVector = 0 * randn(1, length(I_1_HALF));
t_samp = linspace(0, 1*Tc, 200);


signal1 = generateNNSIGNALS(1, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine);
signal2 = generateNNSIGNALS(2, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine);
signal3 = generateNNSIGNALS(3, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine);
signal4 = generateNNSIGNALS(4, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine);

figure
plot(t_samp, signal1, 'LineWidth', 2);axis([0, 1*Tc, -1.25, 1.25]);
title('Signal')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on
hold on
plot(t_samp, signal2, 'LineWidth', 2);axis([0, 1*Tc, -1.25, 1.25]);
title('Signal')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on
hold on
plot(t_samp, signal3, 'LineWidth', 2);axis([0, 1*Tc, -1.25, 1.25]);
title('Signal')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on
hold on
plot(t_samp, signal4, 'LineWidth', 2);axis([0, 1*Tc, -1.25, 1.25]);
title('Signal')
xlabel('Time (seconds)')
ylabel('Amplitude')
grid on

legend("Symbol 00", "Symbol 01", "Symbol 10", "Symbol 11")

 getSDfromSNR(-8)

SymbolArray = [1 2 3 4];
%%
%%
%%
%%
train_depth = 10000;
NN_Signals = zeros(1, 250);
TR_Signals = zeros(1, 250);
NN_label = zeros(1, 1);
TR_label = zeros(1, 1);

SNRs = [-5.5, -6.5, -7.5, -8.5, -9.5, -10.5, -11, -11.5, -12, -12.5, -13];

    state = 0;
    for inx = 1:1:train_depth
        symbol_num = randi(4);
        noiseVector = getSDfromSNR(-13) * randn(1, length(I_1_HALF));
        if(state == 0)
           NN_Signals = generateNNSIGNALS(symbol_num, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine);
           %TR_Signals = generateTRSIGNALS(symbol_num, noiseVector, I_1_HALF, I_0_HALF, Q_1_HALF, Q_0_HALF);
           NN_label = symbol_num;
           %TR_label = symbol_num;
           state = 1;    
        else
           NN_Signals = vertcat(NN_Signals, generateNNSIGNALS(symbol_num, noiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine));
           %TR_Signals = vertcat(TR_Signals, generateTRSIGNALS(symbol_num, noiseVector, I_1_HALF, I_0_HALF, Q_1_HALF, Q_0_HALF));
           NN_label = vertcat(NN_label, symbol_num);
           %TR_label = vertcat(TR_label, symbol_num);
        end
    end   

    writematrix(NN_Signals, 'NN_Signals_n13dB_10k.xlsx', 'Sheet', 1);
    writematrix(NN_label, 'NN_label_n13dB_10k.xlsx', 'Sheet', 1);
    
%     
% switch s
%     case 1
%         writematrix(NN_Signals, 'NN_Signals_n5.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n5.5dB_10k.xlsx', 'Sheet', 1);
%     case 2
%         writematrix(NN_Signals, 'NN_Signals_n6.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n6.5dB_10k.xlsx', 'Sheet', 1);
%     case 3
%         writematrix(NN_Signals, 'NN_Signals_n7.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n7.5dB_10k.xlsx', 'Sheet', 1);
%     case 4
%         writematrix(NN_Signals, 'NN_Signals_n8.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n8.5dB_10k.xlsx', 'Sheet', 1);
%     case 5
%         writematrix(NN_Signals, 'NN_Signals_n9.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n9.5dB_10k.xlsx', 'Sheet', 1);
%     case 6
%         writematrix(NN_Signals, 'NN_Signals_n10.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n10.5dB_10k.xlsx', 'Sheet', 1);   
%     case 7
%         writematrix(NN_Signals, 'NN_Signals_n11dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n11dB_10k.xlsx', 'Sheet', 1);
%     case 8
%         writematrix(NN_Signals, 'NN_Signals_n11.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n11.5dB_10k.xlsx', 'Sheet', 1);
%     case 9
%         writematrix(NN_Signals, 'NN_Signals_n12dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n12dB_10k.xlsx', 'Sheet', 1);
%     case 10
%         writematrix(NN_Signals, 'NN_Signals_n12.5dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n12.5dB_10k.xlsx', 'Sheet', 1);
%     case 11
%         writematrix(NN_Signals, 'NN_Signals_n13dB_10k.xlsx', 'Sheet', 1);
%         writematrix(NN_label, 'NN_label_n13dB_10k.xlsx', 'Sheet', 1);
%     end
%%
%%
%%

function result = generateNNSIGNALS(symbol, NoiseVector, half_positive_half_sine_by_sine, half_negative_half_sine_by_sine, half_positive_half_sine_by_cosine, half_negative_half_sine_by_cosine)
    
    switch symbol
        case 4
            sym1_ZV = half_positive_half_sine_by_sine + half_positive_half_sine_by_cosine;   
        case 3
            sym1_ZV = half_negative_half_sine_by_sine + half_positive_half_sine_by_cosine;  
        case 2
            sym1_ZV = half_positive_half_sine_by_sine + half_negative_half_sine_by_cosine;  
        case 1
            sym1_ZV = half_negative_half_sine_by_sine + half_negative_half_sine_by_cosine;  
    end

    center = length(sym1_ZV)/2 + 1;
    step = 25000;
    sym_noise = NoiseVector + sym1_ZV(1, center : end);
    sym_sample = sampleTheSignal(sym_noise, step);
    
    result = sym_sample;
end

function result = generateTRSIGNALS(symbol, NoiseVector, I_1_HALF, I_0_HALF, Q_1_HALF, Q_0_HALF)
    
    switch symbol
        case 4
            sym1_ZV = Q_1_HALF + I_1_HALF;   
        case 3
            sym1_ZV = Q_0_HALF + I_1_HALF;  
        case 2
            sym1_ZV = Q_1_HALF + I_0_HALF;  
        case 1
            sym1_ZV = Q_0_HALF + I_0_HALF;  
    end

    center = length(sym1_ZV)/2 + 1;
    step = 20000;
    sym_noise = sym1_ZV + NoiseVector;
    sym_sample = sampleTheSignal(sym_noise, step);
    
    result = sym_sample;
end

function result = addNoise(var, signal_vector)
    result = signal_vector + ( var * randn(1, length(signal_vector)));
end

function result = sampleTheSignal(signal, step)
    i=1;
    for inx = 1:step:length(signal)
            temp(i) = signal(inx);
            i=i+1;
    end
    result = temp;
end

function SD = getSDfromSNR(snr)
URE = 2.497702391949678e+02;
SD = sqrt((125.5*0.5)/(URE*(10^(snr/10))));
end

function y = ChangeResolution(x, res)
    temp1 = x ./ res;
    temp2 = round(temp1);
    y = temp2 .* res;
end


function y = fixed(x)
    y = fi(x, 1, 14, 10);
end