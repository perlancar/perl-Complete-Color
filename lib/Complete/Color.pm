package Complete::Color;

use 5.010001;
use strict;
use warnings;
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

use Complete::Common qw(:all);
use Exporter qw(import);

our @EXPORT_OK = qw(
                       complete_known_host
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to colors',
};

$SPEC{'complete_color_name'} = {
    v => 1.1,
    summary => 'Complete from color names',
    description => <<'MARKDOWN',

Currently color names are taken from `Graphics::ColorNamesLite::*` modules.

MARKDOWN
    args => {
        %arg_word,
        lang => {
            schema => ['str*', match=>qr/\A[A-Z][A-Z]\z/],
        },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_en_color_name {
    my %args = @_;

    my $lang = $args{lang};

    my $mod;
    if ($lang) {
        return [400, "Invalid syntax for lang, must be two uppercase digits"] unless $lang =~ /\A[A-Z][A-Z]\z/;
        $mod = $lang;
    } else {
        $mod = "All";
    }
    $mod = "Graphics::ColorNamesLite::$mod";
    (my $mod_pm = "$mod.pm") =~ s!::!/!g;
    require $mod_pm;

    require Complete::Util;
    no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict
    Complete::Util::complete_hash_key(hash => ${"$mod\::NAMES_RGB_TABLE"}, word=>$args{word});
}

1;
# ABSTRACT:

=for Pod::Coverage .+

=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
