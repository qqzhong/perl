#!/usr/bin/perl -w
# @author             :  Copyright (C) Church.ZHONG

use strict;
use warnings;
use utf8;
use Time::HiRes qw( time );
use File::Spec;
use IO qw(Dir);
my $sep = '/';

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s }
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s }
sub trim  { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s }

sub open_filehandle_for_write {
  my $filename = $_[0];
  local *FH;
  use open ':encoding(UTF-8)';
  open( FH, '>', $filename ) || die "Could not open $filename";
  binmode FH, ":encoding(UTF-8)";
  return *FH;
}

sub open_filehandle_for_read {
  my $filename = $_[0];
  local *FH;
  open( FH, $filename ) || die "Could not open $filename";
  return *FH;
}

sub get_abs_path {
  # best code, get file true path.
  my $path_curf = File::Spec->rel2abs(__FILE__);
  # print ("# file in PATH = $path_curf\n");
  my ( $vol, $dirs, $file ) = File::Spec->splitpath($path_curf);
  # print ("# file in Dir = $dirs\n");
  return $dirs;
}

sub printArray {
  my $name = shift;
  print "${name}:[";
  foreach my $e (@_) {
    print "$e,"    if defined $e;
    print "undef," if !defined $e;
  }
  print "]\n";
}

sub printHash {
  my $name = shift;
  my $hRef = shift;
  print "${name}:{";
  foreach my $k ( keys %{$hRef} ) { print "$k => ${$hRef}{$k},"; }
  print "}\n";
}

sub ro {
  ### Getting User and Group Information ###
  listusers_pl();
  listobjpw_pl();
  listfldpw_pl();
  listcorpw_pl();
  listgr_pl();
  listgroups_pl();
  listbigr_pl();
  listfldgr_pl();
}

sub listusers_pl {
  #!/usr/bin/perl
  # listusers.pl
  use warnings;
  use strict;
  my @users;
  while ( my $name = getpwent ) {
    push @users, $name;
  }
  print "Users: @users \n";
}

sub listobjpw_pl {
  # listobjpw.pl
  use warnings;
  use strict;
  use User::pwent qw(:DEFAULT pw_has);
  print "Supported fields: ", scalar(pw_has), "\n";
  while ( my $user = getpwent ) {
    print 'Name : ',    $user->name,   "\n";
    print 'Password: ', $user->passwd, "\n";
    print 'User ID : ', $user->uid,    "\n";
    print 'Group ID: ', $user->gid,    "\n";
    # one of quota, change or age
    print 'Quota : ',  $user->quota,  "\n" if pw_has('quota');
    print 'Change : ', $user->change, "\n" if pw_has('change');
    print 'Age : ',    $user->age,    "\n" if pw_has('age');

    # one of comment or class (also possibly gcos is comment)
    print 'Comment : ', $user->comment, "\n" if pw_has('comment');
    print 'Class : ',   $user->class,   "\n" if pw_has('class');
    print 'Home Dir: ', $user->dir,     "\n";
    print 'Shell : ',   $user->shell,   "\n";
    # maybe gcos, maybe not
    print 'GECOS : ', $user->gecos, "\n" if pw_has('gecos');
    # maybe expires, maybe not
    print 'Expire : ', $user->expire, "\n" if pw_has('expire');
    # seperate records
    print "\n";
  }
}

sub listfldpw_pl {
  # listfldpw.pl
  use warnings;
  use strict;
  use User::pwent qw(:FIELDS pw_has);
  print "Supported fields: ", scalar(pw_has), "\n";
  while ( my $user = getpwent ) {
    print 'Name : ',    $pw_name,   "\n";
    print 'Password: ', $pw_passwd, "\n";
    print 'User ID : ', $pw_uid,    "\n";
    print 'Group ID: ', $pw_gid,    "\n";
    # one of quota, change or age
    print 'Quota : ',  $pw_quota,  "\n" if pw_has('quota');
    print 'Change : ', $pw_change, "\n" if pw_has('change');
    print 'Age : ',    $pw_age,    "\n" if pw_has('age');
    # one of comment or class (also possibly gcos is comment)
    print 'Comment : ', $pw_comment, "\n" if pw_has('comment');
    print 'Class : ',   $pw_class,   "\n" if pw_has('class');
    print 'Home Dir: ', $pw_dir,     "\n";
    print 'Shell : ',   $pw_shell,   "\n";
    # maybe gcos, maybe not
    print 'GCOS : ', $pw_gecos, "\n" if pw_has('gecos');
    # maybe expires, maybe not
    print 'Expire : ', $pw_expire, "\n" if pw_has('expire');
    # seperate records
    print "\n";
  }
}

