use utf8;
package schema::Function;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Function

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<functions>

=cut

__PACKAGE__->table("functions");

=head1 ACCESSORS

=head2 story

  data_type: (empty string)
  is_nullable: 1

=head2 function

  data_type: (empty string)
  is_nullable: 1

=head2 text

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "story",
  { data_type => "", is_nullable => 1 },
  "function",
  { data_type => "", is_nullable => 1 },
  "text",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-02 05:47:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7YO2cGmFvsuB9pxGlTPfpQ
# These lines were loaded from 'schema\Function.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package schema::Function;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Function

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<functions>

=cut

__PACKAGE__->table("functions");

=head1 ACCESSORS

=head2 story

  data_type: (empty string)
  is_nullable: 1

=head2 function

  data_type: (empty string)
  is_nullable: 1

=head2 text

  data_type: (empty string)
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "story",
  { data_type => "", is_nullable => 1 },
  "function",
  { data_type => "", is_nullable => 1 },
  "text",
  { data_type => "", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-02 05:09:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cuIKFm2yFYvDSkpu1wOC9w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from 'schema\Function.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
