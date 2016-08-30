%% Demo demonstrating CPR code using toy data.

%% generate toy training and testing data
RandStream.getGlobalStream.reset(); n0=53; n1=52; n2=0;
model=poseGt('createModel','ellipse'); d=100;
model.parts(1).sigs(1:3)=[10 10 pi];
% [Is,p] = poseGt('toyData',model,n0+n1+n2,d,d,'noise',.2);
% Load ears
data = load('set105_orig_images_TEST.mat');
Is = data.result;
% Load annotations
annotation = load('set254_orig_annotations.mat');
p = annotation.result;
% figure(1); poseGt('draw',model,Is,p);
save('set254-data','Is','model','p','n0','n1','n2');

%% load data and split into training and testing data
name='set254'; d=load([name '-data']); name=[name '00'];
Is=d.Is; 
model=d.model; 
p=d.p; 
n0=d.n0; 
n1=d.n1; 
n2=d.n2; 
clear d;
if(n1==0), n1=n2; end; 
p0=p(1:n0,:); 
p1=p(n0+(1:n1),:);
Is=permute(Is,[1 2 4 3]); 
Is0=Is(:,:,:,1:n0); 
Is1=Is(:,:,:,n0+(1:n1));
clear Is p n2;

%% train or load regressor
if( 0 ) % train regressor
  RandStream.getGlobalStream.reset(); L=ceil(4000/n0);
  if( 1 ), F=64; R=32; T=512; else F=128; R=1024; T=512; end
  ftrPrm = struct('type',2,'F',F,'radius',1.66);
  fernPrm = struct('thrr',[-1 1]/5,'reg',.01,'S',5,'M',1,'R',R,'eta',1);
  cprPrm = struct('model',model,'T',T,'L',L,'ftrPrm',ftrPrm,...
    'fernPrm',fernPrm,'regModel',[],'verbose',1 );
  tic, [regModel,pa0]=cprTrain(Is0,p0,cprPrm); T=regModel.T; toc
  if(1), save([name '-model'],'regModel','cprPrm'); end
else % load regressor
  d=load([name '-model']); regModel=d.regModel; clear d;
  tic, [d,pa0] = cprApply( Is0, regModel ); toc
end

%% apply regressor to test data
tic, [d,pa1] = cprApply( Is1, regModel ); toc

