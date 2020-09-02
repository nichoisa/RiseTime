%% Rise Time ERP plots
% this script exports some figures. Right now, it exports figures showing
% (1) the overall ERP (all standard trials vs. oddball trials (all
% oddballs, short oddballs, long oddballs etc.)
% (2) the matched ERP (the standard trial occurring just before the oddball
% vs. the oddball)

% these plots contain outliers that may be excluded later.

%%
rootpath='/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/';

% 
% MoI='7mo';
% 
% %load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot7mo_plots.mat');
% load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test7mo_plots.mat');
% % % 
MoI='11mo';
%load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/pilot11mo_plots.mat');
load('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/test11mo_plots.mat');
%% read in the csv data but from the individual files

pathsi={'/exports/allStandards/';'/exports/matchedStandards/'};
extni={'_aS_rrf';'_mS_rrf'};

RTdataRejTypes={};
for rej=1:length(pathsi)
    RTdataRejTypes{rej}=cell(length(validBabies),length(RTepochs{rej}));
    for valids=1:length(validBabies)
        for epochs=1:length(RTepochs{rej})
            try
                EEGlabExport=fopen(strcat(rootpath,MoI,pathsi{rej},RTepochs{rej}{epochs},'/',validBabies{valids},'_',MoI,'_',RTepochs{rej}{epochs},extni{rej},'_erp.csv'));
                holder=textscan(EEGlabExport,repmat('%f',[1 960]),'Delimiter',{',','\n'});
                container=[];
                for z=1:960
                    container=[container,holder{z}];
                end
                RTdataRejTypes{rej}{valids,epochs}=container;
            end
        end
    end
end


%% electrode groupings

% first try MMN-focused groupings
% frontocentral = [2,3,4,6,7,8,9,11,12,54,60];
% leftFrontotemporal = [13,14,15,16,18,19,20,22,24];
% rightFrontotemporal = [49,50,51,52,53,56,57,58,59];
% leftTemporoparietal = [21,25,26,27,28,29,30,31,32];
% rightTemporoparietal = [40,41,42,43,44,45,46,47,48];
% 
% electrodes={frontocentral;leftFrontotemporal;rightFrontotemporal;leftTemporoparietal;rightTemporoparietal};

% standard project groupings

frontal=[2,3,5,6,8,9,10,11];
leftFrCe=[12,13,14,15,17,18,19,20];
rightFrCe=[1,50,53,56,57,58,59,60];
central=[4,7,16,21,34,41,51,54];
leftTePa=[22,24,25,26,27,28,29,30];
rightTePa=[42,44,45,46,47,48,49,52];
occiPari=[31,33,35,36,37,38,39,40];

electrodes={frontal;leftFrCe;rightFrCe;central;leftTePa;rightTePa;occiPari};

RTElecAves_perRej={};
for r=1:length(pathsi)
    RTElecAves_perRej{r}=cell(length(validBabies),1);
    for e=1:length(RTElecAves_perRej{r})
        RTElecAves_perRej{r}{e}=cell(length(electrodes),length(RTepochs{r}));
    end
    for v=1:length(validBabies)
        for rt=1:length(RTepochs{r})
            for e=1:length(electrodes)
                try
                    RTElecAves_perRej{r}{v}{e,rt}=mean(RTdataRejTypes{r}{v,rt}(electrodes{e},:));
                end
            end
        end
    end
end

%% averages and stdevs for all babies

groupAves_perRej={};
allMeans_perRej={};
allStds_perRej={};
allSEs_perRej={};

groupAves_perRej_sine={};
allMeans_perRej_sine={};
allStds_perRej_sine={};
allSEs_perRej_sine={};

groupAves_perRej_ssn={};
allMeans_perRej_ssn={};
allStds_perRej_ssn={};
allSEs_perRej_ssn={};

sineNums={};
ssnNums={};
for r=1:length(pathsi)
    sineNums{r}=zeros(1,length(RTepochs{r}));
    ssnNums{r}=zeros(1,length(RTepochs{r}));
    groupAves_perRej{r}=cell(length(electrodes),length(RTepochs{r}));
    groupAves_perRej_sine{r}=cell(length(electrodes),length(RTepochs{r}));
    groupAves_perRej_ssn{r}=cell(length(electrodes),length(RTepochs{r}));
    for z=1:length(RTepochs{r})
        sinecounter=0;
        ssncounter=0;
        for y=1:length(electrodes)
            aveHolder=[];
            ssnHolder=[];
            sineHolder=[];
            for v=1:length(validBabies)
                aveHolder=[aveHolder;RTElecAves_perRej{r}{v}{y,z}];
                if stimuli(v)==1
                    sineHolder=[sineHolder;RTElecAves_perRej{r}{v}{y,z}];
                    sinecounter=sinecounter+1;
                elseif stimuli(v)==2                   
                    ssnHolder=[ssnHolder;RTElecAves_perRej{r}{v}{y,z}];
                    ssncounter=ssncounter+1;
                end 
            end
            groupAves_perRej{r}{y,z}=aveHolder;
            groupAves_perRej_sine{r}{y,z}=sineHolder;
            groupAves_perRej_ssn{r}{y,z}=ssnHolder;

            
        end
        sinecounter=sinecounter/length(electrodes);
        ssncounter=ssncounter/length(electrodes);
        sineNums{r}(1,z)=sinecounter;
        ssnNums{r}(1,z)=ssncounter;
    end
    
    allMeans_perRej{r}=cell(length(electrodes),length(RTepochs{r}));
    allStds_perRej{r}=cell(length(electrodes),length(RTepochs{r}));
    allSEs_perRej{r}=cell(length(electrodes),length(RTepochs{r}));
    
    allMeans_perRej_sine{r}=cell(length(electrodes),length(RTepochs{r}));
    allStds_perRej_sine{r}=cell(length(electrodes),length(RTepochs{r}));
    allSEs_perRej_sine{r}=cell(length(electrodes),length(RTepochs{r}));
    
    allMeans_perRej_ssn{r}=cell(length(electrodes),length(RTepochs{r}));
    allStds_perRej_ssn{r}=cell(length(electrodes),length(RTepochs{r}));
    allSEs_perRej_ssn{r}=cell(length(electrodes),length(RTepochs{r}));
    
    for s=1:length(electrodes)
        for t=1:length(RTepochs{r})
            allMeans_perRej{r}{s,t}=mean(groupAves_perRej{r}{s,t});
            allStds_perRej{r}{s,t}=std(groupAves_perRej{r}{s,t});
            allSEs_perRej{r}{s,t}=allStds_perRej{r}{s,t}/sqrt(subnums{r}(t));
            
            allMeans_perRej_sine{r}{s,t}=mean(groupAves_perRej_sine{r}{s,t});
            allStds_perRej_sine{r}{s,t}=std(groupAves_perRej_sine{r}{s,t});
            allSEs_perRej_sine{r}{s,t}=allStds_perRej_sine{r}{s,t}/sqrt(sineNums{r}(t));
            
            allMeans_perRej_ssn{r}{s,t}=mean(groupAves_perRej_ssn{r}{s,t});
            allStds_perRej_ssn{r}{s,t}=std(groupAves_perRej_ssn{r}{s,t});
            allSEs_perRej_ssn{r}{s,t}=allStds_perRej_ssn{r}{s,t}/sqrt(ssnNums{r}(t));    
        end
    end  
end

%% all Oddballs mean

% adding new holders for the matched Oddballs 

all_Oddballs_perRej={};
obMeans_perRej={};
obStds_perRej={};
obSEs_perRej={};

all_Oddballs_perRej_sine={};
obMeans_perRej_sine={};
obStds_perRej_sine={};
obSEs_perRej_sine={};

all_Oddballs_perRej_ssn={};
obMeans_perRej_ssn={};
obStds_perRej_ssn={};
obSEs_perRej_ssn={};

for r=1:length(pathsi)
    all_Oddballs_perRej{r}=cell(length(electrodes),1);
    all_Oddballs_perRej_sine{r}=cell(length(electrodes),1);
    all_Oddballs_perRej_ssn{r}=cell(length(electrodes),1);
    for l=1:length(electrodes)
        individ_group=[];
        individ_group_sine=[];
        individ_group_ssn=[];
        individ_group_match=[];
        individ_group_sine_match=[];
        individ_group_ssn_match=[];
        for valids=1:length(validBabies)
            individave=[];
            individsine=[];
            individssn=[];
            individavematch=[];
            individsinematch=[];
            individssnmatch=[];
            if r==1
                for t=2:13
                    try
                        individave=[individave;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individsine=[individsine;RTElecAves_perRej{1,r}{valids}{l,t}];
                        elseif stimuli(valids)==2
                            individssn=[individssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end   
            elseif r==2
                for t=1:12
                    try
                        individave=[individave;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individsine=[individsine;RTElecAves_perRej{1,r}{valids}{l,t}];
                        elseif stimuli(valids)==2
                            individssn=[individssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end
                for t=13:24
                    try
                        individavematch=[individavematch;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individsinematch=[individsinematch;RTElecAves_perRej{1,r}{valids}{l,t}];
                        elseif stimuli(valids)==2
                            individssnmatch=[individssnmatch;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end
            end
            individ_group=[individ_group;mean(individave)];
            individ_group_match=[individ_group_match;mean(individavematch)];
            if stimuli(valids)==1
                individ_group_sine=[individ_group_sine;mean(individsine)];
                individ_group_sine_match=[individ_group_sine_match;mean(individsinematch)];
            elseif stimuli(valids)==2
                individ_group_ssn=[individ_group_ssn;mean(individssn)];
                individ_group_ssn_match=[individ_group_ssn_match;mean(individssnmatch)];
                
            end
        end
        all_Oddballs_perRej{r}{l}=individ_group;
        all_Oddballs_perRej_sine{r}{l}=individ_group_sine;
        all_Oddballs_perRej_ssn{r}{l}=individ_group_ssn;
        if r==2
            all_Oddballs_perRej{r}{l,2}=individ_group_match;
            all_Oddballs_perRej_sine{r}{l,2}=individ_group_sine_match;
            all_Oddballs_perRej_ssn{r}{l,2}=individ_group_ssn_match;
        end
    end
    obMeans_perRej{r}=cell(length(electrodes),1);
    obStds_perRej{r}=cell(length(electrodes),1);
    obSEs_perRej{r}=cell(length(electrodes),1);
    
    obMeans_perRej_sine{r}=cell(length(electrodes),1);
    obStds_perRej_sine{r}=cell(length(electrodes),1);
    obSEs_perRej_sine{r}=cell(length(electrodes),1);
    
    obMeans_perRej_ssn{r}=cell(length(electrodes),1);
    obStds_perRej_ssn{r}=cell(length(electrodes),1);
    obSEs_perRej_ssn{r}=cell(length(electrodes),1);
    
    for s=1:length(electrodes)
        obMeans_perRej{r}{s}=mean(all_Oddballs_perRej{r}{s});
        obStds_perRej{r}{s}=std(all_Oddballs_perRej{r}{s});
        obSEs_perRej{r}{s}=obStds_perRej{r}{s}/sqrt(max(subnums{r})); %count all babies, all babies have this mean
        
        obMeans_perRej_sine{r}{s}=mean(all_Oddballs_perRej_sine{r}{s});
        obStds_perRej_sine{r}{s}=std(all_Oddballs_perRej_sine{r}{s});
        obSEs_perRej_sine{r}{s}=obStds_perRej_sine{r}{s}/sqrt(max(sineNums{r}));
        
        obMeans_perRej_ssn{r}{s}=mean(all_Oddballs_perRej_ssn{r}{s});
        obStds_perRej_ssn{r}{s}=std(all_Oddballs_perRej_ssn{r}{s});
        obSEs_perRej_ssn{r}{s}=obStds_perRej_ssn{r}{s}/sqrt(max(ssnNums{r}));
        
        if r==2
            obMeans_perRej{r}{s,2}=mean(all_Oddballs_perRej{r}{s,2});
            obStds_perRej{r}{s,2}=std(all_Oddballs_perRej{r}{s,2});
            obSEs_perRej{r}{s,2}=obStds_perRej{r}{s,2}/sqrt(max(subnums{r})); %count all babies, all babies have this mean

            obMeans_perRej_sine{r}{s,2}=mean(all_Oddballs_perRej_sine{r}{s,2});
            obStds_perRej_sine{r}{s,2}=std(all_Oddballs_perRej_sine{r}{s,2});
            obSEs_perRej_sine{r}{s,2}=obStds_perRej_sine{r}{s,2}/sqrt(max(sineNums{r}));

            obMeans_perRej_ssn{r}{s,2}=mean(all_Oddballs_perRej_ssn{r}{s,2});
            obStds_perRej_ssn{r}{s,2}=std(all_Oddballs_perRej_ssn{r}{s,2});
            obSEs_perRej_ssn{r}{s,2}=obStds_perRej_ssn{r}{s,2}/sqrt(max(ssnNums{r}));
        end        
    end
end
%% 31-39 OBs, 21-29 OBs

Oddballs30_perRej={};
Means30_perRej={};
Stds30_perRej={};
SEs30_perRej={};

Oddballs20_perRej={};
Means20_perRej={};
Stds20_perRej={};
SEs20_perRej={};

Oddballs30_perRej_sine={};
Means30_perRej_sine={};
Stds30_perRej_sine={};
SEs30_perRej_sine={};

Oddballs20_perRej_sine={};
Means20_perRej_sine={};
Stds20_perRej_sine={};
SEs20_perRej_sine={};

Oddballs30_perRej_ssn={};
Means30_perRej_ssn={};
Stds30_perRej_ssn={};
SEs30_perRej_ssn={};

Oddballs20_perRej_ssn={};
Means20_perRej_ssn={};
Stds20_perRej_ssn={};
SEs20_perRej_ssn={};

for r=1:length(pathsi)   
    Oddballs30_perRej{r}=cell(length(electrodes),1);
    Oddballs20_perRej{r}=cell(length(electrodes),1);      
    Oddballs30_perRej_sine{r}=cell(length(electrodes),1);
    Oddballs20_perRej_sine{r}=cell(length(electrodes),1);  
    Oddballs30_perRej_ssn{r}=cell(length(electrodes),1);
    Oddballs20_perRej_ssn{r}=cell(length(electrodes),1);  
    
    for l=1:length(electrodes)
        individ_group30=[];
        individ_group20=[];
        individ_group30_sine=[];
        individ_group20_sine=[];
        individ_group30_ssn=[];
        individ_group20_ssn=[];
        
        individ_group30_match=[];
        individ_group20_match=[];
        individ_group30_sine_match=[];
        individ_group20_sine_match=[];
        individ_group30_ssn_match=[];
        individ_group20_ssn_match=[];
        
        for valids=1:length(validBabies)
            individave30=[];   
            individave20=[];    
            
            individave30_sine=[];   
            individave20_sine=[];  
            
            individave30_ssn=[];   
            individave20_ssn=[];  
            
            individave30_match=[];            
            individave20_match=[];    
            
            individave30_sine_match=[];   
            individave20_sine_match=[];  
            
            individave30_ssn_match=[];   
            individave20_ssn_match=[];
          
            if r==1
                for t=halfStart{r}(1,1):halfEnd{r}(1,1)
                    try
                        individave30=[individave30;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individave30_sine=[individave30_sine;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                        elseif stimuli(valids)==2
                            individave30_ssn=[individave30_ssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                    for t=halfStart{r}(1,2):halfEnd{r}(1,2)
                        try
                            individave20=[individave20;RTElecAves_perRej{1,r}{valids}{l,t}];   
                            if stimuli(valids)==1
                                individave20_sine=[individave20_sine;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                            elseif stimuli(valids)==2
                                individave20_ssn=[individave20_ssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                            end
                        end
                    end
                end    
            elseif r==2
            	for t=halfStart{r}(1,1):halfEnd{r}(1,1)
                    try
                        individave30=[individave30;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individave30_sine=[individave30_sine;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                        elseif stimuli(valids)==2
                            individave30_ssn=[individave30_ssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end               
                for t=halfStart{r}(2,1):halfEnd{r}(2,1)
                    try
                        individave30_match=[individave30_match;RTElecAves_perRej{1,r}{valids}{l,t}];
                        if stimuli(valids)==1
                            individave30_sine_match=[individave30_sine_match;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                        elseif stimuli(valids)==2
                            individave30_ssn_match=[individave30_ssn_match;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end
                for t=halfStart{r}(1,2):halfEnd{r}(1,2)
                    try
                        individave20=[individave20;RTElecAves_perRej{1,r}{valids}{l,t}];   
                        if stimuli(valids)==1
                            individave20_sine=[individave20_sine;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                        elseif stimuli(valids)==2
                            individave20_ssn=[individave20_ssn;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end
                for t=halfStart{r}(2,2):halfEnd{r}(2,2)
                    try
                        individave20_match=[individave20_match;RTElecAves_perRej{1,r}{valids}{l,t}];   
                        if stimuli(valids)==1
                            individave20_sine_match=[individave20_sine_match;RTElecAves_perRej{1,r}{valids}{l,t}];                       
                        elseif stimuli(valids)==2
                            individave20_ssn_match=[individave20_ssn_match;RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end
                end
            end
            individ_group30=[individ_group30;mean(individave30)];
            individ_group30_match=[individ_group30_match;mean(individave30_match)];
            if stimuli(valids)==1
                individ_group30_sine=[individ_group30_sine;mean(individave30_sine)];
                individ_group30_sine_match=[individ_group30_sine_match;mean(individave30_sine_match)];
            elseif stimuli(valids)==2
                individ_group30_ssn=[individ_group30_ssn;mean(individave30_ssn)]; 
                individ_group30_ssn_match=[individ_group30_ssn_match;mean(individave30_ssn_match)]; 
            end
            
            if isempty(individave20)~=1
                if length(individave20(:,1))>1
                    individ_group20=[individ_group20;mean(individave20)];
                    if stimuli(valids)==1
                        individ_group20_sine=[individ_group20_sine;mean(individave20_sine)];
                    elseif stimuli(valids)==2
                        individ_group20_ssn=[individ_group20_ssn;mean(individave20_ssn)];
                    end
                else
                    individ_group20=[individ_group20;(individave20)];
                    if stimuli(valids)==1    
                        individ_group20_sine=[individ_group20_sine;(individave20_sine)];
                    elseif stimuli(valids)==2
                        individ_group20_ssn=[individ_group20_ssn;(individave20_ssn)];
                    end
                end
            end
            if r==2
                if isempty(individave20_match)~=1
                    if length(individave20_match(:,1))>1
                        individ_group20_match=[individ_group20_match;mean(individave20_match)];
                        if stimuli(valids)==1
                            individ_group20_sine_match=[individ_group20_sine_match;mean(individave20_sine_match)];
                        elseif stimuli(valids)==2
                            individ_group20_ssn_match=[individ_group20_ssn_match;mean(individave20_ssn_match)];
                        end
                    else
                        individ_group20_match=[individ_group20_match;(individave20_match)];
                        if stimuli(valids)==1    
                            individ_group20_sine_match=[individ_group20_sine_match;(individave20_sine_match)];
                        elseif stimuli(valids)==2
                            individ_group20_ssn_match=[individ_group20_ssn_match;(individave20_ssn_match)];
                        end
                    end
                end
            end
        end
        Oddballs30_perRej{r}{l}=individ_group30;
        Oddballs20_perRej{r}{l}=individ_group20;  
        Oddballs30_perRej_sine{r}{l}=individ_group30_sine;        
        Oddballs20_perRej_sine{r}{l}=individ_group20_sine;
        Oddballs30_perRej_ssn{r}{l}=individ_group30_ssn;
        Oddballs20_perRej_ssn{r}{l}=individ_group20_ssn;
        if r==2
            Oddballs30_perRej{r}{l,2}=individ_group30_match;
            Oddballs20_perRej{r}{l,2}=individ_group20_match;  
            Oddballs30_perRej_sine{r}{l,2}=individ_group30_sine_match;        
            Oddballs20_perRej_sine{r}{l,2}=individ_group20_sine_match;
            Oddballs30_perRej_ssn{r}{l,2}=individ_group30_ssn_match;
            Oddballs20_perRej_ssn{r}{l,2}=individ_group20_ssn_match;   
        end
    end
    Means20_perRej{r}=cell(length(electrodes),1);  
    Stds20_perRej{r}=cell(length(electrodes),1);
    SEs20_perRej{r}=cell(length(electrodes),1);
    Means30_perRej{r}=cell(length(electrodes),1);
    Stds30_perRej{r}=cell(length(electrodes),1);
    SEs30_perRej{r}=cell(length(electrodes),1);  
    
    Means20_perRej_sine{r}=cell(length(electrodes),1);  
    Stds20_perRej_sine{r}=cell(length(electrodes),1);
    SEs20_perRej_sine{r}=cell(length(electrodes),1);
    Means30_perRej_sine{r}=cell(length(electrodes),1);
    Stds30_perRej_sine{r}=cell(length(electrodes),1);
    SEs30_perRej_sine{r}=cell(length(electrodes),1);  
    
    Means20_perRej_ssn{r}=cell(length(electrodes),1);  
    Stds20_perRej_ssn{r}=cell(length(electrodes),1);
    SEs20_perRej_ssn{r}=cell(length(electrodes),1);
    Means30_perRej_ssn{r}=cell(length(electrodes),1);
    Stds30_perRej_ssn{r}=cell(length(electrodes),1);
    SEs30_perRej_ssn{r}=cell(length(electrodes),1);  
    
    for s=1:length(electrodes)
        Means20_perRej{r}{s}=mean(Oddballs20_perRej{r}{s});
        Stds20_perRej{r}{s}=std(Oddballs20_perRej{r}{s});
        SEs20_perRej{r}{s}=Stds20_perRej{r}{s}/sqrt(max(subnums{r})); %count all babies, all babies have this mean
        
        Means30_perRej{r}{s}=mean(Oddballs30_perRej{r}{s});
        Stds30_perRej{r}{s}=std(Oddballs30_perRej{r}{s});
        SEs30_perRej{r}{s}=Stds30_perRej{r}{s}/sqrt(max(subnums{r}));%count all babies, all babies have this mean
        
        Means20_perRej_sine{r}{s}=mean(Oddballs20_perRej_sine{r}{s});
        Stds20_perRej_sine{r}{s}=std(Oddballs20_perRej_sine{r}{s});
        SEs20_perRej_sine{r}{s}=Stds20_perRej_sine{r}{s}/sqrt(max(sineNums{r})); %count all babies, all babies have this mean
        
        Means30_perRej_sine{r}{s}=mean(Oddballs30_perRej_sine{r}{s});
        Stds30_perRej_sine{r}{s}=std(Oddballs30_perRej_sine{r}{s});
        SEs30_perRej_sine{r}{s}=Stds30_perRej_sine{r}{s}/sqrt(max(sineNums{r}));%count all babies, all babies have this mean
        
        Means20_perRej_ssn{r}{s}=mean(Oddballs20_perRej_ssn{r}{s});
        Stds20_perRej_ssn{r}{s}=std(Oddballs20_perRej_ssn{r}{s});
        SEs20_perRej_ssn{r}{s}=Stds20_perRej_ssn{r}{s}/sqrt(max(ssnNums{r})); %count all babies, all babies have this mean
        
        Means30_perRej_ssn{r}{s}=mean(Oddballs30_perRej_ssn{r}{s});
        Stds30_perRej_ssn{r}{s}=std(Oddballs30_perRej_ssn{r}{s});
        SEs30_perRej_ssn{r}{s}=Stds30_perRej_ssn{r}{s}/sqrt(max(ssnNums{r}));%count all babies, all babies have this mean
        if r==2
            Means20_perRej{r}{s,2}=mean(Oddballs20_perRej{r}{s,2});
            Stds20_perRej{r}{s,2}=std(Oddballs20_perRej{r}{s,2});
            SEs20_perRej{r}{s,2}=Stds20_perRej{r}{s}/sqrt(max(subnums{r})); %count all babies, all babies have this mean

            Means30_perRej{r}{s,2}=mean(Oddballs30_perRej{r}{s,2});
            Stds30_perRej{r}{s,2}=std(Oddballs30_perRej{r}{s,2});
            SEs30_perRej{r}{s,2}=Stds30_perRej{r}{s,2}/sqrt(max(subnums{r}));%count all babies, all babies have this mean

            Means20_perRej_sine{r}{s,2}=mean(Oddballs20_perRej_sine{r}{s,2});
            Stds20_perRej_sine{r}{s,2}=std(Oddballs20_perRej_sine{r}{s,2});
            SEs20_perRej_sine{r}{s,2}=Stds20_perRej_sine{r}{s,2}/sqrt(max(sineNums{r})); %count all babies, all babies have this mean

            Means30_perRej_sine{r}{s,2}=mean(Oddballs30_perRej_sine{r}{s,2});
            Stds30_perRej_sine{r}{s,2}=std(Oddballs30_perRej_sine{r}{s,2});
            SEs30_perRej_sine{r}{s,2}=Stds30_perRej_sine{r}{s,2}/sqrt(max(sineNums{r}));%count all babies, all babies have this mean

            Means20_perRej_ssn{r}{s,2}=mean(Oddballs20_perRej_ssn{r}{s,2});
            Stds20_perRej_ssn{r}{s,2}=std(Oddballs20_perRej_ssn{r}{s,2});
            SEs20_perRej_ssn{r}{s,2}=Stds20_perRej_ssn{r}{s,2}/sqrt(max(ssnNums{r})); %count all babies, all babies have this mean

            Means30_perRej_ssn{r}{s,2}=mean(Oddballs30_perRej_ssn{r}{s,2});
            Stds30_perRej_ssn{r}{s,2}=std(Oddballs30_perRej_ssn{r}{s,2});
            SEs30_perRej_ssn{r}{s,2}=Stds30_perRej_ssn{r}{s,2}/sqrt(max(ssnNums{r}));%count all babies, all babies have this mean
        end
    end  
end



%% Paired risetimes

Oddballs3739_perRej={};
Means3739_perRej={};
Stds3739_perRej={};
SEs3739_perRej={};

Oddballs3335_perRej={};
Means3335_perRej={};
Stds3335_perRej={};
SEs3335_perRej={};

Oddballs2931_perRej={};
Means2931_perRej={};
Stds2931_perRej={};
SEs2931_perRej={};

Oddballs2527_perRej={};
Means2527_perRej={};
Stds2527_perRej={};
SEs2527_perRej={};

Oddballs2123_perRej={};
Means2123_perRej={};
Stds2123_perRej={};
SEs2123_perRej={};

Oddballs1719_perRej={};
Means1719_perRej={};
Stds1719_perRej={};
SEs1719_perRej={};



for r=1:length(pathsi)
    Oddballs3739_perRej{r}=cell(length(electrodes),1);
    Oddballs3335_perRej{r}=cell(length(electrodes),1); 
    Oddballs2931_perRej{r}=cell(length(electrodes),1);
    Oddballs2527_perRej{r}=cell(length(electrodes),1);
    Oddballs2123_perRej{r}=cell(length(electrodes),1);
    Oddballs1719_perRej{r}=cell(length(electrodes),1);
    for l=1:length(electrodes)
        locOddball3739=[];
        locOddball3335=[];
        locOddball2931=[];
        locOddball2527=[];
        locOddball2123=[];
        locOddball1719=[];
        locOddball3739_match=[];
        locOddball3335_match=[];
        locOddball2931_match=[];
        locOddball2527_match=[];
        locOddball2123_match=[];
        locOddball1719_match=[];
        locOddballHolder={{locOddball3739,locOddball3335,locOddball2931,locOddball2527,locOddball2123,locOddball1719};...
            {locOddball3739,locOddball3335,locOddball2931,locOddball2527,locOddball2123,locOddball1719;...
            locOddball3739_match,locOddball3335_match,locOddball2931_match,locOddball2527_match,locOddball2123_match,locOddball1719_match}};
        for valids=1:length(validBabies)
            Oddball3739_ind=[];
            Oddball3335_ind=[];
            Oddball2931_ind=[];
            Oddball2527_ind=[];
            Oddball2123_ind=[];
            Oddball1719_ind=[];   
            Oddball3739_ind_match=[];
            Oddball3335_ind_match=[];
            Oddball2931_ind_match=[];
            Oddball2527_ind_match=[];
            Oddball2123_ind_match=[];
            Oddball1719_ind_match=[];
            
            OddballHolder={{Oddball3739_ind,Oddball3335_ind,Oddball2931_ind,Oddball2527_ind,Oddball2123_ind,Oddball1719_ind};...
                {Oddball3739_ind,Oddball3335_ind,Oddball2931_ind,Oddball2527_ind,Oddball2123_ind,Oddball1719_ind;...
                Oddball3739_ind_match,Oddball3335_ind_match,Oddball2931_ind_match,Oddball2527_ind_match,Oddball2123_ind_match,Oddball1719_ind_match}};
            
            for z=1:length(pairStart{r}(1,:))
                for t=(pairStart{r}(1,z)):(pairEnd{r}(1,z))
                    try
                        OddballHolder{r}{1,z}=[OddballHolder{r}{1,z};RTElecAves_perRej{1,r}{valids}{l,t}];
                    end
                end     
                if isempty(OddballHolder{r}{1,z})~=1              
                    if length(OddballHolder{r}{1,z}(:,1))>1
                        locOddballHolder{r}{1,z}=[locOddballHolder{r}{1,z};mean(OddballHolder{r}{1,z})];
                    elseif length(OddballHolder{r}{1,z}(:,1))==1
                        locOddballHolder{r}{1,z}=[locOddballHolder{r}{1,z};OddballHolder{r}{1,z}];
                    end
                end
            end
            if r==2
                 for z=1:length(pairStart{r}(2,:))
                    for t=(pairStart{r}(2,z)):(pairEnd{r}(2,z))
                        try
                            OddballHolder{r}{2,z}=[OddballHolder{r}{2,z};RTElecAves_perRej{1,r}{valids}{l,t}];
                        end
                    end     
                    if isempty(OddballHolder{r}{2,z})~=1              
                        if length(OddballHolder{r}{2,z}(:,1))>1
                            locOddballHolder{r}{2,z}=[locOddballHolder{r}{2,z};mean(OddballHolder{r}{2,z})];
                        elseif length(OddballHolder{r}{2,z}(:,1))==1
                            locOddballHolder{r}{2,z}=[locOddballHolder{r}{2,z};OddballHolder{r}{2,z}];
                        end
                    end
                 end   
            end
        end
        
        Oddballs3739_perRej{r}{l}=locOddballHolder{r}{1,1};
        Oddballs3335_perRej{r}{l}=locOddballHolder{r}{1,2};
        Oddballs2931_perRej{r}{l}=locOddballHolder{r}{1,3};
        Oddballs2527_perRej{r}{l}=locOddballHolder{r}{1,4};
        Oddballs2123_perRej{r}{l}=locOddballHolder{r}{1,5};
        Oddballs1719_perRej{r}{l}=locOddballHolder{r}{1,6};
        if r==2
            Oddballs3739_perRej{r}{l,2}=locOddballHolder{r}{2,1};
            Oddballs3335_perRej{r}{l,2}=locOddballHolder{r}{2,2};
            Oddballs2931_perRej{r}{l,2}=locOddballHolder{r}{2,3};
            Oddballs2527_perRej{r}{l,2}=locOddballHolder{r}{2,4};
            Oddballs2123_perRej{r}{l,2}=locOddballHolder{r}{2,5};
            Oddballs1719_perRej{r}{l,2}=locOddballHolder{r}{2,6};
        end
    end
    
    Means3739_perRej{r}=cell(length(electrodes),1);
    Stds3739_perRej{r}=cell(length(electrodes),1);
    SEs3739_perRej{r}=cell(length(electrodes),1);
    
    Means3335_perRej{r}=cell(length(electrodes),1);
    Stds3335_perRej{r}=cell(length(electrodes),1);
    SEs3335_perRej{r}=cell(length(electrodes),1);
        
    Means2931_perRej{r}=cell(length(electrodes),1);
    Stds2931_perRej{r}=cell(length(electrodes),1);
    SEs2931_perRej{r}=cell(length(electrodes),1);
    
    Means2527_perRej{r}=cell(length(electrodes),1);
    Stds2527_perRej{r}=cell(length(electrodes),1);
    SEs2527_perRej{r}=cell(length(electrodes),1);
    
    Means2123_perRej{r}=cell(length(electrodes),1);
    Stds2123_perRej{r}=cell(length(electrodes),1);
    SEs2123_perRej{r}=cell(length(electrodes),1);
    
    Means1719_perRej{r}=cell(length(electrodes),1);
    Stds1719_perRej{r}=cell(length(electrodes),1);
    SEs1719_perRej{r}=cell(length(electrodes),1);
    
    for s=1:length(electrodes)
        Means3739_perRej{r}{s,1}=mean(Oddballs3739_perRej{r}{s,1});
        Stds3739_perRej{r}{s,1}=std(Oddballs3739_perRej{r}{s,1});
        SEs3739_perRej{r}{s,1}=Stds3739_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,1)),subnums{r}(pairEnd{r}(1,1))));
        
        Means3335_perRej{r}{s,1}=mean(Oddballs3335_perRej{r}{s,1});
        Stds3335_perRej{r}{s,1}=std(Oddballs3335_perRej{r}{s,1});
        SEs3335_perRej{r}{s,1}=Stds3335_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,2)),subnums{r}(pairEnd{r}(1,2))));
        
        Means2931_perRej{r}{s,1}=mean(Oddballs2931_perRej{r}{s,1});
        Stds2931_perRej{r}{s,1}=std(Oddballs2931_perRej{r}{s,1});
        SEs2931_perRej{r}{s,1}=Stds2931_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,3)),subnums{r}(pairEnd{r}(1,3))));
        
        Means2527_perRej{r}{s,1}=mean(Oddballs2527_perRej{r}{s,1});
        Stds2527_perRej{r}{s,1}=std(Oddballs2527_perRej{r}{s,1});
        SEs2527_perRej{r}{s,1}=Stds2527_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,4)),subnums{r}(pairEnd{r}(1,4))));
        
        Means2123_perRej{r}{s,1}=mean(Oddballs2123_perRej{r}{s,1});
        Stds2123_perRej{r}{s,1}=std(Oddballs2123_perRej{r}{s,1});
        SEs2123_perRej{r}{s,1}=Stds2123_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,5)),subnums{r}(pairEnd{r}(1,5))));
        
        if length(subnums{1})>11
            Means1719_perRej{r}{s,1}=mean(Oddballs1719_perRej{r}{s,1});
            Stds1719_perRej{r}{s,1}=std(Oddballs1719_perRej{r}{s,1});
            SEs1719_perRej{r}{s,1}=Stds1719_perRej{r}{s,1}/sqrt(max(subnums{r}(pairStart{r}(1,6)),subnums{r}(pairEnd{r}(1,6))));
        end
        if r==2
            Means3739_perRej{r}{s,2}=mean(Oddballs3739_perRej{r}{s,2});
            Stds3739_perRej{r}{s,2}=std(Oddballs3739_perRej{r}{s,2});
            SEs3739_perRej{r}{s,2}=Stds3739_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,1)),subnums{r}(pairEnd{r}(2,1))));

            Means3335_perRej{r}{s,2}=mean(Oddballs3335_perRej{r}{s,2});
            Stds3335_perRej{r}{s,2}=std(Oddballs3335_perRej{r}{s,2});
            SEs3335_perRej{r}{s,2}=Stds3335_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,2)),subnums{r}(pairEnd{r}(2,2))));

            Means2931_perRej{r}{s,2}=mean(Oddballs2931_perRej{r}{s,2});
            Stds2931_perRej{r}{s,2}=std(Oddballs2931_perRej{r}{s,2});
            SEs2931_perRej{r}{s,2}=Stds2931_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,3)),subnums{r}(pairEnd{r}(2,3))));

            Means2527_perRej{r}{s,2}=mean(Oddballs2527_perRej{r}{s,2});
            Stds2527_perRej{r}{s,2}=std(Oddballs2527_perRej{r}{s,2});
            SEs2527_perRej{r}{s,2}=Stds2527_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,4)),subnums{r}(pairEnd{r}(2,4))));

            Means2123_perRej{r}{s,2}=mean(Oddballs2123_perRej{r}{s,2});
            Stds2123_perRej{r}{s,2}=std(Oddballs2123_perRej{r}{s,2});
            SEs2123_perRej{r}{s,2}=Stds2123_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,5)),subnums{r}(pairEnd{r}(2,5))));
            if length(subnums{1})>11
                Means1719_perRej{r}{s,2}=mean(Oddballs1719_perRej{r}{s,2});
                Stds1719_perRej{r}{s,2}=std(Oddballs1719_perRej{r}{s,2});
                SEs1719_perRej{r}{s,2}=Stds1719_perRej{r}{s,2}/sqrt(max(subnums{r}(pairStart{r}(2,6)),subnums{r}(pairEnd{r}(2,6))));
            end
        end
    end        
