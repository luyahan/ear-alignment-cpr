# Ear alignment using Cascaded Pose Regression

This library is fork of [Piotrs Dollar](https://github.com/pdollar/) Cadcaded Pose Regression library([download link](http://pdollar.github.io/files/code/cpr/cprV1.00.zip)). Library successfully determines orientation and position of predefined model on picture. LIbrary requires Matlab Image Processing Toolbox and [Piotr's Matlab Toolbox](http://pdollar.github.io/toolbox/) (version 3.00 or later). The code was tested on Matlab R2015b.

THIS IS FROM CPR README

4. Getting Started.

The code is quite compact, as is the method. Start with cprDemo.m which first generates toy data, then trains a CPR model, 
and finally displays the error and example results. The demo should take under 5 minutes to run, including training time. 
To run CPR with your own data start with cprDemo.m but replace the toy data with real data (using the same format). You may 
also want to update poseGt.m to define a new pose model (models in poseGt are provided for fish, mouse, and face data) and 
poseLabeler to label ground truth pose.

###################################################################

5. Contents.

Code:
   cprApply     - Apply multi stage pose regressor.
   cprDemo      - Demo demonstrating CPR code using toy data.
   cprTrain     - Train multistage pose regressor.
   poseGt       - Object pose annotations struct.
   poseLabeler  - Pose labeler for static images.

Other:
    bsd.txt     - Simplified BSD License.
    readme.txt  - This file.