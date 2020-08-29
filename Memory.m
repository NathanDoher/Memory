function [] = Memory(matSize,p,name)

if nargin ==0  %checks to see if game is just starting up and sets default to 4
    matSize=4;
    p=1;       %counter for 1 player game and 2 player game
    name=0;    %place holder for player names
    name1=' '; %place holder for player 1 name
    name2=' '; %place holder for player 2 name
    n={};
    playerCount=1;
else 
    
    
end

a = ' ';        %Creates a place holder for temp button location
b = 0;          %Creates a place holder for temp button value
c = [0 0];      %Counter for button presses in each group
endcounter = 0; %Counter to determine when the game is completed
counter = 0;    %Counter to determine the total number of attempts

tic

cellNum=randmat(matSize);%creates random matrix based off difficulty level


S.fh = figure('units','normalized','position',[.3 .3 .5 .5],'menubar','none','name','Memory','numbertitle','off','resize','on');

if p==1

    y=1; 
elseif p==2
    
    scoreTop={0 0};
    %S is standard structure title, pt is for a text box, s is for score, n is for name, and  1 or 2 is for which player
    S.pt_s1 = uicontrol('style','text','unit','normalized','fontsize',15,...
        'position',[0 .9 .1 .1],'string',scoreTop{1},'backgroundc',[0.94 .94 .94]);

    S.pt_n1 = uicontrol('style','text','unit','normalized','fontsize',15,...
        'position',[.15 .9 .25 .1],'string',name{1},'backgroundc',[0.94 .94 .94],...
        'HorizontalAlignment','left','ForegroundColor',[1 .7 .3]);

    S.pt_s2 = uicontrol('style','text','unit','normalized','fontsize',15,...
        'position',[.5 .9 .1 .1],'string',scoreTop{2},'backgroundc',[0.94 .94 .94]);

    S.pt_n2 = uicontrol('style','text','unit','normalized','fontsize',15,...
        'position',[.65 .9 .25 .1],'string',name{2},'backgroundc',[0.94 .94 .94],...
        'HorizontalAlignment','left','ForegroundColor',[0 .5 1]);
    y=.90;               %changes board size to account for a 2 player information bar
    j=randperm(2,1);     %Starts the game with a random starting player
    
    if j==1              %shuts off the opposite player from playing and scoring
        set(S.pt_s2,'Enable','off')
        set(S.pt_n2,'Enable','off')
    elseif j==2
        set(S.pt_s1,'Enable','off')
        set(S.pt_n1,'Enable','off')
    end
end
 

w=matSize*2;             %Used to make columns for buttons
d=1/w;                   %Used to make button location and button size
pairs=(matSize*matSize); %total number of pairs
i=0;                     %Creates place holder for counter for button locations

%-----------------Creates button based off the size of matrix--------------
for cl=1:w 
    for rl=1:matSize
    i=i+1;               %counter used to create unique button locations
    
    if i>=1 && i<=(pairs);
        col= 'cyan';     %color for group 1
        v=1;             %group 1 buttons
    else
        col= [0 1 .5];   %color for group 2 
        v=2;             %group 2 buttons 
    end %if i>=1 && i<=(num/2);
    
%-----------------Button manufacturer--------------------------------------
        S.pb(i) = uicontrol('style','push',... %Type of object
        'unit','normalized',... %Unit of measurement for size and location of button.
        'position',[(d*cl-d) (d*rl-d)*2*y d d*2*y],... %Location of the button
        'fontsize',15,...
        'string','*',... %The default back of the button
        'callback',{@pb_call,cellNum{rl,cl},p},... %@pb_call, access the pb_call function; cellNum transfers the random number associated to the button to the call function, p variable is to send if the game is 1 player or 2 player. 
        'backgroundc',col,... %Sets the default color.
        'busyaction','cancel',...
        'interrupt','off',...
        'UserData',struct('val',v,'butLoc',i)); %Transfers the button 'group' number and the button structure name for later access.
    end %for rl=1:S.c
end %cl=1:w



%-----------------Menu options---------------------------------------------
memMenu = uimenu(S.fh,'Label','Game');
uimenu(memMenu,'Label','1-Player','Callback',@tryagain);
uimenu(memMenu,'Label','2-Player','Callback',@playTwo);
uimenu(memMenu,'Label','High Score','Callback',@score);
uimenu(memMenu,'Label','Exit','Callback',@endgame);

memSize = uimenu(S.fh,'Label','Difficulty');
uimenu(memSize,'Label','Easy','Callback',{@easy,p,name});
uimenu(memSize,'Label','Medium','Callback',{@medium,p,name});
uimenu(memSize,'Label','Hard','Callback',{@hard,p,name});
uimenu(memSize,'Label','Custom','Callback',{@custom,p,name});

memHelp = uimenu(S.fh,'Label','Help');
uimenu(memHelp,'Label','How To Play','Callback',{@help_play});
uimenu(memHelp,'Label','About','Callback',{@about});

%-----------------Push button function-------------------------------------
function [] = pb_call(src,~,x,p) % Callback for pushbutton. src is the variable for the button structure, and x is the button value
data = src.UserData; %stores information that is carried over by the button

