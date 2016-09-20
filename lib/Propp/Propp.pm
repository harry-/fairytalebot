package Propp;

=pod

=head1 Propp

load and select a set of functions that are going to make up our story

=cut

use strict;
use warnings;

use Data::Dumper;
use Log::Log4perl qw(get_logger);
my $log = get_logger(__PACKAGE__);



=head2 new

=head3 arguments

=cut

sub new
{
   my ($class, $story) = @_;  $log->debug((caller(0))[3].": ".join(",",@_));
   
   my $self;

   my $cast = new Cast($story,"random");
   my $Story = new Story($story);

   my $functions = $::schema->resultset('Functions2')->search(undef, {order_by=>"idx"});

   my @types = Cast::getTypes();
   
   my @lines;
   while (my $function=$functions->next)
   {
      $log->debug($function->idx.$function->function);
      my $line;
      exists($Story->{lines}->{$function->function}) and $line = $Story->{lines}->{$function->function}
                                           or next;

      int(rand(100)) < 50 and next;

      for my $type (@types)
      {
         $line=~s/\[$type\]/$cast->{$type}/g;
         $line=~s/\[$type posspron\]/$cast->{"$type posspron"}/g;
         $line=~s/\[$type indefname\]/$cast->{"$type indefname"}/g;
         $line=~s/\[$type pronoun\]/$cast->{"$type pronoun"}/g;
         
         if($line=~/\[o $type\]/)
         {
            (my $vocative = $cast->{$type}) =~ s/^the //;
            $line=~s/\[o $type]/$vocative/g;
         }

         if($line=~/\[$type object\]/)
         {
            my $object;
            $object = "him" if $cast->{"$type pronoun"} eq "he";
            $object = "her" if $cast->{"$type pronoun"} eq "she";
            $object = "it" if $cast->{"$type pronoun"} eq "it";

            $line=~s/\[$type object]/$object/g;
         }
         
         $line=~s/\. t/\. T/g;
         $line=~s/\. s/\. S/g;
         $line=~s/\. h/\. H/g;
      }
      push @lines,ucfirst($line)." ";
   }

   $self->{tale} =  join ('',@lines);

   bless $self, $class;
   return $self;
}

=head2 commands

=head3 arguments

=cut

sub commands
{
   my $commands;
   
   $commands->{story} = 
   sub
   {
      my $Tale = new Propp("none");
      return $Tale->{tale};
   };

   return $commands;
}


1;