sub listcorpw_pl {
  # listcorpw.pl
  use warnings;
  use strict;
  use User::pwent();

  sub User::pwent::has {
    my $self = shift;
    return User::pwent::pw_has(@_);
  }
  print "Supported fields: ", scalar(User::pwent::has), "\n";
  while ( my $user = User::pwent::getpwent ) {
    print 'Name : ',    $user->name,   "\n";
    print 'Password: ', $user->passwd, "\n";
    print 'User ID : ', $user->uid,    "\n";
    print 'Group ID: ', $user->gid,    "\n";
    # one of quota, change or age
    print 'Quota : ',  $user->quota,  "\n" if $user->has('quota');
    print 'Change : ', $user->change, "\n" if $user->has('change');
    print 'Age : ',    $user->age,    "\n" if $user->has('age');
    # one of comment or class (also possibly gcos is comment)
    print 'Comment : ', $user->comment, "\n" if $user->has('comment');
    print 'Class : ',   $user->class,   "\n" if $user->has('class');
    print 'Home Dir: ', $user->dir,     "\n";
    print 'Shell : ',   $user->shell,   "\n";
    # maybe gcos, maybe not
    print 'GECOS : ', $user->gecos, "\n" if $user->has('gecos');
    # maybe expires, maybe not
    print 'Expire : ', $user->expire, "\n" if $user->has('expire');
    # separate records
    print "\n";
  }
}

sub listgr_pl {
  # listgr.pl
  use warnings;
  use strict;
  while ( my ( $name, $passwd, $gid, $members ) = getgrent ) {
    print "$gid: $name [$passwd] $members \n";
  }
}

sub listgroups_pl {
  # listgroups.pl
  use warnings;
  use strict;
  my @groups;
  while ( my $name = getgrent ) {
    push @groups, $name;
  }
  print "Groups: @groups \n";
}

sub listbigr_pl {
  # listbigr.pl
  use warnings;
  use strict;
  use User::grent;
  while ( my $group = getgrent ) {
    print 'Name : ',    $group->name,   "\n";
    print 'Password: ', $group->passwd, "\n";
    print 'Group ID: ', $group->gid,    "\n";
    print 'Members : ', join( ', ', @{ $group->members } ), "\n\n";
  }
}

sub listfldgr_pl {
  # listfldgr.pl
  use warnings;
  use strict;
  use User::grent qw(:FIELDS);
  while ( my $group = getgrent ) {
    print 'Name : ',    $gr_name,   "\n";
    print 'Password: ', $gr_passwd, "\n";
    print 'Group ID: ', $gr_gid,    "\n";
    print 'Members : ', join( ', ', @{ $group->members } ), "\n\n";
  }
}

sub ro1 {
  ### The Unary File Test Operators ###

  #  -r $filename # return true if file is readable by us
  #  -w $filename # return true if file is writable by us
  #  -d DIRECTORY # return true if DIRECTORY is opened to a directory
  #  -t STDIN # return true if STDIN is interactive
  #  -e Return true if file exists. Equivalent to the return value of the stat function.

  #  -r Return true if file is readable by effective user id.
  #  -R Return true if file is readable by real user id.
  #  -w Return true if file is writable by effective user id.
  #  -W Return true if file is writable by real user id.
  #  -x Return true if file is executable by effective user id.
  #  -X Return true if file is executable by real user id.

  #  -o Return true if file is owned by our real user id.
  #  -u Return true if file is setuid (chmod u+S, executables only).
  #  -g Return true if file is setgid (chmod g+S. executables only), this does not exist on Windows.
  #  -k Return true if file is sticky (chmod +T, executables only), this does not exist on Windows.

  # These tests for size work on Windows as on UNIX:
  # -z Return true if file has zero length (that is, it is empty).
  # -s Return true if file has non-zero length (opposite of -z).
  # The following are file type tests. While -f, -d, -t are generic, the others are platform dependent:
  # -f Return true if file is a plain file (that is, not a directory, link, pipe, etc.).
  # -d Return true if file is a directory.
  # -l Return true if file is a symbolic link.
  # -p Return true if file is a named pipe or filehandle is a pipe filehandle.
  # -S Return true if file is a UNIX domain socket or filehandle is a socket filehandle.
  # -b Return true if file is a block device.
  # -c Return true if file is a character device.
  # -t Return true if file is interactive (opened to a terminal).
  # We can use -T and -B to test whether a file is text or binary:
  # -T Return true if file is a text file. See below for details.
  # -B Return true if file is not a text file. See below details.

  #  -M Returns the age of the file as a fractional number of days, counting from the time at
  #     which the application started (which avoids a system call to find the current time). To test
  #     which of two files is more recent we can write:
  #     $file = (-M $file1 > -M $file2)? $file1: $file2;
  #  -A Returns last access time.
  #  -C On UNIX, returns last inode change time (not creation time, as is commonly
  #     misconceived; this does return the creation time, but only so long as the inode has not
  #     changed since the file was created). On other platforms, it returns the creation time.

  # if (-l $file and !-e $file) { print "'$file' is a broken link! \n"; }

  ### Using 'stat' Objects ###
  filesize_pl();
  filesizefld_pl();
}

sub filesize_pl {
  # filesize.pl
  use warnings;
  use strict;
  use File::stat;
  print "Enter filename: ";
  # my $filename = <>;
  my $filename = 'dummy.txt';
  chomp $filename;
  if ( my $stat = stat $filename ) {
    print "'$filename' is ", $stat->size, " bytes and occupies ", $stat->blksize * $stat->blocks, " bytes of disc space \n";
  } else {
    print "Cannot stat $filename: $| \n";
  }
}

sub filesizefld_pl {
  # filesizefld.pl
  use warnings;
  use strict;
  use File::stat qw(:FIELDS);
  print "Enter filename: ";
  # my $filename = <>;
  my $filename = 'dummy.txt';
  chomp($filename);
  if ( stat $filename ) {
    print "'$filename' is ", $st_size, " bytes and occupies ", $st_blksize * $st_blocks, " bytes of disc space \n";
  } else {
    print "Cannot stat $filename: $| \n";
  }
}

sub ro2 {
  ### Access Control Lists, the Superuser, and the 'filestat' Pragma ###
  #  R_OK Test file has read permission.
  #  W_OK Test file has write permission.
  #  X_OK Test file has execute permission.
  #  F_OK Test that file exists. Implied by R_OK, W_OK, or X_OK.

  ids_pl();

  ### The 'Fcntl' Module ###
  #  Name Description Operator
  #  S_IFREG Regular file -f
  #  S_IFDIR Directory -d
  #  S_IFLNK Link -l
  #  S_IFBLK Block special file -b
  #  S_IFCHR Character special file -c
  #  S_IFIFO Pipe or named fifo -p
  #  S_IFSOCK Socket -S
  #  S_IFWHT Interactive terminal -t

### Unlinking Files ###
  #  foreach (@files) {
  #  unlink if /\.bak/; # unlink $_ if it ends '.bak'
  #  }
  #  unlink <*.bak>; # the same, via a file glob

### Comparing Files ###
  #  SWITCH: foreach (compare $file1, $file2) {
  #  /^0/ and print("Files are equal"), last;
  #  /^1/ and print("Files are not equal"), last;
  #  print "Error comparing files: $! \n";
  #  }

### 'glob' Syntax ###
  my $filespec = '*.pl';
  my @files    = glob $filespec;    # better
  if ($File::Glob::GLOB_ERROR) {
    die "Error globbing '$filespec': $! \n";
  }

  foreach (@files) {
    print $_, "\n";
  }

}

sub ids_pl {
  # ids.pl
  use warnings;
  use strict;
  # get user names and primary groups
  my ( %users, %usergroup );
  while ( my ( $name, $passwd, $uid, $gid ) = getpwent ) {
    $users{$name}     = $uid if $uid;
    $usergroup{$name} = $gid if $gid;
  }
  # get group names and gids
  my ( %groups, @groups );
  while ( my ( $name, $passwd, $gid ) = getgrent ) {
    $groups{$name} = $gid if $gid;
    $groups[$gid] = $name if $name && $gid;
  }
  # print out basic user and group information
  foreach my $user ( sort { $users{$a} <=> $users{$b} } keys %users ) {
    print "$users{$user}: $user, group $usergroup{$user}
($groups[$usergroup{$user}])\n";
  }
}

sub lcall_pl {
  # lcall.pl
  use warnings;
  use strict;
  use File::Find;
  use File::Copy;
  die "Usage: $0 <dir> [<dir>...] \n" unless @ARGV;
  foreach (@ARGV) {
    die "'$_' does not exist \n" unless -e $_;
  }

  sub lcfile {
    print "$File::Find::dir - $_ \n";
    move( $_, lc $_ );
  }
  finddepth( \&lcfile, @ARGV );
}

sub findsuid_pl {
  # findsuid.pl
  use warnings;
  use strict;
  use File::Find;
  my $count = 0;

  sub is_suid {
    if ( -x && ( -u _ || -g _ ) ) {
      $count++;
      print "\t'$File::Find::dir/$_' is ";
      if ( -u _ && -g _ ) {
        print "setuid and setgid \n";
      } elsif ( -u _ ) {
        print "setuid \n";
      } else {
        print "setgid \n";
      }
    }
  }
  print "Scanning for files in ", join( ', ', @ARGV ), ":\n";
  find( \&is_suid, @ARGV );
  print "$count setuid or setgid executables found \n";
}

sub checklink_pl {
  # checklink.pl
  use warnings;
  use strict;
  use File::Find;
  my $count = 0;

  sub check_link {
    if ( -l && !-e ) {
      $count++;
      print "\t$File::Find::name is broken \n";
    }
  }
  print "Scanning for broken links in ", join( ', ', @ARGV ), ":\n";
  find( \&check_link, @ARGV );
  print "$count broken links found \n";
}

sub ro3 {
  ### Temporary Files ###
  ### Creating a Temporary Filehandle ###
  my $tmphandle = IO::File->new_tmpfile();
  unless ($tmphandle) {
    print "Could not create temporary filehandle: $! \n";
  }
  $tmphandle->close();

### Temporary Filenames via the POSIX module ###
### POSIX::tmpnam() is deprecated in Perl 5.22.0 ###
  # use POSIX qw(tmpnam);
  use File::Temp qw/ :POSIX /;
  my $tmpname = tmpnam();
  print $tmpname, "\n";    # produces something like '/tmp/fileV9vJXperl'
  unlink $tmpname;

  do {
    my $newpath = '';
    $tmpname = tmpnam();
    $tmpname = $1 if $tmpname =~ m|/ ([^/]+) $|;    # strip '/tmp'
    $tmpname = $newpath . $tmpname;                 # add new path
  } while ( -e $tmpname );
  print $tmpname, "\n";
  unlink $tmpname;

  # get an open (and unique) temporary file
  use Fcntl;
  do {
    $tmpname = tmpnam();
    sysopen TMPFILE, $tmpname, O_RDWR | O_CREAT | O_EXCL;
  } until ( defined fileno(TMPFILE) );
  print $tmpname, "\n";
  unlink $tmpname;

### Using 'File::Temp' ###
  # ($FILEHANDLE, $filename) = tempfile($template, DIR => $dir, SUFFIX = $suffix);
  use File::Temp qw(tempfile);
  my ( $fh, $filename ) = tempfile();
  print $filename, "\n";
  unlink $filename;

  # mkstemp Using the provided template, this function returns the name of the temporary file
  # and a filehandle to it:
  # ($HANDLE, $name) = mkstemp($template);
  # If we are interested only in the filehandle, then we can use mkstemp in scalar
  # context.
  # mkstemps This is similar to mkstemp but accepts the additional option of a suffix that is
  # appended to the template:
  # ($HANDLE, $name) = mkstemps($template, $suffix);
  # mktemp This function returns a temporary filename but does not ensure that the file will
  # not be opened by a different process:
  # $unopened = mktemp($template);
  # Mkdtemp This function uses the given the template to create a temporary directory. The
  # name of the directory is returned upon success and undefined otherwise:
  # $dir = mktemp($template);
}

sub ro4 {
  ### Manipulating Directories ###

### Reading Directories ###
  #  open HANDLE, $filename; # open a filehandle
  #  opendir HANDLE, $dirname; # open a directory handle
  #  $line = <HANDLE>; # read a line from $filename
  #  $item = readdir HANDLE; # read an entry from $dirname
  #  close HANDLE; # close file $filename
  #  closedir HANDLE; # close directory $dirname

  # list permissions of all files in current directory
  # perl -MCPAN -e shell
  # install IO::All
  my %directory;
  tie %directory, 'IO::Dir', '.';
  foreach ( sort keys %directory ) {
    printf( "$_ has permissions %o \n", $directory{$_}->mode & 0777 );
  }
  untie %directory;

### Creating and Destroying Directories ###
### Creating Multiple Directories ###
  # foreach ('a', 'b', 'c') { mkdir $_; chdir $_; }

  #  mkpath ([
  #  '/usr/local/apps/myapp/manual',
  #  '/usr/local/apps/myapp/scripts',
  #  '/usr/local/apps/myapp/bin',
  #  '/usr/local/apps/myapp/lib/scripts',
  #  '/var/log/myapp',
  #  ], 1, 0755);

### Destroying Multiple Directories ###
  # use File::Path;
  # $verbose = 1;
  # $safe = 1;
  # rmtree $path, $verbose, $safe;
  # remove three directory trees silently and safely.
  # rmtree([ $path1, $path2, $path3 ], 0, 1);

  # perl -MCPAN -e shell
  # install File::Path

  #    use File::Path;    # import 'getcwd', 'fastcwd', 'fastgetcwd', and 'cwd'
  #    my $cwd = getcwd;  # slow, safe Perl
  #    print $cwd, "\n";
  #    $cwd = fastcwd;    # faster but potentially unsafe Perl
  #    print $cwd, "\n";
  #    $cwd = getfastcwd;    # alias for 'fastcwd'
  #    print $cwd, "\n";
  #    $cwd = cwd;           # use native platform support
  #    print $cwd, "\n";

  use Cwd qw(abs_path realpath fast_abs_path);
  # find the real path of 'filename'
  my $absdir = abs_path('/vmlinuz');
  print $absdir, "\n";
  # 'realpath' is an alias for 'abs_path'
  $absdir = realpath('/vmlinuz');
  print $absdir, "\n";
  # find the real path of our great grand parent directory
  $absdir = fast_abs_path('../..');
  print $absdir, "\n";

  # override system 'chdir' with 'chdir' from File::Path
  # use File::Path qw(chdir);
  print 'chdir() not exported by default', "\n" if !defined(&chdir);
}

sub example {
  ro4();
  my @array = ( 1, 2, 3 );
  printArray( 'array', @array );
  my %hash = ( one => 1, two => 2, three => 3 );
  printHash( 'hash', \%hash );
  sleep 0.6;
}

# -------------------------------- main --------------------------------
sub main() {
  # my $startTime = Time::HiRes::gettimeofday();
  # my $beginT    = time();
  example();
  my $elapsed_time = time() - $^T;
  # $^T just like $start_time=time() put it very beginning of perl script.
  print "\n# run time is: $elapsed_time second(s) \n";

  # my $endT = time();
  # printf( "%.4f\n", $endT - $beginT );
  # my $stopTime = Time::HiRes::gettimeofday();
  # printf( "%.4f\n", $stopTime - $startTime );
}
# -------------------------------- exit --------------------------------
main();
exit 0;
# sudo apt install -y perltidy
# http://perltidy.sourceforge.net/tutorial.html
# chapter13:Chapter 13 Manipulating Files and Directories
# Sun 12 Jun 2022 12:38:31 PM HKT
# f="/data/2022/perl/00_professional_perl_programming/church/example13.pl";perltidy -ce -l=128 -i=2 -nbbc -b ${f};
