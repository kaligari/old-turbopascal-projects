program ogien_show;
uses crt, graf_fx;
type czastki = record
     x:word;
     y:word;
     life:word;
     kolor:byte;
     aktywny:boolean;
     end;
var
ogien:array[0..4000] of czastki;
j:word;
adres_2_buforu:pointer;
tlo:obraz;
z,d:prostokat;
sciezka:string;
x_start:byte;
y_start:byte;
liczba:byte;
{***************************************************************************}
procedure inicjacja;
begin
g_ustaw_tryb_VGA($13);
sciezka:='C:\soften\czastki\';
g_laduj_palete_BMP(sciezka+'paleta.bmp');
g_laduj_BMP_13h(tlo,sciezka+'ogien.bmp');
g_pobierz_pam_dla_drugiego_buforu(adres_2_buforu);
x_start:=150;
y_start:=10;
randomize;
for j:=0 to 999 do
 begin
 ogien[j].x:=random(10)+157;
 ogien[j].y:=97;
 ogien[j].life:=0;
 ogien[j].kolor:=114;{237}
 ogien[j].aktywny:=FALSE;
 end;
end;
{***************************************************************************}
{rysuje pojedyncza czastke i}
procedure rysuj_ogien(adres:pointer; i:byte;
x2:word; y2:word; szer:word;wys:word;zycie:integer;
kolor:byte;skala_k:word;dod:boolean;
lewo:byte;prawo:byte;grawit:boolean;ped:boolean);
begin
  g_rysuj_piksel_w_buforze(adres,
  ogien[i].x,ogien[i].y,ogien[i].kolor);
 {reset czasteczaek}
 if(ogien[i].life=500)then
 begin
 ogien[i].life:=0;
 ogien[i].x:=random(szer)+x2;
 ogien[i].y:=random(wys)+y2;
 ogien[i].kolor:=kolor;
 ogien[i].aktywny:=FALSE;
 end;

 if(ogien[i].aktywny=TRUE)then
 begin
 liczba:=random(2);
 if(liczba=0)then
 ogien[i].x:=ogien[i].x+random(prawo) else
 ogien[i].x:=ogien[i].x-random(lewo);
 if(ped)then
 begin
  if(grawit)then
  ogien[i].y:=ogien[i].y+(ogien[i].life div zycie)-(random(2)) else
  ogien[i].y:=ogien[i].y-(ogien[i].life div zycie)-(random(2))
 end else
  if(grawit)then
 ogien[i].y:=ogien[i].y+(ogien[i].life div zycie)+(random(2)) else
 ogien[i].y:=ogien[i].y-(ogien[i].life div zycie)+(random(2));
 if(dod)then
 ogien[i].kolor:=ogien[i].kolor+(ogien[i].life div skala_k) else
 ogien[i].kolor:=ogien[i].kolor-(ogien[i].life div skala_k);
 end;
 inc(ogien[i].life, 10);
end;
{***************************************************************************}
procedure ogien_all(adres:pointer;ile:integer;
x2:word;y2:word;szer:word;wys:word;sila:integer;zycie:integer;
kolor:byte;skala_k:word;dod:boolean;
lewo:byte;prawo:byte;grawit:boolean;ped:boolean);
begin
 for j:=0 to ile do
  if(ogien[j].aktywny=TRUE)then
  rysuj_ogien(adres,j,x2,y2,szer,wys,ile-zycie,kolor,skala_k,dod,lewo,prawo,
  grawit,ped);

 liczba:=random(1);
 if(liczba=0)then
 for j:=0 to sila do
  ogien[random(ile)].aktywny:=TRUE;
end;
{***************************************************************************}
BEGIN
inicjacja;
repeat{GLOWNA PETLA}
g_wypelnij_p(z, 0,0,320,200);
g_wypelnij_p(d, 0,0,320,200);
g_wyswietl_obraz_13h(adres_2_buforu,z,d,tlo);

ogien_all(adres_2_buforu,999,157,97,10,0,100,600,114,380,true,2,2,false,true);

{ogien_all(adres_2_buforu,1000,157,97,50,0,300,800,58,450,false,1,1,true,false);}
g_czekaj_na_powrot_pionowy;
g_kopiuj_bufor(ptr($A000,0000),adres_2_buforu);
until(keypressed);
{zwalnianie pamieci}
END.