# Common utils
`apt install lsscsi sg3-utils mtx mt-st sysstat`

# Change tape script
```bash
#!/bin/bash
answer=""
while [ "$answer" != "done" ]; do
    read -p "Current tape is full. Please insert a new tape and answer 'done' to continue or press Ctrl+C to stop >> " answer
done

```

# Set compression and clean tape
`mt defcompression 0; mt rewind; mt erase 0; mt compression 0; mt status`

`erase 0` = quick erase / `erase` or `erase 1` = long erase

# Backup
`tar --verbose --totals --create --multi-volume --blocking-factor=2048 --new-volume-script="/home/whc/tape_change.sh"  --file=/dev/nst0 ...`

# View write speed
`tapestat --human 1`
