# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibxcBuilder"
version = v"4.3.4"

# Collection of sources required to build LibxcBuilder
sources = [
    "https://gitlab.com/libxc/libxc/-/archive/4.3.4/libxc-4.3.4.tar.gz" =>
    "2d5878dd69f0fb68c5e97f46426581eed2226d1d86e3080f9aa99af604c65647",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libxc-4.3.4/
autoreconf -i
./configure --prefix=$prefix --host=$target --enable-shared
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    MacOS(:x86_64),
    Linux(:x86_64, libc=:glibc),
    Linux(:i686, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "xc-threshold", :xcthreshold),
    LibraryProduct(prefix, "libxc", :libxc),
    ExecutableProduct(prefix, "xc-info", :xcinfo)
]

# Dependencies that must be installed before this package can be built
dependencies = [

]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
