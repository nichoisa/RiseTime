%% rise time script 2: filtering done - time to add in events

MoI='7mo';
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot7mo.mat');
%load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test7mo.mat');

% MoI='11mo';
% %load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot11mo.mat');
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test11mo.mat');

rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';
%% step 1: manual channel rejection
% manually review data and select consistently bad channels to reject
% after the process runs, check the data again to be sure you selected the
% "correct" bad channels
% automated channel rejection will be done later, after segmenting

[ALLEEG EEG, CURRENTSET ALLCOM] = eeglab;
manChans=csvread(strcat(rootpath,MoI,'/chanRej/first_chanRejMan_',MoI,'.csv')); %file with manually selected channels
for ppt=1:length(validBabies)
    EEG=pop_loadset('filename',strcat(validBabies{ppt},'_',MoI,'_filt.set'),'filepath',strcat(rootpath,MoI,'/filt/'));
    rejname=strcat(validBabies{ppt},'_',MoI,'_rejChan');
    manNonZero=manChans(ppt,:)~=0;
    manelec=manChans(ppt,manNonZero);
    rej=[manelec,23,55,61,62,63,64];
    rej=sort(rej);
    rej=unique(rej);
    EEG = eeg_interp(EEG, rej);
    EEG = pop_saveset(EEG,rejname,strcat(rootpath,MoI,'/chanRej/'));
end
%% step 2: add event names
% load the guide to the trials
load('Rise_time_video_codes.mat')
load('Rise_time_video_codes_alt.mat')
load('Rise_time_video_codes_72.mat')

% also do the ones where we're matching the final pre-oddball trial
load('Rise_time_video_codes_match.mat')
load('Rise_time_video_codes_alt_match.mat')
load('Rise_time_video_codes_72_match.mat')

% we need to do this twice
% once with the chanRej data and once with the filt data
% all will be explained in step 3!

evt=dir([strcat(rootpath,MoI,'/') '*.evt']);
evtList=[];
for x=1:length(evt)
    evtList=[evtList;string(evt(x).name)];
end

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

infilelocs={strcat(rootpath,MoI,'/filt/');strcat(rootpath,MoI,'/chanRej/')};
infilenames={'_filt.set';'_rejChan.set'};
outfilelocs={strcat(rootpath,MoI,'/renamedEvents/filteredOnly/');strcat(rootpath,MoI,'/renamedEvents/chanRejected/')};
outfilenames={'_filtEvts.set';'_rejEvts.set'};

for valids=11%:length(validBabies)
    for rounds=1:length(infilelocs)
        for evts=1:length(evtList)
            if strcmp(validBabies{valids},evtList{evts}(1:length(validBabies{valids})))
                validBabies{valids,2}=evtList{evts};
            end
        end
        evtname=strcat(rootpath,MoI,'/',validBabies{valids,2});
        fullevt=fopen(evtname);
        evtstore=textscan(fullevt,'%s %*s %s %*s %s %*s %s %u64 %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s' ,'Delimiter','\t','headerlines', 3);
        trsps=find(strcmp(evtstore{1,1},'TRSP'));
        RTtrigger=[];
        for triggers = 1:length(trsps)
            RTtrigger=[RTtrigger;evtstore{1,5}(trsps(triggers))];
        end
        risetimes=find(RTtrigger==7); % find anywhere with a risetime TRSP
        if ((validBabies{valids}=="EK10pf48")||((validBabies{valids}=="RK05ld83")&&(MoI=="7mo"))||((validBabies{valids}=="ES20tv22")&&(MoI=="11mo"))||((validBabies{valids}=="RK05ld83")&&(MoI=="11mo")))
            trsps=trsps-1;
        end
        % We are doing this with the FILTERED and not the ChanRej data for a
        % reason
        % I don't want to double-interpolate - we'll do the chanrej
        % interpolation AGAIN as part of the segment-by-segment interpolation
