%% individual ERPs
% AC September 19, based on ERPplots

% we are going to get an array of output datasets containing ERPs
% 1. ERP. Normal ERP comparison between conditions (oddballs, standards).
% 2. ERP_matchedStandards. Normal ERP comparison, but each oddball has a matched standard (last standard trial before oddball).
% 3. ERP_perTrial_mS. ERP but account for every trial (don't get an average per condition). Using mS trials, not all trials for standard.
% 4. MMN_matchedStandards. MMN, each oddball response has the preceding standard subtracted.
% 5. MMN_perERP. MMN, the mean oddball response has the mean standard response subtracted.
% 6. MMN_perTrial. MMN, each oddball response has the mean standard response subtracted.
% 1 and 5 are similar; 2 and 4; 3 and 6.
% in this file we make 1-3

% here's some details on where data is below for the above (bl and ob windows)
% 1. oddballs: RTmSERPVals                 standards: RT01ERPVals{ages}{1}
% 2. oddballs: RTmSERPVals                 standards: RT01ERPVals{ages}{2}
% 3. oddballs: RTin_ERPVals{ages}{2}(1:10) standards: RTin_ERPVals{ages}{2}(11:20)

rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';
RTepochs={{'RT01';'RT39';'RT37';'RT35';'RT33';'RT31';'RT29';'RT27';'RT25';'RT23';'RT21'};...
    {'RT39';'RT37';'RT35';'RT33';'RT31';'RT29';'RT27';'RT25';'RT23';'RT21';'RT38';'RT36';'RT34';'RT32';'RT30';'RT28';'RT26';'RT24';'RT22';'RT20'}};
fileHolder=cell(length(RTepochs),1);
%got rid of RT20/21 briefly due to problems

% validBabies = {{'CW23hj23';'DS04gg02';'EE29jp49';'EG20dz29';'EL03fg21';'EM16js91';'ET19pa06';'GD20bg51';'OD29as10';...
%  'RW31rm47';'SB22sg34';'AJ09ac23';'CR14by47';'DM18eo92';'DW04rp75';'EM13zx98';'ER09ji58';'FA22ws13';'HH07pd92';'LH25pp22';...
%  'LO23sc41';'RF12vh59';'EK24xi46';'HS14ab22'},{'AJ09ac23';'CR14by47';'CW23hj23';'DM18eo92';'DS04gg02';'DW04rp75';...
%     'EE29jp49';'EG20dz29';'EK24xi46';'EL03fg21';'EM13zx98';'EM16js91';'ER09ji58';...
%     'ET19pa06';'FA22ws13';'GD20bg51';'HH07pd92';'HS14ab22';'LO23sc41';'OD29as10';...
%     'RW31rm47';'SB22sg34'}};
% VbNameLen=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8];
% stimuli=[1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,1,1;2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,1,1,2,2,1,1,0,0];    
% subnums=[24,22,24,24,24,24,23,24,24,24,24,2,2;22,22,22,22,22,22,22,21,21,21,21,0,0];

 validBabies = {{'AA08gs64';'AB19cm13';'AB28ka99';'AH12ps44';'AH20eg91';'AV03ct18';...
    'AW12se23';'BD08ol68';'BM26hg18';'CM06cb41';'DA01fy01';'DA28ns10';'DC09ls10';...    
    'EB23kn04';'EK10pf48';'EL16jn01';'ES06cf77';'ES20tv22';'EW01gm26';...   
    'FS15vp50';'GZ21am18';'HB29lw72';'HE27ab19';'HX13xx13';'IG21te67';'IS19kq76';...   
    'JL04qq88';'KG05gg66';'LD09sd7';'LF20fm32';'MC31dv56';'MS04jo74';...  
    'MW15sk21';'NB05JR55';'NG10tr65';'NO08js23';'NW28cp37';'OT08eb49';'OW16al07';...    
    'RC01mw31';'RG31rt10';'RK05ld83';'RM05sz86';'SH28dt49';'SN02sm01';'TC09jp54';...    
    'WP25ph27';'YB13yu73';'ZL23te18';'ZT29ab23';'CW23hj23';'DS04gg02';'EE29jp49';...
    'EG20dz29';'EL03fg21';'EM16js91';'ET19pa06';'GD20bg51';'OD29as10';'RW31rm47';...
    'SB22sg34';'AJ09ac23';'CR14by47';'DM18eo92';'DW04rp75';'EM13zx98';'ER09ji58';...
    'FA22ws13';'HH07pd92';'LH25pp22';'LO23sc41';'RF12vh59';'EK24xi46';'HS14ab22'},...
     {'AA08gs64';'AB16cg04';'AB28ka99';'AM26ys67';'AR17bh32';'AT07pi88';...
    'AV03ct18';'AV13hg77';'AW12se23';'BD08ol68';'BM26hg18';'CA08zr73';...
    'CM06cb41';'DA01fy01';'DA28ns10';'DC09ls10';'EB21bfy5';'EB23kn04';'ED14vx53';...
    'EK10pf48';'EL16jn01';'ES06cf77';'ES20tv22';'EW01gm26';'FA10jp92';...
    'FB085k2m';'FM12cv10';'FR22ya5';'FS11cd42';'GK03fj19';'GS21bc55';'GZ21am18';...
    'HB29lw72';'HE27ab19';'HS01fg79';'HX13xx13';'IG21te67';'IM14fr77';'IS19kq76';...
    'JD31ga12';'JL04qq88';'KG05gg66';'LB04tg17';'LB27ab98';'LD09sd7';'LF20fm32';...
    'LL12cb78';'MC31dv56';'MW15sk21';'NB13ay10';'NG10tr65';'NH10nm27';'NO08js23';...
    'NW28cp37';'OT08eb49';'OW16al07';'PS11kr29';'RB28nb19';'RC01mw31';'RG31rt10';...
    'RK05ld83';'RM05sz86';'RM28at5b';'RO18ck33';'RR04tr76';'SH28dt49';'SI00g2';...
    'TP01cd11';'TV2401';'VP14wb41';'WP25ph27';'YB13yu73';'ZL23te18';'ZT29ab23';...
    'AJ09ac23';'CR14by47';'CW23hj23';'DM18eo92';'DS04gg02';'DW04rp75';'EE29jp49';...
    'EG20dz29';'EK24xi46';'EL03fg21';'EM13zx98';'EM16js91';'ER09ji58';'ET19pa06';...
    'FA22ws13';'GD20bg51';'HH07pd92';'HS14ab22';'LO23sc41';'OD29as10';'RW31rm47';'SB22sg34'}};

