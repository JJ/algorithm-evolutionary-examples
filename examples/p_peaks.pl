#!/usr/bin/perl

=head1 NAME

  p_peaks.pl - Implementation of the p-peaks combinatorial optimization problem

=head1 SYNOPSIS

  prompt% ./p_peaks.pl <population> <number of generations>

or

  prompt% perl p_peaks.pl <bits> <peaks> <population> <number of generations>

  Shows the values of the two floating-point components of the
  chromosome and finally the best value and fitness reached, which
  should be as close to 1 as possible.
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Tries to find the max of the bidimensional
Tide , and outputs the x and y coordinates, along with fitness. Best
fitness is close to 1. Around 50 generations should be enough, but
default is population and number of generations equal to 100.

This script includes also a test of the consensus function (shown as "C" in output),
which is used in some types of algorithms. 

=cut

use warnings;
use strict;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Easy;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::P_Peaks;
use Algorithm::Evolutionary::Utils qw(entropy consensus);

#----------------------------------------------------------#
my $bits = shift || 64;
my $peaks = shift || 100;
my $popSize = shift || 512; #Population size
my $numGens = shift || 500; #Max number of generations
my $selection_rate = shift || 0.2;


#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}
print "Initial consensus: ", consensus(\@pop), "\n\n";

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Mutation->new( 0.1 );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2);

# Fitness function
my $p_peaks = new  Algorithm::Evolutionary::Fitness::P_Peaks( $peaks, $bits );

#----------------------------------------------------------#
#Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
my $fitness = sub { $p_peaks->apply(@_) };
my $generation = Algorithm::Evolutionary::Op::Easy->new( $fitness , $selection_rate , [$m, $c] ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
  if ( !defined $_->Fitness() ) {
    my $this_fitness = $fitness->($_);
    $_->Fitness( $this_fitness );
  }
}

my $contador=0;
do {
  $generation->apply( \@pop );
  
  print "$contador : ", $pop[0]->asString(), "\n" ;
  print "$contador C ", consensus(\@pop), "\n\n";
  $contador++;
} while( ($contador < $numGens) 
	 && ($pop[0]->Fitness() < 1));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "Best is:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluations: ", $p_peaks->evaluations(), "\n";

print "\n\tCache size ratio: ", $p_peaks->cached_evals()/$p_peaks->evaluations(), "\n";

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2012/05/15 11:58:01 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/p_peaks.pl,v 3.1 2012/05/15 11:58:01 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $
  $Name $

=cut
