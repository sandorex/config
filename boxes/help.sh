#!/usr/bin/bash
# the default entrypoint for box images

cat <<EOF
Image made for use with box

To use this image install box using one of the following ways:

cargo:
    $ cargo install --git https://github.com/sandorex/box

Copy from from this container while its running:
    $ podman cp <CONTAINER_ID>:/usr/local/bin/box ./box

EOF

echo "Press any key to shutdown the container"
read -n1
echo "Goodbye."
