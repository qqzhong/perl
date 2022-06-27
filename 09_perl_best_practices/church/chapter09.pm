use Contextual::Return;

sub get_server_status {
  my ($server_ID) = @_;
  # Acquire server data somehow...
  my %server_data = _ascertain_server_status($server_ID);
  # Return different components of that data, depending on call context...
  return (
    LIST    { @server_data{qw( name uptime load users )}; }
    BOOL    { $server_data{uptime} > 0; }
    NUM     { $server_data{load}; }
    STR     { "$server_data{name}: $server_data{uptime}, $server_data{load}"; }
    HASHREF { \%server_data; }
  );
}

sub defined_samples_in {
  return (
    LIST {
      grep { defined $_ } @_
    }    # All defined vals
    SCALAR {
      first { defined $_ } @_
    }    # One defined val
    NUM {
      scalar grep { defined $_ } @_
    }    # How many vals defined?
    ARRAYREF {
      [ grep { defined $_ } @_ ]
    }    # Return vals in an array
  );
}
