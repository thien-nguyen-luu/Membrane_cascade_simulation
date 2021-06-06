function drawpfd(M,N,comp_duty)
nameM = M;
nameN = N;

% FIGURE OPTION
    % HIDE THE AXIS
    % ADD BACKGROUND COLOR
    % NO MARGIN
f = figure('Visible','off','Position',[100,100,1800,850],'Renderer','painters');
set(gca,'XColor', 'none','YColor','none');
set(gca,'color',[240/255 240/255 240/255]);
set(gcf,'InvertHardCopy','Off');
Tight = get(gca, 'TightInset');  %Gives you the bording spacing between plot box and any axis labels
                                 %[Left Bottom Right Top] spacing
NewPos = [Tight(1) Tight(2) 1-Tight(1)-Tight(3) 1-Tight(2)-Tight(4)]; %New plot position [X Y W H]
set(gca, 'Position', NewPos);
axis([0 360 38 105]);


% DRAW THE FEED MEMBRANE
out = leftarrow([0,60],30);
out = comp(out(1),out(2));
out = leftarrow(out,30);
[ret,per] = memFeed(out);
outfeedper = leftarrow(per,30);
line([ret(1) ret(1)] , [ ret(2) ret(2) + 20],'Color','black','Linewidth',2);
outfeedret = leftarrow([ret(1),ret(2) + 20],30);


% DRAW THE STRIPPING MEMBRANE
if M > 3
M = 3;
% Stripping Stage
    for i = 1:M
        ret = memStripping(outfeedret);
        outfeedret = ret;
    end
    xpos = 255-0;
    parallell(xpos,102,[0, 0.4470, 0.7410]);
    line([xpos+0.5,xpos+5],[102,102],'Color',[240/255 240/255 240/255],'LineStyle','-','Linewidth',3)
    parallell(xpos+5,102,[0, 0.4470, 0.7410]);

    parallell(xpos,84,[0, 0, 0]);
    line([xpos+0.5,xpos+5],[84,84],'Color',[240/255 240/255 240/255],'LineStyle','-','Linewidth',3)
    parallell(xpos+5,84,[0, 0, 0]);
else
    for i = 1:M
        ret = memStripping(outfeedret);
        outfeedret = ret;
    end
end


% DRAW THE ENRICHING MEMBRANE
if N>3
N = 3;
    for i = 1:N
        per = memEnriching(outfeedper);
        outfeedper = per;
    end
    xpos = 275-2.5;
    parallell(xpos,41,[0.8500, 0.3250, 0.0980]);
    line([xpos+0.5,xpos+5],[41,41],'Color',[240/255 240/255 240/255],'LineStyle','-','Linewidth',3)
    parallell(xpos+5,41,[0.8500, 0.3250, 0.0980]);
    
    xpos = 277-2.5;
    parallell(xpos,54,[0, 0, 0]);
    line([xpos+0.5,xpos+5],[54,54],'Color',[240/255 240/255 240/255],'LineStyle','-','Linewidth',3)
    parallell(xpos+5,54,[0, 0, 0]);
else
    for i = 1:N
        per = memEnriching(outfeedper);
        outfeedper = per;
    end
end

% DRAW THE TEXT
% FEED
text(90,60,'Feed','FontSize',32);
text(60,62,'F0','FontSize',24);
text(0,62,'Feed','FontSize',24);
text(108,86,'FS0','FontSize',24);
text(128,56,'FE0','FontSize',24);

% STRIPPING
if nameM == 0
    nameM = 0;
elseif nameM == 1
    text(145,84,'S1','FontSize',32);
    
    text(22,100,'RStrip','FontSize',24);
    
    text(152,97,'RS1','FontSize',24);
    text(172,86,'FS1','FontSize',24);
elseif nameM == 2
    text(145,84,'S1','FontSize',32);
    text(145+70,84,'S2','FontSize',32);
    
    text(22,100,'RStrip','FontSize',24);
    
    text(152,97,'RS1','FontSize',24);
    text(172,86,'FS1','FontSize',24);

    text(222,97,'RS2','FontSize',24);
    text(242,86,'FS2','FontSize',24);
