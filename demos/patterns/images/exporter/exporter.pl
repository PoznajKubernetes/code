#!/usr/bin/perl
my $log_file = $ENV{'LOG_FILE'};

# // based on: k8spatterns.io
use base qw(Net::Server::HTTP);
use Text::CSV qw(csv);
use strict;

__PACKAGE__->run(port  => 9898);

sub process_http_request {
  my $self = shift;
  print "Content-type: text/plain\n\n";
  print &extract_metrics();
}

sub extract_metrics {
  my $data = csv(in => $log_file);

  my $total_nanos = 0;
  my $count = 0;
  while (my $row = shift @$data) {
    $total_nanos += $row->[2];
    $count++;
  }
  my $total_seconds = $total_nanos / (1000 * 1000 * 1000);
  return <<EOT;
pkad_random_count $count
pkad_random_seconds_total $total_seconds
EOT
}