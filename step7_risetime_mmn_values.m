%% individual MMNs
% AC November 19, based on step 6

% we are going to get an array of output datasets
% 1. ERP. Normal ERP comparison between conditions (oddballs, standards).
% 2. ERP_matchedStandards. Normal ERP comparison, but each oddball has a matched standard (last standard trial before oddball).
% 3. ERP_perTrial. Matched Standards ERP but account for every trial (don't get an average per condition).
% 4. MMN_matchedStandards_ERP. MMN, each oddball ERP has the preceding standard ERP subtracted.
% 5. MMN_perERP. MMN, the mean oddball response has the mean standard response subtracted.
% 6. MMN_perTrial. MMN, each oddball response has the mean standard response subtracted.
% 7. MMN_perTrial_mS. MMN, each oddball response has the mean matched standard response subtracted.

% 1 and 5 are similar; 2 and 4; 3 and 6.
% in this file, we make 4-6

% here's some details on where data is below for the above (bl and ob windows)

% 4. oddballs:                             standards:
% 5. oddballs:                             standards:
% 6. oddballs:                             standards:

rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';
RTepochs={{'RT01';'RT39';'RT37';'RT35';'RT33';'RT31';'RT29';'RT27';'RT25';'RT23';'RT21'};...
    {'RT39';'RT37';'RT35';'RT33';'RT31';'RT29';'RT27';'RT25';'RT23';'RT21';'RT38';'RT36';'RT34';'RT32';'RT30';'RT28';'RT26';'RT24';'RT22';'RT20'}};
fileHolder=cell(length(RTepochs),1);

 validBabies = {{'AA08gs64';'AB19cm13';'AB28ka99';'AH12ps44';'AH20eg91';'AV03ct18';...
    'AW12se23';'BD08ol68';'BM26hg18';'CM06cb41';'DA01fy01';'DA28ns10';'DC09ls10';...    
    'EB23kn04';'EK10pf48';'EL16jn01';'ES06cf77';'ES20tv22';'EW01gm26';...   
    'FS15vp50';'GZ21am18';'HB29lw72';'HE27ab19';'HX13xx13';'IG21te67';'IS19kq76';...   
    'JL04qq88';'KG05gg66';'LD09sd7';'LF20fm32';'MC31dv56';'MS04jo74';...  
    'MW15sk21';'NB05JR55';'NG10tr65';'NO08js23';'NW28cp37';'OT08eb49';'OW16al07';...    
    'RC01mw31';'RG31rt10';'RK05ld83';'RM05sz86';'SH28dt49';'SN02sm01';'TC09jp54';...    
    'WP25ph27';'YB13yu73';'ZL23te18';'ZT29ab23'},...
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
    'TP01cd11';'TV2401';'VP14wb41';'WP25ph27';'YB13yu73';'ZL23te18';'ZT29ab23'}};

%VbNameLen=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8];
  
stimuli={{2,2,1,2,1,2,2,2,2,2,1,1,1,...
    2,2,1,1,2,1,2,1,1,1,2,1,2,...
    1,2,1,1,1,2,2,1,2,2,2,2,1,...
    1,1,1,2,2,1,1,2,2,2,1};...
    {2,1,2,1,1,2,2,1,2,2,2,1,...
    1,1,2,2,1,2,2,2,2,1,2,2,1,...
    1,2,1,2,1,1,2,2,2,1,2,2,1,2,...
    2,1,2,1,1,1,2,1,1,1,1,1,1,2,...
    2,2,1,2,1,2,2,1,1,1,1,1,2,1,...
    2,1,2,2,2,1,1}};  
    %subnums=[70,68,70,70,70,70,68,68,69,70,70,6,6;88,87,86,88,87,87,88,87,85,86,85,0,0];

MoI={'7mo';'11mo'};
MoIdata=['07';'11'];

%% to create MMN vals, let's open the saved files from step 6

load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RTmSERPVals.mat');
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RT01ERPVals.mat');
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RTin_ERPVals.mat');
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/RT01_pairedERPVals.mat');


