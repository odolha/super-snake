uses mycrt,fastgra2,mouse;
const MaxHighs=10;
      Processor=100;
      ComputerAccelerate=5;

type pointtype= record
                      x:integer;
                      y:integer;
                end;
     HighScore= record
                      name:string;
                      score:integer;
                end;

var m:tmouse;
    P1KeyUp,P1KeyDown,P1KeyLeft,P1KeyRight:char;
    P2KeyUp,P2KeyDown,P2KeyLeft,P2KeyRight:char;

    ValP1KeyUp,ValP1KeyDown,ValP1KeyLeft,ValP1KeyRight:integer;
    ValP2KeyUp,ValP2KeyDown,ValP2KeyLeft,ValP2KeyRight:integer;

    NHighs:integer;
    HS:array[1..MaxHighs] of HighScore;

    i,j:integer;


procedure inp(x,y,c:integer;q:string;var a:string);
var k:char;

begin
     cls;
     WriteF(x,y,q,'def',c,2,0);

     repeat k:=readkey until not(keypressed);
     k:=#0;

     a:='';
     repeat
           k:=readkey;
           case k of
                #13: begin end;
                #8: begin
                         if length(a)>0 then delete(a,length(a),1);
                    end;
                else begin
                     k:=upcase(k);
                     a:=a+k;
                end;
           end;

           bar(x,y,320,y+10,0,0);
           WriteF(x,y,q,'def',c,2,0);
           WriteF(x,y,q+a,'def',c,2,0);
     until k=#13;
end;




procedure LoadSetup;
var f:text;

begin
     Assign(f,'setup.dat');

     Reset(f);
              readln(f,ValP1KeyUp);
              readln(f,ValP1KeyDown);
              readln(f,ValP1KeyLeft);
              readln(f,ValP1KeyRight);
              readln(f,ValP2KeyUp);
              readln(f,ValP2KeyDown);
              readln(f,ValP2KeyLeft);
              readln(f,ValP2KeyRight);

              P1KeyUp:=chr(ValP1KeyUp);
              P1KeyDown:=chr(ValP1KeyDown);
              P1KeyLeft:=chr(ValP1KeyLeft);
              P1KeyRight:=chr(ValP1KeyRight);
              P2KeyUp:=chr(ValP2KeyUp);
              P2KeyDown:=chr(ValP2KeyDown);
              P2KeyLeft:=chr(ValP2KeyLeft);
              P2KeyRight:=chr(ValP2KeyRight);

     Close(f);
end;




procedure LoadHighScores;
var f:text;
    n,i:integer;
    sc:integer;
    na:string;

begin
     assign (f,'High.dat');

     reset(f);
              readln(f,n);
              NHighs:=n;
              for i:=1 to MaxHighs do begin
                  if i<=n then begin
                     readln(f,na);
                     readln(f,sc);
                  end
                  else begin
                       na:='';
                       sc:=0;
                  end;

                  HS[i].name:=na;
                  HS[i].score:=sc;
              end;
     close(f);
end;







procedure ShowHighScores;
var s: string;
    i: integer;
    k: char;

begin
     cls;

     s:='HIGH SCORES';
     WriteF(160-(length(s)*8) div 2,10,s,'def',13,3,0);

     for i:=1 to MaxHighs do begin
         str(i,s);
         if i<10 then s:=' '+s;
         s:=s+'. '+HS[i].name;
         WriteF(10,20+i*10,s,'def',15,2,0);

         str(HS[i].score,s);
         WriteF(310-length(s)*7,20+i*10,s,'def',15,2,0);
     end;

     if keypressed then repeat k:=readkey until not(keypressed);


     repeat until keypressed;
end;





procedure SaveHighScores;
var f:text;
    n,i:integer;
    sc:integer;
    na:string;

begin
     assign (f,'High.dat');

     rewrite(f);
              n:=MaxHighs;
              writeln(f,n);
              for i:=1 to MaxHighs do begin
                  writeln(f,HS[i].name);
                  writeln(f,HS[i].score);
              end;
     close(f);
end;




procedure SortHighScore;
var i,j:integer;
    aux:HighScore;
    maxV,maxI:integer;

begin
     for i:= 1 to NHighs do begin
         maxV:=0;
         maxI:=0;

         for j:=i to NHighs do begin
             if HS[j].score>=maxV then begin maxV:=HS[j].score; maxI:=j; end;
         end;

         aux:=HS[maxI];
         HS[maxI]:=HS[i];
         HS[i]:=aux;
     end;
end;












procedure NewGame(Players,P1Type,P2Type,P1Color,P2Color:byte;Demo:boolean;Difficulty:integer);
var Level,Score1,Lives1,Score2,Lives2:integer;
    MaxLevels:integer;
    LevelWF1,LevelWF2:integer;
    PComputer1,PComputer2:boolean;
    NoHuman:boolean;

procedure GameInits;
begin
     MaxLevels:=20;
     Level:=1;

     Score1:=0;
     Lives1:=4;
     LevelWF1:=0;

     Score2:=0;
     Lives2:=4;
     LevelWF2:=0;

     if P1Type=2 then PComputer1:=true else PComputer1:=false;
     if P2Type=2 then PComputer2:=true else PComputer2:=false;

     NoHuman:=false;
end;





procedure NewLevel;
const MatrixX=70;
      MatrixY=40;
      PointWidth=5;
      PointHeight=5;
      MaxSnakePoints=500;

      MaxSegments=5;

      WaitToClearTime=8;

type Matrix=array[1..MatrixX,1..MatrixY] of byte;

var s:string;

    BX:integer;
    BY:integer;

    ExitCode:integer;
    PointsNeeded:integer;
    LivesBonus:integer;
    PointsBonus:integer;
    Pause:integer;
    Points:integer;
    InitialLength:integer;

    MnX:integer;
    MnY:integer;
    M:Matrix;
    S1Length:integer;
    S1Left:integer;
    S1OldLength:integer;
    OldDir1:integer;
    S1Dir:integer;
    S1:array[1..MaxSnakePoints] of pointtype;
    S2Length:integer;
    S2Left:integer;
    S2OldLength:integer;
    OldDir2:integer;
    S2Dir:integer;
    S2:array[1..MaxSnakePoints] of pointtype;

    P:pointtype;
    LifePoint:boolean;

    Start,Finish:pointtype;
    PathN1,PathN2:integer;
    PathFound1:array[1..MaxSegments] of pointtype;
    DirFound1:array[1..MaxSegments] of byte;
    PathFound2:array[1..MaxSegments] of pointtype;
    DirFound2:array[1..MaxSegments] of byte;
    MM:Matrix;
    Walked1,Walked2:integer;

    Time1,Time2:integer;
    Wait1,Wait2:real;

    CanMove1,CanMove2:boolean;




procedure IntroLevel;
var s:string;

begin
     cls;
     str(Level,s);
     s:='LEVEL '+s;
     writeF(140,90,s,'def',random(250)+1,2,0);

     delay(100);
end;



procedure LoadLevel(LevelPath:string);
var f:text;
    i,j:integer;

