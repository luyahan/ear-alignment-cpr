%% Demo demonstrating CPR code using toy data.

%% generate toy training and testing data
RandStream.getGlobalStream.reset(); n0=50; n1=50; n2=0;
model=poseGt('createModel','ellipse'); d=100;
model.parts(1).sigs(1:3)=[10 10 pi];
% [Is,p] = poseGt('toyData',model,n0+n1+n2,d,d,'noise',.2);
% Load ears
data = load('test_ears.mat');
Is = data.result;
% Load annotations
annotation = load('ears_annotated.mat');
p = annotation.result;
figure(1); poseGt('draw',model,Is,p);
save('toyLizard-data','Is','model','p','n0','n1','n2');

%% load data and split into training and testing data
name='toyLizard'; d=load([name '-data']); name=[name '00'];
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
if( 1 ) % train regressor
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
lks=[model.parts.lks]; m=length(model.parts); f=2.5;
nms=['dx','dy',repmat({'angle','scale','aspr'},1,m)];
[ds0,dsa0]=poseGt('dist',model,pa0,p0); dsa0=dsa0(:,lks==0,:);
[ds1,dsa1]=poseGt('dist',model,pa1,p1); dsa1=dsa1(:,lks==0,:);
ds0m=squeeze(median(ds0)); dsa0m=squeeze(median(dsa0))'; dse0=ds0(:,end);
ds1m=squeeze(median(ds1)); dsa1m=squeeze(median(dsa1))'; dse1=ds1(:,end);
d=sqrt(dse0); fprintf('train-loss mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
d=sqrt(dse1); fprintf('test-loss  mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
figure(1); clf; h1=loglog(dsa1m,'-'); hold on; loglog(dsa0m,':');
loglog(ds0m,':k','LineWidth',3); loglog(ds1m,'-k','LineWidth',3);
legend(h1,nms(lks==0)); set(h1,'LineWidth',1); axis tight
if(0), savefig([name '-T-plot'],'jpeg'); end
% fail=squeeze(mean(ds1>f^2)); figure(2); semilogx(fail,'--r');

%% display some results
figure(2); poseGt('drawRes',model,Is1,p1,pa1(:,:,end),'nCol',10);
if(0), savefig([name '-examples'],'jpeg'); end

%% test cprApply with clustering
RandStream.getGlobalStream.reset();
n2=min(128,n1); Is2=Is1(:,:,:,1:n2); p2=p1(1:n2,:);
tic; [d2,pa2] = cprApply(Is2,regModel); toc;
tic; [dK,pa2k] = cprApply(Is2,regModel,'K',16,'chunk',128); toc;
ds2=poseGt('dist',regModel.model,pa2,p2); ds2e=ds2(:,:,end);
ds2k=poseGt('dist',regModel.model,pa2k,p2); ds2ke=ds2k(:,:,end);
d=sqrt(ds2e); fprintf('reg-loss mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
d=sqrt(ds2ke); fprintf('clust-loss  mu=%f, f=%f\n',mean(d(d<f)),mean(d>f));
figure(2); poseGt('drawRes',model,Is2,p2,pa2(:,:,end),'nCol',10);
figure(3); poseGt('drawRes',model,Is2,p2,pa2k(:,:,end),'nCol',10);
if(0), savefig([name '-examplesK'],'jpeg'); end
