use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Shodan',
    AUTHOR              => q{"John Matherly" <"jmath@surtri.com">},
    VERSION_FROM        => 'lib/Shodan/WebAPI.pm',
    ABSTRACT_FROM       => 'lib/Shodan/WebAPI.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'CGI::Enurl' => 0,
        'JSON::XS'   => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Shodan-*' },
);
