package Shodan::WebAPI;

use CGI::Enurl;
use HTTP::Request::Common qw(GET);
use JSON::XS;
use LWP::UserAgent;

use warnings;
use strict;

our $VERSION = '0.1';

=head1 NAME

Shodan::WebAPI - A Perl wrapper around the Shodan webservice

=head1 AUTHOR

"achillean", C<< <"jmath at surtri.com"> >>

=head1 SUBROUTINES/METHODS

=head2 new

Initializes the API object.

=cut

sub new {
	my $class = shift;
	my $self  = {
		_api_key  => shift,
		_base_url => "http://www.shodanhq.com/api/",
	};

	bless $self, $class;
	return $self;
}

=head2 _request

General-purpose function to create web requests to SHODAN.

=cut

sub _request {
	my ( $self, $func, $params ) = @_;

	# Add the API key to the parameters automatically
	$params->{'key'} = $self->{_api_key};

	# Create the request URL
	my $url = $self->{_base_url} . $func . "?" . enurl($params);

	# Send the request
	my $ua       = LWP::UserAgent->new;
	my $response = $ua->request( GET $url);

	# Parse the JSON
	my $json_parser = JSON::XS->new();

	# Return the data as a hash
	return $json_parser->decode( $response->content );
}

=head2 search

Search the SHODAN database.

Arguments:
query    -- search query; identical syntax to the website

Returns:
A dictionary with 3 main items: matches, countries and total.
Visit the website for more detailed information.

=cut

sub search {
	my ( $self, $query ) = @_;

	return $self->_request( "search", { q => $query } );
}

=head2 host

Get all available information on an IP.

Arguments:
ip    -- IP of the computer

Returns:
All available information SHODAN has on the given IP,
subject to API key restrictions.

=cut

sub host {
	my ( $self, $ip ) = @_;

	return $self->_request( "host", { ip => $ip } );
}

1;    # End of Shodan::WebAPI
