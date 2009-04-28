package Net::XMPP::Simple;
use strict;

$Net::XMPP::Simple::VERSION = '1.0';

use Net::XMPP;

=head1 NAME

Net::XMPP::Simple - a bare bones wrapper for sending messages using Net::XMPP

=head1 SUMMARY

 use Net::XMPP::Simple::GTalk;

 my $g = Net::XMPP::Simple::GTalk->new({
 	'username' => 'foo',
	'password' => 's33kret',
 });

 if ($g->login()){
 	$g->send_message('bar', 'hello world');
 }

=head1 DESCRIPTION

Net::XMPP::Simple is a bare bones wrapper for sending messages using
Net:XMPP. That's it. It doesn't do anything else other than save you
the trouble of writing a bunch of boiler plate code.

=cut

=head1 PACKAGE METHODS

=cut

=head2 __PACKAGE__->new(\%args)

Valid arguments are:

=over 4

=item * B<username>

String. I<Required>

=item * B<password>

String. I<Required>

=item * B<hostname>

String. I<Required>

=item * B<componentname>

String. I<Required>

=item * B<port>

Default is I<5222>

=item * B<connectiontype>

Default is I<tcpip>

=item * B<tls>

Default is I<true>

=item * B<resource>

Default is the current package name.

=back

Returns a L<Net::XMPP::Simple> object.

=cut

sub new {
        my $pkg = shift;
        my $args = shift;

        my %self = %{$args};

        $self{'port'} ||= 5222;
        $self{'connectiontype'} ||= 'tcpip';
        $self{'tls'} ||= 1;
        $self{'resource'} ||= __PACKAGE__;

        $self{'conn'} = undef;

        return bless \%self, $pkg;
}

=head1 OBJECT METHODS

=cut

# "private"

sub login {
        my $self = shift;

        if ($self->{'conn'}){
                return 1;
        }

        my $conn = new Net::XMPP::Client();

        #

        my $status = $conn->Connect('hostname' => $self->{'hostname'}, 'port' => $self->{'port'},
                                    'componentname' => $self->{'componentname'},
                                    'connectiontype' => $self->{'connectiontype'},
                                    'tls' => $self->{'tls'});

        if (! defined($status)) {
                print "ERROR:  XMPP connection failed.\n";
                print "        ($!)\n";
                return 0;
        }

        # Change hostname

        my $sid = $conn->{SESSION}->{id};
        $conn->{STREAM}->{SIDS}->{$sid}->{hostname} = $self->{'componentname'};

        # Authenticate

        my @result = $conn->AuthSend('username' => $self->{'username'},
                                     'password' => $self->{'password'},
                                     'resource' => $self->{'resource'});

        if ($result[0] ne "ok") {
                print "ERROR: Authorization failed: $result[0] - $result[1]\n";
                return 0;
        }

        $self->{'conn'} = $conn;
        return 1;
}

=head2 $obj->send_message($to, $message)

Returns true or false.

=cut

sub send_message {
        my $self = shift;
        my $to = shift;
        my $message = shift;

        if ((! $self->{'conn'}) && (! $self->login())){
                return 0;
	}

        $to = "$to\@$self->{componentname}";

        $self->{'conn'}->MessageSend('to' => $to,
                                     'body' => $message,
                                     'resource' => $self->{'resource'});

        return 1;
}

=head1 AUTHOR

Aaron Straup Cope

=head1 VERSION

1.0

=head1 DATE

$Date: 2009/04/28 02:17:31 $

=head1 SEE ALSO

L<Net::XMPP>

=head1 LICENSE

Copyright (c) 2005-2009 Aaron Straup Cope. All Rights Reserved.

This is free software. You may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

return 1;