MMN_perTrial=cell(1,12);
MMN_perTrial_mS=cell(1,12);

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
%MMN_perERP
MMN_perERP=cell(1,11);
exclusions=[];
for ages=1:length(MoI)
    for ppts=1:length(RTmSERPVals{ages}{1}(:,1))
        for elec=1:7 %length of "electrodes"
            for epochs=1:length(RTmSERPVals{ages}{1}(1,:)) % within RTmsERP, this is all of the RTs plus their matched standards
            	RTdev=RTmSERPVals{ages}{elec}(ppts,epochs); %this is the response to the deviant
                if mod(epochs,2)==1 % this checks if we need the baseline window or the actual window
                    RTsta=RT01ERPVals{ages}{1,elec}(ppts,1); %then grabs the AVERAGE OF ALL STANDARDS accordingly
                elseif mod(epochs,2)==0                      % remember RT01ERPvals is in valids order                             
                    RTsta=RT01ERPVals{ages}{1,elec}(ppts,2); % pairing is only for trial-based stuff
                end
                if RTdev==0
                    exclusions=[exclusions;ages,ppts,elec,epochs];
                else
                    RTval=RTdev-RTsta; %MMN - deviant minus standard
                    MMN_perERP{1}=[MMN_perERP{1};validBbz{ages}{ppts}];
                    if mod(epochs,2)==1
                        MMN_perERP{2}=[MMN_perERP{2};"baseline"];
                    elseif mod(epochs,2)==0
                        MMN_perERP{2}=[MMN_perERP{2};"mmwindow"]; %labels the baseline or window accordingly
                    end
                    MMN_perERP{3} = [MMN_perERP{3}; elec]; 
                    MMN_perERP{4} = [MMN_perERP{4}; RTval];
                    if mod(epochs,2)==1
                        MMN_perERP{5} = [MMN_perERP{5}; RTepochs{2}{(epochs+1)/2}]; % this tells us which RT           
                    elseif mod(epochs,2)==0
                        MMN_perERP{5} = [MMN_perERP{5}; RTepochs{2}{epochs/2}];  % just maths to deal with the doubling (window and baseline)
                    end
                    if stimuli{ages}{ppts}==1
                        MMN_perERP{6} = [MMN_perERP{6};"sne"];
                    elseif stimuli{ages}{ppts}==2 
                        MMN_perERP{6} = [MMN_perERP{6};"ssn"];
                    end
                    MMN_perERP{7}=[MMN_perERP{7};str2num(MoIdata(ages,:))];
                    MMN_perERP{8}=[MMN_perERP{8};sqrt(RTval^2)];
                end
            end
        end
    end
end

%%
%MMN_matchedStandards
MMN_matchedStandards_ERP=cell(1,11);

for ages=1:length(MoI)
    for ppts=1:length(RTmSERPVals{ages}{1}(:,1))
        for elec=1:7
            for epochs=1:(length(RTmSERPVals{ages}{1}(1,:)))
                RTdev=RTmSERPVals{ages}{elec}(ppts,epochs);
                RTsta=RT01ERPVals{ages}{2,elec}(ppts,epochs);
                if (RTdev~=0)&&(RTsta~=0)
                    RTval=RTdev-RTsta;
                    MMN_matchedStandards_ERP{1}=[MMN_matchedStandards_ERP{1};validBbz{ages}{ppts}];
                    if mod(epochs,2)==1
                        MMN_matchedStandards_ERP{2}=[MMN_matchedStandards_ERP{2};"baseline"];
                    elseif mod(epochs,2)==0
                        MMN_matchedStandards_ERP{2}=[MMN_matchedStandards_ERP{2};"mmwindow"];
                    end
                    MMN_matchedStandards_ERP{3} = [MMN_matchedStandards_ERP{3}; elec];
                    MMN_matchedStandards_ERP{4} = [MMN_matchedStandards_ERP{4}; RTval];
                    if mod(epochs,2)==1
                        MMN_matchedStandards_ERP{5} = [MMN_matchedStandards_ERP{5}; RTepochs{2}{(epochs+1)/2}]; % this tells us which RT           
                    elseif mod(epochs,2)==0
                        MMN_matchedStandards_ERP{5} = [MMN_matchedStandards_ERP{5}; RTepochs{2}{epochs/2}];  % just maths to deal with the doubling (window and baseline)
                    end
                    if stimuli{ages}{ppts}==1
                        MMN_matchedStandards_ERP{6} = [MMN_matchedStandards_ERP{6};"sne"];
                    elseif stimuli{ages}{ppts}==2 
                        MMN_matchedStandards_ERP{6} = [MMN_matchedStandards_ERP{6};"ssn"];
                    end
                    MMN_matchedStandards_ERP{7}=[MMN_matchedStandards_ERP{7};str2num(MoIdata(ages,:))];
                    MMN_matchedStandards_ERP{8}=[MMN_matchedStandards_ERP{8};sqrt(RTval^2)];
                end
            end
        end
    end