if p==1 %checks to see if 1 player game or 2 player game, then checks to see whos turn it is
    turn=0;
elseif p==2
    ck = strcmp(get(S.pt_n1,'Enable'),'on');
    if ck==1
        turn=1;
    else
        turn=2;
    end %ck==1
end %if p==1


if c(1)==1 && data.val==1 %Checks to make sure 2nd button in group does not get pushed

elseif c(2)==1 && data.val==2 %Checks to make sure 2nd button in group does not get pushed
    
elseif c(1)==0 && data.val==1 %Starts check for button in a group
    
    if c(2)==0 %For button if opposite group has no button pressed
        set(src,'str',x,'backg',[.9 .5 .5]) %Changes the button vaule and color
        c(1) = c(1)+1; %Adds to the counter for group 1
        a=data.butLoc; %Saves the button location for later use
        b=x; %Saves value of button for later use
        
    elseif c(2)==1 %Starts check for two buttons pressed, 1 in each group
        set(src,'str',x,'backg',[.9 .5 .5]) %Changes the button vaule and color
        pause (1) %Wait this many seconds
        counter = counter + 1;
        
        if x==b %Checks if both button number is equal
            if turn==1 %adds a point to whoever's turn it is if its 2 player game and changes the color
                set(S.pt_s1,'string',str2double((get(S.pt_s1,'string')))+1)
                set(src,'backg',get(S.pt_n1,'ForegroundColor'))
                set(S.pb(a),'backg',get(S.pt_n1,'ForegroundColor'))
            elseif turn==2
                set(S.pt_s2,'string',str2double((get(S.pt_s2,'string')))+1)
                set(src,'backg',get(S.pt_n2,'ForegroundColor'))
                set(S.pb(a),'backg',get(S.pt_n2,'ForegroundColor'))
            end
            
            
            set(src,'Enable','off') %Turns off button for the match
            set(S.pb(a),'Enable','off') %Turns off button for the match
            c(2) = c(2)-1; %Subtracts the counter for group 2
            endcounter = endcounter  +1;
            
            
            

            if endcounter == pairs %End game message, transfering if its a 1 player game or 2 player game
                endMemGUI(p)
            end
            
        else
            set(src,'str','*','backg','cyan') %Resets button because of incomplete match
            set(S.pb(a),'str','*','backg',[0 1 .5]) %Resets button because of incomplete match
            c(2) = c(2)-1; %Subtracts the counter for group 2
            
            if turn==1 %Due to wrong match, turn switches
                set(S.pt_s1,'Enable','off')
                set(S.pt_n1,'Enable','off')
                set(S.pt_s2,'Enable','on')
                set(S.pt_n2,'Enable','on')
            elseif turn==2
                set(S.pt_s2,'Enable','off')
                set(S.pt_n2,'Enable','off')
                set(S.pt_s1,'Enable','on')
                set(S.pt_n1,'Enable','on')
            end
            
            
        end %if x==b
    end %if c(2)==0
    
%-----------------Mirror code from up above is down below to account for button being pressed in opposite order-----------------    
elseif c(2)==0 && data.val==2
    
    if c(1)==0
        set(src,'str',x,'backg',[.9 .5 .5])
        c(2) = c(2)+1;
        a=data.butLoc;
        b=x;
        
    elseif c(1)==1
        set(src,'str',x,'backg',[.9 .5 .5])
        pause (1)
        counter = counter + 1;
        
        if x==b
            if turn==1 %adds a point to whoever's turn it is if its 2 player game and changes the color
                set(S.pt_s1,'string',str2double((get(S.pt_s1,'string')))+1)
                set(src,'backg',get(S.pt_n1,'ForegroundColor'))
                set(S.pb(a),'backg',get(S.pt_n1,'ForegroundColor'))
            elseif turn==2
                set(S.pt_s2,'string',str2double((get(S.pt_s2,'string')))+1)
                set(src,'backg',get(S.pt_n2,'ForegroundColor'))
                set(S.pb(a),'backg',get(S.pt_n2,'ForegroundColor'))
            end
            
            set(src,'Enable','off')
            set(S.pb(a),'Enable','off')
            c(1) = c(1)-1;
            endcounter = endcounter  +1;

            if endcounter == pairs
                endMemGUI(p)
            end %if endcounter == pairs
            
        else
            set(src,'str','*','backg',[0 1 .5])
            set(S.pb(a),'str','*','backg','cyan')
            c(1) = c(1)-1;
            
            if turn==1 
                set(S.pt_s1,'Enable','off')
                set(S.pt_n1,'Enable','off')
                set(S.pt_s2,'Enable','on')
                set(S.pt_n2,'Enable','on')
            elseif turn==2
                set(S.pt_s2,'Enable','off')
                set(S.pt_n2,'Enable','off')
                set(S.pt_s1,'Enable','on')
                set(S.pt_n1,'Enable','on')
            end

        end %end for if x==b
    end %end for c(1)==0
end %c(1)==1 && data.val==1
end %function [] = pb_call(src,~,x)

