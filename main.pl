#!/usr/bin/perl

use strict;
use List::MoreUtils qw(uniq); #pozwoli na sprawdzenie wystepowania duplikatow w podanej rece
# funkcje
# FUNKCJA DO POBRANI ODZEWU I JEJ WALIDACJI 
sub odzew{ 
	my $ostatniodzew = $_[0]; # pierwszy parametr wywolania
	my $ilePas = $_[1]; # drugi parametr wywolania
	my $conajmniej = $_[2]; # trzeci parametr wywolania
	my $indexodzywki = 0; 
	my $odzew = "";
	while(1){
		$odzew= <STDIN>;
		if ($odzew =~ /([1-7]([CDHS]|NT))|PAS|KON|REKON/){
			if ($odzew =~ /1/ ){ $indexodzywki = 0*5; } 
			elsif ($odzew =~ /2/){ $indexodzywki = 1*5; }
			elsif ($odzew =~ /3/){ $indexodzywki = 2*5; }
			elsif ($odzew =~ /4/){ $indexodzywki = 3*5; }
			elsif ($odzew =~ /5/){ $indexodzywki = 4*5; }
			elsif ($odzew =~ /6/){ $indexodzywki = 5*5; }
			elsif ($odzew =~ /7/){ $indexodzywki = 6*5; }
			if ($odzew =~ /C/ ){ $indexodzywki += 1; }
			elsif ($odzew =~ /D/){ $indexodzywki += 2; }
			elsif ($odzew =~ /H/){ $indexodzywki += 3; }
			elsif ($odzew =~ /S/){ $indexodzywki += 4; }
			elsif ($odzew =~ /NT/){ $indexodzywki += 5; }
			if ($odzew =~ /KON/){ $indexodzywki = $ostatniodzew;$ilePas=0;last;}
			if ($odzew =~ /REKON/){$indexodzywki = $ostatniodzew; $ilePas=0;last;}
			if ($odzew  =~ /PAS/){$indexodzywki = $ostatniodzew; $ilePas++; last; }
			if ($indexodzywki>$ostatniodzew){$ilePas=0;last; }
			else{
				print "Podanno odzew o za niskiej wartosci \n"
			}
		}
					
		else{
			print "Podano niewlasciwe oznaczenie\n"
		}		
		
	}
	return ($indexodzywki, $ilePas, $odzew)
}
#czesc glowna programu

print "Witamy w programie wspomagajacym licytacje brydzowa!\n";

my $pozycjaGracza;
my $pozycjaRozdajacego;
my $pozycjaPartnera;
my @kierunki = ("","","",""); # inicjalizacja pustej tablicy 4 elementowej
while(1) {	#gracz podaje swoja pozycje - zmienna pozycjaGracza
	print "Podaj swoja pozycje (NEWS): ";
	$pozycjaGracza = <STDIN>;
	chomp $pozycjaGracza;
	$pozycjaGracza = uc $pozycjaGracza;
	if ($pozycjaGracza =~ /[NEWS]/) {
		if ($pozycjaGracza eq "N") {$pozycjaPartnera = "S";}
		elsif ($pozycjaGracza eq "E") {$pozycjaPartnera = "W";}
		elsif ($pozycjaGracza eq "W") {$pozycjaPartnera = "E";}
		elsif ($pozycjaGracza eq "S") {$pozycjaPartnera = "N";}
		last;
	} else {
		print "Bledna litera!\n";
	}
}

while(1) {	#gracz podaje pozycje rozdajacego - zmienna pozycjaRozdajacego
	print "Podaj pozycje rozdajacego (NEWS): ";
	$pozycjaRozdajacego = <STDIN>;
	chomp $pozycjaRozdajacego;
	$pozycjaRozdajacego = uc $pozycjaRozdajacego;
	if ($pozycjaRozdajacego =~ /[NEWS]/) {
		if ($pozycjaRozdajacego eq "N") {@kierunki = ("N","E","S","W");}
		elsif ($pozycjaRozdajacego eq "E") {@kierunki = ("E","S","W","N");}
		elsif ($pozycjaRozdajacego eq "S") {@kierunki = ("S","W","N","E");}
		elsif ($pozycjaRozdajacego eq "W") {@kierunki = ("W","N","E","S");}
		last;
	} else {
		print "Bledna litera!\n";
	}
}