%% display training/testing error as function of T
% lks=[model.parts.lks]; m=length(model.parts); f=2.5;
% nms=['dx','dy',repmat({'angle','scale','aspr'},1,m)];
% [ds0,dsa0]=poseGt('dist',model,pa0,p0); dsa0=dsa0(:,lks==0,:);
% [ds1,dsa1]=poseGt('dist',model,pa1,p1); dsa1=dsa1(:,lks==0,:);
% ds0m=squeeze(median(ds0)); dsa0m=squeeze(median(dsa0))'; dse0=ds0(:,end);
% ds1m=squeeze(median(ds1)); dsa1m=squeeze(median(dsa1))'; dse1=ds1(:,end);
% d=sqrt(dse0); fprintf('train-loss mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
% d=sqrt(dse1); fprintf('test-loss  mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
% figure(1); clf; h1=loglog(dsa1m,'-'); hold on; loglog(dsa0m,':');
% loglog(ds0m,':k','LineWidth',3); loglog(ds1m,'-k','LineWidth',3);
% legend(h1,nms(lks==0)); set(h1,'LineWidth',1); axis tight
% if(0), savefig([name '-T-plot'],'jpeg'); end
% fail=squeeze(mean(ds1>f^2)); figure(2); semilogx(fail,'--r');

%% display some results
% figure(5); poseGt('drawRes',model,Is1,p1,pa1(:,:,end),'nCol',10);
% figure(6); poseGt('drawRes',model,Is0,p0,pa0(:,:,end),'nCol',10);
% if(0), savefig([name '-examples'],'jpeg'); end

%% save images

map = load('set105_map_matrix_TEST');
map = map.map;
index=1;
Is0 = uint8(Is0);
% for k = 1:size(Is0,4)
% %     figure(9);
%     %TODO SEGMENTATION
%     %rotation
%     test = imresize(imrotate(Is0(:,:,k), p0(k,5)*(-57.2957795)), [100 100]);
% %     imshow(test);
% %     imwrite(test, ['TEST_aligned/',int2str(k),'.png'])
% 
%     % check if dir exist
%     folderName = map{index};
%     folderName = folderName(1:3);
%     if ~exist(['TEST_aligned/',folderName], 'dir')
%         % Folder does not exist so create it.
%         mkdir(['TEST_aligned/',folderName]);
%     end
%     imwrite(test, ['TEST_aligned/',map{index}])
%     index = index + 1;
% end

Is1 = uint8(Is1);
% get absolute positions of elipses
bbs=poseGt('getBbs', model,p1,1);
p1_1 = p1;
p1 = bbs;
for k = 2:size(Is1,4)
    % angle of ear
    theta = (p1_1(k,5)*(-180)/pi);

    %rotate & scale image
        earIm = Is1(:,:,:,k);
%     earIm = imrotate(Is1(:,:,:,k), theta);
%     earIm = imresize(earIm, [100 100]);

%     rotation_matrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    figure(6); imshow(earIm); hold on;
    % plot center of rotated elipse
    [h, hc, hl] = plotEllipse(p1(k,1),p1(k,2),p1(k,3),p1(k,4),p1(k,5));
    plot(hl.XData(1),hl.YData(1),'g.','MarkerSize',25);
    plot(hl.XData(2),hl.YData(2),'r.','MarkerSize',25);
    
    
    earIm = rotateAround(earIm, hc.XData(1), hc.YData(1), theta);
    imshow(earIm); hold on; axis on;
    % define ROI mask
    % need to plot elipse again to gain new coordiantes of aligned ellipse
    [h, hc, hl] = plotEllipse(p1(k,1),p1(k,2),p1(k,3),p1(k,4),-pi/2);
    mask = roipoly(earIm,h.XData, h.YData);
    masked_image = earIm.*uint8(mask);
    
   
    % calculate min distance from center to elipse - this is smaller axis
    center = [hc.XData(1), hc.YData(1)];
    min = 999999; % yeah yeah bad practice...
    for l = 1:size(h.XData,2)
        distance = sqrt((h.XData(l)-center(1))^2 + (h.YData(l)-center(2))^2);
        if(distance < min )
            min = distance;
        end
    end
%     disp(min);
%     plot(center(1)-min,center(2),'y.','MarkerSize',25);
%     plot(center(1)+min,center(2),'r.','MarkerSize',25);
    
    %TODO major axis length
    major_axis_len = sqrt((hl.XData(2)-center(1))^2 + (h.YData(2)-center(2))^2);
    %TODO crop rectangle [xmin ymin width height]
    crop_rect = imcrop(earIm, [center(1)-min hl.YData(2) min*2 major_axis_len*2]);
    figure(7); imshow(crop_rect);
    
%     plot(p1(k,1),p1(k,4),'r.','MarkerSize',20);

    % save alligned image
%     result_dir = 'TEST_aligned/';
%     imwrite(test, [result_dir,int2str(k+53),'.png'])
%     folderName = map{index};
%     folderName = folderName(1:3);
%     if ~exist([result_dir,folderName], 'dir')
%         % Folder does not exist so create it.
%         mkdir([result_dir,folderName]);
%     end
%     imwrite(test, [result_dir,map{index}])
    index = index + 1;
end
%% test cprApply with clustering
% RandStream.getGlobalStream.reset();
% n2=min(128,n1); Is2=Is1(:,:,:,1:n2); p2=p1(1:n2,:);
% tic; [d2,pa2] = cprApply(Is2,regModel); toc;
% tic; [dK,pa2k] = cprApply(Is2,regModel,'K',16,'chunk',128); toc;
% ds2=poseGt('dist',regModel.model,pa2,p2); ds2e=ds2(:,:,end);
% ds2k=poseGt('dist',regModel.model,pa2k,p2); ds2ke=ds2k(:,:,end);
% d=sqrt(ds2e); fprintf('reg-loss mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
% d=sqrt(ds2ke); fprintf('clust-loss  mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
% figure(2); poseGt('drawRes',model,Is2,p2,pa2(:,:,end),'nCol',10);
% figure(3); poseGt('drawRes',model,Is2,p2,pa2k(:,:,end),'nCol',10);
% if(0), savefig([name '-examplesK'],'jpeg'); end
