%% rise time script 3 - event names in - let's segment
% % 
% MoI='7mo';
% 
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot7mo.mat');
%load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test7mo.mat');
% % % % 
MoI='11mo';
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot11mo.mat');
%load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test11mo.mat');

rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';

%% step 3: segment into epochs
eeglab

filelocs={'filteredOnly/';'chanRejected/'};
infilenames={'_filtEvts.set';'_rejEvts.set'};
outfilenames={'_filtSeg.set';'_rejSeg.set'};

matchHolder={};
cautionFiles=[];

for valids=1:length(validBabies)
    for rounds=1:length(filelocs)
        EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,'_aS',infilenames{rounds}),'filepath',strcat(rootpath,MoI,'/pilots/renamedEvents/',filelocs{rounds},'allStandards/'));
        EEG = pop_epoch( EEG,  {'RT01','RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17'} , [-0.16  0.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        EEG = pop_rmbase( EEG, [-160  0]); %changed from -200 baseline to -160ms (20% of trial length). Try to avoid pos slow wave
        segname=strcat(validBabies{valids},'_',MoI,'_aS',outfilenames{rounds});
        EEG = pop_saveset( EEG, segname, strcat(rootpath,MoI,'/pilots/seg/',filelocs{rounds},'allStandards/')); 
        
        EEG2 = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,'_mS',infilenames{rounds}),'filepath',strcat(rootpath,MoI,'/pilots/renamedEvents/',filelocs{rounds},'matchedStandards/'));
        EEG2 = pop_epoch( EEG2,  {'RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17','RT38','RT36','RT34','RT32','RT30','RT28','RT26','RT24','RT22','RT20','RT18','RT16'} , [-0.16  0.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
        EEG2 = pop_rmbase( EEG2, [-160  0]); %changed from -200 baseline to -160ms (20% of trial length). Try to avoid pos slow wave
        segname2=strcat(validBabies{valids},'_',MoI,'_mS',outfilenames{rounds});
        EEG2 = pop_saveset( EEG2, segname2, strcat(rootpath,MoI,'/pilots/seg/',filelocs{rounds},'matchedStandards/'));
        
        urevtlist=[];
        urevtlist2=[];
        for buildUr=1:length(EEG.event)
            % first, let's make sure any urevent numbers that are the same
            % between an Oddball and the SUBSEQUENT standard, get changed
            % (so the urevent of the subsequent standard, which won't be in the mS files,
            % is coded as 999)
            if (buildUr<length(EEG.event))&&(EEG.event(buildUr).type~="RT01")&&(EEG.event(buildUr+1).type=="RT01")&&(EEG.event(buildUr).urevent==EEG.event(buildUr+1).urevent)
                EEG.event(buildUr+1).urevent=999;
                if EEG.event(buildUr+2).urevent==EEG.event(buildUr).urevent
                    EEG.event(buildUr+2).urevent=999;
                end
            end 
            % now let's do the same in case multiple RT01s have the same
            % urevent as the key RT01 (the one before the Oddball)
            if (buildUr>1)&&(buildUr<length(EEG.event))&&(EEG.event(buildUr).type=="RT01")&&(EEG.event(buildUr-1).type=="RT01")&&(EEG.event(buildUr+1).type~="RT01")
                urr=EEG.event(buildUr).urevent;
                check=find(urevtlist==urr);
                urevtlist(check)=999;
            end
            urevtlist=[urevtlist;EEG.event(buildUr).urevent];  
        end
        for buildUr2=1:length(EEG2.event)
            urevtlist2=[urevtlist2;EEG2.event(buildUr2).urevent];
        end
        listMatches=ismember(urevtlist,urevtlist2);
        listMatches2=find(listMatches==1);
    end
    matchHolder{valids,1}=listMatches2;
end
save(strcat(rootpath,MoI,'/pilots/seg/trialMatches.mat'),'matchHolder');
%these segments are available should we want to do some manual rejections

%% step 4 reject bad epochs

%% step 4.1
% try to preserve as many trials as possible: run channel rejection on a
% trial-by-trial basis

chanRejIndivid=cell(length(validBabies),2);
chanRejIndivid_match=cell(length(validBabies),2);
chanRejFile={chanRejIndivid;chanRejIndivid_match};
rejFileTypes={'_aS';'_mS'};
inFolders={'allStandards/';'matchedStandards/'};
evtNames={{'RT01','RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17'};{'RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17','RT38','RT36','RT34','RT32','RT30','RT28','RT26','RT24','RT22','RT20','RT18','RT16'}};

manChans=csvread(strcat(rootpath,MoI,'/pilots/chanRej/first_chanRejMan_',MoI,'.csv')); %file with manually selected channels
for valids=1:length(validBabies)
    for analysisTypes=1:2
        badChans={};
        interps=[];
        % first up - let's categorise babies
        % how many channels have been interpolated already; how many therefore can be replaced in a trial?
        manNonZero=manChans(valids,:)~=0;
        manelec=manChans(valids,manNonZero);
        permissChans=11-length(manelec);

        if permissChans>0 %if there's any capacity for other channels to be interpolated
            %first up, run the threshold detection to find channels peaking
            %above 500 microvolts

            %we'll do this with the "chanRej" data, so the bad channels are
            %already gone
            EEGt = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_rejSeg.set'),'filepath',strcat(rootpath,MoI,'/pilots/seg/chanRejected/',inFolders{analysisTypes}));
            EEGt = pop_eegthresh(EEGt,1,[1:22,24:54,56:60],-500,500,-0.16,0.8,0,0);   
            thresHolderIndivid = EEGt.reject.rejthreshE;
            for epochs=1:length(thresHolderIndivid(1,:))
                badChans{epochs}=find(thresHolderIndivid(:,epochs)==1);
                if (length(badChans{epochs})<=permissChans)&&(length(badChans{epochs})>0)
                    interps(epochs)=1;
                else
                    interps(epochs)=0;
                end
            end
            interpTrials=find(interps==1);
            noninterpTrials=find(interps==0);
            interpChans=badChans(interpTrials);
            % let's interpolate these guys trial by trial
            % let's do it with the FILTERED ONLY data and add in all the manual
            % chanRej stuff at the same time
            EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_filtSeg.set'),'filepath',strcat(rootpath,MoI,'/pilots/seg/filteredOnly/',inFolders{analysisTypes}));
            EEGkeep=pop_selectevent(EEG,'epoch',noninterpTrials,'deleteevents','off','deleteepochs','on','invertepochs','off');
            krej=[manelec,23,55,61,62,63,64]; %manually selected channels, per-trial channels, usual suspects
            krej=sort(krej);
            krej=unique(krej);
            EEGkeep = eeg_interp(EEGkeep, krej);
            EEGe={};
            e=0;    
            for ii=1:length(interpTrials)
                e=e+1;
                EEGe{e}=pop_selectevent(EEG, 'epoch',interpTrials(ii),'deleteevents','off','deleteepochs','on','invertepochs','off');
                rej=[manelec,interpChans{ii}',23,55,61,62,63,64]; %manually selected channels, per-trial channels, usual suspects
                rej=sort(rej);
                rej=unique(rej);
                EEGe{e} = eeg_interp(EEGe{e}, rej);                    
            end
            for eee=1:length(EEGe)
                EEGkeep=pop_mergeset(EEGkeep,EEGe{eee});
            end        
            chanRejFile{analysisTypes}{valids,1} = [(noninterpTrials)';(interpTrials)'];
            chanRejFile{analysisTypes}{valids,2} = interpChans';  
            EEGkeep=pop_saveset( EEGkeep, strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_chanRejMan.set'), strcat(rootpath,MoI,'/pilots/chanRej/individTrials/',inFolders{analysisTypes}));
        else
            EEG = pop_loadset('filename',strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_filtEvts.set'),'filepath',strcat(rootpath,MoI,'/pilots/renamedEvents/filteredOnly/',inFolders{analysisTypes}));
            rej=[manelec,23,55,61,62,63,64];
            rej=sort(rej);
            rej=unique(rej);
            EEG = eeg_interp(EEG, rej);        
            EEG = pop_epoch( EEG,  evtNames{analysisTypes} , [-0.16  0.8], 'newname', 'EGI file epochs', 'epochinfo', 'yes');
            EEG = pop_rmbase( EEG, [-160  0]); %changed from -200 baseline to -160ms (20% of trial length). Try to avoid pos slow wave
            EEG = pop_saveset( EEG, strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_chanRejMan.set'), strcat(rootpath,MoI,'/pilots/chanRej/individTrials/',inFolders{analysisTypes}));
        end
    end
end
save(strcat(rootpath,MoI,'/pilots/chanRej/individTrials/chanRejIndivid.mat'),'chanRejFile');

%% step 4.2 use ERPlab
% ERPlab uses its own segmentation procedure, however what we are going to
% do is re-concatenate the segmented data
[ALLEEG EEG CURRENTSET ALLCOM]=eeglab;

% % do the Event List for epoching data for ERPlab
for valids=1:length(validBabies)
    EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,'_aS_chanRejMan.set'),'filepath',strcat(rootpath,MoI,'/pilots/chanRej/individTrials/allStandards/'));
    EEG=epoch2continuous(EEG);
    EEG=pop_editeventlist(EEG , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',strcat(rootpath,MoI,'/pilots/renamedEvents/ERPlab/evtlist_check_2.txt'),'SendEL2', 'EEG&Text', 'UpdateEEG','off','Warning','off' );
    EEG=pop_epochbin( EEG , [-160.0  800.0],  'pre');
    EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,'_aS_erpBin.set'),strcat(rootpath,MoI,'/pilots/renamedEvents/ERPlab/allStandards/'));

    EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,'_mS_chanRejMan.set'),'filepath',strcat(rootpath,MoI,'/pilots/chanRej/individTrials/matchedStandards/'));
    EEG=epoch2continuous(EEG);
    EEG=pop_editeventlist(EEG , 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List',strcat(rootpath,MoI,'/pilots/renamedEvents/ERPlab/evtlist_check_2match.txt'),'SendEL2', 'EEG&Text', 'UpdateEEG', 'off','Warning', 'off' );
    EEG=pop_epochbin( EEG , [-160.0  800.0],  'pre');
    EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,'_mS_erpBin.set'),strcat(rootpath,MoI,'/pilots/renamedEvents/ERPlab/matchedStandards/'));