elseif nameM == 3
    text(145,84,'S1','FontSize',32);
    text(145+70,84,'S2','FontSize',32);
    text(145+70+70,84,'S3','FontSize',32);
    
    text(22,100,'RStrip','FontSize',24);
    
    text(152,97,'RS1','FontSize',24);
    text(172,86,'FS1','FontSize',24);

    text(222,97,'RS2','FontSize',24);
    text(242,86,'FS2','FontSize',24);

    text(292,97,'RS3','FontSize',24);
    text(312,86,'FS3','FontSize',24);
else
    text(145,84,'S1','FontSize',32);
    text(145+70,84,'S2','FontSize',32);
    text(145+70+70,84,['S',num2str(nameM)],'FontSize',32);
    
    text(22,100,'RStrip','FontSize',24);
    
    text(152,97,'RS1','FontSize',24);
    text(172,86,'FS1','FontSize',24);

    text(222,97,'RS2','FontSize',24);
    text(242,86,'FS2','FontSize',24);

    text(292,97,['RS',num2str(nameM)],'FontSize',24);
    text(312,86,['FS',num2str(nameM)],'FontSize',24);
end
% ENRICHING
if nameN == 0
    nameN = 0;
elseif nameN == 1
    text(165,55,'E1','FontSize',32);
    
    text(22,43,'REnrich','FontSize',24);
    
    text(192,63,'FE1','FontSize',24);
    text(172,46,'RE1','FontSize',24);
elseif nameN == 2
    text(165,55,'E1','FontSize',32);
    text(165+70,55,'E2','FontSize',32);
    
    text(22,43,'REnrich','FontSize',24);
    
    text(192,63,'FE1','FontSize',24);
    text(172,46,'RE1','FontSize',24);

    text(262,63,'FE2','FontSize',24);
    text(242,46,'RE2','FontSize',24);
elseif nameN == 3
    text(165,55,'E1','FontSize',32);
    text(165+70,55,'E2','FontSize',32);
    text(165+70+70,55,'E3','FontSize',32);
    
    text(22,43,'REnrich','FontSize',24);
    
    text(192,63,'FE1','FontSize',24);
    text(172,46,'RE1','FontSize',24);

    text(262,63,'FE2','FontSize',24);
    text(242,46,'RE2','FontSize',24);

    text(332,63,'FE3','FontSize',24);
    text(312,46,'RE3','FontSize',24);
else
    text(165,55,'E1','FontSize',32);
    text(165+70,55,'E2','FontSize',32);
    text(165+70+70,55,['E',num2str(nameN)],'FontSize',32);
    
    text(22,43,'REnrich','FontSize',24);
    
    text(192,63,'FE1','FontSize',24);
    text(172,46,'RE1','FontSize',24);

    text(262,63,'FE2','FontSize',24);
    text(242,46,'RE2','FontSize',24);

    text(332,63,['FE',num2str(nameN)],'FontSize',24);
    text(312,46,['RE',num2str(nameN)],'FontSize',24);
end

% ADD MORE INFORMATION
text(30,54,[num2str(comp_duty),' kW'],'FontSize',24);


% SAVE THE FIGURE TO PNG
print(gcf,'img/processflowdiagram','-dpng');

% FUNCTION
function [ret,per] = memFeed(feed)
offset = 2;
width = 40;
heigh = 12;
x = feed(1);
y = feed(2) - heigh*3/4+offset/2;
rectangle('Position',[x y width heigh],'Linewidth',2,'FaceColor',[1 1 1]);
line([x x+width] , [ y + heigh/2-offset y + heigh/2-offset],'Color','black','LineStyle','-','Linewidth',2);
ret = [x+width/2,y+heigh];
per = [x+width,y+heigh/4-offset/2];
end