end


%% plots (group)
% use this section to make plots

  
timepoints=-159:800;
risetimes={{'RT01','RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17'}...
    {'RT39','RT37','RT35','RT33','RT31','RT29','RT27','RT25','RT23','RT21','RT19','RT17','RT38','RT36','RT34','RT32','RT30','RT28'...
    'RT26','RT24','RT22','RT20','RT18','RT16'}};
saveloc=strcat('/media/aine/5a38de90-ca12-4b4b-bfdc-7240ac05b837/Work_aine/rise time erp/',MoI);
pathso={'/figures/allStandards/';'/figures/matchedStandards/'};
%%
for rej=1% % for the normal allStandards figures
    % % batch export
    for locs=1:length(electrodes)
      % all RTs
        
        for rts=2:length(subnums{rej})
            shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
            hold on
            shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,rts},allSEs_perRej{rej}{locs,rts},'lineprops','r');
            fig.PaperPositionMode = 'auto';
            saveas(gcf,strcat(saveloc,pathso{rej},'RT01vs',risetimes{rej}{rts},'/',risetimes{rej}{rts},'_',num2str(locs),'.jpg'));
            close all
        end

      % overall average

        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,obMeans_perRej{rej}{locs,1},obSEs_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsAllOBs/','RT01vsAllOBs_',num2str(locs),'.jpg'));
        close all
        
        shadedErrorBar(timepoints,allMeans_perRej_sine{rej}{locs,1},allSEs_perRej_sine{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,obMeans_perRej_sine{rej}{locs,1},obSEs_perRej_sine{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'Sine/RT01vsAllOBs/','Sine_RT01vsAllOBs_',num2str(locs),'.jpg'));
        close all
        
        shadedErrorBar(timepoints,allMeans_perRej_ssn{rej}{locs,1},allSEs_perRej_ssn{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,obMeans_perRej_ssn{rej}{locs,1},obSEs_perRej_ssn{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'SSN/RT01vsAllOBs/','SSN_RT01vsAllOBs_',num2str(locs),'.jpg'));
        close all

    % average per 20s and 30s

        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means30_perRej{rej}{locs,1},SEs30_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT30s/','RT01vsRT30s_',num2str(locs),'.jpg'));
        close all

        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means20_perRej{rej}{locs,1},SEs20_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT20s/','RT01vsRT20s_',num2str(locs),'.jpg'));
        close all
        
        shadedErrorBar(timepoints,allMeans_perRej_sine{rej}{locs,1},allSEs_perRej_sine{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means30_perRej_sine{rej}{locs,1},SEs30_perRej_sine{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'Sine/RT01vsRT30s/','Sine_RT01vsRT30s_',num2str(locs),'.jpg'));
        close all

        shadedErrorBar(timepoints,allMeans_perRej_sine{rej}{locs,1},allSEs_perRej_sine{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means20_perRej_sine{rej}{locs,1},SEs20_perRej_sine{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'Sine/RT01vsRT20s/','Sine_RT01vsRT20s_',num2str(locs),'.jpg'));
        close all  
        
        shadedErrorBar(timepoints,allMeans_perRej_ssn{rej}{locs,1},allSEs_perRej_ssn{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means30_perRej_ssn{rej}{locs,1},SEs30_perRej_ssn{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'SSN/RT01vsRT30s/','SSN_RT01vsRT30s_',num2str(locs),'.jpg'));
        close all

        shadedErrorBar(timepoints,allMeans_perRej_ssn{rej}{locs,1},allSEs_perRej_ssn{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means20_perRej_ssn{rej}{locs,1},SEs20_perRej_ssn{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'SSN/RT01vsRT20s/','SSN_RT01vsRT20s_',num2str(locs),'.jpg'));
        close all
        
    % average per pair

        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means3739_perRej{rej}{locs,1},SEs3739_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT3739/','RT01vsRT3739_',num2str(locs),'.jpg'));
        close all  
        
        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means3335_perRej{rej}{locs,1},SEs3335_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT3335/','RT01vsRT3335_',num2str(locs),'.jpg'));
        close all  
        
        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means2931_perRej{rej}{locs,1},SEs2931_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT2931/','RT01vsRT2931_',num2str(locs),'.jpg'));
        close all  
        
        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means2527_perRej{rej}{locs,1},SEs2527_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT2527/','RT01vsRT2527_',num2str(locs),'.jpg'));
        close all  
        
        shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        shadedErrorBar(timepoints,Means2123_perRej{rej}{locs,1},SEs2123_perRej{rej}{locs,1},'lineprops','r');       
        saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT2123/','RT01vsRT2123_',num2str(locs),'.jpg'));
        close all  
        
%         if length(subnums)>11
%         
%             shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
%             hold on
%             shadedErrorBar(timepoints,Means1719_perRej{rej}{locs,1},SEs1719_perRej{rej}{locs,1},'lineprops','r');       
%             saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT1719/','RT01vsRT1719_',num2str(locs),'.jpg'));
%             close all  
%         end
    end
end  

%%
for rej=2%:length(pathsi) % for the matched Standards figures
    % % batch export
%     if MoI=="7mo"
%         adder=12;
%     elseif MoI=="11mo"
%         adder=10;
%     end
    adder=12;
    
    for locs=1%:length(electrodes)
      % all RTs
        
%         for rts=1:(length(subnums{rej})/2)
%             shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,rts+adder},allSEs_perRej{rej}{locs,rts+adder},'lineprops','b');
%             hold on
%             shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,rts},allSEs_perRej{rej}{locs,rts},'lineprops','r');
%            % saveas(gcf,strcat(saveloc,pathso{rej},risetimes{rej}{rts+12},'vs',risetimes{rej}{rts},'/',risetimes{rej}{rts},'_',num2str(locs),'.jpg'));
%             %close all
%         end
% 
%       % overall average
%   
        shadedErrorBar(timepoints,sqrt((obMeans_perRej{rej}{locs,2}-obMeans_perRej{rej}{locs,1}).^2),obSEs_perRej{rej}{locs,1},'lineprops','b');
        hold on
        %shadedErrorBar(timepoints,obMeans_perRej{rej}{locs,1},obSEs_perRej{rej}{locs,1},'lineprops','r');       
        %saveas(gcf,strcat(saveloc,pathso{rej},'AllSTvsAllOB/','AllSTvsAllOB_',num2str(locs),'.jpg'));
%         close all
%         
%         shadedErrorBar(timepoints,obMeans_perRej_sine{rej}{locs,2},obSEs_perRej_sine{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,obMeans_perRej_sine{rej}{locs,1},obSEs_perRej_sine{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'Sine/AllSTvsAllOB/','Sine_AllSTvsAllOB_',num2str(locs),'.jpg'));
%         close all
%         
%         shadedErrorBar(timepoints,obMeans_perRej_ssn{rej}{locs,2},obSEs_perRej_ssn{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,obMeans_perRej_ssn{rej}{locs,1},obSEs_perRej_ssn{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'SSN/AllSTvsAllOB/','SSN_AllSTvsAllOB_',num2str(locs),'.jpg'));
%         close all
% 
%     % average per 20s and 30s
% 
%         shadedErrorBar(timepoints,Means30_perRej{rej}{locs,2},SEs30_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means30_perRej{rej}{locs,1},SEs30_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'ST30vsOB30/','ST30vsOB30_',num2str(locs),'.jpg'));
%         close all
% 
%         shadedErrorBar(timepoints,Means20_perRej{rej}{locs,2},SEs20_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means20_perRej{rej}{locs,1},SEs20_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'ST20vsOB20/','ST20vsOB20_',num2str(locs),'.jpg'));
%         close all
%         
%         shadedErrorBar(timepoints,Means30_perRej_sine{rej}{locs,2},SEs30_perRej_sine{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means30_perRej_sine{rej}{locs,1},SEs30_perRej_sine{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'Sine/ST30vsOB30/','Sine_ST30vsOB30_',num2str(locs),'.jpg'));
%         close all
% 
%         shadedErrorBar(timepoints,Means20_perRej_sine{rej}{locs,2},SEs20_perRej_sine{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means20_perRej_sine{rej}{locs,1},SEs20_perRej_sine{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'Sine/ST20vsOB20/','Sine_ST20vsOB20_',num2str(locs),'.jpg'));
%         close all  
%         
%         shadedErrorBar(timepoints,Means30_perRej_ssn{rej}{locs,2},SEs30_perRej_ssn{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means30_perRej_ssn{rej}{locs,1},SEs30_perRej_ssn{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'SSN/ST30vsOB30/','SSN_ST30vsOB30_',num2str(locs),'.jpg'));
%         close all
% 
%         shadedErrorBar(timepoints,Means20_perRej_ssn{rej}{locs,2},SEs20_perRej_ssn{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means20_perRej_ssn{rej}{locs,1},SEs20_perRej_ssn{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'SSN/ST20vsOB20/','SSN_ST20vsOB20_',num2str(locs),'.jpg'));
%         close all
%         
%     % average per pair
% 
%         shadedErrorBar(timepoints,Means3739_perRej{rej}{locs,2},SEs3739_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means3739_perRej{rej}{locs,1},SEs3739_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'RT3638vsRT3739/','RT3739_',num2str(locs),'.jpg'));
%         close all  
%         
%         shadedErrorBar(timepoints,Means3335_perRej{rej}{locs,2},SEs3335_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means3335_perRej{rej}{locs,1},SEs3335_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'RT3234vsRT3335/','RT3335_',num2str(locs),'.jpg'));
%         close all  
%         
%         shadedErrorBar(timepoints,Means2931_perRej{rej}{locs,2},SEs2931_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means2931_perRej{rej}{locs,1},SEs2931_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'RT2830vsRT2931/','RT2931_',num2str(locs),'.jpg'));
%         close all  
%         
%         shadedErrorBar(timepoints,Means2527_perRej{rej}{locs,2},SEs2527_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means2527_perRej{rej}{locs,1},SEs2527_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'RT2426vsRT2527/','RT2527_',num2str(locs),'.jpg'));
%         close all
% %         
%         shadedErrorBar(timepoints,Means2123_perRej{rej}{locs,2},SEs2123_perRej{rej}{locs,2},'lineprops','b');
%         hold on
%         shadedErrorBar(timepoints,Means2123_perRej{rej}{locs,1},SEs2123_perRej{rej}{locs,1},'lineprops','r');       
%         saveas(gcf,strcat(saveloc,pathso{rej},'RT2022vsRT2123/','RT2123_',num2str(locs),'.jpg'));
%         close all  
%         
% %         if length(subnums)>11
% %         
% %             shadedErrorBar(timepoints,allMeans_perRej{rej}{locs,1},allSEs_perRej{rej}{locs,1},'lineprops','b');
% %             hold on
% %             shadedErrorBar(timepoints,Means1719_perRej{rej}{locs,1},SEs1719_perRej{rej}{locs,1},'lineprops','r');       
% %             saveas(gcf,strcat(saveloc,pathso{rej},'RT01vsRT1719/','RT01vsRT1719_',num2str(locs),'.jpg'));
% %             close all  
% %         end
    end
end  
% 