%VbNameLen=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8];
  
stimuli={{2,2,1,2,1,2,2,2,2,2,1,1,1,...
    2,2,1,1,2,1,2,1,1,1,2,1,2,...
    1,2,1,1,1,2,2,1,2,2,2,2,1,...
    1,1,1,2,2,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,1,1};...
    {2,1,2,1,1,2,2,1,2,2,2,1,...
    1,1,2,2,1,2,2,2,2,1,2,2,1,...
    1,2,1,2,1,1,2,2,2,1,2,2,1,2,...
    2,1,2,1,1,1,2,1,1,1,1,1,1,2,...
    2,2,1,2,1,2,2,1,1,1,1,1,2,1,...
    2,1,2,2,2,1,1,2,2,2,1,1,1,1,1,2,2,2,2,2,2,2,2,1,1,2,2,1,1}};  
    %subnums=[70,68,70,70,70,70,68,68,69,70,70,6,6;88,87,86,88,87,87,88,87,85,86,85,0,0];

MoI={'7mo';'11mo'};
MoIdata=['07';'11'];



%% Before anything, we should pop epoch on a trial-by-trial basis

pathsi={'/exports/allStandards/';'/exports/matchedStandards/'};
pathso={'/results/allStandards/';'/results/matchedStandards/'};
extni={'_aS_rrf.set';'_mS_rrf.set'};
extno={'_aS_trial';'_mS_trial'};

%eeglab

% countholder={};
% for ages=1:2
%     for rej=1:length(pathsi)
%         counts=zeros(length(validBabies),length(RTepochs{rej}));
%         if rej==1
%             epSt=2;
%         elseif rej==2
%             epSt=1;
%         end
%         for valids = 1:length(validBabies{ages})
%             for epochs=epSt:length(RTepochs{rej})
%                 EEG = pop_loadset('filename',strcat(validBabies{ages}{valids},'_',MoI{ages},extni{rej}),'filepath',strcat(rootpath,MoI{ages},pathsi{rej}));
%                 try
%                     EEG=pop_epoch(EEG, {RTepochs{rej}{epochs}}, [-0.16 0.8], 'newname', 'EGI file ', 'epochinfo', 'yes');
%                     eegy=1;
%                 catch
%                     eegy=0;
%                 end
%                 if eegy==1                  
%                     if length(EEG.event)>1
%                         for trials=1:length(EEG.event)
%                             EEGt=pop_selectevent(EEG,'epoch',trials,'deleteevents','off','deleteepochs','on','invertepochs','off');
%                             pop_export(EEGt,strcat(rootpath,MoI{ages},pathso{rej},RTepochs{rej}{epochs},'/',num2str(trials),'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs},extno{rej},'_',num2str(trials),'.csv'),'erp','off','elec','off','time','off','precision',4);   
%                         end
%                     elseif length(EEG.event)==1
%                         pop_export(EEG,strcat(rootpath,MoI{ages},pathso{rej},RTepochs{rej}{epochs},'/1/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs},extno{rej},'_1.csv'),'erp','off','elec','off','time','off','precision',4);
%                     end
%                 end
%             end        
%         end
%     end
% end

%% let's start by creating a variable for getting the ERPs

% we'll create the average ERP 
% read in the ERPs from the csvs created
% these will be all standards, the oddballs, and the matched Standards

pathsi={'/exports/allStandards/';'/exports/matchedStandards/'};
extni={'_aS_rrf';'_mS_rrf'};
RT01_holder={};
RTmSERP_holder={};
% missing=[];
missingFileName={};
cntr=1;
% mfc=0;
for ages=1:length(MoI)
    RT01_holder{ages}=cell(length(pathsi),1);
    for rej=1:length(pathsi)
        RT01_holder{ages}{rej}=cell(length(validBabies{ages}),1);
        RTmSERP_holder{ages}=cell(length(validBabies{ages}),1);
        for valids=1:length(validBabies{ages})
            if rej==1
                for epochs=1
                    try
                        EEGlabExport=fopen(strcat(rootpath,MoI{ages},pathsi{rej},RTepochs{rej}{epochs},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs},extni{rej},'_erp.csv'));
                        holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                        container=[];
                        for z=1:960
                            container=[container,holder{z}];
                        end
                        RT01_holder{ages}{rej}{valids,epochs}=container; %this is all the data from RT01 (all standards) in the first cell within the age cell, and should be 50x1 for 7mo and 74x1 for 11mo
                                                                       % the actual data from the oddballs will be read in as part of the msERP process in the rej==2 process below
                                                                        % as it's the same
                    catch
                        missingFileName{cntr}=strcat(rootpath,MoI{ages},pathsi{rej},RTepochs{rej}{epochs},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs},extni{rej},'_erp.csv');
                        cntr=cntr+1;
                                                                      
                    end
                end
            elseif rej==2
                for epochs=1:length(RTepochs{rej})/2
                    epochs2=epochs+10; % gets the corresponding mS epoch via RTepochs{rej}{epochs2}
                    try
                        EEGlabExport=fopen(strcat(rootpath,MoI{ages},pathsi{rej},RTepochs{rej}{epochs2},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs2},extni{rej},'_erp.csv'));
                        holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                        container=[];
                        for z=1:960
                            container=[container,holder{z}];
                        end
                        RT01_holder{ages}{rej}{valids,epochs}=container; %mS epochs in the second cell per age (num infants x 10)
                    end
                    try
                        EEGlabExport=fopen(strcat(rootpath,MoI{ages},pathsi{rej},RTepochs{rej}{epochs},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs},extni{rej},'_erp.csv'));
                        holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                        container=[];
                        for z=1:960
                            container=[container,holder{z}];
                        end
                        RTmSERP_holder{ages}{valids,epochs}=container; %now this is the actual data per epoch
%                    catch
%                        missing=[missing;ages,valids,epochs];
%                        mfc=mfc+1;
%                        missingFileName{mfc,ages}=strcat(MoI{ages},pathsi{rej},RTepochs{rej}{epochs2},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTepochs{rej}{epochs2},extni{rej},'_erp.csv');
                    end
                end
            end
        end
    end
