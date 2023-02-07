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
ogien:array[0..999] of czastki;
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
procedure rysuj_cz(adres:pointer; cz:czastki;
x2:word; y2:word; szer:word;wys:word;zycie:integer;
kolor:byte;skala_k:word;dod:boolean;
lewo:byte;prawo:byte;grawit:boolean;ped:boolean);
begin
  g_rysuj_piksel_w_buforze(adres,
  cz.x,cz.y,cz.kolor);
 {reset czasteczaek}
 if(cz.life=500)then
 begin
 cz.life:=0;
 cz.x:=random(szer)+x2;
 cz.y:=random(wys)+y2;
 cz.kolor:=kolor;
 cz.aktywny:=FALSE;
 end;

 if(cz.aktywny=TRUE)then
 begin
 liczba:=random(2);
 if(liczba=0)then
 cz.x:=cz.x+random(prawo) else
 cz.x:=cz.x-random(lewo);
 if(ped)then
 begin
  if(grawit)then
  cz.y:=cz.y+(cz.life div zycie)-(random(2)) else
  cz.y:=cz.y-(cz.life div zycie)-(random(2))
 end else
  if(grawit)then
 cz.y:=cz.y+(cz.life div zycie)+(random(2)) else
 cz.y:=cz.y-(cz.life div zycie)+(random(2));
 if(dod)then
 cz.kolor:=cz.kolor+(cz.life div skala_k) else
 cz.kolor:=cz.kolor-(cz.life div skala_k);
 end;
 inc(cz.life, 10);
end;
{***************************************************************************}
procedure cz_all(adres:pointer;cz:czastki;ile:integer;
x2:word;y2:word;szer:word;wys:word;sila:integer;zycie:integer;
kolor:byte;skala_k:word;dod:boolean;
lewo:byte;prawo:byte;grawit:boolean;ped:boolean);
begin
 for j:=0 to ile do
  if(cz.aktywny=TRUE)then
  rysuj_cz(adres,cz,x2,y2,szer,wys,ile-zycie,kolor,skala_k,dod,lewo,prawo,
  grawit,ped);

 liczba:=random(1);
 if(liczba=0)then
 for j:=0 to sila do
  cz[random(ile)].aktywny:=TRUE;
end;
{***************************************************************************}
BEGIN
inicjacja;
repeat{GLOWNA PETLA}
g_wypelnij_p(z, 0,0,320,200);
g_wypelnij_p(d, 0,0,320,200);
g_wyswietl_obraz_13h(adres_2_buforu,z,d,tlo);
cz_all(adres_2_buforu,ogien[],999,147,37,10,0,100,600,114,380,false,2,2,false,true);
{
ogien_all(adres_2_buforu,1000,157,97,50,0,300,800,58,450,false,1,1,true,false);
}
g_czekaj_na_powrot_pionowy;
g_kopiuj_bufor(ptr($A000,0000),adres_2_buforu);
until(keypressed);
{zwalnianie pamieci}
END.