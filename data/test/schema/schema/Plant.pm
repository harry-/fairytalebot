use utf8;
package schema::Plant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Plant

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<plants>

=cut

__PACKAGE__->table("plants");

=head1 ACCESSORS

=head2 scientificname

  data_type: (empty string)
  is_nullable: 1

=head2 englishname

  data_type: (empty string)
  is_nullable: 1

=head2 genus

  data_type: (empty string)
  is_nullable: 1

=head2 petals

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "scientificname",
  { data_type => "", is_nullable => 1 },
  "englishname",
  { data_type => "", is_nullable => 1 },
  "genus",
  { data_type => "", is_nullable => 1 },
  "petals",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-04 09:03:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YNEWqvt+4y3aJhpR5/1alA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