end
%%
% now let's create the baseline and windows means, limited to the RoIs

frontal=[2,3,5,6,8,9,10,11];
leftFrCe=[12,13,14,15,17,18,19,20];
rightFrCe=[1,50,53,56,57,58,59,60];
central=[4,7,16,21,34,41,51,54];
leftTePa=[22,24,25,26,27,28,29,30];
rightTePa=[42,44,45,46,47,48,49,52];
occiPari=[31,33,35,36,37,38,39,40];

electrodes={frontal;leftFrCe;rightFrCe;central;leftTePa;rightTePa;occiPari};

RT01ElecAves={};
RTmSERPElecAves={};
for ages=1:length(MoI)
    RT01ElecAves{ages}=cell(length(pathsi),1);
    for r=1:length(pathsi)
        if r==1
            epcell=1;
        elseif r==2
            epcell=10;
        end
        RT01ElecAves{ages}{r}=cell(length(validBabies{ages}),1);
        if r==2
            RTmSERPElecAves{ages}=cell(length(validBabies{ages}),1);
        end
        for e=1:length(RT01ElecAves{ages}{r})
            RT01ElecAves{ages}{r}{e}=cell(length(electrodes),epcell);
            if r==2
                RTmSERPElecAves{ages}{e}=cell(length(electrodes),epcell);
            end
        end
        for v=1:length(validBabies{ages})
            for rt=1:epcell
                for e=1:length(electrodes)
                    try
                        RT01ElecAves{ages}{r}{v}{e,rt}=mean(RT01_holder{ages}{r}{v,rt}(electrodes{e},:));
                    end
                    if r==2
                        try
                        	RTmSERPElecAves{ages}{v}{e,rt}=mean(RTmSERP_holder{ages}{v,rt}(electrodes{e},:));
                        end
                    end
                end
            end
        end
    end
end
%%
%%
% alternative for difference waves: making plots

elec=[2,3,5,6,8,9,10,11,12,13,14,15,17,18,19,20,1,50,53,56,57,58,59,60,4,7,16,21,34,41,51,54];

electrodes={elec};

RT01ElecAves={};
RTmSERPElecAves={};
for ages=1:length(MoI)
    RT01ElecAves{ages}=cell(length(pathsi),1);
    for r=1:length(pathsi)
        if r==1
            epcell=1;
        elseif r==2
            epcell=10;
        end
        RT01ElecAves{ages}{r}=cell(length(validBabies{ages}),1);
        if r==2
            RTmSERPElecAves{ages}=cell(length(validBabies{ages}),1);
        end
        for e=1:length(RT01ElecAves{ages}{r})
            RT01ElecAves{ages}{r}{e}=cell(length(electrodes),epcell);
            if r==2
                RTmSERPElecAves{ages}{e}=cell(length(electrodes),epcell);
            end
        end
        for v=1:length(validBabies{ages})
            for rt=1:epcell
                for e=1:length(electrodes)
                    try
                        RT01ElecAves{ages}{r}{v}{e,rt}=mean(RT01_holder{ages}{r}{v,rt}(electrodes{e},:));
                    end
                    if r==2
                        try
                        	RTmSERPElecAves{ages}{v}{e,rt}=mean(RTmSERP_holder{ages}{v,rt}(electrodes{e},:));
                        end
                    end
                end
            end
        end
    end
end
%%
RT01ERPVals={};
RTmSERPVals={};
for ages=1:length(MoI)
    RT01ERPVals{ages}=cell(length(pathsi),1);
    for r=1:length(pathsi)
        for e=1:length(electrodes)
            for valids=1:length(validBabies{ages})
                if stimuli{ages}{valids}>0
                    if r==1
                        RT01ERPVals{ages}{r,e}(valids,1)=mean(RT01ElecAves{ages}{r}{valids}{e}(1:160));
                        RT01ERPVals{ages}{r,e}(valids,2)=mean(RT01ElecAves{ages}{r}{valids}{e}(380:540));
                    elseif r==2
                        for rts=1:length(RTepochs{r})/2
                            try
                                RT01ERPVals{ages}{r,e}(valids,(rts*2)-1)=mean(RT01ElecAves{ages}{r}{valids}{e,rts}(1:160));
                                RT01ERPVals{ages}{r,e}(valids,rts*2)=mean(RT01ElecAves{ages}{r}{valids}{e,rts}(380:540));
                            end
                            try
                                RTmSERPVals{ages}{e}(valids,(rts*2)-1)=mean(RTmSERPElecAves{ages}{valids}{e,rts}(1:160));
                                RTmSERPVals{ages}{e}(valids,rts*2)=mean(RTmSERPElecAves{ages}{valids}{e,rts}(380:540));
                            end
                        end
                    end
                end
            end
        end
    end
end
  %% difference waves
  %msERP
  
diffWaveHolder=cell(2,2); %2 ages, 10 means
erpHolder=cell(1,2); %2 ages
mmnDiff=cell(2,2);
mmrDiff=cell(2,2);

