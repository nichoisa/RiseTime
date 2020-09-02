%% Rise time ERP preprocessing

%% first step: truncate EEG files to just the RT data?
% first 50 7 mths

% {'AH20eg91';'DA01fy01';'DA28ns10';'EE29jp49';'EG20dz29';'EK24xi46';'EL03fg21';...
%     'EM16js91';'ES06cf77';'ET19pa06';'GD20bg51';'HS14ab22';'LD09sd7';'LL12cb78';...
%     'MC31dv56';'NB13ay10';'OD29as10';'OW16al07';'RG31rt10';'RK05ld83';'RO18ck33';...
%     'TC09jp54';'ZT29ab23'};

%first 50 11 mths
% {'AB16cg04';'AH20eg91';'AM26ys67';'AR17bh32';'AV13hg77';'BR28df34';'CA08zr73';...
%     'DA01fy01';'EB21bfy5';'EF18uj27';'EG20dz29';'EK24xi46';'EL03fg21';'EM16js91';...
%     'ES06cf77';'ET19pa06';'FB085k2m';'FR22ya5';'GD20bg51';'GK03fj19';'GS21bc55';...
%     'HS01fg79';'HS14ab22';'IM14fr77';'JS18ab01';'LB04tg17';'LB27ab98';'LD09sd7';...
%     'LL12cb78';'MC31dv56';'NB13ay10';'NH10nm27';'OW16al07';'RK05ld83';'RM28at5b';...
%     'RO18ck33';'SI00g2';'TV2401';'ZT29ab23'};


% more sensible - random pilot group per stimulus type

% Sine:
% {'CW23hj23';'DS04gg02';'EE29jp49';'EG20dz29';'EL03fg21';'EM16js91';'ET19pa06';'GD20bg51';'OD29as10';...
% 'RO18ck33';'SB22sg34'};
% SSN:
% {'AJ09ac23';'CR14by47';'DM18eo92';'DW04rp75';'EM13zx98';'ER09ji58';'FA22ws13';'HH07pd92';'LH25pp22';...
% 'LO23sc41';'RF12vh59'};

% in main file with 7s

% 7mo
% mainfile7s={'AA08gs64';'AB19cm13';'AB28ka99';'AH12ps44';'AJ09ac23';'AV03ct18';'BD08ol68';'BM26hg18';'CM06cb31';...
%     'CR14by47';'CW23hj23';'DC09ls10';'DM18eo92';'DS04gg02';'DW04rp75';'EB23kn04';'EL16jn01';'EM13zx98';'ER09ji58';...
%     'ES20tv22';'EW01gm26';'FA22ws13';'FS15vp50';'GZ21am18';'HB29lw72';'HE27ab19';'HH07pd92';'HX13xx13';'IG21te67';...
%     'IS19kq76';'KG05gg66';'LF20fm32';'LH25pp22';'LO23sc41';'MS04jo74';'NG10tr65';'NO08js23';'NW28cp37';'RC01mw31';'RF12vh59';'RM05sz86';...
%     'RW31rm47';'SB22sg34';'SH28dt49';'SN02sm01';'WP25ph27';'YB13yu73';'ZL23te18'};

%11mo

mainfile7s={'AB28ka99';'AJ09ac23';'AV13hg77';'BD08ol68';'BM26hg18';'CR14by47';'CW23hj23';'DA01fy01';'DA28ns10';'DC09ls10';...
    'DM18eo92';'DS04gg02';'DW04rp75';'EB23kn04';'ED14vx53';'EE29jp49';'EG20dz29';'EK10pf48';'EK24xi46';'EL16jn01';...
    'EM13zx98';'ER09ji58';'EW01gm26';'FA10jp92';'FA22ws13';'FM12cv10';'FS11cd42';'GD20bg51';'GZ21am18';'HB29lw72'...
    'HE27ab19';'HH07pd92';'HS14ab22';'HX14xx13';'IS19kq76';'IG21te67';'JD31ga12';'KG05gg66';'LF20fm31';'LL12cb78'...
    'LO23sc41';'NB13ay10';'NG10tr65';'NO08js23';'OD29as10';'OW16al07';'PS11kr29';'RB28nb19';'RC01mw31';'RG31rt10';...
    'RK05ld83';'RM05sz86';'RO18ck33';'RR04tr76';'RW31rm47';'SB22sg34';'SH28dt49';'TP01cd11';'VP14wb41'};

