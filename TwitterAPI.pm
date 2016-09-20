package Twitter;

# fill in the four keys or tokens or whatever, then set twitter to "on" in the settings file (Settings.pm)
# I have no idea why there are four of these things btw lel

use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;

sub twitter
{
    my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key        => "",
    consumer_secret     => "",
    access_token        => "",
    access_token_secret => "",
    ssl                 => 1,
    );

    return $nt;
}




1;