for ages=1:length(MoI)
    erpHolder{1,ages}=cell(2,2); % ST or OB, by RTHalf
    for ppt=1:length(validBabies{ages})
        diffWaveContainer=cell(2,1);
        erpContainerST=cell(2,1);
        erpContainerOB=cell(2,1);
        for rtims=1:length(RTmSERPElecAves{1,ages}{ppt})
            if rtims<6
                if (isempty(RTmSERPElecAves{ages}{ppt}{rtims})==0)&&(isempty(RT01ElecAves{ages}{2}{ppt}{rtims})==0)
                    diffWaveContainer{1}=[diffWaveContainer{1};RTmSERPElecAves{ages}{ppt}{rtims}-RT01ElecAves{ages}{2}{ppt}{rtims}];
                    erpContainerST{1}=[erpContainerST{1};RT01ElecAves{ages}{2}{ppt}{rtims}];
                    erpContainerOB{1}=[erpContainerOB{1};RTmSERPElecAves{ages}{ppt}{rtims}];             
                end
            else
                if (isempty(RTmSERPElecAves{ages}{ppt}{rtims})==0)&&(isempty(RT01ElecAves{ages}{2}{ppt}{rtims})==0)
                    diffWaveContainer{2}=[diffWaveContainer{2};RTmSERPElecAves{ages}{ppt}{rtims}-RT01ElecAves{ages}{2}{ppt}{rtims}];
                    erpContainerST{2}=[erpContainerST{2};RT01ElecAves{ages}{2}{ppt}{rtims}];
                    erpContainerOB{2}=[erpContainerOB{2};RTmSERPElecAves{ages}{ppt}{rtims}];             
                end
            end
        end
        if isempty(diffWaveContainer{1})==0
            if length(diffWaveContainer{1}(:,1))>1
                diffWaveHolder{ages,1}=[diffWaveHolder{ages,1};mean(diffWaveContainer{1})];
            else
                diffWaveHolder{ages,1}=[diffWaveHolder{ages,1};(diffWaveContainer{1})];
            end
        end
        if isempty(diffWaveContainer{2})==0
            if length(diffWaveContainer{2}(:,1))>1
                diffWaveHolder{ages,2}=[diffWaveHolder{ages,2};mean(diffWaveContainer{2})];
            else       
                diffWaveHolder{ages,2}=[diffWaveHolder{ages,2};(diffWaveContainer{2})];
            end
        end
        
        if isempty(erpContainerST{1})==0
            if length(erpContainerST{1}(:,1))>1
                erpHolder{ages}{1,1}=[erpHolder{ages}{1,1};mean(erpContainerST{1})];
            else
                erpHolder{ages}{1,1}=[erpHolder{ages}{1,1};(erpContainerST{1})];
            end
        end
        if isempty(erpContainerST{2})==0
            if length(erpContainerST{2}(:,1))>1
                erpHolder{ages}{1,2}=[erpHolder{ages}{1,2};mean(erpContainerST{2})];
            else       
                erpHolder{ages}{1,2}=[erpHolder{ages}{1,2};(erpContainerST{2})];
            end
        end
        
        if isempty(erpContainerOB{1})==0
            if length(erpContainerOB{1}(:,1))>1
                erpHolder{ages}{2,1}=[erpHolder{ages}{2,1};mean(erpContainerOB{1})];
            else
                erpHolder{ages}{2,1}=[erpHolder{ages}{2,1};(erpContainerOB{1})];
            end
        end
        if isempty(erpContainerOB{2})==0
            if length(erpContainerOB{2}(:,1))>1
                erpHolder{ages}{2,2}=[erpHolder{ages}{2,2};mean(erpContainerOB{2})];
            else       
                erpHolder{ages}{2,2}=[erpHolder{ages}{2,2};(erpContainerOB{2})];
            end
        end
    end
end

for ages=1:length(diffWaveHolder(:,1))
    for rts=1:length(diffWaveHolder(1,:))
        for datapoints=1:length(diffWaveHolder{ages,rts}(:,1))
            keyDiff=mean(diffWaveHolder{ages,rts}(datapoints,380:540));
            if keyDiff>0
                mmrDiff{ages,rts}=[mmrDiff{ages,rts};diffWaveHolder{ages,rts}(datapoints,:)];
            elseif keyDiff<0
                mmnDiff{ages,rts}=[mmnDiff{ages,rts};diffWaveHolder{ages,rts}(datapoints,:)];
            end
        end
    end
end

%% plotting

timepoints=-159:800;
saveloc=strcat('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/');

%% difference waves
% mmr 
% plots: same age, same dir, diff RTs

%1 MMR 7mo 
shadedErrorBar(timepoints,mean(mmrDiff{1,1}),(std(mmrDiff{1,1})/sqrt(length(mmrDiff{1,1}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,mean(mmrDiff{1,2}),(std(mmrDiff{1,2})/sqrt(length(mmrDiff{1,2}(:,1)))),'lineprops','r')
%saveas(gcf,strcat(saveloc,'MMR_7mo.png'));
%close all

%2 MMR 11mo
shadedErrorBar(timepoints,mean(mmrDiff{2,1}),(std(mmrDiff{2,1})/sqrt(length(mmrDiff{2,1}(:,1)))),'lineprops','g')
hold on
shadedErrorBar(timepoints,mean(mmrDiff{2,2}),(std(mmrDiff{2,2})/sqrt(length(mmrDiff{2,2}(:,1)))),'lineprops','y')
%saveas(gcf,strcat(saveloc,'MMR_11mo.png'));
saveas(gcf,strcat(saveloc,'MMR.png'));
close all

%3 MMN 7mo
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{1,1})).^2),(std(mmnDiff{1,1})/sqrt(length(mmnDiff{1,1}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{1,2})).^2),(std(mmnDiff{1,2})/sqrt(length(mmnDiff{1,2}(:,1)))),'lineprops','r')
%saveas(gcf,strcat(saveloc,'MMN_7mo.png'));
%close all

%4 MMN 11mo
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{2,1})).^2),(std(mmnDiff{2,1})/sqrt(length(mmnDiff{2,1}(:,1)))),'lineprops','g')
hold on
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{2,2})).^2),(std(mmnDiff{2,2})/sqrt(length(mmnDiff{2,2}(:,1)))),'lineprops','y')
%saveas(gcf,strcat(saveloc,'MMN_11mo.png'));
saveas(gcf,strcat(saveloc,'MMN.png'));
close all
%%
%5 MMR 30s 
shadedErrorBar(timepoints,mean(mmrDiff{1,1}),(std(mmrDiff{1,1})/sqrt(length(mmrDiff{1,1}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,mean(mmrDiff{2,1}),(std(mmrDiff{2,1})/sqrt(length(mmrDiff{2,1}(:,1)))),'lineprops','r')
saveas(gcf,strcat(saveloc,'MMR_30s.png'));
close all

%6 MMR 20s
shadedErrorBar(timepoints,mean(mmrDiff{1,2}),(std(mmrDiff{1,2})/sqrt(length(mmrDiff{1,2}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,mean(mmrDiff{2,2}),(std(mmrDiff{2,2})/sqrt(length(mmrDiff{2,2}(:,1)))),'lineprops','r')
saveas(gcf,strcat(saveloc,'MMR_20s.png'));
close all

%7 MMN 30s
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{1,1})).^2),(std(mmnDiff{1,1})/sqrt(length(mmnDiff{1,1}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{2,1})).^2),(std(mmnDiff{2,1})/sqrt(length(mmnDiff{2,1}(:,1)))),'lineprops','r')
saveas(gcf,strcat(saveloc,'MMN_30s.png'));
close all

%8 MMN 20s
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{1,2})).^2),(std(mmnDiff{1,2})/sqrt(length(mmnDiff{1,2}(:,1)))),'lineprops','b')
hold on
shadedErrorBar(timepoints,sqrt((mean(mmnDiff{2,2})).^2),(std(mmnDiff{2,2})/sqrt(length(mmnDiff{2,2}(:,1)))),'lineprops','r')
saveas(gcf,strcat(saveloc,'MMN_20s.png'));
close all