begin
     Assign(f,LevelPath);

     Reset(f);
              readln(f,PointsNeeded);
              readln(f,LivesBonus);
              readln(f,PointsBonus);
              readln(f,Pause);
              readln(f,InitialLength);

              readln(f,MnX);
              readln(f,MnY);

              for j:=1 to MnY do begin
                  for i:=1 to MnX do begin
                      read(f,M[i,j]);
                  end;
                  readln(f);
              end;
     Close(f);
end;



function Collision(x,y:integer;special:integer):boolean;
var IsSnake:boolean;
    i:integer;

begin
     Collision:=false;

     if x<1 then x:=MnX;
     if x>MnX then x:=1;
     if y<1 then y:=MnY;
     if y>MnY then y:=1;

     case special of
          0: begin
                  IsSnake:=false;
                  for i:=1 to S1Length do begin
                      if ((S1[i].x=x) and (S1[i].y=y)) then IsSnake:=true;
                  end;
                  for i:=1 to S2Length do begin
                      if ((S2[i].x=x) and (S2[i].y=y)) then IsSnake:=true;
                  end;

                  if (M[x,y]=1) or IsSnake then Collision:=true
             end;
          1: begin
                  IsSnake:=false;
                  for i:=2 to S1Length do begin
                      if ((S1[i].x=x) and (S1[i].y=y)) then IsSnake:=true;
                  end;
                  for i:=1 to S2Length do begin
                      if ((S2[i].x=x) and (S2[i].y=y)) then IsSnake:=true;
                  end;

                  if (M[x,y]=1) or IsSnake then Collision:=true
             end;
          2: begin
                  IsSnake:=false;
                  for i:=1 to S1Length do begin
                      if ((S1[i].x=x) and (S1[i].y=y)) then IsSnake:=true;
                  end;
                  for i:=2 to S2Length do begin
                      if ((S2[i].x=x) and (S2[i].y=y)) then IsSnake:=true;
                  end;

                  if (M[x,y]=1) or IsSnake then Collision:=true
             end;

     end;
end;



{-----------------}


procedure FindPath(pl:integer;d1,d2,d3,d4:boolean);
var FoundIt:boolean;
    TSeg:integer;
    Segments:integer;
    Path:array[1..100] of pointtype;
    Dir:array[1..100] of byte;
    n,a:byte;
    r:array[1..4] of boolean;

procedure WritePath;
var i:integer;

begin
     if pl=1 then begin
        PathN1:=TSeg;
        Time1:=0;
        Wait1:=0;
     end
     else begin
        PathN2:=TSeg;
        Time2:=0;
        Wait2:=0;
     end;

     for i:=1 to TSeg do begin
         if pl=1 then begin
            PathFound1[i]:=Path[i];
            DirFound1[i]:=Dir[i];
         end
         else begin
            PathFound2[i]:=Path[i];
            DirFound2[i]:=Dir[i]
         end;
     end;

     if pl=1 then begin
        PathN1:=PathN1+1;
        PathFound1[PathN1]:=Finish;
        DirFound1[PathN1]:=5;
     end
     else begin
        PathN2:=PathN2+1;
        PathFound2[PathN2]:=Finish;
        DirFound2[PathN2]:=5;
     end;
end;




procedure Try(x,y:integer;d1,d2,d3,d4:boolean);
label 1,2,3,4,5,6;
var i,j:integer;
    wb:boolean;

begin
     if FoundIt then Exit;

     TSeg:=TSeg+1;
     Path[TSeg].x:=x;
     Path[TSeg].y:=y;

     n:=0;
     for i:=1 to 4 do r[i]:=false;

6:
  n:=n+1;
  if n>4 then goto 5;
  repeat
     a:=random(4)+1;
  until r[a]=false;
  r[a]:=true;
  case a of
       1: goto 1;
       2: goto 2;
       3: goto 3;
       4: goto 4;
  end;



1:
     if d1 then begin
        Dir[TSeg]:=1;
        wb:=false;
        i:=x;
        for j:=y-1 downto 1 do begin
            if MM[i,j]=1 then begin wb:=true; break; end;

            if (i=Finish.x) and (j=Finish.y) then begin
               FoundIt:=true;
               WritePath;
            end
            else begin
                 if TSeg<Segments then begin
                    Try(i,j,false,true,false,true);
                 end;
            end;
        end;
        if (MM[x,1]=2) and not(wb) then begin
           i:=x;
           for j:=MnY downto y+1 do begin
               if MM[i,j]=1 then break;

               if (i=Finish.x) and (j=Finish.y) then begin
                  FoundIt:=true;
                  WritePath;
               end
               else begin
                    if TSeg<Segments then begin
                       Try(i,j,false,true,false,true);
                    end;
               end;
           end;
        end;
     end;

     goto 6;



2:
     if d2 then begin
        Dir[TSeg]:=2;
        wb:=false;
        j:=y;
        for i:=x+1 to MnX do begin
            if MM[i,j]=1 then begin wb:=true; break; end;

            if (i=Finish.x) and (j=Finish.y) then begin
               FoundIt:=true;
               WritePath;
            end
            else begin
                 if TSeg<Segments then begin
                    Try(i,j,true,false,true,false);
                 end;
            end;
        end;
        if (MM[MnX,y]=2) and not(wb) then begin
           j:=y;
           for i:=1 to x-1 do begin
               if MM[i,j]=1 then break;

               if (i=Finish.x) and (j=Finish.y) then begin
                  FoundIt:=true;
                  WritePath;
               end
               else begin
                    if TSeg<Segments then begin
                       Try(i,j,true,false,true,false);
                    end;
               end;
           end;
        end;
     end;

     goto 6;



3:
     if d3 then begin
        Dir[TSeg]:=3;
        wb:=false;
        i:=x;
        for j:=y+1 to MnY do begin
            if MM[i,j]=1 then begin wb:=true; break; end;

            if (i=Finish.x) and (j=Finish.y) then begin
               FoundIt:=true;
               WritePath;
            end
            else begin
                 if TSeg<Segments then begin
                    Try(i,j,false,true,false,true);
                 end;
            end;
        end;
        if (MM[x,MnY]=2) and not(wb) then begin
           i:=x;
           for j:=1 to y-1 do begin
               if MM[i,j]=1 then break;

               if (i=Finish.x) and (j=Finish.y) then begin
                  FoundIt:=true;
                  WritePath;
               end
               else begin
                    if TSeg<Segments then begin
                       Try(i,j,false,true,false,true);
                    end;
               end;
           end;
        end;
     end;

     goto 6;



4:
     if d4 then begin
        Dir[TSeg]:=4;
        wb:=false;
        j:=y;
        for i:=x-1 downto 1 do begin
            if MM[i,j]=1 then begin wb:=true; break; end;

            if (i=Finish.x) and (j=Finish.y) then begin
               FoundIt:=true;
               WritePath;
            end
            else begin
                 if TSeg<Segments then begin
                    Try(i,j,true,false,true,false);
                 end;
            end;
        end;
        if (MM[1,y]=2) and not(wb) then begin
           j:=y;
           for i:=MnX downto x+1 do begin
               if MM[i,j]=1 then break;

               if (i=Finish.x) and (j=Finish.y) then begin
                  FoundIt:=true;
                  WritePath;
               end
               else begin
                    if TSeg<Segments then begin
                       Try(i,j,true,false,true,false);
                    end;
               end;
           end;
        end;
     end;

     goto 6;


