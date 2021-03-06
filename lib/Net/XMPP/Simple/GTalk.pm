package Net::XMPP::Simple::GTalk;
use base qw (Net::XMPP::Simple);

=head1 NAME

Net::XMPP::Simple - a bare bones wrapper for sending GTalk messages using Net::XMPP

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

Net::XMPP::Simple is a bare bones wrapper for sending GTalk messages
using Net:XMPP. That's it. It doesn't do anything else other than
save you the trouble of writing a bunch of boiler plate code.

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

=item * B<port>

Default is I<5222>

=item * B<connectiontype>

Default is I<tcpip>

=item * B<tls>

Default is I<true>

=item * B<resource>

Default is the current package name.

=back

Note that I<hostname> and I<componentname> are set automatically.

Returns a L<Net::XMPP::Simple> object.

=cut

sub new {
        my $pkg = shift;
        my $self = $pkg->SUPER::new(@_);

        $self->{'hostname'} = 'talk.google.com';
        $self->{'componentname'} = 'gmail.com';

        if (! $self->login()){
                return undef;
        }

        return bless $self, $pkg;
}

=head1 OBJECT METHODS

=cut

=head2 $obj->send_message($to, $message)

Returns true or false.

=cut

# Defined in Simple.pm

=head1 AUTHOR

Aaron Straup Cope

=head1 VERSION

1.0

=head1 DATE

$Date: 2009/04/28 02:16:26 $

=head1 SEE ALSO

L<Net::XMPP>

L<Net::XMPP::Simple>

=head1 LICENSE

Copyright (c) 2005-2009 Aaron Straup Cope. All Rights Reserved.

This is free software. You may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

return 1;
