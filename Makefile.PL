
# $Id: Makefile.PL,v 1.13 1998/12/13 08:27:23 mergl Exp $

use ExtUtils::MakeMaker;
use Config;
use strict;

print "\nConfiguring Pg\n";
print "Remember to actually read the README file !\n";
die "\nYou didn't read the README file !\n" unless ($] >= 5.002);

if (! $ENV{POSTGRES_HOME}) {
    warn "\$POSTGRES_HOME not defined. Searching for PostgreSQL...\n";
    foreach(qw(/usr/local/pgsql /usr/lib/pgsql /usr/pgsql /home/pgsql /opt/pgsql /usr/local/postgres /usr/lib/postgres /usr/postgres /home/postgres /opt/postgres /usr/local/postgresql /usr/lib/postgresql /usr/postgresql /home/postgresql /opt/postgresql)) {
        if (-d "$_/lib") {
            $ENV{POSTGRES_HOME} = $_;
            last;
        }
    }
}

if (-d "$ENV{POSTGRES_HOME}/lib") {
    print "Found PostgreSQL in $ENV{POSTGRES_HOME}\n";
} else {
    die "Unable to find PostgreSQL\nplease set environment variable POSTGRES_HOME\n";
}


my %opts = (
    NAME         => 'Pg',
    VERSION_FROM => 'Pg.pm',
    INC          => "-I$ENV{POSTGRES_HOME}/include",
    OBJECT       => "Pg\$(OBJ_EXT)",
    LIBS         => ["-L$ENV{POSTGRES_HOME}/lib -lpq"],
);

my $os = $^O;
my $osvers = $Config{osvers};
if ($os eq 'hpux') {
    if ($osvers < 10) {
        print "Warning: Forced to build static not dynamic on $os $osvers.\a\n";
        $opts{LINKTYPE} = 'static';
    }
}

if ($Config{dlsrc} =~ /dl_none/) {
    $opts{LINKTYPE} = 'static';
}


WriteMakefile(%opts);

exit(0);

# end of Makefile.PL