%% can also do the diff waves in R, see if the plots are nicer?
% 
mismatchHolder_mmn730=mmnDiff{1,1};
save(strcat(saveloc,'mmn_7_30.mat'),'mismatchHolder_mmn730');




%% Read in the values from the trial files: separate trials
% for the Oddballs in the allStandards and all trials in the
% matchedStandards approaches

RTin_holder={};
RTin_filenames={};

pathsi={'/results/allStandards/';'/results/matchedStandards/'};
extni={'_aS';'_mS'};

for ages=1:length(MoI)
    RTin_holder{ages}=cell(length(pathsi),1);
    RTin_filenames{ages}=cell(length(pathsi),1);
    RT1m_holder{ages}=cell(length(pathsi),1);
    RT1m_filenames{ages}=cell(length(pathsi),1);
    for rej=1:length(pathsi)
        pathin=strcat(rootpath,MoI{ages},pathsi{rej});   
        if rej==1
            epSt=2;
            RTin_holder{ages}{rej}=cell(length(RTepochs{rej})-1,4);
            RTin_filenames{ages}{rej}=cell(length(RTepochs{rej})-1,4);
        elseif rej==2
            epSt=1;
            RTin_holder{ages}{rej}=cell(length(RTepochs{rej}),4);
            RTin_filenames{ages}{rej}=cell(length(RTepochs{rej}),4);
        end
        for epochs=epSt:length(RTepochs{rej})
            if rej==1
                epochs2=epochs-1;
                currfilenums=[106,107;113,114];
            elseif rej==2
                epochs2=epochs;
                currfilenums=[110,111;117,118];
            end
            for nums=1:4
                rtin=dir([strcat(pathin,RTepochs{rej}{epochs},'/',num2str(nums),'/') '*.csv']);
                RTin_holder{ages}{rej}{epochs2,nums}=cell(length(rtin),1);
                RTin_filenames{ages}{rej}{epochs2,nums}=cell(length(rtin),1);
                for ppt=1:length(rtin)
                    currFileName=strcat(pathin,RTepochs{rej}{epochs},'/',num2str(nums),'/',rtin(ppt).name);
                    EEGlabExport=fopen(currFileName);
                    holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                    container=[];
                    for z=1:960
                        container=[container,holder{z}];
                    end       
                    RTin_holder{ages}{rej}{epochs2,nums}{ppt}=container;
                    if ages==1
                        RTin_filenames{ages}{rej}{epochs2,nums}{ppt}=currFileName(currfilenums(1,1):currfilenums(2,1));
                    elseif ages==2
                        RTin_filenames{ages}{rej}{epochs2,nums}{ppt}=currFileName(currfilenums(1,2):currfilenums(2,2));
                    end
                end
            end
        end
    end
end
%%
% compress to RoIs

RTin_ElecAves={};

for ages=1:length(MoI)
    RTin_ElecAves{ages}=cell(1,1);
    for r=1:length(pathsi)
        if r==1
            RTin_ElecAves{ages}{r}=cell(length(RTepochs{r})-1,4);
        elseif r==2
            RTin_ElecAves{ages}{r}=cell(length(RTepochs{r}),4);
        end
        for epochs=1:length(RTin_ElecAves{ages}{:,r})
            for nums=1:4
                RTin_ElecAves{ages}{r}{epochs,nums}=cell(length(RTin_holder{ages}{r}{epochs,nums}),1);
                for ppts=1:length(RTin_holder{ages}{r}{epochs,nums})
                    for rois=1:length(electrodes)
                        RTin_ElecAves{ages}{r}{epochs,nums}{ppts}=[RTin_ElecAves{ages}{r}{epochs,nums}{ppts};mean(RTin_holder{ages}{r}{epochs,nums}{ppts}(electrodes{rois},:))];                  
                    end
                end
            end
        end
    end
end
%%
% this approach feels dumb and complicated
% seems to tell us, which baby code the value corresponds to
% i guess this will help pick out the correct RT01
RTin_ERPVals={};
RT01_pairedERPVals={}; %making this here so we can have a file of matching deviants
for ages=1:length(MoI)
    RTin_ERPVals{ages}=cell(1,1);
    RT01_pairedERPVals{ages}=cell(1,1);
    for r=1:length(pathsi)
        if r==1
            RTin_ERPVals{ages}{r}=cell(length(RTepochs{r})-1,4);
            RT01_pairedERPVals{ages}{r}=cell(length(RTepochs{r})-1,4);        
        elseif r==2
            RTin_ERPVals{ages}{r}=cell(length(RTepochs{r}),4);
            RT01_pairedERPVals{ages}{r}=cell(length(RTepochs{r}),4);
        end       
        for epochs=1:length(RTin_ElecAves{ages}{:,r})
            for nums=1:4
                RTin_ERPVals{ages}{r}{epochs,nums}=cell(length(RTin_holder{ages}{r}{epochs,nums}),1);
                RT01_pairedERPVals{ages}{r}{epochs,nums}=cell(length(RTin_holder{ages}{r}{epochs,nums}),1);
                for ppts=1:length(RTin_holder{ages}{r}{epochs,nums})    
                    for elec=1:length(electrodes)
                        RTin_ERPVals{ages}{r}{epochs,nums}{ppts}(elec,1)=mean(RTin_ElecAves{ages}{r}{epochs,nums}{ppts}(elec,1:160));
                        RTin_ERPVals{ages}{r}{epochs,nums}{ppts}(elec,2)=mean(RTin_ElecAves{ages}{r}{epochs,nums}{ppts}(elec,380:540));
                        for valids=1:length(validBabies{ages})
                            if strcmp(validBabies{ages}{valids}(1:5),RTin_filenames{ages}{r}{epochs,nums}{ppts}(1:5))
                                RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}=valids;
                                % 
                            end
                        end
                    end
                end
            end
        end
    end
