package Settings;

use strict;
use warnings;

use Log::Log4perl qw(get_logger);

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub set
{
  my ($self, $key, $value) = @_;
  my $log = get_logger("Settings");
  $::settings{$key} = $value;

}


sub settings
{
  my ($self, $key) = @_;
  my $log = get_logger("Settings");
  my %dictionary;
  


  %dictionary =
  (
    #section technical
    "dbpath",         "propp",
    "twitter",        "off",            # either on or off
    "fairytales",     "on",             # either on or off
    "databaseType",   "sqlite",         # either "sqlite-memory", "csv" or "sqlite" - description in Data.pm
    "csvSeparator",   "|",              # for csv based data only obv
    "orm",            "DBIx::Class",    # either  "DBIx::Class" or "custom"
    "silent" ,        0,
    "stdout" ,        "out/out.html",   # "print" to stdout (0) or somewhere else
    "printmode" ,     ">",              # > for normal mode, >> for appending

  );

  #settings handed over as command line options override values set in this file:

  for my $key (keys %::settings)
  {
     $dictionary{$key} = $::settings{$key};
  }

  $key eq "all" and return %dictionary;


  exists($::settings{$key}) and return $::settings{$key};

  exists($dictionary{$key}) or $log->error("no setting found for $key");
  return $dictionary{$key};
}





1;