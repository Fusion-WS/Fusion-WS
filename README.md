# Fusion-WS

The ***FU***nctional & ***S***tructural ***I***ntegration ***O***f ***N***euroimages (Fusion) - ***W***ater***S***hed (WS) toolbox.

The Fusion-WS toolbox provides a data-driven pipeline for creating regions of interest (ROIs) from 3D functional MRI (fMRI) task activation contrasts. At its core, Fusion-WS relies on a variant of the classic watershed algorithm<sup>1</sup> to transform smooth continuous statistical spaces into discrete ROIs. Watershed is an elegant but naive approach that doesn't assume gaussianity or apriori knowledge of the number of clusters/ROI (in contrast to *k*-means, for example).

The current Fusion-WS toolbox is implemented in Matlab. 

### Matlab versions & toolboxes
Fusion-WS has been tested on Matlab 2018 & up. Fusion-WS assumes the following Matlab toolboxes are installed and in your path:
```
image_toolbox
signal_toolbox
statistics_toolbox
```

### Installation 
Download and unzip into your Matlab path. 

### Default pipeline - DEMO
The default pipeline is called with ```fws.generate_ROI.m``` and will run the watershed ROI creation using an fMRI task activation map of the multiple-demand cortex<sup>2</sup>. An interactive GUI will be generated to visualise the input map alongside a 3D render of the ROIs and some basic summaries of the ROI volume and peak voxel magnitudes. The demo can be simply called by:

```
fws.generate_ROI("demo")
```





The only required input to the function is a valid path to a ```.nii``` or ```nii.gz```. 

```
fws.generate_ROI("my_fMRI_activation_map.nii")
```


### References
1. Meyer, F. and Beucher, S., 1990. Morphological segmentation. Journal of visual communication and image representation, 1(1), pp.21-46.
2. Fedorenko, E., Duncan, J. and Kanwisher, N., 2013. Broad domain generality in focal regions of frontal and parietal cortex. Proceedings of the National Academy of Sciences, 110(41), pp.16616-16621.
