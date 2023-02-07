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
sciezka:='C:\tp\soften\czastki\';
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
procedure rysuj_ogien(i:byte);   {rysuje pojedyncza czastke i}
begin
  g_rysuj_piksel_w_buforze(adres_2_buforu,
  ogien[i].x,ogien[i].y,ogien[i].kolor);
 {reset czasteczaek}
 if(ogien[i].life=500{(random(100))+450})then
 begin
 ogien[i].life:=0;
 ogien[i].x:=random(10)+157;
 ogien[i].y:=97;
 ogien[i].kolor:=114;
 ogien[i].aktywny:=FALSE;
 end;

 if(ogien[i].aktywny=TRUE)then
 begin
 liczba:=random(2);
 if(liczba=0)then
 ogien[i].x:=ogien[i].x+random(2) else
 ogien[i].x:=ogien[i].x-random(2);
 ogien[i].y:=ogien[i].y-(ogien[i].life div 800)-(random(2));
 ogien[i].kolor:=ogien[i].kolor+(ogien[i].life div 400);
 end;
 inc(ogien[i].life, 10);
end;
{***************************************************************************}
procedure ogien_all;
begin
 for j:=0 to 999 do
  if(ogien[j].aktywny=TRUE)then rysuj_ogien(j);

 liczba:=random(1);
 if(liczba=0)then
 for j:=0 to 400 do
  ogien[random(999)].aktywny:=TRUE;
end;
{***************************************************************************}
BEGIN
inicjacja;
repeat{GLOWNA PETLA}
g_wypelnij_p(z, 0,0,320,200);
g_wypelnij_p(d, 0,0,320,200);
g_wyswietl_obraz_13h(adres_2_buforu,z,d,tlo);
ogien_all;
g_czekaj_na_powrot_pionowy;
g_kopiuj_bufor(ptr($A000,0000),adres_2_buforu);
until(keypressed);
{zwalnianie pamieci}
END.