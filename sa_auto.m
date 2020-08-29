function sa_auto(input_file)

sa_path = 'SpectralAnalysis';

[filepath,name,ext] = fileparts(input_file)


% Set up datacube generation variables

% Preprocessing file (.sap) location
preprocessingWorkflowFile = './preprocessingWorkflow.sap'; 
nzm_multiple = 3; % multiple of non zero median

% Add SpectralAnalysis to the path - this only needs to be done once per MATLAB session
disp('Setting up ');
addpath(genpath(sa_path));
addJARsToClassPath();



% Generate preprocessing workflow
preprocessing = PreprocessingWorkflow();
preprocessing.loadWorkflow(preprocessingWorkflowFile);

peakPicking = GradientPeakDetection();
medianPeakFilter = PeakThresholdFilterMedian(1, nzm_multiple);
peakPicking.addPeakFilter(medianPeakFilter);

% Move the inout file folder to assure access to the ibd
work_folder = cd(filepath);


%%
%for i = 1:length(filesToProcess)
    disp(['Processing ' name]);

 %   input_file = [filesToProcess(i).folder filesep filesToProcess(i).name];

    % Get the filename from the path
    %[~, filename, ~] = fileparts(input_file);

    %% make datacubes from each dataset

    % obtain total spectrum
    disp(['Generating Total Spectrum for ' ,input_file]);
    parser = ImzMLParser([name ext]);
    parser.parse;
    data = DataOnDisk(parser);

    spectrumGeneration = TotalSpectrum();
    spectrumGeneration.setPreprocessingWorkflow(preprocessing);

    totalSpectrum = spectrumGeneration.process(data);
    totalSpectrum = totalSpectrum.get(1);

    %% Peak picking
    disp('Peak picking ');
    peaks = peakPicking.process(totalSpectrum);
    
    spectralChannels_all = totalSpectrum.spectralChannels;
    spectralChannels = [peaks.centroid];

    %% Make datacube
    disp(['! Generating data cube with ' num2str(length(peaks)) ' peaks...'])

    % If peakTolerance < 0 then the detected peak width is used
    peakTolerance = -1;

    reduction = DatacubeReduction(peakTolerance);
    reduction.setPeakList(peaks);

    % Inform the user whether we are using fast methods for processing (i.e. Java methods)
    addlistener(reduction, 'FastMethods', @(src, canUseFastMethods)disp(['! Using fast Methods?   ' num2str(canUseFastMethods.bool)]));
    
    dataRepresentationList = reduction.process(data);

    % We only requested one data representation, the entire dataset so extract that from the list
    dataRepresentation = dataRepresentationList.get(1);
    % Convert class to struct so that if SpectralAnalysis changes the DataRepresentation class, the data can still be loaded in
    dataRepresentation_struct = dataRepresentation.saveobj();

    datacube = dataRepresentation.data;
    pixels = dataRepresentation.pixels;

    %% K means clustering
    disp('Performing k-means clustering on top 1000 peaks with k = 2 and cosine distance')

    [~, top1000idx] = maxk([peaks.intensity], 1000);
    datacube_small = datacube(:,top1000idx);

    [kmeans_idx, kmeans_c, ~, ~ ] = kmeans(datacube_small, 2, 'distance', 'cosine');

    %% Make mean spectrum
    disp('Saving cluster mean spectra')

    datacube_clust1 = datacube(kmeans_idx == 1,:);
    datacube_clust2 = datacube(kmeans_idx == 2,:);

    mean_intensity_clust1 = mean(datacube_clust1);
    mean_intensity_clust2 = mean(datacube_clust2);
    mean_intensity_all = mean(datacube);

    %% Save all
    disp('Saving files')
    
    cd(work_folder);

   save([name '.mat'], '-struct', 'dataRepresentation_struct', '-v7.3')
   save([name '.mat'], ...
       'peaks', 'spectralChannels_all', 'spectralChannels', 'kmeans_idx', 'kmeans_c', ...
       'top1000idx', 'mean_intensity_clust1', 'mean_intensity_clust2', 'mean_intensity_all',...
       '-append')
 


    disp([name ' complete']);

exit;
