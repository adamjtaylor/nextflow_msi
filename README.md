# nextflow_msi
Working up a nextflow pipeline to convert and process MSI data with SpectralAnalysis

to run ensure you have nextflow installed then cd to the folder you wish the output directory to be placed

Then run the following command

    nextflow run adamjtaylor/nextflow_msi -r master --imzml "path-to-imzml" --sap "path-to-preprocessing-workflow-file" --sa_path "path-to-spectralanalysis --outdir "processed_data"

To process files together specify

    nextflow run adamjtaylor/nextflow_msi -r process_together --imzml_folder "path-to-folder-containing-imzmls" --sap "path-to-preprocessing-workflow-file" --outdir "processed_data"

In a reproducible  environment this will
- make the mean spectrum using the specified preprocessing file
- peak pick with 3x non zero median threshold
- produce a datacue
- make a small datacube of top 500 peaks for clustering
- k-means cluster with cosine distance and k = 2
- save mean spectra of each cluster
- preduct which cluster is the background by taking the modal cluster of the edge pixels
- save datacube, pixel locations and mean spectra
- return these in a matlab v7.3 (hdf5) file

It will output a matlab -v7.3 file (which can be opened as a hdf5 in R, Python or similar containing the following objects

Show in New WindowClear OutputExpand/Collapse Output
 - "bg_cluster"              
 - "class"                   
 - "data" a matrix containign the integrated peak intensities per pixel. Pixels are rows. Peaks are columns               
- "distance" - a string containing the distance matrix used for k-means clustering                
- "edge_clusters" - a vector containing the cluster assigned for each of the pixels with min/max x/y coords        
- "edges" - vector with the index of the pixels that are at min/max x/y coords                
- "height" - height of the image in pixels                 
- "input_file" - name of the file input into the last step of processing. Should be 'datacube.mat'             
- "isContinuous"           
- "isRowMajor"              
- "k" - Number of clusteres used for clustering. Will be set to 2                     
- "kmeans_idx" - clustering results per pixel             
- "max_peaks" - number of peaks set for the small datacube used for clustering              
- "mean_intensity_all"  - mean intensity for all pixels    
- "mean_intensity_bg" mean intensity for pixels in cluster assigned as background     
- "mean_intensity_k1" mean intensity for pixels in cluster 1      
- "mean_intensity_k2" mean intensity for pixels in cluster 2      
- "mean_intensity_tissue" mean intensity for pixels in cluster assigned as tissue 
- "name" name of the input imzml                   
- "pixelIndicies" - indicies for the pixels          
- "pixels" x and y coordinates of the pixels                
- "sa_path" path to the version of spectralanalysis ysed                
- "spectralChannelRange" range of mz values   
- "spectralChannels" values of mz in data      
- "tb_ratio" vector of tissue background ratio per peak               
- "tissue_cluster" assignment of the tissue cluster         
- "tissue_peak_idx" indicies of the peaks wich have a log2(tissue/background) ratio above 0       
- "tissue_pixel_idx" indicies of the pixels that are in the tissue assigned cluster       
- "tissue_spectralChannels" vector of mz values which have log2(tissue/background) ratio above 0 
- "top_peaks_idx" index of peaks used for kmeans clustering (defaults to 500 most intense         
- "width" width of the image in pixels         

TODO

- [ ] Install SA within container if location not speficied
- [x] Allow to work in parallel through multiple files
- [x] Define preprocessing file - currenrly defaults to interpolation ppm rebin between m/z 50-1200 with 5 ppm bin width
