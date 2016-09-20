package Twitter;

use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;
use Storable;



sub channels
{
   if (-e "channels")
   {
      my $hashref = retrieve("channels") or return undef;
      return $hashref;
   }
}

sub currenttweets
{
  if (-e "currenttweets")
  {
      my $hashref = retrieve("currenttweets") or return undef;
      return $hashref;
  }
}


sub commands
{
   my $commands = {


    # TWATTRE
    "lasttweet"    => sub {

        my $msg = shift;
        my $channels = channels();
        my $nt = twitter();

        exists($channels->{ $msg->{chat}{id} })  or return "no users added yet";

        my @accounts = keys $channels->{ $msg->{chat}{id} }  ;
        @_ and @accounts = @_;

        my $answer;
        for my $account (@accounts)
        {
            $account = $_[1] if $_[1];

            my $r =  $nt->show_user({screen_name=>$account});

            my $url = "https://twitter.com/$account/status/".$r->{status}{id_str};
            $answer.= "$url\n";
        }
        return $answer
    },

    # TWATTRE
    "add"    => sub {

      my $msg = shift;
       my $channels = channels();
       my $currenttweets = currenttweets();
           my $nt = twitter();

      for my $account (@_)
      {
          $channels->{ $msg->{chat}{id} } {$account}=1;

          my $r =  $nt->show_user({screen_name=>$account});
          $currenttweets->{$account}=$r->{status}{id_str};
          store $currenttweets, "currenttweets";
      }

      store $channels, "channels";
      return "added maybe"

    },

        "remove"    => sub {

      my $msg = shift;
          my $channels = channels();

      for my $account (@_)
      {
          delete $channels->{ $msg->{chat}{id} } {$account};
      }

      store $channels, "channels";
      return "probably deleted"

    },

    # TWATTRE
    "list"    => sub {

      my $msg = shift;
      my $channels = channels();

      if (exists($channels->{ $msg->{chat}{id} })  )
      {
         return join (", ",keys $channels->{ $msg->{chat}{id} } )
      }
      else
      {
         return "no twitter users have been added for this channel yet"
      }

    },

   };


    return $commands


  
}



1;