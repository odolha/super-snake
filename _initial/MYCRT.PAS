unit mycrt;

interface

type key = string[2];

function keypressed : boolean;
function readkey : char;
function readspecialkey : key;
procedure delay(ss:longint);
procedure clrscr;
procedure gotoxy(x,y:byte);
function getx:byte;
function gety:byte;


implementation
uses dos;

function keypressed : boolean;
var rez : boolean;
begin
     asm
        mov ah, 0bh
        int 21h
        mov rez,al
     end;

     keypressed := rez;
end;

function readkey : char;
var c : char;
begin
     c := '?';

     while not keypressed do ;
     asm
        mov ah, 07h
        int 21h
        mov c, al
     end;

     readkey := c;
end;

function readspecialkey : key;
var k : key;
    c : char;
begin
     c := readkey;
     k := c;
     if (c = #0) then
     begin
        k := k + readkey;
     end;

     readspecialkey := k;
end;


procedure delay(ss:longint);
var h,m1,m2,s1,s2,ss1,ss2:word;
    tm:longint;

begin
     gettime(h,m1,s1,ss1);

     repeat
           gettime(h,m2,s2,ss2);

           tm:=(ss2-ss1)+(s2-s1)*100;
     until tm>ss;
end;



procedure clrscr;
var i:byte;

begin
     for i:=0 to 50 do writeln;

     asm
        mov ah,2
        mov dh,0
        mov dl,0
        mov bh,0

        int 10H
     end;
end;


procedure gotoxy(x,y:byte);
begin
     asm
        mov ah,2
        mov dh,y-1
        mov dl,x-1
        mov bh,0

        int 10H
     end;
end;


function getx:byte;
var x:byte;

begin
     asm
        mov ah,3
        mov bh,0

        int 10H
        mov x,dl
     end;

     getx:=x;
end;


function gety:byte;
var y:byte;

begin
     asm
        mov ah,3
        mov bh,0

        int 10H
        mov y,dh
     end;

     gety:=y;
end;



begin
end.