5:

     TSeg:=TSeg-1;
end;


procedure WriteMM;
var i,j:integer;

begin
     MM:=M;
     if pl=1 then begin
        if P1Type<>0 then for i:=2 to S1Length do MM[S1[i].x,S1[i].y]:=1;
        if P2Type<>0 then for i:=1 to S2Length do MM[S2[i].x,S2[i].y]:=1;
     end
     else begin
        if P1Type<>0 then for i:=1 to S1Length do MM[S1[i].x,S1[i].y]:=1;
        if P2Type<>0 then for i:=2 to S2Length do MM[S2[i].x,S2[i].y]:=1;
     end;
end;



begin
     Segments:=0;
     FoundIt:=false;

     PathN1:=-1;
     PathN2:=-1;

     if pl=1 then begin
        Start:=S1[1];
     end
     else begin
        Start:=S2[1];
     end;

     Finish:=P;

     WriteMM;

     Wait1:=WaitToClearTime;
     Wait2:=WaitToClearTime;

     repeat
           TSeg:=0;
           Try(Start.x,Start.y,d1,d2,d3,d4);

           Segments:=Segments+1;
     until (FoundIt) or (Segments>MaxSegments);

     if pl=1 then Walked1:=0 else Walked2:=0;
end;


{-----------------}


procedure ComputerMove(p:integer);
begin
     if p=1 then begin
        if (Walked1<PathN1) and (S1[1].x=PathFound1[Walked1+1].x) and (S1[1].y=PathFound1[Walked1+1].y)
        then Walked1:=Walked1+1;
     end
     else begin
        if (Walked2<PathN2) and (S2[1].x=PathFound2[Walked2+1].x) and (S2[1].y=PathFound2[Walked2+1].y)
        then Walked2:=Walked2+1;
     end;

     if p=1 then if (PathN1>0) and (DirFound1[Walked1]<>5) then S1Dir:=DirFound1[Walked1];
     if p=2 then if (PathN2>0) and (DirFound2[Walked2]<>5) then S2Dir:=DirFound2[Walked2];
end;




procedure ComputerFindPath(p:integer);
var d1,d2,d3,d4:boolean;

begin
     if p=1 then begin
        d1:=true; d2:=true; d3:=true; d4:=true;
        if S1Dir=1 then d3:=false;
        if S1Dir=2 then d4:=false;
        if S1Dir=3 then d1:=false;
        if S1Dir=4 then d2:=false;

        FindPath(1,d1,d2,d3,d4);
        ComputerMove(1);
     end
     else begin
        d1:=true; d2:=true; d3:=true; d4:=true;
        if S2Dir=1 then d3:=false;
        if S2Dir=2 then d4:=false;
        if S2Dir=3 then d1:=false;
        if S2Dir=4 then d2:=false;

        FindPath(2,d1,d2,d3,d4);
        ComputerMove(2);
     end;
end;



procedure CheckPath(p:integer);
var Closed:boolean;
    i,j:integer;

begin
     if (random(20*Difficulty)<>0) then begin
        if p=1 then if (Walked1<PathN1) then begin
           Closed:=false;
           case DirFound1[Walked1] of
                1: for j:=S1[1].y downto PathFound1[Walked1+1].y do
                       if Collision(S1[1].x,j,1) then begin Closed:=true; break; end;

                2: for i:=S1[1].x to PathFound1[Walked1+1].x do
                       if Collision(i,S1[1].y,1) then begin Closed:=true; break; end;

                3: for j:=S1[1].y to PathFound1[Walked1+1].y do
                       if Collision(S1[1].x,j,1) then begin Closed:=true; break; end;

                4: for i:=S1[1].x downto PathFound1[Walked1+1].x do
                       if Collision(i,S1[1].y,1) then begin Closed:=true; break; end;
           end;
           if Closed then ComputerFindPath(1);
        end;
        if p=2 then if (Walked2<PathN2) then begin
           Closed:=false;
           case DirFound2[Walked2] of
                1: for j:=S2[1].y downto PathFound2[Walked2+1].y do
                       if Collision(S2[1].x,j,2) then begin Closed:=true; break; end;

                2: for i:=S2[1].x to PathFound2[Walked2+1].x do
                       if Collision(i,S2[1].y,2) then begin Closed:=true; break; end;

                3: for j:=S2[1].y to PathFound2[Walked2+1].y do
                       if Collision(S2[1].x,j,2) then begin Closed:=true; break; end;

                4: for i:=S2[1].x downto PathFound2[Walked2+1].x do
                       if Collision(i,S2[1].y,2) then begin Closed:=true; break; end;
           end;
           if Closed then ComputerFindPath(2);
        end;
     end;

     if random((Difficulty*5-4))=0 then ComputerFindPath(p);
end;





procedure ComputerRandomDir(pl:integer);
var d,i:integer;
    Closed:boolean;

begin
     if pl=1 then begin
        i:=0;
        repeat
              d:=random(4)+1;
              Closed:=false;
              case d of
                   1: if Collision(S1[1].x,S1[1].y-1,1) then Closed:=true;
                   2: if Collision(S1[1].x+1,S1[1].y,1) then Closed:=true;
                   3: if Collision(S1[1].x,S1[1].y+1,1) then Closed:=true;
                   4: if Collision(S1[1].x-1,S1[1].y,1) then Closed:=true;
              end;
              i:=i+1;
        until ((d mod 2<>S1Dir mod 2) and not(Closed)) or (i>15);
        if i<=15 then S1Dir:=d;
     end
     else begin
        i:=0;
        repeat
              d:=random(4)+1;
              Closed:=false;
              case d of
                   1: if Collision(S2[1].x,S2[1].y-1,2) then Closed:=true;
                   2: if Collision(S2[1].x+1,S2[1].y,2) then Closed:=true;
                   3: if Collision(S2[1].x,S2[1].y+1,2) then Closed:=true;
                   4: if Collision(S2[1].x-1,S2[1].y,2) then Closed:=true;
              end;
              i:=i+1;
        until ((d mod 2<>S2Dir mod 2) and not(Closed)) or (i>15);
        if i<=15 then S2Dir:=d;
     end;
end;






procedure AnalogMove(p:integer);
var Closed:boolean;