function ret = memStripping (feed)
offset = 2;
width = 40;
heigh = 12;
x = feed(1);
y = feed(2) - heigh/4 - offset/2;
rectangle('Position',[x y width heigh],'Linewidth',2,'FaceColor',[1 1 1]);
line([x x+width] , [ y + heigh/2 + offset , y + heigh/2 + offset],'Color','black','LineStyle','-','Linewidth',2);
line([x+width/2 x+width/2],[y+heigh y+heigh+10],'Color',[0, 0.4470, 0.7410],'Linewidth',2);
line([x+width/2 20],[y+heigh+10 y+heigh+10],'Color',[0, 0.4470, 0.7410],'Linewidth',2);
downarrow([20,y+heigh+10],y+heigh+10-60);
ret = leftarrow([x+width,feed(2)],30);
end

function per = memEnriching (feed)
offset = 2;
width = 40;
heigh = 12;
x = feed(1);
y = feed(2) - heigh/4;
rectangle('Position',[x y width heigh],'Linewidth',2,'FaceColor',[1 1 1]);
line([x x+width] , [ y + heigh/2 + offset , y + heigh/2 + offset],'Color','black','LineStyle','-','Linewidth',2);
line([x+width/2 x+width/2],[y y-10],'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2);
line([x+width/2 20],[y-10 y-10],'Color',[0.8500, 0.3250, 0.0980],'Linewidth',2);
uparrow([20,y-10],(60 - (y-10)));
line([x+width x+width+10] , [ y+heigh*0.75+offset/2 , y+heigh*0.75+offset/2],'Color','black','Linewidth',2);
line([x+width+10 x+width+10] , [ y+heigh*0.75+offset/2 , y+heigh*0.75-heigh/2],'Color','black','Linewidth',2);
per = leftarrow([x+width+10,y+heigh*0.75-heigh/2],20);
end

function out = comp (y,x) % because we rotate the shape
a = 20; % length
h = 8; % big base
r = 3;  % small bas
%%Frame vertices
A =  [x+h/2 y] ;
B =  [x+r/2 y+a] ;
C =  [x-r/2 y+a] ; 
D =  [x-h/2 y] ;
coor = [D ; A; B; C] ;
patch(coor(:,2), coor(:,1),[0, 0.75, 0.75],'Linewidth',2)
out = [y+a,x];
end

function out = leftarrow(p1,len)
p2 = [p1(1)+len,p1(2)];
line([p1(1),p2(1)],[p1(2),p2(2)],'Color','black','LineStyle','-','Linewidth',2);
A =   p2 ;
B =  [p2(1)-4,p2(2)+1] ;
C =  [p2(1)-4,p2(2)-1] ;
D =  p2;
coor = [A; B; C; D] ;
patch(coor(:,1), coor(:,2),'k');
out = p2;
end

function out = downarrow(p1,len)
p2 = [p1(1),p1(2)-len];
line([p1(1),p2(1)],[p1(2),p2(2)],'Color',[0, 0.4470, 0.7410],'LineStyle','-','Linewidth',2);
A =  p2 ;
B =  [p2(1)-2,p2(2)+2] ;
C =  [p2(1)+2,p2(2)+2] ;
D = A;
coor = [A; B; C ; D] ;
patch(coor(:,1), coor(:,2),[0, 0.4470, 0.7410]);
out = p2;
end

function out = uparrow(p1,len)
p2 = [p1(1),p1(2)+len];
line([p1(1),p2(1)],[p1(2),p2(2)],'Color',[0.8500, 0.3250, 0.0980],'LineStyle','-','Linewidth',2);
A =  p2 ;
B =  [p2(1)-2,p2(2)-2] ;
C =  [p2(1)+2,p2(2)-2] ;
D = A;
coor = [A; B; C ; D] ;
patch(coor(:,1), coor(:,2),	[0.8500, 0.3250, 0.0980]);
out = p2;
end

function  parallell(x,y,Color)
    slope = sqrt(3)/2;
    intercept = y - slope * x;
    a = 5;
    h = 10;
    line([x-a/2,x+a/2],[slope*(x-a/2)+intercept,slope*(x+a/2)+intercept],'Color',Color,'LineStyle','-','Linewidth',2)
end

end