end

%%
% now let's run the peak to peak rejection... but it will kill trials with just one
% bad channel so let's only kill those with over 6 bad channels (10%)
rejEpochs=cell(2,1);
rejFileTypes={'_aS';'_mS'};
inFolders={'allStandards/';'matchedStandards/'};
for valids=1:length(validBabies)
    for analysisTypes=1:2
        EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_erpBin.set'),'filepath',strcat(rootpath,MoI,'/pilots/renamedEvents/ERPlab/',inFolders{analysisTypes}));
        EEG=pop_artmwppth( EEG , 'Channel',  1:60, 'Flag',  1, 'Threshold',  200, 'Twindow', [ -160 799], 'Windowsize',  200, 'Windowstep',  100 ); 
        rejEpochHolder=[];
        for x=1:length(EEG.reject.rejmanualE(1,:))
            if sum(EEG.reject.rejmanualE(:,x))>6
                EEG.reject.rejmanual(x)=1;
            else
                EEG.reject.rejmanual(x)=0;
            end
            rejEpochHolder=find(EEG.reject.rejmanual==1);
        end        
        rejEpochs{analysisTypes}{valids}=(EEG.reject.rejmanual)';
        EEG=pop_rejepoch(EEG,rejEpochHolder,0);
        EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_erpRej.set'),strcat(rootpath,MoI,'/pilots/artRej/erplab/',inFolders{analysisTypes}));
    end
