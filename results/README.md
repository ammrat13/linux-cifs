# Linux RDMA Hang: Results

## Structure

Each configuration I tested has a `deb/` and a `logs/` directory.

The `deb/` directory contains the version of the kernel I used.

The `logs/` directory contains results of `dmesg` and of `trace-cmd` on some
events and functions (given in the Ansible playbook). The `dmesg.log` is just
the unaltered output of `dmesg`. The `trace-cmd` report has been split into the
lines pertaining to the `function_graph` plugin - given in
`trace-cmd-funcgraph.log`, and the lines pertaining to events - given in
`trace-cmd-events.log`.

## Configurations

- `rxe/bad/`: The "bad" kernel with RXE
- `rxe/good/`: The "good" kernel with RXE
- `siw/bad/`: The "bad" kernel with SIW
