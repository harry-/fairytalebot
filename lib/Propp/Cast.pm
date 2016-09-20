package Cast;

=pod

=head1 Cast

load all the characters from the db and provide acces to them somehow

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
   my ($class, $story, $mode) = @_;  $log->debug((caller(0))[3].": ".join(",",@_));
   $mode or $mode = "default";

   my $self;
   my $attributes;

   my $types = $::schema->resultset('Character')->search(
    {},
    {
      columns => [ qw/type/ ],
      distinct => 1
    }
  );
  

   $log->info("there are ".$types->count." types of characters in the db. This is interesting, yes?");


   if ($mode eq "random")
   {
     $log->info("choosing a random cast");

     while (my $type = $types->next)
      {

         my $Characters  = $::schema->resultset('Character');
         my $randomChoice = int(rand($Characters->count));

         my $idx=0;
         while (my $Character = $Characters->next)
         {
            if($idx == $randomChoice)
            {
               $self->{$type->type}=$Character->defname;
               $self->{$type->type." "."pronoun"}=$Character->pronoun;
               $self->{$type->type." "."posspron"}=$Character->posspron;
               $self->{$type->type." "."indefname"}=$Character->indefname;

               $log->debug($Character->defname." added as ".$type->type);
            }
            $idx++;
         }
      }
   }
   else
   {
      $attributes->{ 'story' } = $story;
      my @rows = Data::find("Character", $attributes);

      for my $row (@rows)
      {
         $self->{$row->type}=$row->defname;
         $self->{$row->type." "."pronoun"}=$row->pronoun;
         $self->{$row->type." "."posspron"}=$row->posspron;
      }
   }
   
   bless $self, $class;
   return $self;
}

=head2 getTypes

=cut

sub getTypes
{
    my @types = Data::getDistinct("Character", "type");
    return @types;
}



1;