begin
     if (random(20*Difficulty)<>0) then begin
        if p=1 then begin
           Closed:=false;
           case S1Dir of
                1: if Collision(S1[1].x,S1[1].y-1,1) then Closed:=true;
                2: if Collision(S1[1].x+1,S1[1].y,1) then Closed:=true;
                3: if Collision(S1[1].x,S1[1].y+1,1) then Closed:=true;
                4: if Collision(S1[1].x-1,S1[1].y,1) then Closed:=true;
           end;
           if Closed then ComputerRandomDir(1);
        end;
        if p=2 then begin
           Closed:=false;
           case S2Dir of
                1: if Collision(S2[1].x,S2[1].y-1,2) then Closed:=true;
                2: if Collision(S2[1].x+1,S2[1].y,2) then Closed:=true;
                3: if Collision(S2[1].x,S2[1].y+1,2) then Closed:=true;
                4: if Collision(S2[1].x-1,S2[1].y,2) then Closed:=true;
           end;
           if Closed then ComputerRandomDir(2);
        end;
     end;

     if ((p=1) and (Time1<Wait1)) or ((p=2) and (Time2<Wait2)) then if random((Difficulty*5))=0 then ComputerRandomDir(p);
end;







procedure NewPoint;
begin
     Repeat
           P.x:=random(MnX)+1;
           P.y:=random(MnY)+1;
     Until not(Collision(P.x,P.y,0));

     if random(35)=0 then LifePoint:=true else LifePoint:=false;

     if (P1Type=2) and CanMove1 then ComputerFindPath(1);
     if (P2Type=2) and CanMove2 then ComputerFindPath(2);
end;




procedure BorderInits;
begin
     BX:=(320-(PointWidth*MnX)) div 2;
     BY:=(190-(PointHeight*MnY)) div 2;
end;


procedure ClearValues;
var i:integer;

begin
     S1Length:=0;
     S2Length:=0;
     for i:=1 to MaxSnakePoints do begin
         S1[i].x:=-1;
         S1[i].y:=-1;

         S2[i].x:=-1;
         S2[i].y:=-1;
     end;
end;


procedure InitPlayer(p:integer;total:boolean);
begin
     if p=1 then begin
        if P1Type<>0 then begin
           S1Length:=1;
           if total then S1Left:=InitialLength else S1Left:=S1OldLength;
           if S1Left>=MaxSnakePoints-1 then S1Left:=MaxSnakePoints-1;
           S1Dir:=-1;
           Repeat
                 S1[1].x:=random(MnX)+1;
                 S1[1].y:=random(MnY)+1;
           Until not(Collision(S1[1].x,S1[1].y,1));
        end;
     end
     else begin
        if P2Type<>0 then begin
           S2Length:=1;
           if total then S2Left:=InitialLength else S2Left:=S2OldLength;
           if S2Left>=MaxSnakePoints-1 then S2Left:=MaxSnakePoints-1;
           S2Dir:=-1;
           Repeat
                 S2[1].x:=random(MnX)+1;
                 S2[1].y:=random(MnY)+1;
           Until not(Collision(S2[1].x,S2[1].y,2));
        end;
     end;
end;



procedure LevelInits;
begin
     ClearValues;

     InitialLength:=(InitialLength*Difficulty) div 3;
     PointsNeeded:=(PointsNeeded*Difficulty) div 3;
     Pause:=(Pause*3) div Difficulty;

     InitPlayer(1,true);

     InitPlayer(2,true);

     CanMove1:=true;
     CanMove2:=true;
     if P2Type=1 then CanMove1:=False;
     if P1Type=1 then CanMove2:=False;

     NewPoint;

     BorderInits;
end;



procedure FinalVer(p:integer);
begin
     if P1Type<>0 then LevelWF1:=Level;
     if P2Type<>0 then LevelWF2:=Level;

     if (p=1) or (p=0) then if Lives1<0 then begin
        P1Type:=0;
        if P2Type=2 then NoHuman:=true;
     end;
     if (p=2) or (p=0) then if Lives2<0 then begin
        P2Type:=0;
        if P1Type=2 then NoHuman:=true;
     end;

     if (P1Type=0) and (P2Type=0) then ExitCode:=5;
end;





procedure Runtime;
var Key:char;


procedure DrawDemo;
begin
     writeF(random(1)+130,random(1)+90,'SUPER SNAKE','def',56,1,0);
     writeF(random(1)+131,random(1)+91,'SUPER SNAKE','def',48,1,0);

     writeF(220,180,'BY OVIDIU DOLHA','def',random(255)+1,1,0);
end;

procedure DrawMatrixXY(i,j:integer);
begin
     if M[i,j]=0 then bar(BX+(i-1)*PointWidth,BY+(j-1)*PointHeight,
     BX+(i-1)*PointWidth+PointWidth-1,BY+(j-1)*PointHeight+PointHeight-1,0,0);
     if M[i,j]=1 then bar(BX+(i-1)*PointWidth,BY+(j-1)*PointHeight,
     BX+(i-1)*PointWidth+PointWidth-1,BY+(j-1)*PointHeight+PointHeight-1,6,6);
     if M[i,j]=2 then bar(BX+(i-1)*PointWidth,BY+(j-1)*PointHeight,
     BX+(i-1)*PointWidth+PointWidth-1,BY+(j-1)*PointHeight+PointHeight-1,0,0);
end;




procedure DrawMatrix;
var i,j:integer;

begin
     rectangle(BX-1,BY-1,BX+MnX*PointWidth,BY+MnY*PointHeight,17);

     for j:=1 to MnY do begin
         for i:=1 to MnX do begin
             DrawMatrixXY(i,j);
         end;
     end;
end;



procedure DrawPoint;
begin
     if LifePoint=true then begin
        if PointsNeeded>1 then draw('LifeP.pmp',BX+(P.X-1)*PointWidth,BY+(P.Y-1)*PointHeight)
        else draw('LifePF.pmp',BX+(P.X-1)*PointWidth,BY+(P.Y-1)*PointHeight);
     end
     else begin
        if PointsNeeded>1 then draw('Point.pmp',BX+(P.X-1)*PointWidth,BY+(P.Y-1)*PointHeight)
        else draw('PointF.pmp',BX+(P.X-1)*PointWidth,BY+(P.Y-1)*PointHeight);
     end;
end;



procedure DrawSnakes(D:integer;P:integer);
var i:integer;

