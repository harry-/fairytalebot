package Story;

=pod

=head1 Story

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
   my $attributes ;
   my %lines;
   $self->{lines}=\%lines;

   
   my %types = Data::getDistinct("Functions2", "function");

   if ($story ne "none")
   {
      $attributes->{ 'story' } = $story;
     for my $type (keys %types)
     {
       $attributes->{function} = $type;
       $log->debug("distinct types: ".$type);
       my @rows = Data::find("Function", $attributes);
  
       $log->debug($type);
       $lines{$type} = $rows[int(rand($#rows))]->text; 
     }
     
   }
   else
   {

     for my $type (keys %types)
     {

       my $Lines  = $::schema->resultset('Function')->search({ function => $type, story => ["morph","bernd","none","zapatero"] });
         my $randomChoice = int(rand($Lines->count));

         my $idx=0;
         while (my $Line = $Lines->next)
         {
            if($idx == $randomChoice)
            {
               $lines{$type} = $Line->text;
            }
            $idx++;
         }
     }
   }







   
   bless $self, $class;
   return $self;
}


1;