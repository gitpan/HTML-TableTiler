package HTML::TableTiler;
$VERSION = '1.01';
use 5.005;
use Carp qw ( croak );
use HTML::PullParser 1.0;
use Exporter (); @ISA = qw( Exporter ); @EXPORT_OK =  qw( tile_table );
use strict;

sub new
{
    my $c = shift;
    my $s = _parse_table(&_read_tile);
    bless $s, $c;
}

sub _read_tile
{
    local $_ = shift ||  \ '<table><tr><td></td></tr></table>';
    if    (ref eq 'SCALAR') { $_ = $$_ }
    elsif (ref eq 'GLOB' || ref  \$_ eq 'GLOB') { $_ = do{local $/; <$_>} }
    elsif ($_ && !ref) { open _ or croak "Error opening the tile file \"$_\": ($^E)";
                           $_ = do{local $/; <_>}; close _ }
    else  { croak 'Wrong tile parameter type: '. (ref||'UNDEF') }
    $_ or croak 'The tile content is empty';
}

sub tile_table
{
    my ($s, $data_matrix, $tile, $mode);
    if (UNIVERSAL::isa($_[0], __PACKAGE__)) { ($s, $data_matrix, $mode)    = @_ }
    else                                     { ($data_matrix, $tile, $mode) = @_;
	                                            $s = __PACKAGE__->new($tile) ; undef $tile }
    # bi-dimensional array check
    for ( @$data_matrix )
    {
        if   ( ref eq 'ARRAY' )
             { for (@$_) { not ref or croak 'Wrong data matrix content: a cell cannot contain a reference' } }
        else { croak 'Wrong data matrix content: a row must be a reference to an array' }
    }

    # set Hmode and Vmode
	my $m = qr/(PULL|TILE|TRIM)/;
	my ($Hmode) = $mode =~ /\b H_ $m \b/x; $Hmode ||= 'PULL';
	my ($Vmode) = $mode =~ /\b V_ $m \b/x; $Vmode ||= 'PULL';

    # spread table
    my $out = "\n";
    ROW: for (my ($dmi, $tmi); $dmi <= $#$data_matrix; $dmi++, $tmi++)
    {
        if ($tmi > $#{$s->{rows}})
        {
            if    ($Vmode eq 'PULL') { $tmi = $#{$s->{rows}} }
            elsif ($Vmode eq 'TILE') { $tmi = 0 }
            elsif ($Vmode eq 'TRIM') { last ROW }
        }
        $out .= $s->{rows}->[$tmi]{Srow}."\n";
        my $data_cells = $data_matrix->[$dmi];
        my $html_cells = $s->{rows}->[$tmi]{cells} ;

        CELL: for (my ($di, $ti); $di <= $#$data_cells; $di++, $ti++)
        {
            if ($ti > $#$html_cells)
            {
                if    ($Hmode eq 'PULL') { $ti = $#$html_cells }
                elsif ($Hmode eq 'TILE') { $ti = 0 }
                elsif ($Hmode eq 'TRIM') { last CELL }
            }
            $out .= "\t".$html_cells->[$ti]{Scell}
                        .$data_cells->[$di].$html_cells->[$ti]{Ecell}."\n";
        }
        $out .= $s->{rows}->[$tmi]{Erow}."\n" ;
    }
    $s->{start}.$out.$s->{end};
}


sub _parse_table
{
    my ( $content, $p, $rows, $ri, $di, $ignore, $td, $in_tr, $in_td) = shift;
    my ($start, $Hrows, $end) = $content =~ m|^(.*?)( <TR[^>]*?> .* </TR> )(.*)$|xsi;
    $Hrows or croak 'The tile does not contain any "<tr>...</tr>" area';

    eval {
    	     local $SIG{__DIE__};
             $p = HTML::PullParser->new( doc   => $Hrows,
                                         start => 'tag, text',
                                         end   => 'tag, text'  )
         }
    || croak "Problem with the HTML parser: $@";

    while ( my $tok = $p->get_token )
    {
        my ($tag, $text) = @$tok;
        if    ($tag eq "tr")
        {
        	(not $in_tr and not $in_td) or _illegal_tag($text);
        	$rows->[$ri]{Srow} = $text;
        	$in_tr = 1;
        }
        elsif ($tag eq "/tr")
        {
        	($in_tr and not $in_td) or _illegal_tag($text);
        	$rows->[$ri++]{Erow} = $text;
        	$in_tr = 0;
        	$di = 0;
        }
        elsif ($tag eq "td")
        {
        	($in_tr and not $in_td) or _illegal_tag($text);
        	$rows->[$ri]{cells}[$di]{Scell} = $text;
        	$in_td = 1;
        }
        elsif ($tag eq "/td" )
        {
        	($in_tr and $in_td) or _illegal_tag($text) ;
        	$rows->[$ri]{cells}[$di++]{Ecell} .= $text;
        	$in_td = 0;
        	$td++;
        }
        elsif ($tag !~ m|^/| )
        {
        	($in_tr and $in_td) or _illegal_tag($text) ;
        	$rows->[$ri]{cells}[$di]{Scell} .= $text if $in_td
        }
        elsif ($tag =~ m|^/|)
        {
        	($in_tr and $in_td) or _illegal_tag($text) ;
        	$rows->[$ri]{cells}[$di]{Ecell} .= $text if $in_td
        }
    }
    $td or croak 'The tile does not contain any "<td>...</td>" area';
    { start => $start, rows => $rows, end => $end };
}

sub _illegal_tag { croak "Unespected HTML tag $_[0] found in the tile" }

1;