begin
     case D of
          3: begin
                  if P1Type<>0 then
                  for i:=1 to S1Length do begin
                      bar(BX+(S1[i].x-1)*PointWidth,BY+(S1[i].y-1)*PointHeight,
                      BX+(S1[i].x-1)*PointWidth+PointWidth-1,BY+(S1[i].y-1)*PointHeight+PointHeight-1,0,0);
                  end;
                  if P2Type<>0 then
                  for i:=1 to S2Length do begin
                      bar(BX+(S2[i].x-1)*PointWidth,BY+(S2[i].y-1)*PointHeight,
                      BX+(S2[i].x-1)*PointWidth+PointWidth-1,BY+(S2[i].y-1)*PointHeight+PointHeight-1,0,0);
                  end;
             end;
          2: begin
                  if P1Type<>0 then
                  for i:=1 to S1Length do begin
                      bar(BX+(S1[i].x-1)*PointWidth,BY+(S1[i].y-1)*PointHeight,
                      BX+(S1[i].x-1)*PointWidth+PointWidth-1,BY+(S1[i].y-1)*PointHeight+PointHeight-1,P1Color,P1Color);
                  end;
                  if P2Type<>0 then
                  for i:=1 to S2Length do begin
                      bar(BX+(S2[i].x-1)*PointWidth,BY+(S2[i].y-1)*PointHeight,
                      BX+(S2[i].x-1)*PointWidth+PointWidth-1,BY+(S2[i].y-1)*PointHeight+PointHeight-1,P2Color,P2Color);
                  end;
             end;
          1: begin
                  if (P1Type<>0) and (S1Left>=0) then
                  bar(BX+(S1[1].x-1)*PointWidth,BY+(S1[1].y-1)*PointHeight,
                  BX+(S1[1].x-1)*PointWidth+PointWidth-1,BY+(S1[1].y-1)*PointHeight+PointHeight-1,P1Color,P1Color);

                  if (P2Type<>0) and (S2Left>=0) then
                  bar(BX+(S2[1].x-1)*PointWidth,BY+(S2[1].y-1)*PointHeight,
                  BX+(S2[1].x-1)*PointWidth+PointWidth-1,BY+(S2[1].y-1)*PointHeight+PointHeight-1,P2Color,P2Color);
             end;
          0: begin
                  if P1Type<>0 then if S1Left<=0 then if (P=1) or (P=0) then
                  bar(BX+(S1[S1Length].x-1)*PointWidth,BY+(S1[S1Length].y-1)*PointHeight,
                  BX+(S1[S1Length].x-1)*PointWidth+PointWidth-1,BY+(S1[S1Length].y-1)*PointHeight-1+PointHeight,0,0);

                  if P2Type<>0 then if S2Left<=0 then if (P=2) or (P=0) then
                  bar(BX+(S2[S2Length].x-1)*PointWidth,BY+(S2[S2Length].y-1)*PointHeight,
                  BX+(S2[S2Length].x-1)*PointWidth+PointWidth-1,BY+(S2[S2Length].y-1)*PointHeight-1+PointHeight,0,0);
             end;
     end;
end;



procedure DrawStats(D:boolean);
var s:string;
    i:integer;

begin
     if not(D) then bar(0,190,320,200,0,0)
     else begin
          if (P1Type=1) and (P2Type=1) then begin
               if P1Type<>0 then begin
                  str(Score1,s);
                  writeF(318-length(s)*7,191,s,'def',P1Color,2,0);
                  for i:=1 to Lives1 do Draw('Life.pmp',318-length(s)*7-11-(i-1)*8,191);
               end;

               if P2Type<>0 then begin
                  str(Score2,s);
                  writeF(2,191,s,'def',P2Color,2,0);
                  for i:=1 to Lives2 do Draw('Life.pmp',length(s)*7+4+(i-1)*8,191);
               end;
          end
          else begin
               if P1Type<>0 then begin
                  str(Score1,s);
                  writeF(2,191,s,'def',P1Color,2,0);
                  for i:=1 to Lives1 do Draw('Life.pmp',length(s)*7+4+(i-1)*8,191);
               end;

               if P2Type<>0 then begin
                  str(Score2,s);
                  writeF(318-length(s)*7,191,s,'def',P2Color,2,0);
                  for i:=1 to Lives2 do Draw('Life.pmp',318-length(s)*7-11-(i-1)*8,191);
               end;
          end;
     end;
end;





procedure MoveSnakeXY(SnakeNo,MX,MY:integer);
var i:integer;

begin
     if SnakeNo=1 then begin
        if S1Left>0 then begin
           S1Length:=S1Length+1;
           S1Left:=S1Left-1;
        end;
        for i:=S1Length downto 2 do begin
            S1[i].x:=S1[i-1].x;
            S1[i].y:=S1[i-1].y;
        end;
        S1[1].x:=S1[1].x+MX;
        S1[1].y:=S1[1].y+MY;

        if S1[1].x<1 then S1[1].x:=MnX;
        if S1[1].x>MnX then S1[1].x:=1;
        if S1[1].y<1 then S1[1].y:=MnY;
        if S1[1].y>MnY then S1[1].y:=1;
     end
     else begin
        if S2Left>0 then begin
           S2Length:=S2Length+1;
           S2Left:=S2Left-1;
        end;
        for i:=S2Length downto 2 do begin
            S2[i].x:=S2[i-1].x;
            S2[i].y:=S2[i-1].y;
        end;
        S2[1].x:=S2[1].x+MX;
        S2[1].y:=S2[1].y+MY;

        if S2[1].x<1 then S2[1].x:=MnX;
        if S2[1].x>MnX then S2[1].x:=1;
        if S2[1].y<1 then S2[1].y:=MnY;
        if S2[1].y>MnY then S2[1].y:=1;
     end;
end;






procedure ChangeDir(SnakeNo,NewDir:integer);
begin
     if SnakeNo=1 then begin
        if S1Dir>0 then begin
           if (S1Dir>=0) and (abs(S1Dir-NewDir)<>2) and (abs(OldDir1-NewDir)<>2) then S1Dir:=NewDir;
        end else S1Dir:=NewDir;
        if P1Type=1 then begin
           if P2Type=2 then if CanMove2=false then ComputerFindPath(2);
           CanMove2:=true;
        end;
     end
     else begin
        if S2Dir>0 then begin
           if (S2Dir>=0) and (abs(S2Dir-NewDir)<>2) and (abs(OldDir2-NewDir)<>2) then S2Dir:=NewDir;
        end else S2Dir:=NewDir;
        if P2Type=1 then begin
           if P1Type=2 then if CanMove1=false then ComputerFindPath(1);
           CanMove1:=true;
        end;
     end;
end;




procedure CheckKeys;
begin
     Key:=readkey;
     If Key=#27 then ExitCode:=12;

     if P1Type=1 then begin
        If Key=P1KeyUp then ChangeDir(1,1);
        If Key=P1KeyDown then ChangeDir(1,3);
        If Key=P1KeyLeft then ChangeDir(1,4);
        If Key=P1KeyRight then ChangeDir(1,2);
     end;

     if P2Type=1 then begin
        If Key=P2KeyUp then ChangeDir(2,1);
        If Key=P2KeyDown then ChangeDir(2,3);
        If Key=P2KeyLeft then ChangeDir(2,4);
        If Key=P2KeyRight then ChangeDir(2,2);
     end;

     if Demo then ExitCode:=11;
end;





procedure CollisionVerify(Pl:integer);
var ran:integer;

