function make_datacube(input_imzml, input_sap)

sa_path = 'SpectralAnalysis';

[filepath,name,ext] = fileparts(input_imzml)


% Set up datacube generation variables

% Preprocessing file (.sap) location
nzm_multiple = 3; % multiple of non zero median

% Add SpectralAnalysis to the path - this only needs to be done once per MATLAB session
disp('Setting up ');
addpath(genpath(sa_path));
addJARsToClassPath();

% Generate preprocessing workflow
preprocessing = PreprocessingWorkflow();
preprocessing.loadWorkflow(input_sap);

peakPicking = GradientPeakDetection();
medianPeakFilter = PeakThresholdFilterMedian(1, nzm_multiple);
peakPicking.addPeakFilter(medianPeakFilter);

% Move the inout file folder to assure access to the ibd
work_folder = cd(filepath);

%% make datacubes from each dataset

% obtain total spectrum
disp(['Generating Total Spectrum for ' ,input_imzml]);
parser = ImzMLParser(input_imzml);
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

%% Save all

cd(work_folder);

save([name '.mat'], '-struct', 'dataRepresentation_struct', '-v7.3')
 

exit;