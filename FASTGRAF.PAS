unit fastgraf;


interface

type pmpobject = record
                       x:integer;
                       y:integer;
                       path:string;
                 end;
     pmplist = array[1..16] of pmpobject;

procedure init256graf;
procedure putpixel(x,y:integer;c:byte);
function getpixel(x,y:integer):integer;
procedure rectangle(x1,y1,x2,y2:integer;c:byte);
procedure bar(x1,y1,x2,y2:integer;c,cf:byte);
procedure circle(x0,y0,r:real;c:integer);
procedure draw(t:string;x:integer;y:integer);
procedure drawrotate(t:string;x,y,x0,y0:integer;u:real);
procedure drawobjects(n:integer; l:pmplist; ac:byte);
procedure line(x1,y1,x2,y2:integer;c:byte);
procedure writeF(x,y:integer;prop,fontname:string;cul,sx,sy:integer);
procedure cls;

implementation


function sgn(x:real):integer;
begin
     if x>0 then sgn:=1;
     if x=0 then sgn:=0;
     if x<0 then sgn:=-1;
end;







procedure init256graf;
begin
     asm
        mov AH,0
        mov AL,13H
        int 10H
     end;
end;


procedure putpixel(x,y:integer;c:byte);
var v:longint;

begin
     v:=320*y+x;
     if (x>=0) and (x<320) and (y>=0) and (y<200) then mem[40960:v]:=c;
end;



function getpixel(x,y:integer):integer;
var v:longint;

begin
     v:=320*y+x;
     if (x>=0) and (x<320) and (y>=0) and (y<200) then getpixel:=mem[40960:v] else getpixel:=-1;
end;



procedure rectangle(x1,y1,x2,y2:integer;c:byte);
var v:longint;
    xx,yy:integer;

begin
     if x1>x2 then
     begin
        xx:=x1;
        x1:=x2;
        x2:=xx;
     end;

     if y1>y2 then
     begin
        yy:=y1;
        y1:=y2;
        y2:=yy;
     end;

     yy:=320*y1;
     if (y1>=0) and (y1<200) then begin
        for xx:=x1 to x2 do begin
            v:=yy+xx;
            if (xx>=0) and (xx<320) then mem[40960:v]:=c else if xx>=320 then break;
        end;
     end;


     if (x1>=0) and (x1<320) then begin
        for yy:=y1 to y2 do begin
            v:=yy*320+x1;
            if (yy>=0) and (yy<200) then mem[40960:v]:=c else if yy>=200 then break;
        end;
     end;


     if (x2>=0) and (x2<320) then begin
        for yy:=y1 to y2 do begin
            v:=yy*320+x2;
            if (yy>=0) and (yy<200) then mem[40960:v]:=c else if yy>=200 then break;
        end;
     end;


     yy:=320*y2;
     if (y2>=0) and (y2<200) then begin
        for xx:=x1 to x2 do begin
            v:=yy+xx;
            if (xx>=0) and (xx<320) then mem[40960:v]:=c else if xx>=320 then break;
        end;
     end;
end;




procedure bar(x1,y1,x2,y2:integer;c,cf:byte);
var v:longint;
    xx,yy,k:integer;

begin
     if x1>x2 then
     begin
        xx:=x1;
        x1:=x2;
        x2:=xx;
     end;

     if y1>y2 then
     begin
        yy:=y1;
        y1:=y2;
        y2:=yy;
     end;

     yy:=320*y1;
     if (y1>=0) and (y1<200) then begin
        for xx:=x1 to x2 do begin
            v:=yy+xx;
            if (xx>=0) and (xx<320) then mem[40960:v]:=c else if xx>=320 then break;
        end;
     end;


     yy:=320*(y1+1);
     for k:=y1+1 to y2-1 do begin
         if (k>=0) and (k<200) then begin
            for xx:=x1 to x2 do begin
                v:=yy+xx;
                if (xx>=0) and (xx<320) and (c>=0) then begin
                   if (xx=x1) or (xx=x2) then mem[40960:v]:=c else mem[40960:v]:=cf;
                end
                else if xx>=320 then break;
            end;
         end
         else if k>=200 then break;

         yy:=yy+320;
     end;


     yy:=320*y2;
     if (y2>=0) and (y2<200) then begin
        for xx:=x1 to x2 do begin
            v:=yy+xx;
            if (xx>=0) and (xx<320) then mem[40960:v]:=c else if xx>=320 then break;
        end;
     end;
end;







procedure draw(t:string;x:integer;y:integer);
var v,nx,ny:longint;
    xx,yy,i,j:integer;
    a:integer;
    f:text;

begin
     assign(f,t);

     reset(f);
              readln(f,nx);
              readln(f,ny);

              xx:=x;
              yy:=y;
              v:=320*y+x;
              for j:=1 to ny do begin
                  for i:=1 to nx do begin
                      read(f,a);
                      if (a<>-1) and (xx>=0) and (xx<320) and (yy>=0) and (yy<200) then mem[40960:v]:=a;
                      xx:=xx+1;
                      v:=v+1;
                  end;
                  readln(f);
                  yy:=yy+1;
                  xx:=x;
                  v:=v+320-nx;
              end;
     close(f);
