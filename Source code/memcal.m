function [T,Enriched_Stream,Delepeted_Stream,esp,elops] = memcal(Feed,nStripping,nEnriching,alpha,phi_Strp,theta_Strp,phi_Ench,theta_Ench,CompressPressure)
%MEMCAL Summary of this function goes here

%INITIAL CONDITION
Recycle = Stream(0,1,0.5,0.5);
Recycle_Enriching = Stream(0,1,0.5,0.5);
Recycle_Stripping = Stream(0,1,0.5,0.5);
esp = 0;

% BEGIN SIMULATION
% EVALUATE ENRICHING SECTION
    F_Enriching = Stream.create_table(nEnriching+2);
    F_Enriching(1) = Feed;
for elops = 1:1000
    F_Enriching(1) = Membr.Compress(F_Enriching(1),CompressPressure);
    R_Enriching = Stream.create_table(nEnriching+1);
    % Create Membrane Enriching
    for i = 1:(nEnriching+1)
        Membrane_enriching(i) = Membr(alpha,phi_Ench(i),theta_Ench(i));
        Membrane_enriching(i) = Membr.MemCounterFlow(Membrane_enriching(i),F_Enriching(i));
        R_Enriching(i) = Membrane_enriching(i).Retentate;
        F_Enriching(i+1) = Membrane_enriching(i).Permeate;
    end
    
    if nEnriching > 0
        QE = sum([R_Enriching.Flowrate])-R_Enriching(1).Flowrate;
        xA_E = (sum([R_Enriching.Flowrate].*[R_Enriching.xA])-...
            R_Enriching(1).Flowrate * R_Enriching(1).xA)/QE;
        Recycle_Enriching = Stream(QE,1,xA_E ,1-xA_E);
    end
    
% EVALUATE STRIPPING SECTION
if nStripping > 0
    F_Stripping = Stream.create_table(nStripping+1);
    R_Stripping = Stream.create_table(nStripping);
    F_Stripping(1) = R_Enriching(1);
    % Create Membrane Stripping
    for i = 1:(nStripping)
        Membrane_stripping(i) = Membr(alpha,phi_Strp(i),theta_Strp(i));
        Membrane_stripping(i) = Membr.MemCounterFlow(Membrane_stripping(i),F_Stripping(i));
        F_Stripping(i+1) = Membrane_stripping(i).Retentate;
        R_Stripping(i) = Membrane_stripping(i).Permeate;
    end
    
    QS = sum([R_Stripping.Flowrate]);
    xA_S = sum([R_Stripping.Flowrate].*[R_Stripping.xA])/QS;
    Recycle_Stripping = Stream(QS,1,xA_S ,1-xA_S);
end

    Recycle = Membr.Mixer(Feed,Recycle_Stripping,Recycle_Enriching);
    esp = Membr.Recycle(Recycle,F_Enriching(1));
    
    if esp < 10^-6
        break
    end
    F_Enriching(1) = Recycle;
end
% END SIMULATION

% SHOW THE RESULT

% PRODUCT STREAM TO CALCULATE PERFORMANCE
if nStripping > 0
    S = [Feed,Recycle_Stripping,Recycle_Enriching,R_Stripping,R_Enriching,F_Stripping,F_Enriching];
    Nstrp = nStripping+1;
    Enriched_Stream = F_Enriching(length(F_Enriching));
    Delepeted_Stream = F_Stripping(length(F_Stripping));
else
    S = [Feed,Recycle_Stripping,Recycle_Enriching,R_Enriching,F_Enriching];
    Nstrp = 0;
    Enriched_Stream = F_Enriching(length(F_Enriching));
    Delepeted_Stream = R_Enriching(1);
end

% NAMING STREAM FOR STREAM TABLE
strs(1) = "Feed";
strs(2) = "RStrip";
strs(3) = "REnrich";
for t = 4:((nStripping+Nstrp)+(2*(nEnriching+1)+1)+3)
    if 3 < t && t <= (nStripping + 3)        
        strs(t) = "RS" + num2str(t-3); 
        
    elseif (nStripping + 3) < t && t <= (nStripping + (nEnriching+1) + 3)
        strs(t) = "RE" + num2str(t-(nStripping + 3));  
        
    elseif (nStripping + (nEnriching+1)+ 3) < t && t <= (nStripping + Nstrp + (nEnriching+1) + 3)
        strs(t) = "FS" + num2str(t-(nStripping + nEnriching+1 + 3));
        
    else
        strs(t) = "FE" +num2str(t - (nStripping + Nstrp + (nEnriching+1) + 3));  
    end
end

% CONSTRUCT STREAM TABLE
T.Stream = strs';
T.Flowrate = [S.Flowrate]';
T.Pressure = [S.Pressure]';
T.xA = [S.xA]';
T.xB = [S.xB]';
end