end

% let's save some of these files
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RTmSERPValsALL.mat','RTmSERPVals');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RT01ERPValsALL.mat','RT01ERPVals');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RTin_ERPValsALL.mat','RTin_ERPVals');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RT01_pairedERPValsALL.mat','RT01_pairedERPVals');

%% Now let's create the .mat files for export
%% first up, pull out the values we need for the 3 types of file

riseTime_ERP=cell(1,8);
riseTime_ERP_matchedStandards=cell(1,9);
riseTime_ERP_perTrial_mS=cell(1,10);

validBbz=cell(2,1);

for z=1:2
    for x=1:length(validBabies{z})
        if length(validBabies{z}{x})==7
            validBbz{z}{x}=strcat(validBabies{z}{x},'0');            
        elseif length(validBabies{z}{x})==6
            validBbz{z}{x}=strcat(validBabies{z}{x},'00'); 
        else
            validBbz{z}{x}=validBabies{z}{x};
        end        
    end
end
%%
%riseTime_ERP 
for ages=1:length(MoI)
    for ppts=1:length(RTmSERPVals{ages}{1}(:,1))
        for elec=1:length(electrodes)
            for epochs=1:length(RTmSERPVals{ages}{1}(1,:))
            	RTdev=RTmSERPVals{ages}{elec}(ppts,epochs);              
                riseTime_ERP{1}=[riseTime_ERP{1};validBbz{ages}{ppts}];
                if mod(epochs,2)==1
                    riseTime_ERP{2}=[riseTime_ERP{2};"baseline"];
                elseif mod(epochs,2)==0
                    riseTime_ERP{2}=[riseTime_ERP{2};"mmwindow"];
                end
                riseTime_ERP{3} = [riseTime_ERP{3}; elec];
                riseTime_ERP{4} = [riseTime_ERP{4}; RTdev];
                if mod(epochs,2)==1
                    riseTime_ERP{5} = [riseTime_ERP{5}; RTepochs{2}{(epochs+1)/2}];            
                elseif mod(epochs,2)==0
                    riseTime_ERP{5} = [riseTime_ERP{5}; RTepochs{2}{epochs/2}];  
                end
                if stimuli{ages}{ppts}==1
                    riseTime_ERP{6} = [riseTime_ERP{6};"sne"];
                elseif stimuli{ages}{ppts}==2 
                    riseTime_ERP{6} = [riseTime_ERP{6};"ssn"];
                end
                riseTime_ERP{7}=[riseTime_ERP{7};str2num(MoIdata(ages,:))];
                riseTime_ERP{8}=[riseTime_ERP{8};sqrt(RTdev^2)];
            end
            for erpwindow=1:2
                RTdev=RT01ERPVals{ages}{1,elec}(ppts,erpwindow);
                riseTime_ERP{1}=[riseTime_ERP{1};validBbz{ages}{ppts}];
                if erpwindow==1
                	riseTime_ERP{2}=[riseTime_ERP{2};"baseline"];
                elseif erpwindow==2
                    riseTime_ERP{2}=[riseTime_ERP{2};"mmwindow"];  
                end
                riseTime_ERP{3} = [riseTime_ERP{3}; elec];
                riseTime_ERP{4} = [riseTime_ERP{4}; RTdev];
                riseTime_ERP{5} = [riseTime_ERP{5}; RTepochs{1}{1}];
                if stimuli{ages}{ppts}==1
                    riseTime_ERP{6} = [riseTime_ERP{6};"sne"];
                elseif stimuli{ages}{ppts}==2
                    riseTime_ERP{6} = [riseTime_ERP{6};"ssn"];
                end
                riseTime_ERP{7}=[riseTime_ERP{7};str2num(MoIdata(ages,:))];
                riseTime_ERP{8}=[riseTime_ERP{8};sqrt(RTdev^2)];
            end
        end
    end
end
%%
%riseTime_ERP_matchedStandards
for ages=1:length(MoI)
    for ppts=1:length(RTmSERPVals{ages}{1}(:,1))
        for elec=1:length(electrodes)
            for epochs=1:length(RTmSERPVals{ages}{1}(1,:))
                for conds=1:2
                    if conds==1
                        RTdev=RTmSERPVals{ages}{elec}(ppts,epochs); 
                    elseif conds==2
                        RTdev=RT01ERPVals{ages}{2,elec}(ppts,epochs);
                    end
                    riseTime_ERP_matchedStandards{1}=[riseTime_ERP_matchedStandards{1};validBbz{ages}{ppts}];
                    if mod(epochs,2)==1
                        riseTime_ERP_matchedStandards{2}=[riseTime_ERP_matchedStandards{2};"baseline"];
                    elseif mod(epochs,2)==0
                        riseTime_ERP_matchedStandards{2}=[riseTime_ERP_matchedStandards{2};"mmwindow"];
                    end
                    riseTime_ERP_matchedStandards{3} = [riseTime_ERP_matchedStandards{3}; elec];
                    riseTime_ERP_matchedStandards{4} = [riseTime_ERP_matchedStandards{4}; RTdev];
                    if mod(epochs,2)==1
                        riseTime_ERP_matchedStandards{5} = [riseTime_ERP_matchedStandards{5}; RTepochs{2}{((epochs+1)/2)+((conds-1)*10)}];                
                    elseif mod(epochs,2)==0
                        riseTime_ERP_matchedStandards{5} = [riseTime_ERP_matchedStandards{5}; RTepochs{2}{(epochs/2)+((conds-1)*10)}]; 
                    end
                    if stimuli{ages}{ppts}==1
                        riseTime_ERP_matchedStandards{6} = [riseTime_ERP_matchedStandards{6};"sne"];
                    elseif stimuli{ages}{ppts}==2 
                        riseTime_ERP_matchedStandards{6} = [riseTime_ERP_matchedStandards{6};"ssn"];
                    end
                    riseTime_ERP_matchedStandards{7}=[riseTime_ERP_matchedStandards{7};str2num(MoIdata(ages,:))];
                    riseTime_ERP_matchedStandards{8}=[riseTime_ERP_matchedStandards{8};sqrt(RTdev^2)];
                    riseTime_ERP_matchedStandards{9}=[riseTime_ERP_matchedStandards{9};conds];%1 = oddballs 2 = standards
                end
            end
        end
    end
