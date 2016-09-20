use utf8;
package schema::Character;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Character

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<characters>

=cut

__PACKAGE__->table("characters");

=head1 ACCESSORS

=head2 story

  data_type: (empty string)
  is_nullable: 1

=head2 type

  data_type: (empty string)
  is_nullable: 1

=head2 defname

  data_type: (empty string)
  is_nullable: 1

=head2 indefname

  data_type: (empty string)
  is_nullable: 1

=head2 posspron

  data_type: (empty string)
  is_nullable: 1

=head2 pronoun

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "story",
  { data_type => "", is_nullable => 1 },
  "type",
  { data_type => "", is_nullable => 1 },
  "defname",
  { data_type => "", is_nullable => 1 },
  "indefname",
  { data_type => "", is_nullable => 1 },
  "posspron",
  { data_type => "", is_nullable => 1 },
  "pronoun",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-02 05:47:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9SLQb54BP6zJKEpSR8i1nQ
# These lines were loaded from 'schema\Character.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package schema::Character;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Character

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<characters>

=cut

__PACKAGE__->table("characters");

=head1 ACCESSORS

=head2 story

  data_type: (empty string)
  is_nullable: 1

=head2 type

  data_type: (empty string)
  is_nullable: 1

=head2 defname

  data_type: (empty string)
  is_nullable: 1

=head2 indefname

  data_type: (empty string)
  is_nullable: 1

=head2 posspron

  data_type: (empty string)
  is_nullable: 1

=head2 pronoun

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "story",
  { data_type => "", is_nullable => 1 },
  "type",
  { data_type => "", is_nullable => 1 },
  "defname",
  { data_type => "", is_nullable => 1 },
  "indefname",
  { data_type => "", is_nullable => 1 },
  "posspron",
  { data_type => "", is_nullable => 1 },
  "pronoun",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-02 05:09:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PKGvDULyLbLmRwimO3/SBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

1;
# End of lines loaded from 'schema\Character.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
