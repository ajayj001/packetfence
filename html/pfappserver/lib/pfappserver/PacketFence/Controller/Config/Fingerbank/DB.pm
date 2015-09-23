package pfappserver::PacketFence::Controller::Config::Fingerbank::DB;

=head1 NAME

pfappserver::PacketFence::Controller::Config::Fingerbank::DB

=head1 DESCRIPTION

Basic interaction with Fingerbank database.

Customizations can be made using L<pfappserver::Controller::Config::Fingerbank::DB>

=cut

use Moose;  # automatically turns on strict and warnings
use namespace::autoclean;

use pf::api::jsonrpcclient;

BEGIN { extends 'pfappserver::Base::Controller'; }

=head2

Update "local" upstream Fingerbank database from Fingerbank project

=cut

sub update :Local :Args(0) :AdminRole('FINGERBANK_UPDATE') {
    my ( $self, $c ) = @_;

    $c->stash->{current_view} = 'JSON';

    my $apiclient = pf::api::jsonrpcclient->new;
    $apiclient->notify('fingerbank_update_upstream_db');

    $c->stash->{status_msg} = $c->loc("Fingerbank upstream DB update request successfully dispatched");
}

=head2 submit

Allow submission of "unknown" and "unmatched" fingerprints to upstream Fingerbank project

=cut

sub submit :Local :Args(0) :AdminRole('FINGERBANK_READ') {
    my ( $self, $c ) = @_;

    $c->stash->{current_view} = 'JSON';

    my $apiclient = pf::api::jsonrpcclient->new;
    $apiclient->notify('fingerbank_submit_unmatched');

    $c->stash->{status_msg} = $c->loc("Submit unknown/unmatched fingerprints to Fingerbank request successfully dispatched");
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2015 Inverse inc.

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

__PACKAGE__->meta->make_immutable;

1;