%                
        EEG=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,infilenames{rounds}),'filepath',infilelocs{rounds});
        EEG.comments=(strcat(char(EEG.comments(1)),char(EEG.comments(2))));
        EEGm=pop_loadset('filename',strcat(validBabies{valids},'_',MoI,infilenames{rounds}),'filepath',infilelocs{rounds});
        EEGm.comments=(strcat(char(EEGm.comments(1)),char(EEGm.comments(2))));

        %% let's make some different parameters depending on the type of file
       
        if DINfile{valids}=="48" %if it's a standard file
            RTfile=rise_time_code;
            RTmatch=rise_time_code_match;
            RTlen=48;
            typRTs=5;
        elseif DINfile{valids}=="72"
            RTfile=rise_time_code_72;
            RTmatch=rise_time_code_72_match;
            RTlen=72;
            typRTs=4;
        elseif DINfile{valids}=="alt"    
            RTfile=rise_time_code_alt;
            RTmatch=rise_time_code_alt_match;
            RTlen=48;
            typRTs=6;
        elseif DINfile{valids}=="alt5"
            RTfile=rise_time_code_alt;
            RTmatch=rise_time_code_alt_match;
            RTlen=48;
            typRTs=5;
        end
        
        typRTstart=1+missingFirstTrial(valids);
        typRTend=typRTs-missingEndTrials(valids);            

        %stick in rise time TRSPs for those that have them    
        if (isempty(risetimes)==0 && individErrs{valids}~="manual")
            for rts=typRTstart:typRTend
                EEG.event(trsps(risetimes(rts))).type=(strcat('RTE',num2str(rts)));
                EEGm.event(trsps(risetimes(rts))).type=(strcat('RTE',num2str(rts)));
            end 
            if insertedDINs(valids)==1 %if they need to have missing DINs added back
                %bads should be a 2 column file with TRSP number (not risetime number) and DIN number.
                bads=csvread(strcat(rootpath,MoI,'/renamedEvents/',validBabies{valids},'_',MoI,'_insertDINs.csv'));
                [insertedEvents,trsps]=missingRTDINs(EEG.event,bads,trsps);
                if validBabies{valids}=="RM05sz86"&&MoI=="11mo" %custom fix
                    latencydiff=(insertedEvents(153).latency-insertedEvents(150).latency)/3;
                    insertedEvents(151).latency=insertedEvents(150).latency+latencydiff;
                    insertedEvents(152).latency=insertedEvents(153).latency-latencydiff;
                elseif validBabies{valids}=="NG10tr65"&&MoI=="11mo" %custom fix
                    latencydiff=(insertedEvents(156).latency-insertedEvents(153).latency)/3;
                    insertedEvents(154).latency=insertedEvents(153).latency+latencydiff;
                    insertedEvents(155).latency=insertedEvents(156).latency-latencydiff;
                end
                EEG.event=insertedEvents;
                EEGm.event=insertedEvents;
            end  
            for rts=typRTstart:typRTend
                for dins=1:RTlen
                    dinname=num2str(RTfile(rts,dins));
                    dinname_match=num2str(RTmatch(rts,dins));
                    if length(dinname)<2
                        dinname=strcat('0',dinname);
                    end
                    if length(dinname_match)<2
                    	dinname_match=strcat('0',dinname_match);
                    end
                    if (validBabies{valids}=="AA08gs64")&&(rts==1)&&(MoI=="7mo") %custom issue
                        EEG.event((trsps(risetimes(rts)))+dins+2).type=(strcat('RT',dinname));
                        EEGm.event((trsps(risetimes(rts)))+dins+2).type=(strcat('RT',dinname_match)); 
                    else
                        EEG.event((trsps(risetimes(rts)))+dins).type=(strcat('RT',dinname));
                        EEGm.event((trsps(risetimes(rts)))+dins).type=(strcat('RT',dinname_match));
                    end
                end
            end
            
        %for those that don't have TRSPs         
        else
            if insertedDINs(valids)==1 %if they need to have missing DINs added back
                trsps=1;
                %bads should be a 2 column file with TRSP number (not risetime number) and DIN number.
                bads=csvread(strcat(rootpath,MoI,'/renamedEvents/',validBabies{valids},'_',MoI,'_insertDINs.csv'));
                [insertedEvents,trsps]=missingRTDINs(EEG.event,bads,trsps);
                EEG.event=insertedEvents;
                EEGm.event=insertedEvents;
            end  
            if individErrs{valids}=="none" && isempty(risetimes) 
                for rts=typRTstart:typRTend
                    if (rts==4)&&(validBabies{valids}=="NH10nm27") %custom problem solver
                        RTlen2=51;
                    elseif rts==3&&validBabies{valids}=="EB21bfy5"
                        RTlen2=53;
                    else
                        RTlen2=RTlen;
                    end
                    for dins=diffStart(valids):RTlen2
                        dinname=num2str(RTfile(rts,dins));
                        dinname_match=num2str(RTmatch(rts,dins));
                        if length(dinname)<2
                            dinname=strcat('0',dinname);
                        end
                        if length(dinname_match)<2
                            dinname_match=strcat('0',dinname_match);
                        end
                        EEG.event(dins+dinsB4FirstSound(valids)+((rts-1)*RTlen)).type=strcat('RT',dinname);
                        EEGm.event(dins+dinsB4FirstSound(valids)+((rts-1)*RTlen)).type=strcat('RT',dinname_match);
                    end
                end
            elseif individErrs{valids}=="diffStart"
                for dins=(diffStart(valids)):RTlen
                    dinname=num2str(RTfile(typRTstart,dins));
                    dinname_match=num2str(RTmatch(typRTstart,dins));                    
                    if length(dinname)<2
                        dinname=strcat('0',dinname);
                    end
                    if length(dinname_match)<2
                        dinname_match=strcat('0',dinname_match);
                    end
                    %something here about typRTstart?
                    EEG.event(dins-diffStart(valids)+1+dinsB4FirstSound(valids)).type=strcat('RT',dinname);
                    EEGm.event(dins-diffStart(valids)+1+dinsB4FirstSound(valids)).type=strcat('RT',dinname_match);
                end
                for rts=typRTstart+1:typRTend
                    for dins=1:RTlen
                        dinname=num2str(RTfile(rts,dins));
                        dinname_match=num2str(RTmatch(rts,dins));
                        if length(dinname)<2
                            dinname=strcat('0',dinname);
                        end
                        if length(dinname_match)<2
                            dinname_match=strcat('0',dinname_match);
                        end
                        EEG.event(dins+((rts-1)*RTlen)-(diffStart(valids)-1)-dinsB4FirstSound(valids)).type=strcat('RT',dinname);
                        EEGm.event(dins+((rts-1)*RTlen)-(diffStart(valids)-1)-dinsB4FirstSound(valids)).type=strcat('RT',dinname_match);
                    end
                end   
            elseif individErrs{valids}=="manual"
                % all these numbers pertain to EM16; maybe we can finesse if
                % problem affects more than 1 baby
                if validBabies{valids}=="EM16js91"
                    holder=EEG.event;
                    holderm=EEGm.event;
                    for structLines=19:210 %put all of the events from when the DINs/events start back, til the end of the file, in a holder
                        EEG.event(structLines+27)=holder(structLines);
                        EEGm.event(structLines+27)=holderm(structLines);
                    end                    
                    EEG.event(1).latency=500; %define the latency of the first (new) event
                    EEGm.event(1).latency=500;
                    for firstStim=2:45 % add events at a fixed interval of 1s
                        EEG.event(firstStim).latency=EEG.event(1).latency+((firstStim-1)*1000);
                        EEGm.event(firstStim).latency=EEGm.event(1).latency+((firstStim-1)*1000);
                    end
                    for dins=(diffStart(valids)):RTlen %diffStart should be =4 for EM16 
                        dinname=num2str(RTfile(1,dins));
                        dinname_match=num2str(RTmatch(1,dins));                    
                        if length(dinname)<2
                            dinname=strcat('0',dinname);
                        end
                        if length(dinname_match)<2
                            dinname_match=strcat('0',dinname_match);
                        end
                        EEG.event(dins-(diffStart(valids)-1)).type=(strcat('RT',dinname));
                        EEGm.event(dins-(diffStart(valids)-1)).type=(strcat('RT',dinname_match));
                    end           
                    for rts=2:typRTs
                        for dins=1:RTlen
                            dinname=num2str(RTfile(rts,dins));                    
                            dinname_match=num2str(RTmatch(rts,dins));                    
                            if length(dinname)<2
                                dinname=strcat('0',dinname);
                            end
                            if length(dinname_match)<2
                                dinname_match=strcat('0',dinname_match);
                            end
                            EEG.event(45+((rts-2)*48)+dins).type=(strcat('RT',dinname));
                            EEGm.event(45+((rts-2)*48)+dins).type=(strcat('RT',dinname_match));
                        end
                    end 
                elseif validBabies{valids}=="LD09sd7"
                    for dins=diffStart(valids):RTlen
                        dinname=num2str(RTfile(1,dins));
                        dinname_match=num2str(RTmatch(1,dins));
                        if length(dinname)<2
                            dinname=strcat('0',dinname);
                        end
                        if length(dinname_match)<2
                            dinname_match=strcat('0',dinname_match);
                        end
                        EEG.event(dins-diffStart(valids)+1).type=strcat('RT',dinname);
                        EEGm.event(dins-diffStart(valids)+1).type=strcat('RT',dinname_match);
                    end
                    for rts=(typRTstart-1):(typRTend-1)
                        EEG.event(trsps(risetimes(rts))).type=(strcat('RTE',num2str(rts+1)));
                        EEGm.event(trsps(risetimes(rts))).type=(strcat('RTE',num2str(rts+1)));
                        for dins=1:RTlen
                            dinname=num2str(RTfile(rts+1,dins));
                            dinname_match=num2str(RTmatch(rts+1,dins));  
                            if length(dinname)<2
                                dinname=strcat('0',dinname);
                            end
                            if length(dinname_match)<2
                                dinname_match=strcat('0',dinname_match);
                            end                      
                            EEG.event((trsps(risetimes(rts)))+dins).type=(strcat('RT',dinname));
                            EEGm.event((trsps(risetimes(rts)))+dins).type=(strcat('RT',dinname_match));
                        end
                    end
                end
            end 
        end
        evtname2=strcat(validBabies{valids},'_',MoI,'_test_aS',outfilenames{rounds});       
        evtname3=strcat(validBabies{valids},'_',MoI,'_test_mS',outfilenames{rounds}); 
        EEG = pop_saveset(EEG, evtname2,strcat(outfilelocs{rounds},'allStandards/'));   
        EEGm = pop_saveset(EEGm,evtname3,strcat(outfilelocs{rounds},'matchedStandards/'));
    end
end