#pobranie reki od uzytkownika

my $rekaString;
my @rekaTablica;
my $ilePoprawnych;
my $ileKart;
my @rekaUnikalne;
my $ileKartUnik;
my $ileNiepoprawnych;

while(1) {
	print "Podaj swoja reke (karty oddziel spacja):\n";
	$rekaString = <STDIN>;
	$rekaString = uc $rekaString;
	@rekaTablica = split / /, $rekaString;
	$ilePoprawnych = 0; #ile kart zostalo podanych zgodnie z instrukcja
	$ileKart = $#rekaTablica + 1; #ile kart zostalo podane
	@rekaUnikalne = uniq @rekaTablica;
	$ileKartUnik = $#rekaUnikalne + 1; #ile kart sie nie powtarza
	if ($ileKartUnik == 13) {
		foreach (@rekaTablica) {
			if ($_ =~ /(10|[AKQJ2-9])[CDHS]/) { $ilePoprawnych++ }
		}	
		if ($ilePoprawnych != 13) {
			$ileNiepoprawnych = 13-$ilePoprawnych;
			print "Znaleziono $ileNiepoprawnych niepoprawnych kart!\n";
		} else {
			last;
		}
	} else {
		print "Bledna liczba kart! (za malo/duzo lub powtorzenia)\n"
	}
}

#-------------
#obliczanie potrzebnych wskaznikow
#-------------

my $punktyHonorowe = 0;
my $punktyPrzeliczeniowe = 0;
my $ileC = 0; #ile trefli na rece
my $ileD = 0; #ile karo
my $ileH = 0; #ile kierow
my $ileS = 0; #ile pikow
my $ppC = 0; 
my $ppD = 0; 
my $ppH = 0;
my $ppS = 0;
my $mocC = 0;# ile wysokich trefli
my $mocD = 0;# ile wysokich kar
my $mocH = 0;# ile wysokich kier
my $mocS = 0;# ile wysokich pikow
my $rekazrownowazona=0;
foreach (@rekaTablica) {
	#punkty honorowe
	if ($_ =~ /A/) {$punktyHonorowe += 4;} #za asy
	if ($_ =~ /K/) {$punktyHonorowe += 3;} #za krole
	if ($_ =~ /Q/) {$punktyHonorowe += 2;} #za damy
	if ($_ =~ /J/) {$punktyHonorowe += 1;} #za walety

	#dlugosc kolorow
	if ($_ =~ /C/) {$ileC += 1;} #ile trefli
	if ($_ =~ /D/) {$ileD += 1;} #ile karo
	if ($_ =~ /H/) {$ileH += 1;} #ile kierow
	if ($_ =~ /S/) {$ileS += 1;} #ile pikow
	#moc koloru
	if ($_ =~ /AC/) {$mocC += 1;} #za asa trefl
	if ($_ =~ /KC/) {$mocC += 1;} #za krola trefl
	if ($_ =~ /QC/) {$mocC += 1;} #za dame trefl
	if ($_ =~ /AD/) {$mocD += 1;} #za asa karo
	if ($_ =~ /KD/) {$mocD += 1;} #za krola karo
	if ($_ =~ /QD/) {$mocD += 1;} #za dame karo
	if ($_ =~ /AH/) {$mocH += 1;} #za asa kier
	if ($_ =~ /KH/) {$mocH += 1;} #za krola kier
	if ($_ =~ /QH/) {$mocH += 1;} #za dame kier
	if ($_ =~ /AS/) {$mocS += 1;} #za asa pik
	if ($_ =~ /KS/) {$mocS += 1;} #za krola pik
	if ($_ =~ /QS/) {$mocS += 1;} #za dame pik
}
#PP za dlugosc
if ($ileC > 4) {$ppC = $ileC - 4;}
if ($ileD > 4) {$ppD = $ileD - 4;}
if ($ileH > 4) {$ppH = $ileH - 4;}
if ($ileS > 4) {$ppS = $ileS - 4;}
if ($ileC >= 2 && $ileD > 2 && $ileH > 2 && $ileS > 2) {$rekazrownowazona=1} # reka zrownowazona z dubeltonem w treflach
if ($ileC > 2 && $ileD >= 2 && $ileH > 2 && $ileS > 2) {$rekazrownowazona=1} # reka zrownowazona z dubeltonem w karo
if ($ileC > 2 && $ileD > 2 && $ileH >= 2 && $ileS > 2) {$rekazrownowazona=1} # reka zrownowazona z dubeltonem w sercach
if ($ileC > 2 && $ileD > 2 && $ileH > 2 && $ileS >= 2) {$rekazrownowazona=1} # reka zrownowazona z dubeltonem w pikach
#punkty przeliczeniowe
$punktyPrzeliczeniowe = $punktyHonorowe + $ppC + $ppD + $ppH + $ppS;

