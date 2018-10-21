fs = 44100;                             
a = audiorecorder(fs, 16, 2);          
record(a);                              
stop(a);                                
b = getaudiodata(a);                    
audiowrite('orig_input.wav', b, fs); 

  [data, fs] = audioread('orig_input.wav'); %Doc lai file ghi am
[rows colums] = size(data);                 %Size cua ma tran data
t = 0 : 1/fs : 1.5;                         %Truc thoi gian
f1 = 430;                                   %Tan so
f2 = 2 * f1;
f3 = 3 * f1;
f4 = 4 * f1;
f5 = 5 * f1;

A1 = .3; A2 = A1/2; A3 = A1/3; A4 = A1/4; A5 = A1/5; 
w = 0;

y1 = A1 * sin( 2 * pi * f1 * t + w );
y2 = A2 * sin( 2 * pi * f2 * t + w );
y3 = A3 * sin( 2 * pi * f3 * t + w );
y4 = A4 * sin( 2 * pi * f4 * t + w );
y5 = A5 * sin( 2 * pi * f5 * t + w );

y = [y1 y2 y3 y5 y3 y5 y1 y4 y1 y2 y3 y4 y3 y5 y2 y2];
data_new = y(1:length(data));
%Tron 2 tin hieu lai voi nhau
for i = 1:colums
    for j = 1:rows
        data_new(j+i) = data(j,i) + y(i+j);
        
    end
end

audiowrite('melody.wav', data_new, fs);
[data_meloly fs_melody] = audioread('melody.wav');

Y = fft(data_meloly);
plot(abs(Y));                       %Ve hinh plot(fft(Y))
figure(1);

N =length(data_meloly);                       %Do dai(so diem) FFT
transform = fft(data_meloly,N)/N;
magTransform = abs(transform);
faxis = linspace(-N/2,N/2,N);
figure(2);
plot(faxis,fftshift(magTransform)); %FFT
xlabel('Frequency (Hz)')
win = 128;                          %Do dai
hop = win/2;                        %So mau tin hieu chong len nhau

%Tao hinh ve
figure(3);
nfft = win;                         %Chieu rong cua pho
spectrogram(data_meloly,win,hop,nfft,fs,'yaxis');
yt = get(gca,'YTick');  
set(gca,'YTickLabel', sprintf('%.0f|',yt))
title('Spectrogram');


