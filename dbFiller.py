""" Module that makes insertions in ZQL database"""

import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()


def insert(cursor, filename: str) -> None:
    """ Performs insertion query written on file"""

    with open(filename, encoding='utf8') as f:
        cursor.execute(f.read())

        print(filename)

        f.close()


conn = psycopg2.connect(
    database=os.getenv('DATABASE'),
    host=os.getenv('HOST'),
    user=os.getenv('USER'),
    password=os.getenv('PASSWORD'),
    port=os.getenv('PORT')
)

file_names = [
    './data/att_insertions.txt',
    './data/reg_insertions.txt',
    './data/jou_insertions.txt',
    './data/op_insertions.txt',
    './data/prod_insertions.txt',
    './data/film_insertions.txt',
    './data/tvs_insertion.txt',
    './data/st_insertions.txt',
    './data/ep_insertions.txt',
    './data/cast_insertions.txt',
    './data/oe_insertions.txt',
    './data/venezia_insertions.txt',
    './data/compst_attore.txt',
    './data/compst_regista.txt',
    './data/compst_giornalista.txt',
    './data/nom_oe_insertions.txt',
    './data/nom_ven_insertions.txt',
    './data/spect_insertions.txt',
    './data/follow_insertions.txt',
    './data/gest_insertions.txt',
    './data/proj_insertions.txt',
    './data/sub_insertions.txt',
    './data/rev_insertions.txt',
    './data/comm_insertions.txt',
    './data/vota_att_insertions.txt',
    './data/vota_dir_insertions.txt',
    './data/vota_gior_insertions.txt',
    './data/vota_spect_insertions.txt'
]


for file in file_names:
    cursor = conn.cursor()

    insert(cursor, file)

    conn.commit()

    cursor.close()

conn.close()
