# nextflow_msi
Working up a nextflow pipeline to convert and process MSI data with SpectralAnalysi

to run ensure you have nextflow installed then cd to the folder you wish the output directory to be placed

Then run the following command

    nextflow run adamjtaylor/nextflow_msi --in "path_to_imzml" --outdir "output_dir_name"

In a reproducible contanarised environemnt this will
- zero fill
- make the mean spectrum,
- peak pick with 3x non zero median threshold
- produce a datacue
- make a small datacube of top 500 peaks for clustering
- k-means cluster with cosine distance and k = 2
- save mean spectra of each cluster
- save datacube, pixel locations and mean spectra
- return these in a matlab v7.3 (hdf5) file
