#!/bin/perl -w

use warnings;
use strict;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

# FinalFourFiestaFFV.pl
# Chooses four random classes in Final Fantasy V...one from each crystal,
### that the player must stick with for the entire game

my @wind = qw(Knight Monk Thief BlackMage WhiteMage BlueMage);
my @water = qw(RedMage TimeMage Summoner BERSERKER MysticKnight);
my @fire = qw(Beastmaster Geomancer Ninja Ranger Bard);
my @earth = qw(Dragoon Dancer Samurai Chemist);
my @classic = qw(Knight Monk Thief BlackMage WhiteMage RedMage);
my @magic = qw(WhiteMage BlackMage BlueMage TimeMage Summoner RedMage Geomancer Bard Chemist Dancer);
my @no_magic = qw(Thief Monk Knight MysticKnight BERSERKER Ninja Beastmaster Ranger Samurai Dragoon);
my ($wind_crystal, $water_crystal, $fire_crystal, $earth_crystal);

my %options;
my $results = GetOptions (\%options,
                "run_type|r=s",
                "natural|n",
                );

&check_options(\%options);

my $run_type = lc($options{'run_type'});

if ($run_type eq 'normal'){
	# Normal runs are one class per crystal
	my $rand1 = int(rand(scalar(@wind)));
	my $rand2 = int(rand(scalar(@water)));
	my $rand3 = int(rand(scalar(@fire)));
	my $rand4 = int(rand(scalar(@earth)));

	$wind_crystal = $wind[$rand1];
	$water_crystal = $water[$rand2];
	$fire_crystal = $fire[$rand3];
	$earth_crystal = $earth[$rand4];
} elsif ($run_type eq 'random') {
	# Random is one class chosen from any unlocked crystal at that point
	push(@water, @wind);
	push(@fire, @water);
	push(@earth, @fire);

	my $rand1 = int(rand(scalar(@wind)));
	my $rand2 = int(rand(scalar(@water)));
	my $rand3 = int(rand(scalar(@fire)));
	my $rand4 = int(rand(scalar(@earth)));

	$wind_crystal = $wind[$rand1];
	$water_crystal = $water[$rand2];
	$fire_crystal = $fire[$rand3];
	$earth_crystal = $earth[$rand4];
} elsif ($run_type eq 'chaos') {
	# Chaos runs allow any class to be chosen at any time
	push(@water, @wind);
	push(@fire, @water);
	push(@earth, @fire);

	my $rand1 = int(rand(scalar(@earth)));
	my $rand2 = int(rand(scalar(@earth)));
	my $rand3 = int(rand(scalar(@earth)));
	my $rand4 = int(rand(scalar(@earth)));

	$wind_crystal = $earth[$rand1];
	$water_crystal = $earth[$rand2];
	$fire_crystal = $earth[$rand3];
	$earth_crystal = $earth[$rand4];
} elsif ($run_type eq 'classic') {
	# Classic restricts to only the six FF1 jobs
	$options{'natural'} = 1;
	my $rand1 = int(rand(scalar(@classic)));
	my $rand2 = int(rand(scalar(@classic)));
	my $rand3 = int(rand(scalar(@classic)));
	my $rand4 = int(rand(scalar(@classic)));

	$wind_crystal = $classic[$rand1];
	$water_crystal = $classic[$rand2];
	$fire_crystal = $classic[$rand3];
	$earth_crystal = $classic[$rand4];

	if ($wind_crystal eq 'RedMage' &&
		$water_crystal eq 'RedMage' &&
		$fire_crystal eq 'RedMage' &&
		$earth_crystal eq 'RedMage') {
			# Cannot have 4 Red Mages since it's a Water Crystal job
			until ($earth_crystal ne 'RedMage') {
				$rand1 = int(rand(scalar(@classic)));
				$earth_crystal = $classic[$rand1];
			}
	}
} elsif ($run_type eq '750') {
	# 750 run restricts you to magic users only (essentially)
	my $rand1 = int(rand(scalar(@magic)));
	my $rand2 = int(rand(scalar(@magic)));
	my $rand3 = int(rand(scalar(@magic)));
	my $rand4 = int(rand(scalar(@magic)));

	$wind_crystal = $magic[$rand1];
	$water_crystal = $magic[$rand2];
	$fire_crystal = $magic[$rand3];
	$earth_crystal = $magic[$rand4];
} elsif ($run_type eq 'no750') {
	# No750 run restricts you to non-magic users only (essentially)
	my $rand1 = int(rand(scalar(@no_magic)));
	my $rand2 = int(rand(scalar(@no_magic)));
	my $rand3 = int(rand(scalar(@no_magic)));
	my $rand4 = int(rand(scalar(@no_magic)));

	$wind_crystal = $no_magic[$rand1];
	$water_crystal = $no_magic[$rand2];
	$fire_crystal = $no_magic[$rand3];
	$earth_crystal = $no_magic[$rand4];
} else {
	die "$run_type is not a valid Four Job Fiesta run type: $!\n";
}

print "Final Fantasy V - Final Four Fiesta Jobs\n";
if ($options{'natural'}){
	print "Bartz:\t$wind_crystal\n";
	print "Lenna:\t$water_crystal\n";
	print "Faris:\t$fire_crystal\n";
	print "Galuf/Krile:\t$earth_crystal\n";
} else {
	print "Wind:\t$wind_crystal\n";
	print "Water:\t$water_crystal\n";
	print "Fire:\t$fire_crystal\n";
	print "Earth:\t$earth_crystal\n";
}

sub check_options {
   my $opts = shift;
   foreach my $req ( qw(run_type) ) {
       die "Option $req is required" unless( $opts->{$req} );
   }
}
