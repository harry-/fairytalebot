use utf8;
package schema::Functions2;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

schema::Functions2

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<functions2>

=cut

__PACKAGE__->table("functions2");

=head1 ACCESSORS

=head2 idx

  data_type: 'integer'
  is_nullable: 1

=head2 function

  data_type: 'text'
  is_nullable: 1

=head2 text

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "idx",
  { data_type => "integer", is_nullable => 1 },
  "function",
  { data_type => "text", is_nullable => 1 },
  "text",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-03 09:30:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BYcOUasJ9c0af7vfPN9uBg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
