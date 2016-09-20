use strict;
use warnings;
use WWW::Telegram::BotAPI;
use lib "./lib";
use Getopt::Long;
use Pod::Usage qw(pod2usage);
use Twitter;
use DateTime;
use Storable;
use Data::Dumper;
use TwitterAPI;


my $man = 0;
my $help = 0;
my $debug = "0";
my $info = "0";
my $story = "";
my %settings;
$settings{dbpath}="propp"  ;


GetOptions
(
 "story=s" => \$story,
 "debug"   => \$debug,
 "info"   => \$info,
 "settings=s" => \%settings,
 'help|?' => \$help,
  man => \$man
 ) or pod2usage(2);

pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;



use Propp::Cast;
use Propp::Story;
use Propp::Propp;



use init;
init::settings(\%settings);
init::connectToDB();
init::redirectSTDOUT();

use Log::Log4perl qw(get_logger);
$info and Log::Log4perl->init("log.conf");
$debug and Log::Log4perl->init("log-debug.conf");
($info||$debug) or Log::Log4perl->init("log-error.conf");
my $log = get_logger(__PACKAGE__);





my $api = WWW::Telegram::BotAPI->new (
    token => (shift or die "ERROR: a token is required!\n")
);


# Bump up the timeout when Mojo::UserAgent is used (LWP::UserAgent uses 180s by default)
$api->agent->can ("inactivity_timeout") and $api->agent->inactivity_timeout (45);

my $me = $api->getMe or die;
my ($offset, $updates) = 0;

# The commands that this bot supports.
my $pic_id; # file_id of the last sent picture
my $commands = {
    "start"    => "Hello! Try: /list - /add - /lasttweet - /remove  /story",
    "help"    => "Commands: /list - /add - /lasttweet - /remove - /story",

    # Internal target used to handle unknown commands.
    "_unknown" => "Unknown command :("
};

$log->debug(Dumper(%::settings));

if ($::settings{twitter} eq "on")
{
   my $twittercommands = Twitter::commands();
   $commands = { %$commands, %$twittercommands };
}

if ($::settings{fairytales} eq "on")
{
   my $ftcommands = Propp::commands();
   $commands = { %$commands, %$ftcommands };
}

#print Dumper($commands);



printf "Hello! I am %s. Starting...\n", $me->{result}{username};




my $current="9001";


while (1)
{
   my $dt = DateTime->now;
   my $minute = $dt->minute;


   if ($minute%2==0&&$current!=$minute&&$::settings{twitter} eq "on")
   {
     my $channels = Twitter::channels() or next;
     my $currenttweets = Twitter::currenttweets() or next;
     my $nt = Twitter::twitter();

     $current=$minute;

     $log->debug(Dumper($channels));
     
     for my $channel (keys(%$channels))
     {
        for my $account (keys $channels->{$channel})
        {
          my $r =  $nt->show_user({screen_name=>$account});
          my $tweet = $r->{status}{id_str};
          if ($tweet!=$currenttweets->{$account})
          {
              my $url = "https://twitter.com/$account/status/".$r->{status}{id_str};
              print "$url\n";
              $api->sendMessage ({
                  chat_id => $channel,
                  text => $url
              });
              $currenttweets->{$account}=$tweet;

              store $currenttweets, "currenttweets";
          }
        }
     }
   }

    $updates = $api->getUpdates ({
        timeout => 1,
        $offset ? (offset => $offset) : ()
    });
    unless ($updates and ref $updates eq "HASH" and $updates->{ok}) {
        warn "WARNING: getUpdates returned a false value - trying again...";
        next;
    }
    for my $u (@{$updates->{result}}) {
        $offset = $u->{update_id} + 1 if $u->{update_id} >= $offset;
        if (my $text = $u->{message}{text}) { # Text message
            printf "Incoming text message from \@%s\n", $u->{message}{from}{username};
            printf "Text: %s\n", $text;
            print "chat id: ".$u->{message}{chat}{id};
            next if $text !~ m!^/[^_].!; # Not a command
            my ($cmd, @params) = split / /, $text;
            my $res = $commands->{substr ($cmd, 1)} || $commands->{_unknown};
            # Pass to the subroutine the message object, and the parameters passed to the cmd.
            $res = $res->($u->{message}, @params) if ref $res eq "CODE";
            next unless $res;
            my $method = ref $res && $res->{method} ? delete $res->{method} : "sendMessage";
            $api->$method ({
                chat_id => $u->{message}{chat}{id},
                ref $res ? %$res : ( text => $res )
            });
            print "Reply sent.\n";
        }

    }
}

init::closeDB;

__END__

=head1 telegram bot

bot

=head1 SYNOPSIS

bot.pl [your telegram token] [options]

 Options:
   -story           which story to choose elements from
   -debug           display debugging messages
   -settings        override values in Settings.pm
   -help            brief help message
   -man             full documentation
   

=head1 EXAMPLES

=over 4

=item B<bot.pl 258373689:AAGjn_hbnotarealtokenlelcK-gRrTT_1EiRY0 -debug >

will print debug messages (created with $log->debug()) to stdout

=back


=head1 OPTIONS

=over 4

=item B<-story>

which story to choose elements from. defaults to nothing lel

=item B<-debug>

Displays debugging messages and writes them to the log file.

=item B<-settings>

Let's you override specified values in Settings.pm, for example --settings setting1=value --settings setting2=value

=item B<-help>

Prints a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back


=head1 DESCRIPTION

runs a telegram bot. You will need to create a token for your bot in telegram and pass it to the script as the first argument.


=head1 TODO

nothing, this is perfect

=cut