end
%%
%riseTime_ERP_perTrial_mS
for ages=1:length(MoI)
    for r=2
        for epochs=1:length(RTin_ERPVals{ages}{r}(:,1))
            for nums=1:4
                for ppts=1:length(RTin_ERPVals{ages}{r}{epochs,nums})
                    for elec=1:length(electrodes)
                        for erpwindow=1:2
                            RTval=RTin_ERPVals{ages}{r}{epochs,nums}{ppts}(elec,erpwindow);
                            riseTime_ERP_perTrial_mS{1}=[riseTime_ERP_perTrial_mS{1};validBbz{ages}(RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts})];
                            if erpwindow==1
                                riseTime_ERP_perTrial_mS{2}=[riseTime_ERP_perTrial_mS{2};"baseline"];
                            elseif erpwindow==2
                                riseTime_ERP_perTrial_mS{2}=[riseTime_ERP_perTrial_mS{2};"mmwindow"];    
                            end
                            riseTime_ERP_perTrial_mS{3} = [riseTime_ERP_perTrial_mS{3}; elec];
                            riseTime_ERP_perTrial_mS{4} = [riseTime_ERP_perTrial_mS{4}; RTval];
                            riseTime_ERP_perTrial_mS{5} = [riseTime_ERP_perTrial_mS{5}; RTepochs{r}{epochs}];
                            if stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==1
                                riseTime_ERP_perTrial_mS{6} = [riseTime_ERP_perTrial_mS{6};"sne"];
                            elseif stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==2
                                riseTime_ERP_perTrial_mS{6} = [riseTime_ERP_perTrial_mS{6};"ssn"];
                            end 
                            riseTime_ERP_perTrial_mS{7} = [riseTime_ERP_perTrial_mS{7};str2num(MoIdata(ages,:))];
                            riseTime_ERP_perTrial_mS{8} = [riseTime_ERP_perTrial_mS{8}; sqrt(RTval^2)];
                            riseTime_ERP_perTrial_mS{9} = [riseTime_ERP_perTrial_mS{9};nums];
                            if epochs<11
                                riseTime_ERP_perTrial_mS{10} = [riseTime_ERP_perTrial_mS{10};1];
                            else
                                riseTime_ERP_perTrial_mS{10} = [riseTime_ERP_perTrial_mS{10};2];
                            end
                        end
                    end
                end
            end
        end
    end
end


%% now let's add in some additional columns e.g. for 20s/30s, pairs, direction of magnitude for MMR

variousHolders={riseTime_ERP;riseTime_ERP_matchedStandards;riseTime_ERP_perTrial_mS};
newL=[9,10,11];
newP=[10,11,12];
newH=[11,12,13];

