use utf8;
package schema::Genera;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Genera

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<genera>

=cut

__PACKAGE__->table("genera");

=head1 ACCESSORS

=head2 scientificname

  data_type: (empty string)
  is_nullable: 1

=head2 englishname

  data_type: (empty string)
  is_nullable: 1

=head2 numberofspecies

  data_type: (empty string)
  is_nullable: 1

=head2 family

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "scientificname",
  { data_type => "", is_nullable => 1 },
  "englishname",
  { data_type => "", is_nullable => 1 },
  "numberofspecies",
  { data_type => "", is_nullable => 1 },
  "family",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-04 09:03:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tqnu5wc+0oayosN7PD5gqw

print __PACKAGE__;
# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
