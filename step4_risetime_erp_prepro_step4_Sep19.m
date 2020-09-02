%% rise time script 4 - bad epochs rejected. Let's rereference and rock and roll!
% 
% 
% MoI='7mo';
% 
% %load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot7mo.mat');
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test7mo.mat');
% % % 
MoI='11mo';
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot11mo.mat');
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test11mo.mat');

rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';
        
%% rereference
% exclude the peripheral/non-existent channels
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

paths={'/artRej/allStandards/';'/artRej/matchedStandards/'};
extni={'_aS_finRej.set';'_mS_finRej.set'};
extno={'_aS_Rrf.set';'_mS_Rrf.set'};
pathso={'/reref/allStandards/';'/reref/matchedStandards/'};

for valids=1:length(validBabies)
    for y=1:length(paths)
        EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,extni{y}),'filepath',strcat(rootpath,MoI,paths{y}));
        EEG.ref='averef';
        EEG=pop_reref(EEG,[],'exclude',[61 62 63 64 1 17 23 55 29 47 32 43 35 37 39]);
        EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,extno{y}),strcat(rootpath,MoI,pathso{y}));    
    end
end

%% export the data to CSVs


% %% outlier channels
% % let's find these epoch by epoch and dump
% % bad = max or min amplitude is more than 3 SDs away from the epoch mean
eeglab
filelocs={'allStandards/';'matchedStandards/'};
infilenames={'_aS_Rrf.set';'_mS_Rrf.set'};
RTepochs={{'RT01','RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17'};{'RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17','RT38','RT36','RT34','RT32','RT30','RT28','RT26','RT24','RT22','RT20','RT18','RT16'}};
pathso={'/exports/allStandards/';'/exports/matchedStandards/'};
extno={'_aS_rrf';'_mS_rrf'};

frontal=[2,3,5,6,8,9,10,11];
leftFrCe=[12,13,14,15,17,18,19,20];
rightFrCe=[1,50,53,56,57,58,59,60];
central=[4,7,16,21,34,41,51,54];
leftTePa=[22,24,25,26,27,28,29,30];
rightTePa=[42,44,45,46,47,48,49,52];
occiPari=[31,33,35,36,37,38,39,40];
electrodes={frontal;leftFrCe;rightFrCe;central;leftTePa;rightTePa;occiPari};

elec=[1:22,24:54,56:60];
outlierHolder=cell(length(validBabies),length(infilenames));
flagger=cell(4,1);

countholder={};
for ins=1:length(infilenames)
    counts=zeros(length(validBabies),length(RTepochs{ins}));
    for valids=36%1:length(validBabies)
        EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,infilenames{ins}),'filepath',strcat(rootpath,MoI,'/reref/',filelocs{ins}));
        outlierHolder{valids,ins}=cell(length(EEG.epoch),1); 
        for ep=1:length(EEG.epoch)
            testdata=EEG.data(elec,:,ep);
            testmean=mean(testdata); % what's the mean amplitude per timepoint?
            testStd=std(testdata); % what's the standard deviation of all electrodes at a given timepoint in the epoch?           
            for el=1:length(elec)
                [indMax,indMaxLoc]=max(EEG.data(elec(el),:,ep));
                [indMin,indMinLoc]=min(EEG.data(elec(el),:,ep));
                if (indMax>(testmean(indMaxLoc)+(3.5*(testStd(indMaxLoc)))))||(indMin<(testmean(indMinLoc)-(3.5*(testStd(indMinLoc)))))
                    outlierHolder{valids,ins}{ep}=[outlierHolder{valids,ins}{ep};elec(el)];
                end
            end
            if ~isempty(outlierHolder{valids,ins}{ep})
                excluders=cell(length(electrodes),1);
                for ex=1:length(electrodes)
                    excluders{ex}=ismember(electrodes{ex},outlierHolder{valids,ins}{ep});
                    if sum(excluders{ex})>0
                        replaceds=electrodes{ex}(excluders{ex});
                        replacers=electrodes{ex}(~excluders{ex});
                        if length(replaceds)>3
                            flagger{1,1}=[flagger{1,1};valids];
                            flagger{2,1}=[flagger{2,1};ins];
                            flagger{3,1}=[flagger{3,1};ep];
                            flagger{4,1}=[flagger{4,1};{replaceds}];
                        else
                            for reps=1:length(replaceds)
                                EEG.data(replaceds(reps),:,ep)=mean(EEG.data(replacers,:,ep));
                            end
                        end
                    end
                end
            end
        end
        EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,extno{ins}),strcat(rootpath,MoI,pathso{ins}));  
        for epochs=1:length(RTepochs{ins})
        	epochExist=0;
            EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,extno{ins},'.set'),'filepath',strcat(rootpath,MoI,pathso{ins}));
            try
                EEG=pop_epoch(EEG, {RTepochs{ins}{epochs}}, [-0.16 0.8], 'newname', 'EGI file ', 'epochinfo', 'yes');
                epochExist=1;
                pop_export(EEG,strcat(rootpath,MoI,pathso{ins},RTepochs{ins}{epochs},'/',validBabies{valids},'_',MoI,'_',RTepochs{ins}{epochs},extno{ins},'_erp.csv'),'erp','on','elec','off','time','off','precision',4);
                pop_export(EEG,strcat(rootpath,MoI,pathso{ins},RTepochs{ins}{epochs},'/',validBabies{valids},'_',MoI,'_',RTepochs{ins}{epochs},extno{ins},'.csv'),'erp','off','elec','off','time','off','precision',4);               
            end
            if epochExist==1
                counts(valids,epochs)=length(EEG.event);
                countholder{ins}=counts;
            end     
        end
    end