begin
     if (P1Type<>0) and (Pl=1) then begin
        if Collision(S1[1].x,S1[1].y,1) then begin
           if P2Type=0 then ExitCode:=1
                       else if S1Left>=0 then begin
                                 S1OldLength:=S1Length+S1Left;
                                 S1Left:=-1;
                                 Lives1:=Lives1-1;
                                 DrawStats(false);
                                 DrawStats(true);
                       end;
        end;

        if (P.x=S1[1].x) and (P.y=S1[1].y) then begin
           ran:=random((Level div 3+Difficulty)*random(3)+1)+2;

           if S1Left<MaxSnakePoints then S1Left:=S1Left+ran;
           PointsNeeded:=PointsNeeded-1;
           if PointsNeeded<=0 then begin
              ExitCode:=4;
              Score1:=Score1+PointsBonus;
              Lives1:=Lives1+LivesBonus;
           end;

           if not(LifePoint) then Score1:=Score1+(ran div 4)*random(20)+5
                             else Lives1:=Lives1+1;
           DrawStats(false);
           DrawStats(true);

           NewPoint;
           DrawPoint;
        end;
     end;

     if (P2Type<>0) and (Pl=2) then begin
        if Collision(S2[1].x,S2[1].y,2) then begin
           if P1Type=0 then ExitCode:=2
                       else if S2Left>=0 then begin
                                 S2OldLength:=S2Length+S2Left;
                                 S2Left:=-1;
                                 Lives2:=Lives2-1;
                                 DrawStats(false);
                                 DrawStats(true);
                       end;
        end;

        if (P.x=S2[1].x) and (P.y=S2[1].y) then begin
           ran:=random(Difficulty*random(3)+1)+2;

           if S1Left<MaxSnakePoints then S2Left:=S2Left+ran;
           PointsNeeded:=PointsNeeded-1;
           if PointsNeeded<=0 then begin
              ExitCode:=4;
              Score2:=Score2+PointsBonus;
              Lives2:=Lives2+LivesBonus;
           end;

           if not(LifePoint) then Score2:=Score2+(ran div 4)*random(20)+5
                             else Lives2:=Lives2+1;
           DrawStats(false);
           DrawStats(true);

           NewPoint;
           DrawPoint;
        end;
     end;
end;






procedure MoveSnakes;
begin;
      if P1Type<>0 then begin
           if S1Left=-1 then S1Dir:=0;
           case S1Dir of
                0: if S1Length>1 then begin
                        S1Length:=S1Length-1;
                        DrawSnakes(0,1);
                        if M[S1[1].x,S1[1].y]=1 then DrawMatrixXY(S1[1].x,S1[1].y);
                   end
                   else begin
                        S1Left:=0;
                        if M[S1[1].x,S1[1].y]=1 then DrawMatrixXY(S1[1].x,S1[1].y);
                        FinalVer(1);
                        InitPlayer(1,false);
                        DrawSnakes(1,0);
                        DrawStats(false);
                        DrawStats(true);
                   end;
                1: MoveSnakeXY(1,0,-1);
                2: MoveSnakeXY(1,1,0);
                3: MoveSnakeXY(1,0,1);
                4: MoveSnakeXY(1,-1,0);
           end;
           CollisionVerify(1);
      end;

      if P2Type<>0 then begin
           if S2Left=-1 then S2Dir:=0;
           case S2Dir of
                0: if S2Length>1 then begin
                        S2Length:=S2Length-1;
                        DrawSnakes(0,2);
                        if M[S2[1].x,S2[1].y]=1 then DrawMatrixXY(S2[1].x,S2[1].y);
                   end
                   else begin
                        S2Left:=0;
                        if M[S2[1].x,S2[1].y]=1 then DrawMatrixXY(S2[1].x,S2[1].y);
                        FinalVer(2);
                        InitPlayer(2,false);
                        DrawSnakes(1,0);
                        DrawStats(false);
                        DrawStats(true);
                   end;
                1: MoveSnakeXY(2,0,-1);
                2: MoveSnakeXY(2,1,0);
                3: MoveSnakeXY(2,0,1);
                4: MoveSnakeXY(2,-1,0);
           end;
           CollisionVerify(2);
      end;
end;


procedure BugDebug;
begin
     if (S1Dir>4) or (S1Dir<-1) then S1Dir:=random(4)+1;
     if (S2Dir>4) or (S2Dir<-1) then S2Dir:=random(4)+1;
end;




begin
     cls;
     ExitCode:=0;

     repeat
           if keypressed then Key:=readkey;
     until not(keypressed);
     Key:=#0;

     DrawMatrix;
     DrawPoint;
     DrawSnakes(2,0);
     DrawStats(True);

     Repeat
           If (P1Type=2) and CanMove1 then begin
              if (Time1>=Wait1) then begin
                 CheckPath(1);
                 ComputerMove(1);
              end;
              AnalogMove(1);
           end;
           If (P2Type=2) and CanMove2 then begin
              if (Time2>=Wait2) then begin
                 CheckPath(2);
                 ComputerMove(2);
              end;
              AnalogMove(2);
           end;


           DrawSnakes(0,0);
           MoveSnakes;
           DrawSnakes(1,0);

           if not(NoHuman) then begin
              for i:=1 to (Processor*Pause div 3) do for j:=1 to Processor*Pause div 3 do;
           end
           else begin
              for i:=1 to (Processor*Pause div 3) div ComputerAccelerate do for j:=1 to Processor*Pause div 3 do;
           end;

           OldDir1:=S1Dir;
           OldDir2:=S2Dir;
           while keypressed do CheckKeys;


           BugDebug;


           if Demo then DrawDemo;

           if Time1<Wait1 then Time1:=Time1+1;
           if Time2<Wait2 then Time2:=Time2+1;

     Until ExitCode<>0;
     Key:=#0;
end;







begin
     if not(Demo) then IntroLevel;

     str(Level,s);
     s:=s+'.lev';
     LoadLevel(s);
     LevelInits;
     Runtime;

     if ExitCode>10 then begin Lives1:=-1; Lives2:=-1; P1Type:=0; P2Type:=0; Demo:=true; end
     else begin
          if ExitCode=1 then Lives1:=Lives1-1;
          if ExitCode=2 then Lives2:=Lives2-1;
          if ExitCode=3 then begin Lives1:=Lives1-1; Lives2:=Lives2-1; end;
          if ExitCode=4 then Level:=Level+1;

          FinalVer(0);
     end;
end;








procedure EndOfGame;
var k:char;

procedure WriteScores1;
var s:string;
    SS:string;

begin
     s:='PLAYER 1: ';
     WriteF(160-(length(s)*7) div 2,20,s,'def',P1Color,2,0);

     s:='YOUR SCORE WHEN FINISHED: ';
     str(Score1,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,40,s,'def',P1Color,2,0);

     s:='DIFFICULTY BONUS: ';
     str(-1800+Difficulty*600,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,55,s,'def',P1Color,2,0);
     Score1:=Score1-1800+Difficulty*600;

     if LevelWF1>MaxLevels then begin
        s:='FINISHING THE GAME BONUS: ';
        str(MaxLevels*120+Lives1*1000,SS);
        s:=s+SS;
        WriteF(160-(length(s)*7) div 2+10,70,s,'def',P1Color,2,0);
        Score1:=Score1+MaxLevels*120+Lives1*1000;
     end;

     s:='TOTAL SCORE: ';
     if Score1<0 then Score1:=0;
     str(Score1,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,85,s,'def',P1Color,2,0);
end;





procedure WriteScores2;
var s:string;
    SS:string;