end

%what the reason why this is 16463 and not 16464?
% because one of the RTdev or RTval for a 7-month-old, baseline window, 7th
% RoI must be 0... but that's OK because we're not using RoI 7



%%
%MMN_perTrial

for ages=1:length(MoI)
    for r=1
        for epochs=1:length(RTin_ERPVals{ages}{r})
            for nums = 1:4
                for ppts=1:length(RTin_ERPVals{ages}{r}{epochs,nums})
                    for elec=1:7
                        for erpwindow=1:2
                            RTdev = RTin_ERPVals{ages}{r}{epochs,nums}{ppts}(elec,erpwindow);
                            RTsta= RT01ERPVals{ages}{elec}(RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts},erpwindow); 
                            RTval = RTdev-RTsta;
                            MMN_perTrial{1} = [MMN_perTrial{1};validBbz{ages}(RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts})];
                            if erpwindow==1
                                MMN_perTrial{2} = [MMN_perTrial{2};"baseline"];
                            elseif erpwindow==2
                                MMN_perTrial{2} = [MMN_perTrial{2};"mmwindow"];
                            end
                            MMN_perTrial{3} = [MMN_perTrial{3}; elec];
                            MMN_perTrial{4} = [MMN_perTrial{4}; RTval];
                            MMN_perTrial{5} = [MMN_perTrial{5}; RTepochs{2}{epochs}];
                            if stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==1
                                MMN_perTrial{6} = [MMN_perTrial{6};"sne"];
                            elseif stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==2
                                MMN_perTrial{6} = [MMN_perTrial{6};"ssn"];
                            end 
                            MMN_perTrial{9} = [MMN_perTrial{9};nums];
                            MMN_perTrial{8} = [MMN_perTrial{8}; str2double(MoIdata(ages,:))];
                            MMN_perTrial{7} = [MMN_perTrial{7}; sqrt(RTval^2)];
                        end
                    end
                end
            end
        end
    end
end
%%
%MMN_perTrial_mS
holder=[];
for ages=1:length(MoI)
    for r=2
        for epochs=1:(length(RTin_ERPVals{ages}{r}))/2
            for nums = 1:4
                for ppts=1:length(RTin_ERPVals{ages}{r}{epochs,nums})
                    for elec=1:7
                        for erpwindow=1:2
                            RTsta=9999;
                            RTdev = RTin_ERPVals{ages}{r}{epochs,nums}{ppts}(elec,erpwindow);
                            pptID = RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts};
                            for x=1:length(RT01_pairedERPVals{ages}{r}{epochs+10,nums})
                                if RT01_pairedERPVals{ages}{r}{epochs+10,nums}{x}==pptID
                                    RTsta=RTin_ERPVals{ages}{r}{epochs+10,nums}{x}(elec,erpwindow);
                                end
                            end
                            if RTsta~=9999
                                RTval=RTdev-RTsta;
                                MMN_perTrial_mS{1} = [MMN_perTrial_mS{1};validBbz{ages}(RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts})];
                                if erpwindow==1
                                    MMN_perTrial_mS{2} = [MMN_perTrial_mS{2};"baseline"];
                                elseif erpwindow==2
                                    MMN_perTrial_mS{2} = [MMN_perTrial_mS{2};"mmwindow"];
                                end
                                MMN_perTrial_mS{3} = [MMN_perTrial_mS{3}; elec];
                                MMN_perTrial_mS{4} = [MMN_perTrial_mS{4}; RTval];
                                MMN_perTrial_mS{5} = [MMN_perTrial_mS{5}; RTepochs{2}{epochs}];
                                if stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==1
                                    MMN_perTrial_mS{6} = [MMN_perTrial_mS{6};"sne"];
                                elseif stimuli{ages}{RT01_pairedERPVals{ages}{r}{epochs,nums}{ppts}}==2
                                    MMN_perTrial_mS{6} = [MMN_perTrial_mS{6};"ssn"];
                                end 
                                MMN_perTrial_mS{9} = [MMN_perTrial_mS{9}; nums];
                                MMN_perTrial_mS{8} = [MMN_perTrial_mS{8}; str2double(MoIdata(ages,:))];
                                MMN_perTrial_mS{7} = [MMN_perTrial_mS{7}; sqrt(RTval^2)];
                            end
                        end
                    end
                end
            end
        end
    end
