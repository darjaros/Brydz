#!/usr/bin/perl

use strict;
use List::MoreUtils qw(uniq); #pozwoli na sprawdzenie wystepowania duplikatow w podanej rece

#czesc glowna programu

print "Witamy w programie wspomagajacym licytacje brydzowa!\n";

my $pozycjaGracza;
my $pozycjaRozdajacego;

while(1) {	#gracz podaje swoja pozycje - zmienna pozycjaGracza
	print "Podaj swoja pozycje (NEWS): ";
	$pozycjaGracza = <STDIN>;
	chomp $pozycjaGracza;
	$pozycjaGracza = uc $pozycjaGracza;
	if ($pozycjaGracza =~ /[NEWS]/) {
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
}

#PP za dlugosc
if ($ileC > 4) {$ppC = $ileC - 4;}
if ($ileD > 4) {$ppD = $ileD - 4;}
if ($ileH > 4) {$ppH = $ileH - 4;}
if ($ileS > 4) {$ppS = $ileS - 4;}

#punkty przeliczeniowe
$punktyPrzeliczeniowe = $punktyHonorowe + $ppC + $ppD + $ppH + $ppS;

print "Punkty honorowe: $punktyHonorowe \n";
print "Punkty przeliczeniowe: $punktyPrzeliczeniowe \n";