end
save(strcat(rootpath,MoI,'/exports/outlierChans_',MoI,'.mat'),'outlierHolder')
save(strcat(rootpath,MoI,'/exports/counts_',MoI,'.mat'),'countholder')

% 
% countholder={};
% for rej=1:length(pathsi)
%     counts=zeros(length(validBabies),length(RTepochs{rej}));
%     for valids = 1:length(validBabies)
%         for epochs=1:length(RTepochs{rej})
%             epochExist=0;
%             EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,extni{rej}),'filepath',strcat(rootpath,MoI,pathsi{rej}));
%             try
%                 EEG=pop_epoch(EEG, {RTepochs{rej}{epochs}}, [-0.16 0.8], 'newname', 'EGI file ', 'epochinfo', 'yes');
%                 epochExist=1;
%                 pop_export(EEG,strcat(rootpath,MoI,pathso{rej},RTepochs{rej}{epochs},'/',validBabies{valids},'_',MoI,'_',RTepochs{rej}{epochs},extno{rej},'_erp.csv'),'erp','on','elec','off','time','off','precision',4);
%                 pop_export(EEG,strcat(rootpath,MoI,pathso{rej},RTepochs{rej}{epochs},'/',validBabies{valids},'_',MoI,'_',RTepochs{rej}{epochs},extno{rej},'.csv'),'erp','off','elec','off','time','off','precision',4);               
%             end
%             if epochExist==1
%                 counts(valids,epochs)=length(EEG.event);
%                 countholder{rej}=counts;
%             end           
%         end
%     end
% end

%% new approach summer 2020
% instead of all the epochs, let's just do (1) matched Standards and (2)
% all the 20s vs all the 30s

eeglab
filelocs={'matchedStandards/'};
infilenames={'_mS_Rrf.set'};
RTepNames={'30D','30S','20D','20S'};
RTepochs={{'RT39';'RT37';'RT35';'RT33';'RT31'},{'RT38';'RT36';'RT34';'RT32';'RT30'},{'RT29';'RT27';'RT25';'RT23';'RT21'},{'RT28';'RT26';'RT24';'RT22';'RT20'}};
pathsi={'/exports/matchedStandards/'};
pathso={'/exports/matchedStandards/Aves/'};
extno={'_mS_rrf'};

countholder={};
for ins=1:length(infilenames)
    counts=zeros(length(validBabies),length(RTepochs{ins}));
    for valids=1:length(validBabies)
        for epochs=1:length(RTepochs)
            EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,extno{ins},'.set'),'filepath',strcat(rootpath,MoI,pathsi{ins}));           
            try
                EEG=pop_epoch(EEG, RTepochs{epochs}, [-0.16 0.8], 'newname', 'EGI file ', 'epochinfo', 'yes');
                pop_export(EEG,strcat(rootpath,MoI,pathso{ins},'/',RTepNames{epochs},'/',validBabies{valids},'_',MoI,'_',RTepNames{epochs},extno{ins},'_erp.csv'),'erp','on','elec','off','time','off','precision',4);
            end
        end
    end
end


