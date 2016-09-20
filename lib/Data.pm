package Data;

use strict;
no strict "refs";
use warnings;

use Data::Dumper;
use Log::Log4perl qw(get_logger);
my $log = get_logger(__PACKAGE__);

use DBI;

sub connect
{
   my $dbh;
   my $rules = new Settings;

   my $databasePath=$_[0];
   my $databaseType=$rules->settings("databaseType");
   my $orm=$rules->settings("orm");

   $log->info("connecting to database $databasePath
              type: $databaseType
              orm:  $orm                           ");
              
   
   if ($databaseType eq "sqlite-memory" or $databaseType eq "sqlite" )
   {
      unless (-e "data/$databasePath/sqlite/sqlite")
      {
         $log->error("db data/$databasePath/sqlite/sqlite doesnt exist");
         die;
      }

      if ($databaseType eq "sqlite-memory")
      {
         $dbh = DBI->connect ("dbi:SQLite:dbname=:memory:") or die("no connection to database");
         $dbh->sqlite_backup_from_file("data/$databasePath/sqlite/sqlite");
      }
   
      if ($databaseType eq "sqlite")
      {
   
            $dbh = DBI->connect ("dbi:SQLite:dbname=data/$databasePath/sqlite/sqlite");
      }


      unshift @INC, "data/$databasePath/schema";
     
      require schema;
      $::schema = schema->connect(sub{$dbh}) if ($orm eq "DBIx::Class");
      $dbh->{RaiseError} = 1;
   }

   $dbh and $log->info("connection successful");
   $dbh or $log->error($DBI::errstr);
   return $dbh;
}

sub disconnect
{

   my $log = get_logger("Data");
   
   my $databasePath = $::settings{dbpath};
   if ( $::settings{databaseType} eq "sqlite-memory")
   {
      my $happenings = $::dbh->sqlite_backup_to_file("data/$databasePath/sqlite/sqlite");
      $::dbh->disconnect();
      $happenings or $log->error("something went wrong while closing the db");
      $happenings and $log->info("all data stored to $databasePath");
      return $happenings;
   }
   
   if ( $::settings{databaseType} eq "sqlite")
   {
      return $::dbh->disconnect();
   }

}

sub new
{
    my $class = shift;
    my $self = {table => shift};

    bless $self, $class;
    return $self;
}

sub find
{
    my $self = shift;     $log->debug((caller(0))[3].": ".join(",",@_));
    my $attributes = shift;

    my $table;
    exists($self->{table}) and $table = $self->{table}
                           or  $table = $self;
    $log->debug ("table: $table");
    my @row = $::schema->resultset($table)->search($attributes);

    return @row;
}

sub getList
{
    my ($table, @args) = @_;    $log->debug((caller(0))[3].": ".join(",",@_));
    my @list; #return value
    my %attributes;

    my $wantedColumn = "none";
    @args%2!=0 and $wantedColumn = shift(@args);

    if (@args)
    {
      while(@args)
      {
         my $key = shift(@args);
         my $value = shift(@args);
         $attributes{$key} = $value;
      }
    }

    my @rows = $::schema->resultset(ucfirst(lc($table)))->search( \%attributes);
    
    if($wantedColumn eq "none")
    {
       my %firstrow = $rows[0]->get_columns;
       my @keys = keys %firstrow;

       $wantedColumn=$keys[0];
    }

    for my $row (@rows)
    {
      push(@list,$row->$wantedColumn);
    } 

    return @list;
}

sub getDistinct
{
    my ($table, $wantedColumn, @args) = @_;
    my $log = Log::Log4perl->get_logger("Data");
    my @list; #return value

    my @completeList = getList($table, $wantedColumn, @args);
   
    my %distinct;
    for my $listItem (@completeList)
    {
      $distinct{$listItem} = 1;
    }
    $log->debug(Dumper(%distinct));
    return keys(%distinct);
}

sub getArrayOfHashes
{
    my ($self, @args) = @_;
    my $log = Log::Log4perl->get_logger("Data");
    my @loadedData=(); #return value
    my $sth;

    my $query = "SELECT * FROM $self->{table}";

    if (@args)
    {
      $query.=" WHERE ";
      while(@args)
      {
         my $key = shift(@args);
         my $value = shift(@args);
         $query.="$key = ".$::dbh->quote($value);
         @args and $query.=" AND ";
      }

    }

    $sth = $::dbh->prepare($query)                   or $log->error("query: $query couldnt be prepared - database message: ".$::dbh->err()) and return 0;
    $sth->execute()                                or $log->error("database access failed, query: $query - database message: ".$::dbh->err()) and return 0;

    while (my $row = $sth->fetchrow_hashref)
    {
      push(@loadedData,$row);

    }

    return @loadedData ;
}

=head2 some scalar = getMax (table, field [, col_name1, filter_value1, ..., col_nameN, filter_valueN])

get the maximum value of a given field in a table. optionally, filter the table by a another field's value

to find the highest x coordinate of all hill regions:
$highestXCoordinate = Data::getMax("region", "x", "type", "hills");

to find the higest y coordinate of all regions:
$highestYCoordinate = Data::getMax("region", "y");

=head3 return values

the max value of field in the filtered or unfiltered table

=head3 arguments

table - a db table
field - search for the max value of this field
col_name - some other field of table
filterValue - a value of the column filterByField you want to filter by

=cut

sub getMax
{
    my($table, $field)= @_;                         $log->debug(join(",",@_));

    my $col = getColValuesFilteredByOtherCol(@_)    or $log->error("failed to retrieve column $field from $table") and return undef;

    my $max = $col->max()                           or $log->error("could not find the max value for $field in table $table") and return undef;
    return $max;
}

sub test_getMax
{
    my($table, $field)= @_;                          $log->debug(join(",",@_));

    my $max = getMax(@_)                             or $log->error("testing getMax failed") and return undef;

    print "\nThe maximum value of $field in table $table, filtered by ".join(',',@_)." is $max\n";

    return $max;
}


=head2 getMin

read getMax ffs

=cut

sub getMin
{
    my($table, $field)= @_;                         $log->debug(join(",",@_));

    my $col = getColValuesFilteredByOtherCol(@_)    or $log->error("failed to retrieve column $field from $table") and return undef;;

    my $min = $col->min()                           ~~ undef and $log->error("could not find the min value for $field in table $table") and return undef;
    return $min;
}


=head2 DBIx::Class::ResultSetColumn = getColValuesFilteredByOtherCol (table, field [, col_name, filter_value])

get a specific column of a table. optionally, filter the table by a another field's value

to get the x coordinates of all hill regions:
$column = getColValuesFilteredByOtherCol->getMax("region", "x", "type", "hills");

to get the y coordinates of all regions:
$column = getColValuesFilteredByOtherCol->getMax("region", "y");

=head3 return values

an instance of DBIx::Class::ResultSetColumn

=head3 arguments

table - a db table
field - search for the max value of this field
filterByField - some other field of table
filterValue - a value of the column filterByField you want to filter by

=cut

sub getColValuesFilteredByOtherCol
{
    $log->debug(join(",",@_));

    my $table = shift();
    my $field = shift();

    my $rs = $::schema->resultset($table)                  or  $log->error("retrieving table $table failed") and return undef;

    if(@_)
    {
        my $filters = {};
        while(@_)
        {
           my($col, $value) = (shift(), shift());
           $filters->{$col} = $value;
        }

        use Data::Dumper;
        $log->debug(Dumper($filters));


        $rs = $rs->search($filters)    or $log->error("filtering table $table failed") and return undef;
    }

    my $col = $rs->get_column($field);
}


1;

__END__