end

%% now let's add in some additional columns e.g. for 20s/30s, pairs, direction of magnitude for MMR

variousHoldersMMN={MMN_perERP;MMN_matchedStandards_ERP;MMN_perTrial;MMN_perTrial_mS};

newL=[9,9,10,10];
newP=[10,10,11,11];
newH=[11,11,12,12];

for runs=1:length(variousHoldersMMN)
    
    baselines{runs}=find(variousHoldersMMN{runs}{1,2}=="baseline");
    blprctileRaw{runs}=prctile(variousHoldersMMN{runs}{1,4}(baselines{runs}),[2.5 97.5]);
    blprctileMag{runs}=prctile(variousHoldersMMN{runs}{1,8}(baselines{runs}),95);
    blmeanraw{runs}=mean(variousHoldersMMN{runs}{1,4}(baselines{runs}));
    blmeanmag{runs}=mean(variousHoldersMMN{runs}{1,8}(baselines{runs}));
    blstdraw{runs}=std(variousHoldersMMN{runs}{1,4}(baselines{runs}));
    blstdmag{runs}=std(variousHoldersMMN{runs}{1,8}(baselines{runs}));
    
    windows{runs}=find(variousHoldersMMN{runs}{1,2}=="mmwindow");
    wnprctileRaw{runs}=prctile(variousHoldersMMN{runs}{1,4}(windows{runs}),[2.5 97.5]);
    wnprctileMag{runs}=prctile(variousHoldersMMN{runs}{1,8}(windows{runs}),95);
    wnmeanraw{runs}=mean(variousHoldersMMN{runs}{1,4}(windows{runs}));
    wnmeanmag{runs}=mean(variousHoldersMMN{runs}{1,8}(windows{runs}));
    wnstdraw{runs}=std(variousHoldersMMN{runs}{1,4}(windows{runs}));
    wnstdmag{runs}=std(variousHoldersMMN{runs}{1,8}(windows{runs}));
    
    for rows=1:length(variousHoldersMMN{runs}{1,4}(baselines{runs}))
        variousHoldersMMN{runs}{1,newL(runs)}(baselines{runs}(rows),1)=4;
    end
    
    for rows=1:length(variousHoldersMMN{runs}{1,4}(windows{runs}))
        if variousHoldersMMN{runs}{1,4}(windows{runs}(rows))<=blprctileRaw{runs}(1)
            variousHoldersMMN{runs}{1,newL(runs)}(windows{runs}(rows),1)=1;
        elseif variousHoldersMMN{runs}{1,4}(windows{runs}(rows))>=blprctileRaw{runs}(2)
            variousHoldersMMN{runs}{1,newL(runs)}(windows{runs}(rows),1)=2;
        elseif (variousHoldersMMN{runs}{1,4}(windows{runs}(rows))<blprctileRaw{runs}(2))&&(variousHoldersMMN{runs}{1,4}(windows{runs}(rows))>blprctileRaw{runs}(1))
            variousHoldersMMN{runs}{1,newL(runs)}(windows{runs}(rows),1)=0;
        end
    end

    for rows=1:length(variousHoldersMMN{runs}{1,5})
        if (strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT39"))||(strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT37"))
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=3937;
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=30;
        elseif (strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT35"))||(strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT33"))
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=3533;
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=30;
        elseif strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT31")
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=3129; 
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=30;
        elseif strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT29")
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=3129; 
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=20;
        elseif (strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT27"))||(strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT25"))
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=2725;
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=20;
        elseif (strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT23"))||(strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT21"))
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=2321;
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=20;  
        elseif strcmp(variousHoldersMMN{runs}{1,5}(rows,:),"RT01")
            variousHoldersMMN{runs}{1,newP(runs)}(rows,1)=1000;
            variousHoldersMMN{runs}{1,newH(runs)}(rows,1)=10;   
        end
    end
end

riseTime_MMN1=variousHoldersMMN{1};
riseTime_MMN2=variousHoldersMMN{2};
riseTime_MMN3=variousHoldersMMN{3};
riseTime_MMN4=variousHoldersMMN{4};

save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perERP/MMN_perERP.mat','riseTime_MMN1')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_matchedStandards/MMN_matchedStandards.mat','riseTime_MMN2')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perTrial/MMN_perTrial.mat','riseTime_MMN3')
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perTrial_mS/MMN_perTrial_mS.mat','riseTime_MMN4')

%% create files for use in R

