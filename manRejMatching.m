%% script for taking manually rejected allStandards channels, 
%  and extrapolating to matchedStandards

% this stuff is in step3_risetime as well
rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';

MoI='7mo';
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test7mo.mat');

% MoI='11mo';
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test11mo.mat');

% load('Rise_time_video_codes.mat')
% load('Rise_time_video_codes_alt.mat')
% load('Rise_time_video_codes_72.mat')
% 
% norm48=[rise_time_code(1,:),rise_time_code(2,:),rise_time_code(3,:),rise_time_code(4,:),rise_time_code(5,:)];
% alt48=[rise_time_code_alt(1,:),rise_time_code_alt(2,:),rise_time_code_alt(3,:),rise_time_code_alt(4,:),rise_time_code_alt(5,:)];
% norm72=[rise_time_code_72(1,:),rise_time_code_72(2,:),rise_time_code_72(3,:),rise_time_code_72(4,:)];

%%
load(strcat(rootpath,MoI,'/chanRej/individTrials/chanRejIndivid.mat'));
manRej=csvread(strcat(rootpath,MoI,'/artRej/allStandards/artrej_',MoI,'_manualChecks_aSlist.csv'));
load(strcat(rootpath,MoI,'/seg/trialMatches.mat'));
manrej2=[];
for ppts=1:length(validBabies)
    trialOrder=chanRejFile{2,1}{ppts,1};
    trialOrder1=chanRejFile{1,1}{ppts,1};
    matches=matchHolder{ppts}(trialOrder);
    manrej2ppt=manRej(matches,ppts);
    if length(manrej2ppt)<80
       for t=(length(manrej2ppt)+1):80
           manrej2ppt(t,1)=0;
       end
    end
    manrej2=[manrej2,manrej2ppt];
end
