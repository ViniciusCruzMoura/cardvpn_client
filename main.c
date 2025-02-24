#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define shift( xs, xs_sz ) ( assert( xs_sz > 0 ), --xs_sz, *xs++ )

int main( int argc, char *argv[] ) 
{
    const char *program_name = shift(argv, argc);

    if ( argc < 1 ) {
        fprintf(stderr, "Usage: '%s <option> help' to get help on each command\n", program_name);
        return 1;
    }

    const char *command_name = shift(argv, argc);

    if ( strcmp(command_name, "version") == 0 ) {
        printf( "%s Version %s\n", program_name , PROGRAM_VERSION );
        return 0;
    } else if ( strcmp( command_name, "cg" ) == 0 ) {
        system( "openconnect " VPN_CG_PROXY );
        return 0;
    } else if ( strcmp( command_name, "sp3" ) == 0 ) {
        system( "openconnect --protocol=fortinet " VPN_SP3_PROXY );
        return 0;
    } else {
        fprintf( stderr, "ERROR: unknown command %s\n", command_name );
        return 1;
    }
    return 0;
}
//     int have_openconnect = 0;
//     if ( system( "ls -la openconnect-master/ > /dev/null 2>&1" ) == 0 )
//         have_openconnect = 1;
//     if ( !have_openconnect ) {
//         system( "wget https://gitlab.com/openconnect/openconnect/-/archive/master/openconnect-master.tar.gz &&"
//                 "tar -xf openconnect-master.tar.gz && rm -f openconnect-master.tar.gz &&"
//                 "cd openconnect-master/ && ./autogen.sh && ./configure && make"
//               );
//     }