% first up, alphabetise babies, assign numbers, create variable accordingly
validBabas=unique([validBbz{1},validBbz{2}]);

validnums=sort(validBabas);

for runs=1:length(variousHoldersMMN)
    mmnExp{runs}=[];
    mmnExpH{runs}=variousHoldersMMN{runs}{1};
    for x=1:length(mmnExpH{runs})
        for v=1:length(validnums)
            if strcmp(mmnExpH{runs}(x,:),validnums{v})
                mmnExp{runs}=[mmnExp{runs};v];
            end
        end
    end
    mmnExp2{runs}=[];
    mmnExpH2{runs}=variousHoldersMMN{runs}{2};
    for x=1:length(mmnExpH2{runs})
        if mmnExpH2{runs}{x}=="baseline"
            mmnExp2{runs}=[mmnExp2{runs};1];
        elseif mmnExpH2{runs}{x}=="mmwindow"
            mmnExp2{runs}=[mmnExp2{runs};2];
        end
    end
    
    mmnExp{runs}(:,2)=mmnExp2{runs};
    mmnExp{runs}(:,3)=variousHoldersMMN{runs}{3};
    mmnExp{runs}(:,4)=variousHoldersMMN{runs}{4};
    
    mmnExp5{runs}=[];
    mmnExpH5{runs}=variousHoldersMMN{runs}{5};
    for x=1:length(mmnExpH5{runs})
        mmnExp5{runs}=[mmnExp5{runs};str2double(mmnExpH5{runs}(x,3:4))];
    end
    
    mmnExp{runs}(:,5)=mmnExp5{runs};
    
    mmnExpH6{runs}=variousHoldersMMN{runs}{6};
    mmnExp6{runs}=[];
    for x=1:length(mmnExpH6{runs})
        if mmnExpH6{runs}{x}=="sne"
            mmnExp6{runs}=[mmnExp6{runs};1]; 
        elseif mmnExpH6{runs}{x}=="ssn"
            mmnExp6{runs}=[mmnExp6{runs};2];
        end
    end
    
    mmnExp{runs}(:,6)=mmnExp6{runs};
    
    for t=7:length(variousHoldersMMN{runs})
        mmnExp{runs}(:,t)=variousHoldersMMN{runs}{t};
    end
end
    
%% get rid of outliers
% based on erp values, not magnitudes
% use 2.5 stdev, strict but otherwise we get bizarre values

for runs=1:length(mmnExp)
    outlierholder{runs}=[];
    outlierholderbase{runs}=[];
    for x=1:length(windows{runs})
        if (mmnExp{runs}(windows{runs}(x),4)>(wnmeanraw{runs}+(2.5*wnstdraw{runs})))||(mmnExp{runs}(windows{runs}(x),4)<(wnmeanraw{runs}-(2.5*wnstdraw{runs})))
            outlierholder{runs}=[outlierholder{runs};windows{runs}(x),mmnExp{runs}(windows{runs}(x),4)];
        end
    end
    for x=1:length(baselines{runs})
        if (mmnExp{runs}(baselines{runs}(x),4)>(blmeanraw{runs}+(2.5*blstdraw{runs})))||(mmnExp{runs}(baselines{runs}(x),4)<(blmeanraw{runs}-(2.5*blstdraw{runs})))
            outlierholderbase{runs}=[outlierholderbase{runs};baselines{runs}(x),mmnExp{runs}(baselines{runs}(x),4)];
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
    mmnExp{runs}(droptrials{runs},:)=[];
    baselines2{runs}=find(mmnExp{runs}(:,2)==0);
    windows2{runs}=find(mmnExp{runs}(:,2)==1);   
end

mmn_Exp1=mmnExp{1};
mmn_Exp2=mmnExp{2};
mmn_Exp3=mmnExp{3};
mmn_Exp4=mmnExp{4};
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perERP/MMN_perERP_R.mat','mmn_Exp1');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_matchedStandards/MMN_matchedStandards_R.mat','mmn_Exp2');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perTrial/MMN_perTrial_R.mat','mmn_Exp3');
save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perTrial_mS/MMN_perTrial_mS_R.mat','mmn_Exp4');
%% new thoughts summer 2020
% the matched Standards thing is not really working because the ordering
% could be off, e.g. we could be subtracting the response to the 4th
% deviant from the 2nd matched standard

% going to look at data from 2 perspectives
% 1. collapse the 4 frontal/central RoIs into 1

load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perERP/MMN_perERP_R.mat');

