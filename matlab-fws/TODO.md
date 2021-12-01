- Tags:: #NeuroImaging #Functional #Tools #Matlab #Paper #Imperial #Humpshire-Hub #Python 
- Due Date:: [[July 31st, 2020]]
- Goals::  #Publish
- Status:: #ongoing
- Contributors:: [[Richard Daws]] [[Adam Hampshire]]
- =============================================
- ## [[Project TODOs]]
    - ### [[Programing Tasks]]
        - [x] Simplify new WS function as nested functions
            - [x] Cluster function
                - [x] create new function
                - [x] test functionality 
            - [x] Spatial Filter function
            - [x] Input identifier function  
            - [x] Merge Neighbors function  
            - [x] Automatic thresholding - be based initially on IQR
            - [X] label to table #RICH #1
            - [X] Minimal inspection ROI interactive visualization #RICH #2
            - [ ] Automated Text Report Generator #RICH
            - [x] Deal with interpolator   #EYAL #0
        - [ ] Plotting capabilities 
            - [x] MIP plots with numbers as defaults   #EYAL #1
            - [ ] ROI plots with numbers as defaults   #EYAL #2
        - [X] Table Summary Stats capabilities 
        - [ ] HTML report  #EYAL #3
            - [ ] Distribution of the weights
            - [ ] Input MIP plots 
                - [ ] rs ls axial mrs mls
            - [ ] WS parameters as a methods paragraph 
            - [ ] Output ROI plots 
                - [ ] rs ls axial mrs mls
            - [X] Output ROI table 
                - [X] AAL 
                - [X] BA 
                - [X] MNI  - Peak coordinates
                - [X] MNI  -  Center of ROI
                - [X] Volume - (in voxels)
                - [X] Stats [min, mean, max, std]
                - [X] Peak stat 
                - [ ] Pass volume kind to label to table to fix type of stats being mined  
    - ### [[Paper Tasks]]
        - [ ] Create outline [[June 25th, 2020]]
        - [X] Create [[Fusion-Watershed]] example list 
        - [X] Rewrite [[Fusion-Watershed]] algorithm section

	- [ ] Figure 1 - Federenko statistical space thresholded 
		 	 Activation map - selected slices
			 Demo ROI maps, pos activation only 
	

    - [ ] Figure 2 - Federenko statistical space 
		 	 Activation map - selected slices
			 Demo ROI maps, pos activation only 
		 
	- [ ] Figure 3 - Federenko Parameter sweep
			 Small to large neighbourhood radius

	- [ ] Figure 4 - 3D projection atlases intersection
        - [ ] Table 1  - Label_to_table

	- [ ] Figure 5 - Neurosynth Parameter sweep
			 Thresholding: lower, exclude

	- [ ] Figure 6 - Application
			 Clinical example - OCD

	- [ ] Figure 7 - ICA's
			 Volume

 
    - ### [[General Tasks]]
        - [X] Create a [[Fusion-Watershed]] Git repository and share it with Rich 
        - [X] Create a Google document with outline for [[Fusion-Watershed]]
    - ### [[**Learn HowTo**]]
        - [ ] Use [staticjinja](https://github.com/Ceasar/staticjinja) to create html report #HowTo
        - [ ] Use [docx2latex](https://www.docx2latex.com/gdoc_addon/) with thesis plots to create a google doc for fusion-watershed #HowTo
- =============================================
- ## [[Outline]]
    - **Important Things**
        - Simplicity and Transparency 
        - The gist is point and create 
        - The function also has some more advanced capabilities 
    - ## **The default behaviour is: **
        - Convert a nifti file to ROI's based on local morphology 
        - Output a ROI nifti file, HTML report, csv table 
