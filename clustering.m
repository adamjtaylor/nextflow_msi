function clustering(input_file, distance, k, max_peaks)
  
  % Load the dataacube
  load(input_file);
  
  % Calculate the mean spectrum
  mean_intensity_all = mean(data);
  
  % Make a smaller datacube of the topk peaks
  
  [~, top_peaks_idx] = maxk([mean_intensity_all], max_peaks);
  small_data = data(:,top_peaks_idx);

  [kmeans_idx, ~, ~ ] = kmeans(small_data, k, 'distance', distance);

  %% Make mean spectrum

  data_k1 = data(kmeans_idx == 1,:);
  data_k2 = data(kmeans_idx == 2,:);

  mean_intensity_k1 = mean(data_k1);
  mean_intensity_k2 = mean(data_k1); 
  
  clear data_k1
  clear data_k2
  clear small_data

  % Write into the mat file
  
  save(input_file, ...
  'spectralChannels', 'kmeans_idx', ...
  'top_peaks_idx', 'mean_intensity_k1', 'mean_intensity_k2', 'mean_intensity_all',...
  'distance', 'k', 'max_peaks',...
  '-append')
  
 end
