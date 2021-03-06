#!/usr/bin/perl

=head1 NAME

Violations

=cut

=head1 DESCRIPTION

unit test for Violations

=cut

use strict;
use warnings;
use DateTime;
use lib '/usr/local/pf/lib';
use pf::dal::violation;
use pf::violation;

BEGIN {
    #include test libs
    use lib qw(/usr/local/pf/t);
    #Module for overriding configuration paths
    use setup_test_config;
}

use Test::More tests => 25;
use Test::Mojo;
use Test::NoWarnings;
my $t = Test::Mojo->new('pf::UnifiedApi');

#truncate the violation table
pf::dal::violation->remove_items();

#run unittest
$t->get_ok('/api/v1/violations' => json => { })
  ->json_is('/',undef)
  ->status_is(200);

#setup
my $mac = '00:01:02:03:04:05';
my $tenant_id = 1;
my $vid = 1300000; #'Generic' Violation
my $dt_format = DateTime::Format::Strptime->new(pattern => '%Y-%m-%d %H:%M:%S');
my $dt_start = DateTime->now(time_zone=>'local');
my $dt_release = DateTime->now(time_zone=>'local')->add(seconds => 7200);

#clear node, violation will auto-insert
#my $node_status = pf::node::node_delete($mac, $tenant_id);

#insert known data (violation)
my %values = (
    mac          => $mac,
    vid          => $vid,
    start_date   => $dt_format->format_datetime($dt_start),
    release_date => $dt_format->format_datetime($dt_release),
    status       => 'open',
    notes        => 'test notes',
    ticket_ref   => 'test ticket_ref',
);

#my $violation_status = pf::violation::violation_add($mac, $vid, (
#    start_date   => $dt_format->format_datetime($dt_start),
#    release_date => $dt_format->format_datetime($dt_release),
#    status       => 'open',
#    notes        => 'test notes',
#    ticket_ref   => 'test ticket_ref',
#));

$t->post_ok('/api/v1/violations' => json => \%values)
  ->status_is(201);


#run unittest
$t->get_ok('/api/v1/violations' => json => { })
  ->json_is('/items/0/mac',$values{mac})
  ->status_is(200);

my $id = $t->tx->res->json->{items}[0]{id};

#run unittest, use $id
$t->get_ok("/api/v1/violation/$id")
  ->status_is(200)
  ->json_is('/item/vid',$values{vid})
  ->json_is('/item/status','open')
  ->json_is('/item/release_date',$values{release_date})
  ->json_is('/item/ticket_ref',$values{ticket_ref})
  ->json_is('/item/notes',$values{notes})
  ->json_is('/item/start_date',$values{start_date})
  ->json_is('/item/mac',$values{mac});

$t->delete_ok("/api/v1/violation/$id")
  ->status_is(200);
  
$t->delete_ok("/api/v1/violation/$id")
  ->status_is(404);
  
$t->get_ok('/api/v1/violations' => json => { })
  ->json_is('/',undef)
  ->status_is(200);  

  
=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2018 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;
