package init;
use Data;

use Log::Log4perl qw(get_logger);
Log::Log4perl->init("log.conf");
my $log = get_logger("init");

use v5.14;

sub redirectSTDOUT
{
  if ($::settings{"stdout"})
  {
     open (STDOUT, $::settings{"printmode"}, $::settings{"stdout"})
  }
}

sub connectToDB
{
  $::dbh = Data::connect( $::settings{dbpath});
}

sub settings
{
  my ($settings, $data);
  @_ and $settings = shift;
  if(defined($settings->{dbpath}))
  {
     $data = $settings->{dbpath}
  }
  else
  {
     $data = "test"
  }

  require "data/$data/Settings.pm";
  my $rules = new Settings();
  %::settings = $rules->settings("all");

  for my $key (keys $settings)
  {
     $::settings{$key} = $settings->{$key};
  }
}

sub closeDB
{
  if ($::settings{"databaseType"} eq "sqlite-memory")
  {
    Data::disconnect() or $log->error("database could not be saved - all changes are lost");
  }
  
  if ($::settings{"databaseType"} eq "sqlite")
  {
    Data::disconnect() or $log->error("idklol");
    $log->info("disconnected from db");
  }
}

1;