end
rejEpochs{1}=rejEpochs{1}';
rejEpochs{2}=rejEpochs{2}';
save(strcat(rootpath,MoI,'/pilots/artRej/erplab/rejEpochs.mat'),'rejEpochs');


%% step 4.3 look at agreement/disagreement between methods

aS_agreeKeep={};
aS_agreeDump={};
aS_manDump={};
aS_autoDump={};

mS_agreeKeep={};
mS_agreeDump={};
mS_manDump={};
mS_autoDump={};

load(strcat(rootpath,MoI,'/artRej/erplab/rejEpochsERPLab_FR22check.mat'));
load(strcat(rootpath,MoI,'/artRej/matchedStandards/artrej_',MoI,'_manualChecks_mSlist.mat'));
manRej=csvread(strcat(rootpath,MoI,'/artRej/allStandards/artrej_',MoI,'_manualChecks_aSlist.csv'));

for valids=28%:length(validBabies)
    aS_agreeKeep_holder=[];
    aS_agreeDump_holder=[];
    aS_manDump_holder=[];
    aS_autoDump_holder=[];

    mS_agreeKeep_holder=[];
    mS_agreeDump_holder=[];
    mS_manDump_holder=[];
    mS_autoDump_holder=[];

    for trial=1:length(rejEpochs{1,1}{valids})
        if manRej(trial,valids)==0&&rejEpochs{1,1}{valids}(trial)==0
            aS_agreeKeep_holder=[aS_agreeKeep_holder;trial];
        elseif manRej(trial,valids)==1&&rejEpochs{1,1}{valids}(trial)==1
            aS_agreeDump_holder=[aS_agreeDump_holder;trial];
        elseif manRej(trial,valids)==1&&rejEpochs{1,1}{valids}(trial)==0
            aS_manDump_holder=[aS_manDump_holder;trial];
        elseif manRej(trial,valids)==0&&rejEpochs{1,1}{valids}(trial)==1
            aS_autoDump_holder=[aS_autoDump_holder;trial];
        end                
    end
    for trial2=1:length(rejEpochs{2,1}{valids})
        if manrej2(trial2,valids)==0&&rejEpochs{2,1}{valids}(trial2)==0
            mS_agreeKeep_holder=[mS_agreeKeep_holder;trial2];
        elseif manrej2(trial2,valids)==1&&rejEpochs{2,1}{valids}(trial2)==1
            mS_agreeDump_holder=[mS_agreeDump_holder;trial2];
        elseif manrej2(trial2,valids)==1&&rejEpochs{2,1}{valids}(trial2)==0
            mS_manDump_holder=[mS_manDump_holder;trial2];
        elseif manrej2(trial2,valids)==0&&rejEpochs{2,1}{valids}(trial2)==1
            mS_autoDump_holder=[mS_autoDump_holder;trial2];
        end                
    end
    aS_agreeKeep{valids,1}=aS_agreeKeep_holder;
    aS_agreeDump{valids,1}=aS_agreeDump_holder;
    aS_manDump{valids,1}=aS_manDump_holder;
    aS_autoDump{valids,1}=aS_autoDump_holder;

    mS_agreeKeep{valids,1}=mS_agreeKeep_holder;
    mS_agreeDump{valids,1}=mS_agreeDump_holder;
    mS_manDump{valids,1}=mS_manDump_holder;
    mS_autoDump{valids,1}=mS_autoDump_holder;
