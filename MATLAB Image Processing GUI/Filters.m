% --- Determine which filter is being called and return the result_img --- %

function result_img = Filters(initial_img, filter, freq_level,threshold_freq)
    if strcmp(filter, 'Butterworth')
        if strcmp(freq_level, 'Low')
            result_img = ButterworthLowPassFilter(initial_img, threshold_freq);
            disp('Butterworth low pass')
        elseif strcmp(freq_level, 'High')
            result_img = ButterworthHighPassFilter(initial_img, threshold_freq);
            disp('Butterworth high pass')
        end
        
    elseif strcmp(filter, 'Gaussian')
        if strcmp(freq_level, 'Low')
            result_img = GaussianLowPassFilter(initial_img, threshold_freq);
            disp('Gaussian low pass')
        elseif strcmp(freq_level, 'High')
            result_img = GaussianHighPassFilter(initial_img, threshold_freq);
            disp('Gaussian high pass')
        end
    end
