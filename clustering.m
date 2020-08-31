function clustering(input_file, distance, k, max_peaks)
  
  disp('Loading the data')
  % Load the dataacube
  load(input_file);
  
  disp('Extracting name and filepath')
  [filepath,name,ext] = fileparts(input_file)
  
  % Calculate the mean spectrum
  disp('Calculate mean spectrum')
  mean_intensity_all = mean(data);
  
  % Make a smaller datacube of the topk peaks
  disp('Making small datacube')
  [~, top_peaks_idx] = maxk([mean_intensity_all], max_peaks);
  small_data = data(:,top_peaks_idx);

  disp('Running k-means clustering')
  [kmeans_idx, ~, ~ ] = kmeans(small_data, k, 'distance', distance);

  %% Make mean spectrum
disp('Calculate cluster mean spectra')
  data_k1 = data(kmeans_idx == 1,:);
  data_k2 = data(kmeans_idx == 2,:);

  mean_intensity_k1 = mean(data_k1);
  mean_intensity_k2 = mean(data_k1); 
  
  clear data_k1
  clear data_k2
  clear small_data

  % Write into the mat file
  disp(['Saving workspace to: ' name '.mat'])
  save([name '_processed.mat'], '-v7.3');

  
 end