mmn_Exp_mod = mmn_Exp1(find(mmn_Exp1(:,3)<5),:);
rtprobs=[];

ppts=unique(mmn_Exp_mod(:,1)); 
mmn_Exp_1R=[]; 
for p=1:length(ppts)
    for ages=[7,11]
        for win=1:2
            for RTs=[39,37,35,33,31,29,27,25,23,21]
                holder=[];
                holder1=[];
                holder2=[];
                holder3=[];
                holder4=[];
                holder=mmn_Exp_mod(mmn_Exp_mod(:,1)==p,:);
                try
                    holder1=holder(holder(:,7)==ages,:);
                    holder2=holder1(holder1(:,2)==win,:);
                    try
                        holder3=holder2(holder2(:,5)==RTs,:);
                        holder4=holder3(1,:);
                        holder4(1,4)=mean(holder3(:,4));
                        if win==1
                            holder4(1,9)=4;
                        else
                            if holder4(1,4)<0
                                holder4(1,9)=1;
                            elseif holder4(1,4)>0
                                holder4(1,9)=2;
                            else
                                holder4(1,9)=0;
                            end
                        end
                        holder4(1,8)=sqrt(holder4(1,4)^2);
                        mmn_Exp_1R=[mmn_Exp_1R;holder4];
                    catch
                        rtprobs=[rtprobs;p,win,ages,RTs];
                    end
                catch
                    rtprobs=[rtprobs;p,win,ages,RTs];
                end
            end
        end
    end
end

save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perERP/MMN_perERP_R_RoIcollapsed.mat','mmn_Exp_1R');

    

%%
% 2. collapse the ERPs into longer and shorter RTs

% let's use the ERP approach, and let's do the 2 sets of rise times

% run top bit - rootpath, validBabies etc.

frontal=[2,3,5,6,8,9,10,11];
leftFrCe=[12,13,14,15,17,18,19,20];
rightFrCe=[1,50,53,56,57,58,59,60];
central=[4,7,16,21,34,41,51,54];
leftTePa=[22,24,25,26,27,28,29,30];
rightTePa=[42,44,45,46,47,48,49,52];
occiPari=[31,33,35,36,37,38,39,40];

electrodes={frontal;leftFrCe;rightFrCe;central;leftTePa;rightTePa;occiPari};
RTpaths='exports/matchedStandards/Aves/';
RTtypes={'20D';'20S';'30D';'30S'};


for ages=1:length(MoI)
    RT_holder{ages}=cell(1,4);
    for rs=1:4
        RT_holder{ages}{rs}=cell(length(validBabies{ages}),1);
        for valids=1:length(validBabies{ages})
            try
                EEGlabExport=fopen(strcat(rootpath,MoI{ages},'/',RTpaths,RTtypes{rs},'/',validBabies{ages}{valids},'_',MoI{ages},'_',RTtypes{rs},'_mS_rrf_erp.csv'));
                holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                container=[];
                for z=1:960
                	container=[container,holder{z}];
                end
                RT_holder{ages}{rs}{valids}=container;
            end
        end
    end
end

RT_ElecAves={};
for ages=1:length(MoI)
    RT_ElecAves{ages}=cell(2,4);
    for RTs=1:4  
        for ppts=1:length(validBabies{ages})
            for rois=1:length(electrodes)
                try
                    tester=mean(RT_holder{ages}{RTs}{ppts}(electrodes{rois},:));  
                    RT_ElecAves{ages}{1,RTs}(ppts,rois)=mean(tester(1:160));
                    RT_ElecAves{ages}{2,RTs}(ppts,rois)=mean(tester(380:540));
                catch
                    RT_ElecAves{ages}{1,RTs}(ppts,rois)=0;
                    RT_ElecAves{ages}{2,RTs}(ppts,rois)=0;
                end
            end
        end
    end
end

%%
MMN_RTsMatched=cell(1,9);

