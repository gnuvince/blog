#!/bin/bash
rsync -e "ssh -p 2222"  -avr public vfoley@vfoley.xyz:/var/www/