end

% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_agreeKeep.mat'),'aS_agreeKeep');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_agreeDump.mat'),'aS_agreeDump');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_manDump.mat'),'aS_manDump');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_autoDump.mat'),'aS_autoDump');
% 
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_agreeKeep.mat'),'mS_agreeKeep');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_agreeDump.mat'),'mS_agreeDump');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_manDump.mat'),'mS_manDump');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_autoDump.mat'),'mS_autoDump');

% now visually check trials where there is disagreement!
% run this section again but save with new names:

% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_agreeKeep_done.mat'),'aS_agreeKeep');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_agreeDump_done.mat'),'aS_agreeDump');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_manDump_done.mat'),'aS_manDump');
% save(strcat(rootpath,MoI,'/artRej/allStandards/aS_autoDump_done.mat'),'aS_autoDump');
% 
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_agreeKeep_done.mat'),'mS_agreeKeep');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_agreeDump_done.mat'),'mS_agreeDump');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_manDump_done.mat'),'mS_manDump');
% save(strcat(rootpath,MoI,'/artRej/matchedStandards/mS_autoDump_done.mat'),'mS_autoDump');

%% step 4.4 actually reject data according to combos of the protocols above. 
% We are using manual and peak to peak, with a second round of manual
% rejection based on disagreements with peak-to-peak

