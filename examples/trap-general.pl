#!/usr/bin/perl

=head1 NAME

  trap.pl - Massively multimodal deceptive problem

=head1 SYNOPSIS

  prompt% ./trap.pl <population> <number of generations>

or

  prompt% perl trap.pl <population> <number of generations>

Shows fitness and best individual  
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Optimizes trap function.

=cut

use warnings;
use strict;
use v5.14;

use Time::HiRes qw( gettimeofday tv_interval);

use lib qw(lib ../lib);
use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Tournament_Selection;
use Algorithm::Evolutionary::Op::Replace_Worst;
use Algorithm::Evolutionary::Op::Generation_Skeleton_Ref;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Trap;


#----------------------------------------------------------#
my $blocks = shift || 10;
my $length = shift || 4;
my $popSize = shift || 1024; #Population size
my $max_evals = shift || 100000; #Max number of generations
my $replacement_rate = shift || 0.5;
my $tournament_size = shift || 2;
my $mutation_priority = shift || 1;
my $crossover_priority = shift || 4;

#----------------------------------------------------------#
#Initial population
my @pop;
#Creamos $popSize individuos
my $bits = $length*$blocks; 
for ( 0..$popSize ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $bits );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Mutation->new( 0.1, $mutation_priority );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, $crossover_priority);

# Fitness function
my $trap = new  Algorithm::Evolutionary::Fitness::Trap( $length );

#----------------------------------------------------------#
# Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
#my $fitness = sub { $trap->apply(@_) };

my $selector = new  Algorithm::Evolutionary::Op::Tournament_Selection $tournament_size;
my $replacer = new  Algorithm::Evolutionary::Op::Replace_Worst;

my $generation = Algorithm::Evolutionary::Op::Generation_Skeleton_Ref->new( $trap, $selector, [$m, $c], $replacement_rate , $replacer ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#
for ( @pop ) {
    if ( !defined $_->Fitness() ) {
	$_->evaluate( $trap );
    }
}

do {
  $generation->apply( \@pop );
  say "Best ", $trap->evaluations(), " ",  $pop[0]->asString();
} while( ($trap->evaluations() < $max_evals) 
	 && ($pop[0]->Fitness() < $length*$blocks));


#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
print "El mejor es:\n\t ",$pop[0]->asString()," Fitness: ",$pop[0]->Fitness(),"\n";

print "\n\n\tTime: ", tv_interval( $inicioTiempo ) , "\n";

print "\n\tEvaluaciones: ", $trap->evaluations(), "\n";

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut
