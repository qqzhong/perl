# StackTrace.pm
package My::StackTrace;
require 5.000;
use FileHandle;
$SIG{'__DIE__'} = 'My::StackTrace::DumpStack';

sub DumpStack {
  my $msg = shift;
  my ( $pack, $file, $line, $subname, $hasargs, $wantarray, $i, @tmp, @args );
  my ( $args_safe, $routine );
  # enable argument processing with DB::args;
  package DB;
  # for inclusion in HTML error documents
  print "<PRE><HR>\n" if $ENV{"REMOTE_HOST"};
  print "\n$msg\n";
  $i = 1;
  while ( ( $pack, $file, $line, $subname, $hasargs, $wantarray ) = caller( $i++ ) ) {
    @args = @DB::args;
    @tmp  = caller($i);
    print "$file:$line ";
    print "(in $tmp[3])" if $tmp[3];
    $routine = $pack . '::' . $subname;
    print "\n\t&$routine";
    $args_safe = 1;
    if ( $routine =~ /SQL_OpenDatabase/o
      || $routine =~ /RPC::PlClient::new/o
      || $routine =~ /DBD::Proxy::dr::connect/o
      || $routine =~ /DBI::connect/o )
    {
      $args_safe = 0;
    }
    if ($args_safe) {
      if ($hasargs) {
        print "(", join( ", ", @args ), ")";
      }
    } else {
      if ($hasargs) {
        print "(", scalar(@args), " arguments hidden for security)";
      }
    }
    print "\n";
  }
  print "\n\n";
  print "<HR></PRE>\n" if $ENV{"REMOTE_HOST"};
  exit;    # transmute death into a graceful exit
}
1;
