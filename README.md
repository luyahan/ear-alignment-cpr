# Ear alignment using Cascaded Pose Regression

### Description
This library is fork of [Piotrs Dollar](https://github.com/pdollar/) Cadcaded Pose Regression library([download link](http://pdollar.github.io/files/code/cpr/cprV1.00.zip)). Library successfully determines orientation and position of predefined model on picture from trained regresson. Based on model position and orientation algorithem then align ear in its natural position. 

This library and research was part of my bachelor thesis and it is avaliable [here](http://eprints.fri.uni-lj.si/3674/1/63110173-METOD_RIBI%C4%8C-Vpliv_poravnave_na_uspe%C5%A1nost_razpoznavanja_uhljev-1.pdf) (in Slovene)

### Requirements
Library requires Matlab Image Processing Toolbox and [Piotr's Matlab Toolbox](http://pdollar.github.io/toolbox/) (version 3.00 or later). The code was tested on Matlab R2015b.

### How to use

- Use poseLabeler.m to label your train (to label ground truth pose)
- cprDemo.m is main function for running CPR
  - You should change parameters depending on your input data (train or test) inside cprDemo:
  ```matlab
  	% number of sample images devided by 2
  	n0, n1 = 50 

  	% number of all input images !!!min. is 100!!!
  	d = 100 

  	% train images, should contain result atribute which stores images
  	data = load('trainImages.mat'); 

  	% train annotations from poseLabeler.m, should contain result atribute which stores annotations
  	$ primarly annotations from poseLabeler are in .txt files, you should use txt_to_mat_converter.m to convert .txt files into one .mat file
  	annotation = load('trainImages_annotations.mat');

  	% train or load/apply regressor

	if( 0 ) 
		% training
	else
		% alignment
	end
   ```

  **NOTE:** All code inside alignment block should be customized based on your needs. For my resarch was crutial to have unaligned set and therefore I needed map matrix to know how to save images.

- Images are aligned based on enclosing ractangle of ellipse get from cpr algorithm.
- If you want to define new model update poseGt.m (this script is original from cpr library and was not chaneg for this research)
  
### Resources
1. Piotr Dollár, Peter Welinder, and Pietro Perona. [Cascaded pose regression](http://web.bii.a-star.edu.sg/~zhangxw/files/Cascaded%20pose%20regression.pdf). In Computer Vision and Pattern Recognition (CVPR), IEEE Conference on, pages 1078-1085, 2010.

2. Anika Pflug and Christoph Busch. [Segmentation and normalization of human ears using cascaded pose regression](https://www.dasec.h-da.de/wp-content/uploads/2014/07/PflugBuch-CPR-NordSec2014.pdf). In Nordic Conference on Secure IT Systems, (NordSec), pages 261-272, 2014.

3. Žiga Emeršič, Vitomir Štruc, and Peter Peer. [Ear recognition: More than a survey](https://arxiv.org/pdf/1611.06203v1.pdf). Accepted in Neurocomputing, 2016.