begin
     s:='PLAYER 2: ';
     WriteF(160-(length(s)*7) div 2,110,s,'def',P2Color,2,0);

     s:='YOUR SCORE WHEN FINISHED: ';
     str(Score2,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,130,s,'def',P2Color,2,0);

     s:='DIFFICULTY BONUS: ';
     str(-1800+Difficulty*600,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,145,s,'def',P2Color,2,0);
     Score2:=Score2-1800+Difficulty*600;

     if (LevelWF2>MaxLevels) then begin
        s:='FINISHING THE GAME BONUS: ';
        str(MaxLevels*120+Lives2*1000,SS);
        s:=s+SS;
        WriteF(160-(length(s)*7) div 2+10,160,s,'def',P2Color,2,0);
        Score2:=Score2+MaxLevels*120+Lives2*1000;
     end;

     s:='TOTAL SCORE: ';
     if Score2<0 then Score2:=0;
     str(Score2,SS);
     s:=s+SS;
     WriteF(160-(length(s)*7) div 2+10,175,s,'def',P2Color,2,0);
end;



procedure EnterScore1;
var nm:string;

begin
     SortHighScore;
     if Score1>=HS[Nhighs].score then begin
        inp(5,5,P1Color,'PLAYER 1 ENTER YOUR NAME: ',nm);

        NHighs:=NHighs+1;
        HS[NHighs].score:=Score1;
        HS[NHighs].name:=nm;
        SortHighScore;
     end;
end;




procedure EnterScore2;
var nm:string;

begin
     SortHighScore;
     if Score2>=HS[Nhighs].score then begin
        inp(5,5,P1Color,'PLAYER 2 ENTER YOUR NAME: ',nm);
        NHighs:=NHighs+1;
        HS[NHighs].score:=Score2;
        HS[NHighs].name:=nm;
        SortHighScore;
     end;
end;




begin
     cls;

     if LevelWF1>0 then WriteScores1;
     if LevelWF2>0 then WriteScores2;

     if keypressed then repeat k:=readkey until not(keypressed);

     repeat until keypressed;


     if (LevelWF1>0) and not(PComputer1) then EnterScore1;
     if (LevelWF2>0) and not(PComputer2) then EnterScore2;

     SaveHighScores;
     ShowHighScores;
end;







begin
     GameInits;
     Level:=1;

     Repeat
           NewLevel;
     Until ((P1Type=0) and (P2Type=0)) or (Level>MaxLevels);

     if not(Demo) then EndOfGame;
end;






{----------------------------------------------------------------------------}






procedure ChooseDifficultyMenu(var Difficulty:integer);
const MenuCommands=7;
      CommandsColorOut:array[1..MenuCommands] of integer =(2,3,1,6,5,4,8);
      CommandsColorIn:array[1..MenuCommands] of integer =(10,11,9,14,13,12,15);
      CommandsText:array[1..MenuCommands] of string =('VERY EASY','EASY','NORMAL','HARD','VERY HARD','IMPOSSIBLE',
                                                    'BACK TO MENU');
      TextColorsOut:array[1..MenuCommands] of integer =(15,15,15,15,15,15,15);
      TextColorsIn:array[1..MenuCommands] of integer =(8,8,8,8,8,8,8);
      CommandsHeight=18;
      CommandsWidth=100;
      CommandsDistance=5;


var i:integer;
    Selected:integer;
    QuitGame:boolean;
    sel:integer;


function GetCommandX1(i:integer):integer;
begin
     GetCommandX1:=160-(CommandsWidth div 2);
end;

function GetCommandX2(i:integer):integer;
begin
     GetCommandX2:=160+(CommandsWidth div 2);
end;

function GetCommandY1(i:integer):integer;
begin
     GetCommandY1:=(200 div (MenuCommands+1))*i-(CommandsHeight div 2);
end;

function GetCommandY2(i:integer):integer;
begin
     GetCommandY2:=(200 div (MenuCommands+1))*i+(CommandsHeight div 2);
end;




procedure DrawMenu;
var i:integer;
    c,cc:integer;

begin
     m.clear;

     for i:=1 to MenuCommands do begin
         if Selected=i then begin
            c:=CommandsColorIn[i];
            cc:=TextColorsIn[i];
         end
         else begin
            c:=CommandsColorOut[i];
            cc:=TextColorsOut[i];
         end;

         bar(GetCommandX1(i),GetCommandY1(i),GetCommandX2(i),GetCommandY2(i),7,c);
         writeF(GetCommandX1(i)+(CommandsWidth-length(CommandsText[i])*7) div 2,GetCommandY1(i)+(CommandsHeight-10) div 2,
         CommandsText[i],'def',cc,2,0);
     end;

     m.show;
end;



procedure ExitCodeVerify;
begin
     Difficulty:=ExitCode;
end;




begin
     cls;

     m.init;
     m.setxy(160*2,100);
     m.show;

     DrawMenu;

     QuitGame:=false;

     ExitCode:=0;
     Repeat
           sel:=Selected;
           Selected:=0;

           for i:=1 to MenuCommands do begin
               if (m.getx div 2>GetCommandX1(i)) and (m.getx div 2<GetCommandX2(i))
               and (m.gety>GetCommandY1(i)) and (m.gety<GetCommandY2(i)) then begin
                   Selected:=i;
                   if m.leftbuton then ExitCode:=i;
               end;
           end;

           if sel<>Selected then DrawMenu;
           delay(1);
           ExitCodeVerify;
     Until ExitCode<>0;

     m.clear;
end;











procedure ChooseColorMenu(n:integer;var c1,c2:integer);
var Exit:boolean;

procedure choosecolor (var c1,c2:integer;t:string);
const cl = 20;
      ch = 11;
var   ok:boolean;
      i,j:integer;
      key:char;

procedure desenallcolors;
var i,j,k:integer;

begin
     k:=0;
     for j:=0 to 15 do begin
         for i:=0 to 15 do begin
             bar (i*cl,j*ch,i*cl+cl,j*ch+ch,k,k);
             k:=k+1;
         end;
     end;
end;




begin
     m.clear;
     cls;

     desenallcolors;
     writeF(10,185,t,'def',15,2,0);

     m.window(0,0,639,177);
     m.show;

     ok:=false;
     repeat
           if m.leftbuton then begin ok:=true; c1:=(m.gety div ch)*16+((m.getx div 2) div cl); end;
           if m.rightbuton then begin ok:=true; c2:=(m.gety div ch)*16+((m.getx div 2) div cl); end;

          if keypressed then begin
             key:=readkey;
             if key=#27 then Exit:=true;
          end;
     until ok or Exit;

     delay(20);
     m.clear;
end;



begin
     Exit:=false;

     m.clear;
     cls;
     m.show;

     choosecolor(c1,c1,'PLAYER 1  CHOOSE YOUR SNAKE COLOR');
     m.show;

     if not(Exit) then begin
        if n=3 then repeat c2:=random(255)+1 until c2<>c1;
        if n=2 then choosecolor(c2,c2,'PLAYER 2  CHOOSE YOUR SNAKE COLOR');
     end;

     if Exit then begin c1:=-1; c2:=-1; end;
     m.show;
end;









