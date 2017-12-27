#!/usr/bin/perl

use strict;
use List::MoreUtils qw(uniq); #pozwoli na sprawdzenie wystepowania duplikatow w podanej rece

#czesc glowna programu

print "Witamy w programie wspomagajacym licytacje brydzowa!\n";

while(1) {	#gracz podaje swoja pozycje - zmienna pozycjaGracza
	print "Podaj swoja pozycje (NEWS): ";
	my $pozycjaGracza = <STDIN>;
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
	my $pozycjaRozdajacego = <STDIN>;
	chomp $pozycjaRozdajacego;
	$pozycjaRozdajacego = uc $pozycjaRozdajacego;
	if ($pozycjaRozdajacego =~ /[NEWS]/) {
		last;
	} else {
		print "Bledna litera!\n";
	}
}

#pobranie reki od uzytkownika
while(1) {
	print "Podaj swoja reke (karty oddziel spacja):\n";
	my $rekaString = <STDIN>;
	$rekaString = uc $rekaString;
	my @rekaTablica = split / /, $rekaString;
	my $ilePoprawnych = 0; #ile kart zostalo podanych zgodnie z instrukcja
	my $ileKart = $#rekaTablica + 1; #ile kart zostalo podane
	my @rekaUnikalne = uniq @rekaTablica;
	my $ileKartUnik = $#rekaUnikalne + 1; #ile kart sie nie powtarza
	if ($ileKartUnik == 13) {
		foreach (@rekaTablica) {
			if ($_ =~ /(10|[AKQJ2-9])[CDHS]/) { $ilePoprawnych++ }
		}	
		if ($ilePoprawnych != 13) {
			my $ileNiepoprawnych = 13-$ilePoprawnych;
			print "Znaleziono $ileNiepoprawnych niepoprawnych kart!\n";
		} else {
			last;
		}
	} else {
		print "Bledna liczba kart! (za malo/duzo lub powtorzenia)\n"
	}
}
