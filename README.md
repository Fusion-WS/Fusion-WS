# Fusion-WS

The ***FU***nctional & ***S***tructural ***I***ntegration ***O***f ***N***euroimages (Fusion) - ***W***ater***S***hed (WS) toolbox.

The Fusion-WS toolbox provides a data-driven pipeline for creating regions of interest (ROIs) from 3D functional MRI (fMRI) task activation contrasts. At its core, Fusion-WS relies on a variant of the classic watershed by floodfill immersion algorithm<sup>1</sup> to transform smooth continuous statistical spaces into discrete ROIs. Watershed is an elegant but naive approach that doesn't assume spatial gaussianity or require apriori knowledge of the number of clusters/ROI (in contrast to *k*-means, for example).

The current Fusion-WS toolbox is implemented in `Matlab`.
<br>

## Matlab versions & toolboxes
Fusion-WS has been tested on Matlab 2018 & up. Fusion-WS assumes the following Matlab toolboxes are installed and in your path:
```
image_toolbox
signal_toolbox
statistics_toolbox
```
<br>

## Installation 
Download and unzip into your Matlab path. 
<br>

## DEMO - Default pipeline
The default pipeline is called with `fws.generate_ROI.m` and will run the watershed ROI creation using an fMRI task activation map of the multiple-demand cortex<sup>2</sup>. An interactive GUI will be generated to visualise the input map alongside a 3D render of the ROIs and some basic summaries of the ROI volume and peak voxel magnitudes. The demo can be simply called by:

```
fws.generate_ROI("demo")
```
<br>

## Default pipeline stages
<br>1.
<br>1.
<br>1.
<br>1.
<br>1.
<br>1.



Calling the default Fusion-WS pipeline (Figure XX) will perform the following sequential steps: (1) Preprocessing, (2) Watershed clustering, (3) ROI statistics and anatomical labelling, (4) Interactive ROI visualisation and (5) Data reporting and exporting. Each of these stages are described in turn below. 


# Using your own data
Simply provide a valid pathname to a `.nii` or `.nii.gz` file to the `fws.generate_ROI.m` function:
```
fws.generate_ROI("path/to/my_fMRI_activation_map.nii")
```
<br>

## Fusion-WS parameters
There are 3 key parameters that influence each stage of the Fusion-WS clustering referred to as `Filter`, `Radius` and `Merge`.

<br>1. `Filter` is applied after the input data is transformed into independent connected components. Components beneath the 'Filter' volume threshold are discarded.
<br>2. `Radius` is the floodfill radius of the watershed algorithm deployed duriung the initial ROIs definition (applied to each connected component). A larger 'Radius' will typically generate a smaller ROI set of ROIs with larger volumes. 
<br>3. `Merge` determines whether neighbouring ROIs below the 'merge' volume are merged. A larger 'merge' will discourage smaller ROIs in the final ROI set.  

### References
1. Meyer, F. and Beucher, S., 1990. Morphological segmentation. Journal of visual communication and image representation, 1(1), pp.21-46.
2. Fedorenko, E., Duncan, J. and Kanwisher, N., 2013. Broad domain generality in focal regions of frontal and parietal cortex. Proceedings of the National Academy of Sciences, 110(41), pp.16616-16621.
