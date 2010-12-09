package Shodan::WebAPI;

use CGI::Enurl;
use HTTP::Request::Common qw(GET);
use JSON::XS;
use LWP::UserAgent;

use warnings;
use strict;

our $VERSION = '0.3';

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
A hash with 3 main items: matches, countries and total.
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

=head2 exploitdb_download

Download the exploit code from the ExploitDB archive.
    
Arguments:
id    -- ID of the ExploitDB entry
    
Returns:
A hash with the following fields:
filename        -- Name of the file
content-type    -- Mimetype
data            -- Contents of the file

=cut

sub exploitdb_download {
	my ( $self, $id ) = @_;

	return $self->_request( "exploitdb/download", { id => $id } );
}

=head2 exploitdb_search

Search the ExploitDB archive.
    
Arguments:
query     -- Search terms

Optional arguments passed as a hash:
author    -- Name of the exploit submitter
platform  -- Target platform (e.g. windows, linux, hardware etc.)
port      -- Service port number
type      -- Any, dos, local, papers, remote, shellcode and webapps
    
Returns:
A hash with 2 main items: matches (array) and total (int).
Each item in 'matches' is a hash with the following elements:
            
id
author
date
description
platform
port
type

Example:
exploitdb_search('PHP', {type => 'webapps'})

=cut

sub exploitdb_search {
	my ( $self, $query, $args ) = @_;
	
	$args->{'q'} = $query;

	return $self->_request( "exploitdb/search", $args );
}

=head2 msf_download

Download a metasploit module given the fullname (id) of it.
            
Arguments:
id        -- fullname of the module (ex. auxiliary/admin/backupexec/dump)

Returns:
A dictionary with the following fields:
filename        -- Name of the file
content-type    -- Mimetype
data            -- File content

=cut

sub msf_download {
	my ( $self, $id ) = @_;

	return $self->_request( "msf/download", { id => $id } );
}

=head2 msf_search

Search for a metasploit module.

=cut

sub msf_search {
	my ( $self, $query, $args ) = @_;
	
	$args->{'q'} = $query;

	return $self->_request( "msf/search", $args );
}

1;    # End of Shodan::WebAPI
