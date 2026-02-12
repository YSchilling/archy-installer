#!/bin/bash

parted "$diskname" mklabel gpt
parted "$diskname" mkpart primary ext4 1MiB 10GiB