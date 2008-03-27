#!/usr/bin/perl

=head1 NAME

  fake_parallel_ga.pl - Two-population fake-parallel genetic algorithm

=head1 SYNOPSIS

  prompt% ./fake_parallel_ga.pl params.yaml conf.yaml


=head1 DESCRIPTION  

A somewhat more complex  example of how to run a Evolutionary algorithm based on
Algorithm::Evolutionary. See L<Algorithm::Evolutionary::Run> for param structure. It works for the time being only on A::E::Fitness namespace fitness functions.

=cut

use warnings;
use strict;

use lib qw(../../lib ../lib);
use Algorithm::Evolutionary::Run;

use POE;
use YAML qw(Dump LoadFile);
use IO::YAML;
use DateTime;

my $spec = shift || die "Usage: $0 params.yaml conf.yaml\n";
my $params_file = shift || "conf.yaml";
my $conf = LoadFile( $params_file ) || die "Can't open $params_file: $@\n";
my $last_evals = 0; # Number of guys evaluated by the other session

my $sessions = $conf->{'sessions'};
for my $s (1..$sessions) {
  POE::Session->create(inline_states => { _start => \&start,
					  generation => \&generation,
					  finish => \&finishing},
		       args  => [$s]
		       );
}

#Time
my $io = IO::YAML->new($conf->{'ID'}.".yaml", ">");
$io->print( [ now(), 'Start' ]);
$poe_kernel->post( "Population 1", "generation", "Population 2");

$poe_kernel->run();
$io->print( [ now(), "Exiting" ]);
$io->close();
exit(0);

sub now {
  my $now = DateTime->now();
  return $now->ymd."T".$now->hms;
}
#----------------------------------------------------------#

sub start {
  my ($kernel, $heap, $session ) = @_[KERNEL, HEAP, ARG0];
  $kernel->alias_set("Population $session");
  my $algorithm =  new Algorithm::Evolutionary::Run $spec;
  $heap->{'algorithm'} = $algorithm;
  $heap->{'counter'} = 0;
}

#------------------------------------------------------------#

sub generation {
  my ($kernel, $heap, $session, $next, $other_best ) = @_[KERNEL, HEAP, SESSION, ARG0, ARG1];
  my $alias =  $kernel->alias_list($session);
  my $algorithm = $heap->{'algorithm'};
  my @data = ( now(), $alias );
  
  if ( $other_best && $heap->{'counter'}) {
    push @data, { 'receiving' => $other_best };
    pop @{$algorithm->{'_population'}};
    push @{$algorithm->{'_population'}}, $other_best;
  }
  $algorithm->run();
  my $somebody = $algorithm->random_member();
  my $best = $algorithm->results()->{'best'};
  push @data, {'sending' => $somebody };
  my $these_evals = $heap->{'algorithm'}->results()->{'evaluations'};
  my ($idx) = ($next =~ /Population (\d+)/);
  my $after_punk = "Population ".($idx+1) ;
  if ( $after_punk gt "Population $sessions" ) {
    $after_punk = "Population 1";
  }
  if ( ( $best->Fitness() < $algorithm->{'max_fitness'} ) 
       && ( ($these_evals + $last_evals) < $conf->{'max_evals'} ) ) {
      $kernel->post($next, 'generation', $after_punk , $somebody );    
      $last_evals = $these_evals;
  } else {
    $kernel->post($session->ID, 'finish');
    $kernel->post($next, 'finish');
  }
  $heap->{'counter'}++;
  $io->print( \@data );
}

sub finishing {
  my $heap   = $_[ HEAP ];
  $io->print( [now(), { Finish => $heap->{'algorithm'}->results }] ) ;
}

=head1 AUTHOR

J. J. Merelo C<jj@merelo.net>

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2008/03/27 10:06:52 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/examples/multikulti/multikulti.pl,v 1.1 2008/03/27 10:06:52 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 1.1 $
  $Name $

=cut
