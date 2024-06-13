#! /bin/bash

if [ -f .env ]; then
    . .env

    if [ ! -d $DATA_SRC ]; then
        mkdir -p $DATA_SRC
    fi

    if [ ! -d $LOG_DIR ]; then
        mkdir -p $LOG_DIR
    fi

    if [ ! -d $DB_DATA ]; then
        mkdir -p $DB_DATA
    fi
fi