for runs=1:length(variousHolders)
    
    baselines{runs}=find(variousHolders{runs}{1,2}=="baseline");
    blprctileRaw{runs}=prctile(variousHolders{runs}{1,4}(baselines{runs}),[2.5 97.5]);
    blprctileMag{runs}=prctile(variousHolders{runs}{1,8}(baselines{runs}),95);
    blmeanraw{runs}=mean(variousHolders{runs}{1,4}(baselines{runs}));
    blmeanmag{runs}=mean(variousHolders{runs}{1,8}(baselines{runs}));
    blstdraw{runs}=std(variousHolders{runs}{1,4}(baselines{runs}));
    blstdmag{runs}=std(variousHolders{runs}{1,8}(baselines{runs}));
    
    windows{runs}=find(variousHolders{runs}{1,2}=="mmwindow");
    wnprctileRaw{runs}=prctile(variousHolders{runs}{1,4}(windows{runs}),[2.5 97.5]);
    wnprctileMag{runs}=prctile(variousHolders{runs}{1,8}(windows{runs}),95);
    wnmeanraw{runs}=mean(variousHolders{runs}{1,4}(windows{runs}));
    wnmeanmag{runs}=mean(variousHolders{runs}{1,8}(windows{runs}));
    wnstdraw{runs}=std(variousHolders{runs}{1,4}(windows{runs}));
    wnstdmag{runs}=std(variousHolders{runs}{1,8}(windows{runs}));
    
    for rows=1:length(variousHolders{runs}{1,4}(baselines{runs}))
        variousHolders{runs}{1,newL(runs)}(baselines{runs}(rows),1)=4;
    end
    
    for rows=1:length(variousHolders{runs}{1,4}(windows{runs}))
        if variousHolders{runs}{1,4}(windows{runs}(rows))<=blprctileRaw{runs}(1)
            variousHolders{runs}{1,newL(runs)}(windows{runs}(rows),1)=1;
        elseif variousHolders{runs}{1,4}(windows{runs}(rows))>=blprctileRaw{runs}(2)
            variousHolders{runs}{1,newL(runs)}(windows{runs}(rows),1)=2;
        elseif (variousHolders{runs}{1,4}(windows{runs}(rows))<blprctileRaw{runs}(2))&&(variousHolders{runs}{1,4}(windows{runs}(rows))>blprctileRaw{runs}(1))
            variousHolders{runs}{1,newL(runs)}(windows{runs}(rows),1)=0;
        end
    end

    for rows=1:length(variousHolders{runs}{1,5})
        if (strcmp(variousHolders{runs}{1,5}(rows,:),"RT39"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT37"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=3937;
            variousHolders{runs}{1,newH(runs)}(rows,1)=30;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT35"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT33"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=3533;
            variousHolders{runs}{1,newH(runs)}(rows,1)=30;
        elseif strcmp(variousHolders{runs}{1,5}(rows,:),"RT31")
            variousHolders{runs}{1,newP(runs)}(rows,1)=3129; 
            variousHolders{runs}{1,newH(runs)}(rows,1)=30;
        elseif strcmp(variousHolders{runs}{1,5}(rows,:),"RT29")
            variousHolders{runs}{1,newP(runs)}(rows,1)=3129; 
            variousHolders{runs}{1,newH(runs)}(rows,1)=20;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT27"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT25"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=2725;
            variousHolders{runs}{1,newH(runs)}(rows,1)=20;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT23"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT21"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=2321;
            variousHolders{runs}{1,newH(runs)}(rows,1)=20;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT38"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT36"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=3836;
            variousHolders{runs}{1,newH(runs)}(rows,1)=32;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT34"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT32"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=3432;
            variousHolders{runs}{1,newH(runs)}(rows,1)=32;
        elseif strcmp(variousHolders{runs}{1,5}(rows,:),"RT30")
            variousHolders{runs}{1,newP(runs)}(rows,1)=3028; 
            variousHolders{runs}{1,newH(runs)}(rows,1)=32;
        elseif strcmp(variousHolders{runs}{1,5}(rows,:),"RT28")
            variousHolders{runs}{1,newP(runs)}(rows,1)=3028; 
            variousHolders{runs}{1,newH(runs)}(rows,1)=22;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT26"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT24"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=2624;
            variousHolders{runs}{1,newH(runs)}(rows,1)=22;
        elseif (strcmp(variousHolders{runs}{1,5}(rows,:),"RT22"))||(strcmp(variousHolders{runs}{1,5}(rows,:),"RT20"))
            variousHolders{runs}{1,newP(runs)}(rows,1)=2220;
            variousHolders{runs}{1,newH(runs)}(rows,1)=22;   
        elseif strcmp(variousHolders{runs}{1,5}(rows,:),"RT01")
            variousHolders{runs}{1,newP(runs)}(rows,1)=1000;
            variousHolders{runs}{1,newH(runs)}(rows,1)=10;   
        end
    end
end

riseTime_ERP2=variousHolders{1};
riseTime_ERP3=variousHolders{2};
riseTime_ERP4=variousHolders{3};
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP/riseTime_ERP_ALL.mat','riseTime_ERP2')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP_matchedStandards/riseTime_ERP_matchedStandards_ALL.mat','riseTime_ERP3')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP_perTrial/riseTime_ERP_perTrial_mS_ALL.mat','riseTime_ERP4')

% these files are saved so they can be loaded into the script for creating MMNs

%% create files for use in R

% first up, alphabetise babies, assign numbers, create variable accordingly
validBabas=unique([validBbz{1},validBbz{2}]);

validnums=sort(validBabas);

for runs=1:length(variousHolders)
    erpExp{runs}=[];
    erpExpH{runs}=variousHolders{runs}{1};
    for x=1:length(erpExpH{runs})
        for v=1:length(validnums)
            if strcmp(erpExpH{runs}(x,:),validnums{v})
                erpExp{runs}=[erpExp{runs};v];
            end
        end
    end
    
    erpExp2{runs}=[];
    erpExpH2{runs}=variousHolders{runs}{2};
    for x=1:length(erpExpH2{runs})
        if erpExpH2{runs}{x}=="baseline"
            erpExp2{runs}=[erpExp2{runs};1];
        elseif erpExpH2{runs}{x}=="mmwindow"
            erpExp2{runs}=[erpExp2{runs};2];
        end
    end
    
    erpExp{runs}(:,2)=erpExp2{runs};
    erpExp{runs}(:,3)=variousHolders{runs}{3};
    erpExp{runs}(:,4)=variousHolders{runs}{4};
    
    erpExp5{runs}=[];
    erpExpH5{runs}=variousHolders{runs}{5};
    for x=1:length(erpExpH5{runs})
        erpExp5{runs}=[erpExp5{runs};str2double(erpExpH5{runs}(x,3:4))];
    end
    
    erpExp{runs}(:,5)=erpExp5{runs};
    
    erpExpH6{runs}=variousHolders{runs}{6};
    erpExp6{runs}=[];
    for x=1:length(erpExpH6{runs})
        if erpExpH6{runs}{x}=="sne"
            erpExp6{runs}=[erpExp6{runs};1]; 
        elseif erpExpH6{runs}{x}=="ssn"
            erpExp6{runs}=[erpExp6{runs};2];
        end
    end
    
    erpExp{runs}(:,6)=erpExp6{runs};
    
    for t=7:length(variousHolders{runs})
        erpExp{runs}(:,t)=variousHolders{runs}{t};
    end
end
    
%% get rid of outliers
% based on erp values, not magnitudes
% use 2.5 stdev, strict but otherwise we get bizarre values

for runs=1:length(erpExp)
    outlierholder{runs}=[];
    outlierholderbase{runs}=[];
    for x=1:length(windows{runs})
        if (erpExp{runs}(windows{runs}(x),4)>(wnmeanraw{runs}+(2.5*wnstdraw{runs})))||(erpExp{runs}(windows{runs}(x),4)<(wnmeanraw{runs}-(2.5*wnstdraw{runs})))
            outlierholder{runs}=[outlierholder{runs};windows{runs}(x),erpExp{runs}(windows{runs}(x),4)];
        end
    end
    for x=1:length(baselines{runs})
        if (erpExp{runs}(baselines{runs}(x),4)>(blmeanraw{runs}+(2.5*blstdraw{runs})))||(erpExp{runs}(baselines{runs}(x),4)<(blmeanraw{runs}-(2.5*blstdraw{runs})))
            outlierholderbase{runs}=[outlierholderbase{runs};baselines{runs}(x),erpExp{runs}(baselines{runs}(x),4)];
        end
    end
    
    % if we're dropping a given value, we should also drop its corollary
    % baseline or window period
    
    if (runs==1)||(runs==3)
        droptrials{runs}=[outlierholder{runs}(:,1);outlierholder{runs}(:,1)-1;outlierholderbase{runs}(:,1);outlierholderbase{runs}(:,1)+1];
    else
        droptrials{runs}=[outlierholder{runs}(:,1);outlierholder{runs}(:,1)-2;outlierholderbase{runs}(:,1);outlierholderbase{runs}(:,1)+2];
    end

    droptrials{runs}=unique(droptrials{runs});
    erpExp{runs}(droptrials{runs},:)=[];
    baselines2{runs}=find(erpExp{runs}(:,2)==0);
    windows2{runs}=find(erpExp{runs}(:,2)==1);   
end

erp_Exp1=erpExp{1};
erp_Exp2=erpExp{2};
erp_Exp3=erpExp{3};
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP/riseTime_ERP_R_all.mat','erp_Exp1')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP_matchedStandards/riseTime_ERP_matchedStandards_R_all.mat','erp_Exp2')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/ERP_perTrial/riseTime_ERP_perTrial_mS_R_all.mat','erp_Exp3')