print "Punkty honorowe: $punktyHonorowe \n";
print "Punkty przeliczeniowe: $punktyPrzeliczeniowe \n";

#---------
#LICYTACJA
#---------

my $ktoLicytuje = $pozycjaRozdajacego;
my $ilePas = 0;
my $indexodzywki = -1;
my $ostatniodzew = -1;
my @listaOdzywek=(	"PAS","1C","1D","1H","1S","1NT",
					"2C","2D","2H","2S","2NT",
					"3C","3D","3H","3S","3NT",
					"4C","4D","4H","4S","4NT",
					"5C","5D","5H","5S","5NT",
					"6C","6D","6H","6S","6NT",
					"7C","7D","7H","7S","7NT",
					"??? - nie mogę ci pomóc!");
my %odzywkiwypowiedziane = {};# miedzy tobą partnerem
my $indeks =0; # oznacza ilosc odzywek miedzy partnerem a toba
# GLOWNA PETLA Z WARUNKAMI
my $odzew =""; #schowek na ostatnia odzywke
my $propozycja=10;
my $pentla = 0;
#pentla glowna
while($ilePas < 3 || $pentla < 1 ){
	
	foreach(@kierunki){
		if ( $_ eq $pozycjaGracza ){
			$propozycja = 0;
			# otwarcie przez gracza
			if($indeks == 0){
				# otwarcie 1
				
				if($punktyPrzeliczeniowe >12 && $punktyPrzeliczeniowe< 22 && $ileC >= 3){$propozycja = 1;} # 1 trefl
				if($punktyPrzeliczeniowe >12 && $punktyPrzeliczeniowe< 22 && $ileD >= 3){$propozycja = 2;} # 1 karo
				if($punktyPrzeliczeniowe >12 && $punktyPrzeliczeniowe< 22 && $ileH >= 5){$propozycja = 3;} # 1 kier
				if($punktyPrzeliczeniowe >12 && $punktyPrzeliczeniowe< 22 && $ileS >= 5){$propozycja = 4;} # 1 pik
				if($punktyHonorowe >  14 && $punktyHonorowe< 18 && $rekazrownowazona == 1){$propozycja = 5;} # 1 BA
				# otwarcie 2
				if($punktyPrzeliczeniowe > 22 && $rekazrownowazona == 0 ){$propozycja = 6;} #2 trefl
				if($punktyPrzeliczeniowe< 13 && $ileD >= 6 && $mocD >= 2 ){$propozycja = 7;} # 2 karo
				if($punktyPrzeliczeniowe< 13 && $ileH >= 6 && $mocH >= 2 ){$propozycja = 8;} # 2 kiery
				if($punktyPrzeliczeniowe< 13 && $ileS >= 6 && $mocS >= 2 ){$propozycja = 9;} # 2 pik
				if($punktyHonorowe >  19 && $punktyHonorowe < 22 && $rekazrownowazona == 1){$propozycja = 10;} # 2 BA
				# otwarcie 3
				if($punktyPrzeliczeniowe< 13 && $ileC >= 7 && $mocC >= 2 ){$propozycja = 11;} # 3 trefl
				if($punktyPrzeliczeniowe< 13 && $ileD >= 7 && $mocD >= 2 ){$propozycja = 12;} # 3 karo
				if($punktyPrzeliczeniowe< 13 && $ileH >= 7 && $mocH >= 2 ){$propozycja = 13;} # 3 kier
				if($punktyPrzeliczeniowe< 13 && $ileS >= 7 && $mocS >= 2 ){$propozycja = 14;} # 3 trefl
				if($punktyHonorowe >  24 && $punktyHonorowe< 28 && $rekazrownowazona == 1){$propozycja = 15;} # 3 BA
				#otwarcie 4
				if($punktyPrzeliczeniowe< 13 && $ileC >= 8 && $mocC >= 2 ){$propozycja = 16;} # 4 trefl
				if($punktyPrzeliczeniowe< 13 && $ileD >= 8 && $mocD >= 2 ){$propozycja = 17;} # 4 karo
				if($punktyPrzeliczeniowe< 13 && $ileH >= 8 && $mocH >= 2 ){$propozycja = 18;} # 4 kier
				if($punktyPrzeliczeniowe< 13 && $ileS >= 8 && $mocS >= 2 ){$propozycja = 19;} # 4 pik
				
				
				
			}
			#odpowiedzi na otwarcia
			if($indeks == 1){
				# odpowiedzi na 1 trefl i karo
				# podniesienia pojedyncze
				if ($odzywkiwypowiedziane{$indeks-1} < 2 && $punktyPrzeliczeniowe >5 &&  $ileD > 3 && $ileD > $ileC && $ileD >= $ileH && $ileD >= $ileS){$propozycja = 2;} # 1 karo				
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >5 &&  $ileH > 3 && $ileH > $ileD && $ileH >= $ileS){$propozycja = 3;} # 1 kier
				if ($odzywkiwypowiedziane{$indeks-1} < 4 && $punktyPrzeliczeniowe >5 &&  $ileS > 3 && $ileS > $ileD && $ileS > $ileH){$propozycja = 4;} # 1 pik
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >5 &&  $ileH == 5 && $ileH> $ileC && $ileH >= $ileD && $ileH > $ileS){$propozycja = 3;} # 1 kier	
				if ($odzywkiwypowiedziane{$indeks-1} < 4 && $punktyPrzeliczeniowe >5 &&  $ileS == 5 && $ileS> $ileC && $ileS > $ileD && $ileS >= $ileH){$propozycja = 4;} # 1 pik	
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >5 && $ileH > 3 && $ileH > $ileC && $ileH > $ileD && $ileH > $ileS){$propozycja = 3;} # 1 kier
				# podniesienia bilansowe;
				if ($odzywkiwypowiedziane{0} < 2 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileC >5 && $ileC >= $ileD && $ileC >= $ileH && $ileC >= $ileS){$propozycja = 6;} # 2 trefl
				if ($odzywkiwypowiedziane{$indeks-1} < 2 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&  $ileD > 5 && $ileD > $ileC && $ileD >= $ileH && $ileD >= $ileS){$propozycja = 7;} # 2 karo				
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileH > 3 && $ileH > $ileC && $ileH > $ileD && $ileH >= $ileS){$propozycja = 8;} # 2 kier
				if ($odzywkiwypowiedziane{$indeks-1} < 4 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&  $ileS > 3 && $ileS> $ileC && $ileS > $ileD && $ileS > $ileH){$propozycja = 9;} # 2 pik
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&  $ileH == 5 && $ileH> $ileC && $ileH >= $ileD && $ileH > $ileS){$propozycja = 8;} # 2 kier	
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileS == 5 && $ileS> $ileC && $ileS > $ileD && $ileS >= $ileH){$propozycja = 9;} # 2 pik	
				if ($odzywkiwypowiedziane{$indeks-1} < 3 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileH > 3 && $ileH > $ileC && $ileH > $ileD && $ileH >= $ileS){$propozycja = 8;} # 2 kier
				if ($odzywkiwypowiedziane{$indeks-1} < 2 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileH > 3 && $ileH > $ileC && $ileH > $ileD && $ileH >= $ileS){$propozycja = 11;} # 3 trefl
				#podniesienia zaporowe
				if ($odzywkiwypowiedziane{$indeks-1} == 1 && $punktyPrzeliczeniowe >5 && $punktyPrzeliczeniowe < 10 && $ileC == 5 && ($ileD < 2 || $ileH < 2 ||$ileS < 2)){$propozycja = 16;} # 4 trefl
				if ($odzywkiwypowiedziane{$indeks-1} == 2 && $punktyPrzeliczeniowe >5 && $punktyPrzeliczeniowe < 10 && $ileD == 5 && ($ileC < 2 || $ileH < 2 ||$ileS < 2)){$propozycja = 17;} # 4 karo
				# odpowiedzi na 1 kier i pik
				if ($odzywkiwypowiedziane{$indeks-1} == 3 && $punktyPrzeliczeniowe >6 && $punktyPrzeliczeniowe < 9 && $ileH == 3 ){$propozycja = 8;} # 2 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 4 && $punktyPrzeliczeniowe >6 && $punktyPrzeliczeniowe < 9 && $ileS == 3 ){$propozycja = 9;}# 2 pik
				if ($odzywkiwypowiedziane{$indeks-1} == 3 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 && $ileH == 3 ){$propozycja = 13;} # 3 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 4 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 && $ileS == 3 ){$propozycja = 14;}# 3 pik
				# podniesienia pojedyncze
				# podniesienia bilansowe
				# podniesienia zaporowe
				if ($odzywkiwypowiedziane{$indeks-1} == 3 && $punktyPrzeliczeniowe >5 && $punktyPrzeliczeniowe < 10 && $ileH == 6 && ($ileD < 2 || $ileC < 2 ||$ileS < 2)){$propozycja = 18;} # 4 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 4 && $punktyPrzeliczeniowe >5 && $punktyPrzeliczeniowe < 10 && $ileS == 6 && ($ileD < 2 || $ileH < 2 ||$ileC < 2)){$propozycja = 19;} # 4 pik
				
				# podniesienia do BA
				if ($odzywkiwypowiedziane{$indeks-1} < 5 && $punktyPrzeliczeniowe >5 && $punktyPrzeliczeniowe < 10 &&   $ileC > 5 && $ileD <  4 && $ileH < 4 && $ileS < 4){$propozycja = 5;} # 1 BA
				if ($odzywkiwypowiedziane{$indeks-1} < 5 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe < 12 &&   $ileC < 5 && $ileD <  4 && $ileH < 4 && $ileS < 4 && $rekazrownowazona == 1){$propozycja = 10;} # 2 BA
				if ($odzywkiwypowiedziane{$indeks-1} < 5 && $punktyPrzeliczeniowe >15 && $punktyPrzeliczeniowe < 19 &&   $ileC < 5 && $ileD <  4 && $ileH < 4 && $ileS < 4 && $rekazrownowazona == 1){$propozycja = 15;} # 3 BA
				# odpowiedzi na 1 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >7 && $punktyPrzeliczeniowe <10){$propozycja=10;} # 2 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe <16){$propozycja=15;} # 3 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >15 && $punktyPrzeliczeniowe <18){$propozycja=20;} # 4 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >17 && $punktyPrzeliczeniowe <20){$propozycja=30;} # 6 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >19 && $punktyPrzeliczeniowe <22){$propozycja=25;} # 5 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 1 && $punktyPrzeliczeniowe >21){$propozycja=35;} # 7 BA
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && ($ileS == 4 || $ileS == 5 || $ileH == 4 || $ileH == 5)){$propozycja = 6;} #2 trefl - Stayman
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe <8 && $ileD > 4){$propozycja = 7;} # 2 karo
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe <8 && $ileH > 4){$propozycja = 8;} # 2 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe <8 && $ileS > 4){$propozycja = 9;} # 2 pik
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $ileC > 4){$propozycja = 11;} # 3 trefl
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $ileD > 4){$propozycja = 12;} # 3 karo
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $ileH > 4){$propozycja = 13;} # 3 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $ileS > 4){$propozycja = 14;} # 3 pik
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe <16 && $ileC > 5){$propozycja = 15;} # 4 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe <16 && $ileD > 5){$propozycja = 15;} # 4 pik
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe <16 && $ileH > 5){$propozycja = 18;} # 4 kier
				if ($odzywkiwypowiedziane{$indeks-1} == 5 && $rekazrownowazona == 0 && $punktyPrzeliczeniowe >9 && $punktyPrzeliczeniowe <16 && $ileS > 5){$propozycja = 19;} # 4 pik
				# odpowiedzi na 2 trefl
				if ($odzywkiwypowiedziane{$indeks-1} == 6) {
					if ($punktyPrzeliczeniowe < 8){$propozycja = 7;} # 2 karo - negat
					elsif ($punktyPrzeliczeniowe > 7 && $ileH > 4 && $mocH > 1){$propozycja = 8;} # 2 kier
					elsif ($punktyPrzeliczeniowe > 7 && $ileS > 4 && $mocS > 1){$propozycja = 9;} # 2 pik
					elsif ($punktyPrzeliczeniowe > 7 && $ileC > 4 && $mocC > 1){$propozycja = 11;} # 3 trefl
					elsif ($punktyPrzeliczeniowe > 7 && $ileD > 4 && $mocD > 1){$propozycja = 12;} # 3 karo
					else {$propozycja = 36;}
				}
				
				#odpowiedz na otwarcie zaporowe
				if ($odzywkiwypowiedziane{$indeks-1} > 15){$propozycja = 36;}
			}
			# odpowiedzi otwierającego na odpowiedzi na otwarcia
			if ($indeks == 2 )
			{
				# reka minimalna
				if ($punktyPrzeliczeniowe > 12 && $punktyPrzeliczeniowe < 16)
				{
					if ($odzywkiwypowiedziane{0} % 5 == 1 && $odzywkiwypowiedziane{$indeks-1} % 5 != 1 && $ileC > 5){$propozycja = $odzywkiwypowiedziane{0} + 5;} # trefl - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 2 && $odzywkiwypowiedziane{$indeks-1} % 5 != 2 && $ileD > 5){$propozycja = $odzywkiwypowiedziane{0} + 5;} # karo - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 3 && $odzywkiwypowiedziane{$indeks-1} % 5 != 3 && $ileH > 5){$propozycja = $odzywkiwypowiedziane{0} + 5;} # kier - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 4 && $odzywkiwypowiedziane{$indeks-1} % 5 != 4 && $ileS > 5){$propozycja = $odzywkiwypowiedziane{0} + 5;} # pik - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 1 && $odzywkiwypowiedziane{0} % 5 != 1 && $ileC > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 5;} # trefl - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 2 && $odzywkiwypowiedziane{0} % 5 != 2 && $ileD > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 5;} # karo - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 3 && $odzywkiwypowiedziane{0} % 5 != 3 && $ileH > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 5;} # kier - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 4 && $odzywkiwypowiedziane{0} % 5 != 4 && $ileS > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 5;} # pik - odpowiedz na zmiane koloru
					else {$propozycja = $odzywkiwypowiedziane{$indeks-1} + $odzywkiwypowiedziane{$indeks-1} % 5;} # BA - gdy brak lepszej opcji
				}
				
				# reka srednia i maksymalna
				if ($punktyPrzeliczeniowe > 15 && $punktyPrzeliczeniowe < 22)
				{
					if ($odzywkiwypowiedziane{0} % 5 == 1 && $odzywkiwypowiedziane{$indeks-1} % 5 != 1 && $ileC > 5){$propozycja = $odzywkiwypowiedziane{0} + 10;} # trefl - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 2 && $odzywkiwypowiedziane{$indeks-1} % 5 != 2 && $ileD > 5){$propozycja = $odzywkiwypowiedziane{0} + 10;} # karo - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 3 && $odzywkiwypowiedziane{$indeks-1} % 5 != 3 && $ileH > 5){$propozycja = $odzywkiwypowiedziane{0} + 10;} # kier - powtorzenie koloru otwarcia
					elsif ($odzywkiwypowiedziane{0} % 5 == 4 && $odzywkiwypowiedziane{$indeks-1} % 5 != 4 && $ileS > 5){$propozycja = $odzywkiwypowiedziane{0} + 10;} # pik - powtorzenie koloru otwarcia
					elsif ($rekazrownowazona == 1 && $punktyPrzeliczeniowe == 18){$propozycja = $odzywkiwypowiedziane{$indeks-1} + $odzywkiwypowiedziane{$indeks-1} % 5 + 5;} # BA
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 1 && $odzywkiwypowiedziane{0} % 5 != 1 && $ileC > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 10;} # trefl - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 2 && $odzywkiwypowiedziane{0} % 5 != 2 && $ileD > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 10;} # karo - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 3 && $odzywkiwypowiedziane{0} % 5 != 3 && $ileH > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 10;} # kier - odpowiedz na zmiane koloru
					elsif ($odzywkiwypowiedziane{$indeks-1} % 5 == 4 && $odzywkiwypowiedziane{0} % 5 != 4 && $ileS > 3){$propozycja = $odzywkiwypowiedziane{$indeks-1} + 10;} # pik - odpowiedz na zmiane koloru
					else {$propozycja = 36;}
				}
				
				# Stayman
				if ($odzywkiwypowiedziane{0} == 5 && $odzywkiwypowiedziane{1} == 6 )
				{
					if ($ileH < 4 && $ileS < 4){$propozycja = 7;}
					if ($ileH > 3){$propozycja = 8;}
					if ($ileS > 3){$propozycja = 9;}
				}
			}
			#odpowiedzi odpowiadajacego na odpowiedz otwierajacego
			if ($indeks == 3 )
			{
				if ($punktyPrzeliczeniowe > 5){$propozycja=36;}
			}
			
			print "Proponuje powiedziec:\n";
			print $listaOdzywek[$propozycja];
			printf "\nCo powiedziales\n";
			($indexodzywki,$ilePas, $odzew) = &odzew($ostatniodzew,$ilePas,$listaOdzywek[$ostatniodzew]);
			if ($indexodzywki>$ostatniodzew){
				$ostatniodzew= $indexodzywki;
				$odzywkiwypowiedziane{$indeks}=$ostatniodzew;
				$indeks++;
			}
		}
		elsif ($_ eq $pozycjaPartnera ){
		
			printf "Co powiedzial twoj partner\n";
			($indexodzywki,$ilePas, $odzew) = &odzew($ostatniodzew,$ilePas,$listaOdzywek[$ostatniodzew]);
			if ($indexodzywki>$ostatniodzew){
				$ostatniodzew= $indexodzywki;
				if ($odzew eq "PAS")
				$odzywkiwypowiedziane{$indeks}=$indexodzywki;
				$indeks++;
				}
		}
		
		else {
			printf ("Co powiedzial przeciwnik na pozycji '%s' \n", $_ );
			($indexodzywki,$ilePas, $odzew) = &odzew($ostatniodzew,$ilePas,$listaOdzywek[$ostatniodzew]);
			if ($indexodzywki>$ostatniodzew){
				$ostatniodzew = $indexodzywki;
			}
		
		}
		if ($ilePas >= 3 && $pentla > 1 ){last;}
	}	
	$pentla++;
}
#przy kazdym podaniu odzywki wejscie bedzie sprawdzane z zawartoscia tablicy listaOdzywek
#"zuzyte" odzywki beda wyrzucane z tablicy listaOdzywek

# Koniec pobieranie znaku potrzebne do windows 
print "To jak narazie koniec";
<STDIN>;