for ages=1:length(MoI)
    for ppts=1:length(RT_ElecAves{ages}{1}(:,1))
        for RTs=[1,3]
            for window=1:2
                for elec=1:7
                    RTdev=RT_ElecAves{ages}{window,RTs}(ppts,elec);
                    RTsta=RT_ElecAves{ages}{window,RTs+1}(ppts,elec);
                    RTval=RTdev-RTsta;
                    if RTdev~=0
                        MMN_RTsMatched{1}=[MMN_RTsMatched{1};validBbz{ages}{ppts}];
                        if window==1
                            MMN_RTsMatched{2}=[MMN_RTsMatched{2};"baseline"];
                        elseif window==2
                            MMN_RTsMatched{2}=[MMN_RTsMatched{2};"mmwindow"];
                        end
                        MMN_RTsMatched{3} = [MMN_RTsMatched{3}; elec];
                        MMN_RTsMatched{4} = [MMN_RTsMatched{4}; RTval];
                        MMN_RTsMatched{5} = [MMN_RTsMatched{5}; RTtypes{RTs}]; % this tells us which RT           
                        if stimuli{ages}{ppts}==1
                            MMN_RTsMatched{6} = [MMN_RTsMatched{6};"sne"];
                        elseif stimuli{ages}{ppts}==2 
                            MMN_RTsMatched{6} = [MMN_RTsMatched{6};"ssn"];
                        end
                        MMN_RTsMatched{7}=[MMN_RTsMatched{7};str2num(MoIdata(ages,:))];
                        MMN_RTsMatched{8}=[MMN_RTsMatched{8};sqrt(RTval^2)];
                    end
                end
            end
        end
    end
end
%% outliers and modifications

baselines=find(MMN_RTsMatched{2}=="baseline");
blprctileRaw=prctile(MMN_RTsMatched{4}(baselines),[2.5 97.5]);
blprctileMag=prctile(MMN_RTsMatched{8}(baselines),95);
blmeanraw=mean(MMN_RTsMatched{4}(baselines));
blmeanmag=mean(MMN_RTsMatched{8}(baselines));
blstdraw=std(MMN_RTsMatched{4}(baselines));
blstdmag=std(MMN_RTsMatched{8}(baselines));

windows=find(MMN_RTsMatched{2}=="mmwindow");
wnprctileRaw=prctile(MMN_RTsMatched{4}(windows),[2.5 97.5]);
wnprctileMag=prctile(MMN_RTsMatched{8}(windows),95);
wnmeanraw=mean(MMN_RTsMatched{4}(windows));
wnmeanmag=mean(MMN_RTsMatched{8}(windows));
wnstdraw=std(MMN_RTsMatched{4}(windows));
wnstdmag=std(MMN_RTsMatched{8}(windows));

for rows=1:length(MMN_RTsMatched{4}(baselines))
    MMN_RTsMatched{9}(baselines(rows),1)=4;
end
% is there actually a peak/difference from baseline
for rows=1:length(MMN_RTsMatched{4}(windows))   
    if MMN_RTsMatched{4}(windows(rows))<=blprctileRaw(1)
        MMN_RTsMatched{9}(windows(rows),1)=1;
    elseif MMN_RTsMatched{4}(windows(rows))>=blprctileRaw(2)
        MMN_RTsMatched{9}(windows(rows),1)=2;
    elseif (MMN_RTsMatched{4}(windows(rows))<blprctileRaw{runs}(2))&&(MMN_RTsMatched{4}(windows(rows))>blprctileRaw(1))
        MMN_RTsMatched{9}(windows(rows),1)=0;
    end
end

%% create files for use in R

% first up, alphabetise babies, assign numbers, create variable accordingly
validBabas=unique([validBbz{1},validBbz{2}]);

validnums=sort(validBabas);

mmnNames=[];
for x=1:length(MMN_RTsMatched{1,1})
    for v=1:length(validnums)
    	if strcmp(MMN_RTsMatched{1,1}(x,:),validnums{v})
            mmnNames=[mmnNames;v];
        end
    end
end
    
mmnExp2=[];
for x=1:length(MMN_RTsMatched{1,2})
    if MMN_RTsMatched{1,2}{x}=="baseline"
        mmnExp2=[mmnExp2;1];
    elseif MMN_RTsMatched{1,2}{x}=="mmwindow"
        mmnExp2=[mmnExp2;2];
    end
end

mmnExp5=[];
for x=1:length(MMN_RTsMatched{1,5})
	mmnExp5=[mmnExp5;str2double(MMN_RTsMatched{5}(x,1:2))];
end

mmnExp6=[];
for x=1:length(MMN_RTsMatched{6})
    if MMN_RTsMatched{6}{x}=="sne"
        mmnExp6=[mmnExp6;1]; 
    elseif MMN_RTsMatched{6}{x}=="ssn"
        mmnExp6=[mmnExp6;2];
    end
end
    
