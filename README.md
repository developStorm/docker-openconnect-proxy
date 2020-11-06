# Docker Open Connect Proxy

A Docker container that connects a cisco vpn w/ 2FA and starts a small socks proxy

## Why?

For when you need to access something on a full tunnel or poorly configured VPN but
don't want to route all of your host traffic through it.

## Usage

Set environment variables and run the container with `NET_ADMIN` CAP