% in separate file with 7s

% 7mo
% sepfile7s={'DA28ns10';'EE29jp49';'EG20dz29';'EK10pf48';
%     'FM12cv10';'GD20bg51';'NB05JR55';'OD29as10';'RG31rt10';'RK05ld83';'RO18ck33'};

% 11mo
sepfile7s={'EL03fg21';'EM16js91';'ES06cf77';'ES20tv22';'GS21bc55';'LD09sd7';'NW28cp37';'ZT29ab23'};
% NB LD09sd7 missing first few DINS and first TRSP.


% in main file, no 7s
% 7mo
%mainfileno7s={'AH20eg91';'ET19pa06';'LD09sd7';'TC09jp54'};

% 11mo
mainfileno7s={'AB16cg04';'CA08zr73';'EB21bfy5'};

% in separate file, no 7s
% 7mo
%sepfileno7s={'DA01fy01';'EK24xi46';'EL03fg21';'EM16js91';'ES06cf77';'HS14ab22';'LL12cb78';'MC31dv5b';'OW16al07';'ZT29sb23'};

% 11mo
sepfileno7s={'AH20eg91';'AM26ys67';'AR17bh32';'AT07pi88';'BR28df34';'EF18uj27';'ET19pa06';'FB085k2m';'FR22ya5';'GK03fj19'...
    'HS01fg79';'IM14fr77';'JS18ab01';'LB04tg17';'LB27ab98';'MC31dv56';'NH10nm27';'RM28at5b';'SI00g2';'TV2401'};


%% modify based on data subgroup

validBabies={'AB19cm13'};
bbtype=1; % in order above 

%%


MoI='7mo';
rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';
rawpath = strcat(rootpath,MoI,'/');
filteredpath = strcat(rootpath,MoI,'/filt/');

%% read raws and evts in
%pathin='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/TaDrum/raw data/6mo/';
raw=dir([rawpath '*.raw']);
evt=dir([rawpath '*.evt']);
rawList=[];
evtList=[];
for x=1:length(raw)
    rawList=[rawList;string(raw(x).name)];
end
for x=1:length(evt)
    evtList=[evtList;string(evt(x).name)];
end


%%
for valids=1:length(validBabies)
    containE=strcat(validBabies{valids},'+\w*.evt');
    containR=strcat(validBabies{valids},'+\w*.raw');
    presentE=regexp(evtList,containE,'match');
    presentR=regexp(rawList,containR,'match');
    raws=[];
    evts=[];
    for e=1:length(presentE)
        if isempty(presentE{e})
            evts=evts;
        else
            evts=[evts presentE{e}];
        end
    end
    for r=1:length(presentR)
        if isempty(presentR{r})
            raws=raws;
        else
            raws=[raws presentR{r}];
        end
    end 
    validBabies{valids,2}=raws;
    validBabies{valids,3}=evts;
end

%% now let's preprocess
%ensure correct sensor array, and filter
% Shorten long files to save on processing power

evtstore={};