%-----------------GUI that opens when game is finished---------------------
function []=endMemGUI(p) 

accuracy=((matSize^2/counter)*100);

if p==1  %Message for 1 player games and different message for 2 player games
    aCell={'You have completed the puzzle in', counter , 'tries and',...
        toc 'seconds','Your accuracy was', accuracy, 'percent'};
elseif p==2
    aCell={['Player ' get(S.pt_n1,'string') ' Scored:'],get(S.pt_s1,'string'),...
        ['Player ' get(S.pt_n2,'string') ' Scored:'], get(S.pt_s2,'string'),...
        toc 'seconds','Your accuracy was', accuracy, 'percent'};
end
    


    


S.fhe = figure('units','normalized',...
              'position',[.3 .3 .3 .4],...
              'menubar','none',...
              'name','Game Over',...
              'numbertitle','off',...
              'resize','off');

S.pb = uicontrol('style','text','unit','normalized','fontsize',14,'position',[0 .25 1 .75 ],'string',aCell,'backgroundc',[0.94 .94 .94]); %

S.pb = uicontrol('style','push','unit','normalized','fontsize',14,'position',[0 0 .5 .25],'string','Play Again','callback',...
    {@tryagain,p,name},'backgroundc',[0.94 .94 .94],'busyaction','cancel','interrupt','off'); %
          
S.pb = uicontrol('style','push','unit','normalized','fontsize',14,'position',[.5 0 .5 .25],'string','Exit','callback',...
    {@endgame},'backgroundc',[0.94 .94 .94],'busyaction','cancel','interrupt','off'); %
end %function [mat]=endMem()

%-----------------Two Player Options-----------------
function [] = playTwo(~,~)
name1='Ben';
name2='Isaac';
playerCount=2;
n={name1 name2};

close all


Memory(matSize,playerCount,n)

end

%-----------------Try Again-----------------
function [] = tryagain(~,~,p,name) %used to restart game, on same difficulty
    
close all
Memory(matSize,p,name)
end


%-----------------Easy Medium Hard-----------------
function [] = easy(~,~,p,name)
close all
Memory(3,p,name)
end

function [] = medium(~,~,p,name)
close all
Memory(4,p,name)
end

function [] = hard(~,~,p,name)
close all
Memory(6,p,name)
end

%-----------------Creates a custom size of a board-------------------------
function [] = custom(~,~,p,name) 
itext1= 'Please Enter a Number for a Custom Game, 1 is easiest.';
itext2= '*Note that some sizes may require the window to be resized, or may not work for your computer.';
S.fh = figure('units','normalized','position',[.3 .3 .25 .25],'menubar','none','name','Custom Options','numbertitle','off','resize','off');
S.pt1 = uicontrol('style','text','unit','normalized','fontsize',14,'position',[0 .7 1 .3],'string',itext1,'backgroundc',[0.94 .94 .94]);
S.pt2 = uicontrol('style','text','unit','normalized','fontsize',10,'position',[0 .5 1 .2],'string',itext2,'backgroundc',[0.94 .94 .94]);
S.pe = uicontrol('style','edit','unit','normalized','fontsize',14,'position',[.3 .2 .4 .2],'string','','backgroundc',[0.94 .94 .94],'callback',{@cust,p,name});
S.pb = uicontrol('style','push','unit','normalized','fontsize',14,'position',[.3 0 .4 .25],'string','Okay','backgroundc',[0.94 .94 .94],'callback',{@cust,p,name});
 
%-----------------Function to get the value entered, convert and send it---
function [] = cust(~,~,p,name)
a=str2double(get(S.pe,'string'));
close all
Memory(a,p,name)
end %function [] = cust(~,~)
end %function [] = custom(~,~)

function [] = help_play(~,~)
itext1= '1 Player games, simply try to match the left side of the board with the right side board.  2 Player game Bla bla bla';
S.fhelp = figure('units','normalized','position',[.3 .3 .25 .25],'menubar','none','name','How To Play','numbertitle','off','resize','off');
S.pt1 = uicontrol('style','text','unit','normalized','fontsize',15,'position',[0 0 1 1],'string',itext1,'backgroundc',[0.94 .94 .94]);
end

function [] = about(~,~)
itext1= 'This game was created by: Kenny Ben Isaac and Nate';
S.fhelp = figure('units','normalized','position',[.3 .3 .25 .25],'menubar','none','name','How To Play','numbertitle','off','resize','off');
S.pt1 = uicontrol('style','text','unit','normalized','fontsize',15,'position',[0 0 1 1],'string',itext1,'backgroundc',[0.94 .94 .94]); 
end

end %function [] = Memory(~,~)

%-----------------Creates two sets of random matrix------------------------
function [c]=randmat(matr)

    l=matr*matr;
    x=randperm(l);
    mat1=reshape(x, [matr matr]);

    x=randperm(l);
    mat2=reshape(x, [matr matr]);
   
    c = [mat1,mat2];
    c=num2cell(c);
end %function [mat]=randmat(matr)

%-----------------Ends and exits the game----------------------------------
function []=endgame(~,~)
close all
end %function []=endgame(~,~)