% save a csv with the new trials for rejection and harmonise again


% do the manual rejections on the "full" aS datasets, then harmonise for
% the mS datasets
eeglab
load(strcat(rootpath,MoI,'/chanRej/individTrials/chanRejIndivid.mat'));
manRej=csvread(strcat(rootpath,MoI,'/artRej/allStandards/artrej_',MoI,'_manualChecks_aSlist.csv'));
load(strcat(rootpath,MoI,'/seg/trialMatches.mat'));
manrej2=[];

for ppts=1:length(validBabies)
    EEGaS=pop_loadset('filename',strcat(validBabies{ppts},'_',MoI,'_aS_chanRejMan.set'),'filepath',strcat(rootpath,MoI,'/chanRej/individTrials/allStandards/'));
    EEGmS=pop_loadset('filename',strcat(validBabies{ppts},'_',MoI,'_mS_chanRejMan.set'),'filepath',strcat(rootpath,MoI,'/chanRej/individTrials/matchedStandards/'));
    if isempty(chanRejFile{2,1}{ppts,1})
        trialOrder1=(1:length(EEGaS.event))';
        trialOrder=(1:length(EEGmS.event))';
    else
        trialOrder=chanRejFile{2,1}{ppts,1};
        trialOrder1=chanRejFile{1,1}{ppts,1};
    end
    matches=matchHolder{ppts}(trialOrder);
    rejed=find(manRej(:,ppts)==1);
    rejed1=trialOrder1(rejed);
    [rejMStrial,rejMSindex]=intersect(matches,rejed1);
    %rejed2=matches(rejMSindex);
    manrej2ppt=zeros(80,1);
    manrej2ppt(rejMSindex)=1;   
    manrej2=[manrej2,manrej2ppt];
end

save(strcat(rootpath,MoI,'/artRej/allStandards/artrej_',MoI,'_manualChecks_aSlist.mat'),'manRej');
save(strcat(rootpath,MoI,'/artRej/matchedStandards/artrej_',MoI,'_manualChecks_mSlist.mat'),'manrej2');
%%
rejEpochs={};
load(strcat(rootpath,MoI,'/artRej/allStandards/artrej_',MoI,'_manualChecks_aSlist.mat'));
load(strcat(rootpath,MoI,'/artRej/matchedStandards/artrej_',MoI,'_manualChecks_mSlist.mat'));
rejEpochs{1}=manRej;
rejEpochs{2}=manrej2;

[ALLEEG EEG CURRENTSET ALLCOM]=eeglab;

rejFileTypes={'_aS';'_mS'};
inFolders={'allStandards/';'matchedStandards/'};
% 
for valids=1:length(validBabies)
    for analysisTypes=1:2
        EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_chanRejMan.set'),'filepath',strcat(rootpath,MoI,'/chanRej/individTrials/',inFolders{analysisTypes}));
        EEG=pop_rejepoch(EEG,(find(rejEpochs{analysisTypes}(:,valids)==1))',0);
        EEG=pop_saveset(EEG,strcat(validBabies{valids},'_',MoI,rejFileTypes{analysisTypes},'_finRej.set'),strcat(rootpath,MoI,'/artRej/',inFolders{analysisTypes}));
    end
end