procedure NewGameMenu;
const MenuCommands=4;
      CommandsColorOut:array[1..MenuCommands] of integer =(2,2,2,4);
      CommandsColorIn:array[1..MenuCommands] of integer =(10,10,10,12);
      CommandsText:array[1..MenuCommands] of string =('ONE HUMAN PLAYER','TWO HUMAN PLAYERS','HUMAN VS COMPUTER','BACK');
      TextColorsOut:array[1..MenuCommands] of integer =(15,15,15,15);
      TextColorsIn:array[1..MenuCommands] of integer =(8,8,8,8);
      CommandsHeight=20;
      CommandsWidth=130;
      CommandsDistance=5;


var i:integer;
    Selected:integer;
    Player1Color,Player2Color:integer;
    Difficulty:integer;
    sel:integer;

function GetCommandX1(i:integer):integer;
begin
     GetCommandX1:=160-(CommandsWidth div 2);
end;

function GetCommandX2(i:integer):integer;
begin
     GetCommandX2:=160+(CommandsWidth div 2);
end;

function GetCommandY1(i:integer):integer;
begin
     GetCommandY1:=(200 div (MenuCommands+1))*i-(CommandsHeight div 2);
end;

function GetCommandY2(i:integer):integer;
begin
     GetCommandY2:=(200 div (MenuCommands+1))*i+(CommandsHeight div 2);
end;




procedure DrawMenu;
var i:integer;
    c,cc:integer;

begin
     m.clear;

     for i:=1 to MenuCommands do begin
         if Selected=i then begin
            c:=CommandsColorIn[i];
            cc:=TextColorsIn[i];
         end
         else begin
            c:=CommandsColorOut[i];
            cc:=TextColorsOut[i];
         end;

         bar(GetCommandX1(i),GetCommandY1(i),GetCommandX2(i),GetCommandY2(i),7,c);
         writeF(GetCommandX1(i)+(CommandsWidth-length(CommandsText[i])*7) div 2,GetCommandY1(i)+(CommandsHeight-10) div 2,
         CommandsText[i],'def',cc,2,0);
     end;

     m.show;
end;



procedure ExitCodeVerify;
begin
     case ExitCode of
          1: begin
                  ChooseColorMenu(1,Player1Color,Player2Color);
                  m.clear;
                  if Player1Color>=0 then begin
                     ChooseDifficultyMenu(Difficulty);
                     cls;
                     If Difficulty<7 then NewGame(1,1,0,Player1Color,0,false,Difficulty);
                  end;
                  cls;
                  m.show;
             end;
          2: begin
                  ChooseColorMenu(2,Player1Color,Player2Color);
                  m.clear;
                  if Player1Color>=0 then begin
                     ChooseDifficultyMenu(Difficulty);
                     cls;
                     If Difficulty<7 then NewGame(2,1,1,Player1Color,Player2Color,false,Difficulty);
                  end;
                  cls;
                  m.show;
             end;
          3: begin
                  ChooseColorMenu(3,Player1Color,Player2Color);
                  m.clear;
                  if Player1Color>=0 then begin
                     ChooseDifficultyMenu(Difficulty);
                     cls;
                     If Difficulty<7 then NewGame(2,1,2,Player1Color,Player2Color,false,Difficulty);
                  end;
                  cls;
                  m.show;
             end;
     end;
end;




begin
     m.clear;
     cls;
     m.show;

     DrawMenu;

     ExitCode:=0;
     Repeat
           sel:=Selected;
           Selected:=0;

           for i:=1 to MenuCommands do begin
               if (m.getx div 2>GetCommandX1(i)) and (m.getx div 2<GetCommandX2(i))
               and (m.gety>GetCommandY1(i)) and (m.gety<GetCommandY2(i)) then begin
                   Selected:=i;
                   if m.leftbuton then ExitCode:=i;
               end;
           end;

           if sel<>Selected then DrawMenu;
           delay(1);
     Until ExitCode<>0;
     ExitCodeVerify;
end;











procedure MainMenu;
const MenuCommands=3;
      CommandsColorOut:array[1..MenuCommands] of integer =(1,5,4);
      CommandsColorIn:array[1..MenuCommands] of integer =(9,13,12);
      CommandsText:array[1..MenuCommands] of string =('NEW GAME','HIGH SCORES','EXIT');
      TextColorsOut:array[1..MenuCommands] of integer =(15,15,15);
      TextColorsIn:array[1..MenuCommands] of integer =(8,8,8);
      CommandsHeight=20;
      CommandsWidth=110;
      CommandsDistance=5;


var i:integer;
    Selected:integer;
    QuitGame:boolean;
    sel:integer;


function GetCommandX1(i:integer):integer;
begin
     GetCommandX1:=160-(CommandsWidth div 2);
end;

function GetCommandX2(i:integer):integer;
begin
     GetCommandX2:=160+(CommandsWidth div 2);
end;

function GetCommandY1(i:integer):integer;
begin
     GetCommandY1:=(200 div (MenuCommands+1))*i-(CommandsHeight div 2);
end;

function GetCommandY2(i:integer):integer;
begin
     GetCommandY2:=(200 div (MenuCommands+1))*i+(CommandsHeight div 2);
end;




procedure DrawMenu;
var i:integer;
    c,cc:integer;

begin
     m.clear;

     for i:=1 to MenuCommands do begin
         if Selected=i then begin
            c:=CommandsColorIn[i];
            cc:=TextColorsIn[i];
         end
         else begin
            c:=CommandsColorOut[i];
            cc:=TextColorsOut[i];
         end;

         bar(GetCommandX1(i),GetCommandY1(i),GetCommandX2(i),GetCommandY2(i),7,c);
         writeF(GetCommandX1(i)+(CommandsWidth-length(CommandsText[i])*7) div 2,GetCommandY1(i)+(CommandsHeight-10) div 2,
         CommandsText[i],'def',cc,2,0);
     end;

     m.show;
end;



procedure ExitCodeVerify;
begin
     case ExitCode of
          1: begin NewGameMenu; m.clear; cls; DrawMenu; m.show; end;
          2: begin m.clear; ShowHighScores; cls; DrawMenu; m.show; end;
          3: QuitGame:=true;
     end;
end;




begin
     cls;

     m.init;
     m.setxy(160*2,100);
     m.show;

     DrawMenu;

     QuitGame:=false;

     ExitCode:=0;
     Repeat
           sel:=Selected;
           Selected:=0;

           for i:=1 to MenuCommands do begin
               if (m.getx div 2>GetCommandX1(i)) and (m.getx div 2<GetCommandX2(i))
               and (m.gety>GetCommandY1(i)) and (m.gety<GetCommandY2(i)) then begin
                   Selected:=i;
                   if m.leftbuton then ExitCode:=i;
               end;
           end;

           if sel<>Selected then DrawMenu;
           delay(1);

           ExitCodeVerify;
           ExitCode:=0;
     Until QuitGame;


     m.clear;
     m.done;
end;







procedure Intro;
begin
     NewGame(1,2,2,random(250)+1,random(250)+1,true,3);
end;






procedure BeforeInits;
begin
     randomize;
end;

procedure InitG;
begin
     init256graf;
end;








begin
     BeforeInits;

     LoadSetup;
     LoadHighScores;

     InitG;

     Intro;

     MainMenu;
end.