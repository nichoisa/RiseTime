function [newEvents,newtrsps]=missingRTDINs(oldEvents,baddies,oldtrsps)
%%    
    evtholder=oldEvents;
    for bds=1:length(baddies(:,1))
        for dins=baddies(bds,2):(length(evtholder)+1)
            evtholder(dins)=oldEvents(dins-1);
        end
        prev=oldEvents(baddies(bds,2)-1).latency;
        nex=oldEvents(baddies(bds,2)).latency;
        if length(baddies(bds,:))==3
            if baddies(bds,3)==0
                evtholder(baddies(bds,2)).latency=prev+((nex-prev)/2);
            elseif baddies(bds,3)==1
                miss2=((nex-prev)/3);
                evtholder(baddies(bds,2)).latency=prev+(2*miss2); 
            end 
        else
            if ((nex-prev)/2)>1500
                evtholder(baddies(bds,2)).latency=prev+1000;
            else
                evtholder(baddies(bds,2)).latency=prev+((nex-prev)/2);
            end
        end
        oldEvents=evtholder;
        if length(oldtrsps)>1
            for trs=(baddies(bds,1)+1):length(oldtrsps)
                oldtrsps(trs)=oldtrsps(trs)+1;
            end
        end
    end
    newEvents=evtholder;
    newtrsps=oldtrsps;
    %%
end