end;




procedure drawrotate(t:string;x,y,x0,y0:integer;u:real);
var v,nx,ny:longint;
    i,j,xx,yy:integer;
    r,xx0,yy0,xxx,yyy:real;
    a:integer;
    f:text;

begin
     assign(f,t);

     reset(f);
              readln(f,nx);
              readln(f,ny);

              xx:=x;
              yy:=y;
              for j:=1 to ny do begin
                  for i:=1 to nx do begin
                      read(f,a);

                      xx0:=x0-xx;
                      yy0:=y0-yy;

                      r:=(pi*u)/180;

                      xxx:=x0-(xx0*cos(r)-yy0*sin(r));
                      yyy:=y0-(xx0*sin(r)+yy0*cos(r));

                      if (a<>-1) and (xxx>=0) and (xxx<320) and (yyy>=0) and (yyy<200) then begin
                         v:=320*round(yyy)+round(xxx);
                         mem[40960:v]:=a;
                      end;

                      xx:=xx+1;
                  end;
                  readln(f);
                  yy:=yy+1;
                  xx:=x;
              end;
     close(f);
end;





procedure drawobjects(n:integer; l:pmplist; ac:byte);
var f:array[1..16] of text;
    xx,yy,ll,hh:array[1..16] of integer;
    i,j:integer;
    k:integer;
    tc,c:integer;
    m:integer;

begin
     for k:=1 to n do begin
         xx[k]:=0;
         yy[k]:=0;

         assign (f[k],l[k].path);
         reset (f[k]);
         readln (f[k],ll[k]);
         readln (f[k],hh[k]);
     end;


     m:=0;
     for j:=0 to 199 do begin
         for i:=0 to 319 do begin
             c:=ac;
             for k:=1 to n do begin
                 if (xx[k]+l[k].x=i) and (yy[k]+l[k].y=j) then begin
                    read (f[k],tc);
                    inc(xx[k]);
                    if xx[k]>=ll[k] then begin readln(f[k]); inc(yy[k]); end;
                    if yy[k]>=hh[k] then begin xx[k]:=-1; hh[k]:=-1; end;
                    if tc<>-1 then c:=tc;
                 end;
             end;
             mem[40960:m]:=c;
             inc(m);
         end;
     end;


     for k:=1 to n do begin
         close (f[k]);
     end;
end;





procedure line(x1,y1,x2,y2:integer;c:byte);
var ix,iy,fx,fy,vix,viy:real;
    v:longint;

begin
     ix:=x1; fx:=x2;
     iy:=y1; fy:=y2;

     if abs(y2-y1)>abs(x2-x1) then begin
        viy:=sgn(y2-y1);
        vix:=0;
        if abs(y2-y1)<>0 then vix:=sgn(x2-x1)*(abs(x2-x1)/abs(y2-y1));
     end
     else begin
        vix:=sgn(x2-x1);
        viy:=0;
        if abs(x2-x1)<>0 then viy:=sgn(y2-y1)*(abs(y2-y1)/abs(x2-x1));
     end;


     repeat
           v:=320*round(iy)+round(ix);
           if (round(ix)>=0) and (round(ix)<320) and (round(iy)>=0) and (round(iy)<200) then mem[40960:v]:=c;
           ix:=ix+vix;
           v:=320*round(iy)+round(ix);
           if (round(ix)>=0) and (round(ix)<320) and (round(iy)>=0) and (round(iy)<200) then mem[40960:v]:=c;
           iy:=iy+viy;
     until (round(ix)=fx) and (round(iy)=fy);

end;





procedure writeF(x,y:integer;prop,fontname:string;cul,sx,sy:integer);
var v,nx,ny:longint;
    xx,yy,i,j:integer;
    a:integer;
    f:text;
    ci:integer;
    st,t:string;

begin

     ci:=1;
     repeat
           str(ord(prop[ci]),st);

           t:=fontname+'.FNT\'+st+'.pmp';

           assign(f,t);

           reset(f);
                    readln(f,nx);
                    readln(f,ny);

                    xx:=x;
                    yy:=y;
                    v:=320*y+x;
                    for j:=1 to ny do begin
                        for i:=1 to nx do begin
                            read(f,a);
                            if (a<>-1) and (xx>=0) and (xx<320) and (yy>=0) and (yy<200) then mem[40960:v]:=cul;
                            xx:=xx+1;
                            v:=v+1;
                        end;
                        readln(f);
                        yy:=yy+1;
                        xx:=x;
                        v:=v+320-nx;
                    end;
           close(f);

           ci:=ci+1;
           x:=x+nx+sx;
           y:=y+sy;
     until ci>length(prop);

end;



procedure cls;
var i:longint;

begin
     for i:=$0 to $FA00 do mem[$A000:i]:=0;
end;




procedure circle(x0,y0,r:real;c:integer);
var i:real;
    x,y:real;

begin
     if r=0 then r:=1;
     i:=0;
     repeat
           x:=x0+cos(i)*r;
           y:=y0+sin(i)*r;

           putpixel(round(x),round(y),c);

           i:=i+1/(10*r);
     until i>2*pi;
end;




begin
end.