mmn_RTM = [mmnNames,mmnExp2,MMN_RTsMatched{1,3},MMN_RTsMatched{1,4},mmnExp5,mmnExp6,MMN_RTsMatched{1,7},MMN_RTsMatched{1,8},MMN_RTsMatched{1,9}];

    

    
%% get rid of outliers
% based on erp values, not magnitudes
% use 3 stdev, with these better averages odd values might be less
% frequent?

outlierholder=[];
outlierholderbase=[];
for x=1:length(windows)
    if (mmn_RTM(windows(x),4)>(wnmeanraw+(3*wnstdraw)))||(mmn_RTM(windows(x),4)<(wnmeanraw-(3*wnstdraw)))
        outlierholder=[outlierholder;windows(x),mmn_RTM(windows(x),4)];
    end
end
for x=1:length(baselines)
    if (mmn_RTM(baselines(x),4)>(blmeanraw+(3*blstdraw)))||(mmn_RTM(baselines(x),4)<(blmeanraw-(3*blstdraw)))
        outlierholderbase=[outlierholderbase;baselines(x),mmn_RTM(baselines(x),4)];
    end
end
% if we're dropping a given value, we should also drop its corollary
% baseline or window period
droptrials=[outlierholder(:,1);outlierholder(:,1)-7;outlierholderbase(:,1);outlierholderbase(:,1)+7];

droptrials=unique(droptrials);
mmn_RTM(droptrials,:)=[];
baselines2=find(mmn_RTM(:,2)==1);
windows2=find(mmn_RTM(:,2)==2);   

save('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/stats/MMN_perERP/MMN_perERP_R_rtSplit.mat','mmn_RTM');


%% getting descriptives

% mmn matched standards ERP collapsed RoIs
%windows
windows=find(mmn_Exp_1R(:,2)==2);
Sevens=find(mmn_Exp_1R(windows,7)==7);
sevenMoWins=windows(Sevens);
Thirties=find(mmn_Exp_1R(sevenMoWins,11)==30);
sevenWinThirt=sevenMoWins(Thirties);
Twenties=find(mmn_Exp_1R(sevenMoWins,11)==20);
sevenWinTwent=sevenMoWins(Twenties);

SWTh=mean(mmn_Exp_1R(sevenWinThirt,4))
SWTh_SD=std(mmn_Exp_1R(sevenWinThirt,4))
SWTh_se=SWTh_SD/(sqrt(length(sevenWinThirt)))

SWTw=mean(mmn_Exp_1R(sevenWinTwent,4))
SWTw_SD=std(mmn_Exp_1R(sevenWinTwent,4))
SWTw_se=SWTw_SD/(sqrt(length(sevenWinTwent)))

Elevens=find(mmn_Exp_1R(windows,7)==11);
elevenMoWins=windows(Elevens);
Thirties11=find(mmn_Exp_1R(elevenMoWins,11)==30);
elevenWinThirt=elevenMoWins(Thirties11);
Twenties11=find(mmn_Exp_1R(elevenMoWins,11)==20);
elevenWinTwent=elevenMoWins(Twenties11);

EWTh=mean(mmn_Exp_1R(elevenWinThirt,4))
EWTh_SD=std(mmn_Exp_1R(elevenWinThirt,4))
EWTh_se=EWTh_SD/(sqrt(length(elevenWinThirt)))

EWTw=mean(mmn_Exp_1R(elevenWinTwent,4))
EWTw_SD=std(mmn_Exp_1R(elevenWinTwent,4))
EWTw_se=EWTw_SD/(sqrt(length(elevenWinTwent)))

%% ppt by ppt

ppt=82;
psevenWinThirt=find(mmn_Exp_1R(sevenWinThirt,1)==ppt);
pswth=sevenWinThirt(psevenWinThirt);
psevenWinTwent=find(mmn_Exp_1R(sevenWinTwent,1)==ppt);
pswtw=sevenWinThirt(psevenWinTwent);

pelevenWinThirt=find(mmn_Exp_1R(elevenWinThirt,1)==ppt);
pewth=elevenWinThirt(pelevenWinThirt);
pelevenWinTwent=find(mmn_Exp_1R(elevenWinTwent,1)==ppt);
pewtw=elevenWinTwent(pelevenWinTwent);

SWTh=mean(mmn_Exp_1R(pswth,4))
SWTw=mean(mmn_Exp_1R(pswtw,4))
EWTh=mean(mmn_Exp_1R(pewth,4))
EWTw=mean(mmn_Exp_1R(pewtw,4))