[ALLEEG,EEG,CURRENTSET,ALLCOM] = eeglab;
pathout=filteredpath;
if bbtype==1
    for ppt=1:length(validBabies(:,1))
        pptRawName=strcat(rawpath,validBabies{ppt,2}(1));
        evtname=strcat(rawpath,validBabies{ppt,3});
        fullevt=fopen(evtname);
        evtstore=textscan(fullevt,'%s %*s %s %*s %s %*s %s %u64 %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s' ,'Delimiter','\t','headerlines', 3);
        trsps=find(strcmp(evtstore{1,1},'TRSP'));
        RTtrigger=[];
        for triggers = 1:length(trsps)
            RTtrigger=[RTtrigger;evtstore{1,5}(trsps(triggers))];
        end
        risetimes=find(RTtrigger==7);
        limitTRSP=max(risetimes+1);
        %should be 48 dins following each Rise Time TRSP
        if trsps(limitTRSP)-trsps(limitTRSP-1)==49
            typicalStatus=1;
        else
            typicalStatus=0;
        end
        EEG = pop_readegi(pptRawName, []);
        EEG=pop_chanedit(EEG, 'load',{'/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/MLpacks/0_2AverageNet64_v1.sfp' 'filetype' 'sfp'},'changefield',{68 'datachan' 0});
        [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
        %final event is the new recording start - so we keep all data after
        %the last RT DIN (recording should be paused fairly soon after
        %anyway) until the "epoc" event when the recording restarts.
        %This section below is for selecting RT data only
        maxRTtime=((EEG.event(trsps(max(risetimes))+49).latency)/1000)+30; %adding an extra 30 secs to see if it helps with the 
                                                                            % truncations of the filter
%         if typicalStatus==1
%              EEG=pop_select(EEG,'time',[EEG.xmin maxRTtime]);
%              EEG = pop_eegfiltnew(EEG, 0.4, 45); % filter used summer 19; 1 highpass mar 19; 0.2 highpass dec 18
%              EEG = pop_saveset(EEG, strcat(pptFileName,'_filt'), pathout);
%         end
    end   
end
%%

if (bbtype==2)||(bbtype==4)
    for ppt=1:length(validBabies(:,1))    
        for numRaws=1:length(validBabies{ppt,2})
            pptRawName=strcat(rawpath,validBabies{ppt,2}(numRaws));
            %pptEvtName=strcat(pathin, validBabies{ppt,3});
            if length(validBabies{ppt,2})>1
                pptFileName=strcat(validBabies{ppt,1},'_',MoI,'_',num2str(numRaws));
            else 
                pptFileName=strcat(validBabies{ppt,1},'_',MoI);
            end
            EEG = pop_readegi(pptRawName, []);
            EEG=pop_chanedit(EEG, 'load',{'/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/MLpacks/0_2AverageNet64_v1.sfp' 'filetype' 'sfp'},'changefield',{68 'datachan' 0});
            [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
             EEG = pop_eegfiltnew(EEG, 0.4, 45); % filter used summer 19; 1 lowpass mar 19; 0.2 lowpass dec 18
            EEG = pop_saveset(EEG, strcat(pptFileName,'_filt'), pathout);
        end
    end
end
%%
if bbtype==3
    for ppt=1:length(validBabies(:,1))
        pptRawName=strcat(rawpath,validBabies{ppt,2}(1));
        evtname=strcat(rawpath,validBabies{ppt,3});
        fullevt=fopen(evtname);
        evtstore=textscan(fullevt,'%s %*s %s %*s %s %*s %s %u64 %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s' ,'Delimiter','\t','headerlines', 3);
        trsps=find(strcmp(evtstore{1,1},'TRSP'));
        Trigger=[];
        for triggers = 1:length(trsps)
            Trigger=[Trigger;evtstore{1,5}(trsps(triggers))];
        end
        firstTrigger=find(Trigger==3);
        limitTRSP=trsps(firstTrigger(1));
        EEG = pop_readegi(pptRawName, []);
        EEG=pop_chanedit(EEG, 'load',{'/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/MLpacks/0_2AverageNet64_v1.sfp' 'filetype' 'sfp'},'changefield',{68 'datachan' 0});
        [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG);
        %keep everything before limitTRSP
        maxRTtime=((EEG.event(limitTRSP-1).latency)/1000)+30; %same as above - try to stop the filtering causing drifts at the last RT
        EEG=pop_select(EEG,'time',[EEG.xmin maxRTtime]);
        EEG = pop_eegfiltnew(EEG, 0.2, 45); % filter used summer 19; 1 highpass mar 19; 0.2 highpass dec 18
        EEG = pop_saveset(EEG, strcat(pptFileName,'_filt'), pathout);
    end
end
