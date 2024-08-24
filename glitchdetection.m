function [hours,minutes,seconds,glitchtime]=glitchdetection(Fs,y,t)
figure;
plot(t, y);
title('Original Signal with Glitches');
xlabel('Time (s)');
ylabel('Amplitude');
hold on;
glitchtime = [];
for i = 1:Fs:length(y)-Fs

    segment = y(i:i+Fs-1);
    Y = fft(segment);
    P2 = abs(Y/Fs);
    P1 = P2(1:Fs/2+1);
    P1(2:end) = 2*P1(2:end);
    f = Fs*(0:(Fs/2))/Fs;
    [max_amplitude, max_idx] = max(P1);
    peak_frequency = f(max_idx) ;
    % Set the threshold frequency for glitch detection
    threshold_frequency = 50; % Hz
    % Check if the peak frequency is within the threshold
  if peak_frequency < threshold_frequency || peak_frequency > threshold_frequency
        % Calculate time of glitch
        glitchtime = i / Fs;
       
        plot(glitchtime, y(i), 'ro'); 
       
        hours = floor(glitchtime / 3600);
        minutes = floor(mod(glitchtime, 3600) / 60);
        seconds = mod(glitchtime, 60);
        disp(['Glitch Detected at time: ', num2str(hours), ' hours, ', num2str(minutes), ' minutes, ', num2str(seconds), ' seconds']);
  end
end
hold off;
end