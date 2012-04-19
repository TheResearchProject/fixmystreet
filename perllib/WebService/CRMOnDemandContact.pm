package WebService::CRMOnDemandContact;

# Generated by SOAP::Lite (v0.714) for Perl -- soaplite.com
# Copyright (C) 2000-2006 Paul Kulchenko, Byrne Reese
# -- generated at [Fri Apr  6 12:41:22 2012]
## Please see file perltidy.ERR
my %methods = (
    ContactQueryPage_Input => {
        endpoint => '/Services/Integration',
        soapaction => 'document/urn:crmondemand/ws/ecbs/contact/10/2004:ContactQueryPage',
        namespace  => 'urn:crmondemand/ws/ecbs/contact/10/2004',
        parameters => [],
    },
    ContactInsert_Input => {
        endpoint => '/Services/Integration',
        soapaction => 'document/urn:crmondemand/ws/ecbs/contact/10/2004:ContactInsert',
        namespace  => 'urn:crmondemand/ws/ecbs/contact/10/2004',
        parameters => [],
    },
);

use SOAP::Lite;
use Exporter;
use Carp ();
use URI;

use vars qw(@ISA $AUTOLOAD @EXPORT_OK %EXPORT_TAGS);
@ISA         = qw(Exporter SOAP::Lite);
@EXPORT_OK   = ( keys %methods );
%EXPORT_TAGS = ( 'all' => [@EXPORT_OK] );

sub _call {
    my ( $self, $method ) = ( shift, shift );
    my $name =
      UNIVERSAL::isa( $method => 'SOAP::Data' ) ? $method->name : $method;
    my %method = %{ $methods{$name} };

    my $endpoint =
      URI->new( $self->{endpoint} . '/' . $method{endpoint} )
      ->canonical->as_string;
    $endpoint =~ s#(?<!:)//+#/#g;

    $self->proxy( $endpoint
          || Carp::croak "No server address (proxy) specified" )
      unless $self->proxy;
    my @templates  = @{ $method{parameters} };
    my @parameters = ();
    foreach my $param (@_) {
        if (@templates) {
            my $template = shift @templates;
            my ( $prefix, $typename ) =
              SOAP::Utils::splitqname( $template->type );
            my $method = 'as_' . $typename;

            # TODO - if can('as_'.$typename) {...}
            my $result =
              $self->serializer->$method( $param, $template->name,
                $template->type, $template->attr );
            push( @parameters, $template->value( $result->[2] ) );
        }
        else {
            push( @parameters, $param );
        }
    }
    $self->endpoint( $endpoint )->ns( $method{namespace} )
      ->on_action( sub { qq!"$method{soapaction}"! } );
    $self->serializer->register_ns( "urn:/crmondemand/xml/Contact/Data",
        "xsdLocal1" );
    $self->serializer->register_ns( "urn:/crmondemand/xml/Contact/Query",
        "xsdLocal2" );
    $self->serializer->register_ns(
        "urn:crmondemand/ws/ecbs/contact/10/2004", "tns" );
    my $som = $self->SUPER::call( $method => @parameters );
    if ( $self->want_som ) {
        return $som;
    }
    UNIVERSAL::isa( $som => 'SOAP::SOM' )
      ? wantarray
          ? $som->paramsall
          : $som->result
      : $som;
}

sub BEGIN {
    no strict 'refs';
    for my $method (qw(want_som)) {
        my $field = '_' . $method;
        *$method = sub {
            my $self = shift->new;
            @_
              ? ( $self->{$field} = shift, return $self )
              : return $self->{$field};
          }
    }
}
no strict 'refs';
for my $method (@EXPORT_OK) {
    my %method = %{ $methods{$method} };
    *$method = sub {
        my $self =
            UNIVERSAL::isa( $_[0] => __PACKAGE__ )
          ? ref $_[0]
              ? shift  # OBJECT
                       # CLASS, either get self or create new and assign to self
              : ( shift->self || __PACKAGE__->self( __PACKAGE__->new ) )

              # function call, either get self or create new and assign to self
          : ( __PACKAGE__->self || __PACKAGE__->self( __PACKAGE__->new ) );
        $self->_call( $method, @_ );
      }
}

sub AUTOLOAD {
    my $method = substr( $AUTOLOAD, rindex( $AUTOLOAD, '::' ) + 2 );
    return if $method eq 'DESTROY' || $method eq 'want_som';
    die
"Unrecognized method '$method'. List of available method(s): @EXPORT_OK\n";
}

1;
