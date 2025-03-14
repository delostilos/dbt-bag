import glob
import pyarrow as pa
import tempfile 
from zipfile import ZipFile
from datetime import datetime, timezone

def levering(dbt, session):
    # area en datum uit leverings info bestand.
    stand_levering = dbt.ref('stand_levering').fetchone()
    datum_levering = stand_levering[0]
    area_levering = stand_levering[1]
    if area_levering == None :
        area_levering = '9999' # landelijk
    datum_array = datum_levering.split("-") 
    datum_string = f"{datum_array[2]}{datum_array[1]}{datum_array[0]}" 
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  datum levering {datum_levering}, area levering {area_levering}")
    return {"datum": datum_string, "area": area_levering}
 
# generiek kopieren voor ieder BAG object
def model(dbt, session):
    levering_config = levering(dbt,session)
    # tbv van lineage, query met bestandsnaam
    bag_config = dbt.source('lz_bag','pand').fetchone()
    sourcedir = bag_config[0]
    base_mnemonic = bag_config[1]
    extension = bag_config[2]
    menemonics =[]
    # standaard historie
    menemonics.append(base_mnemonic)
    # inactief historie
    menemonics.append(f"IA{base_mnemonic}")
    # niet bag historie
    menemonics.append(f"NB{base_mnemonic}")
    # aanmaken tempdir
    temp_dir = tempfile.TemporaryDirectory()
    tmpdirname = temp_dir.name
     
    # unzip bestanden in tempdir 
    for mnemonic in sorted(menemonics):
        zipfile = f"{sourcedir}{levering_config['area']}{mnemonic}{levering_config['datum']}.{extension}"
        ZipFile(zipfile, 'r').extractall(tmpdirname)
        print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {zipfile} uitgepakt")
    # lijst van te verwerken bestanden
    xml_files =  sorted(glob.glob(f"{tmpdirname}/*{base_mnemonic}*.xml"))
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {len(xml_files)} bestanden te verwerken")
    batches = []
    for i, xml_file in enumerate(xml_files, start=1):
        df = session.sql(f"from st_read('{xml_file}')").arrow()
        if df.num_rows > 0:
            rb = df.to_batches()[0]          
            batches.append(rb)
            print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  Batch {i} met {df.num_rows} rijen toegevoegd ({xml_file.split('/')[-1]})")
        else:
            print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  Batch {i} overgeslagen, leeg  ({xml_file.split('/')[-1]})")      
    # temp dir opruimen    
    temp_dir.cleanup()    
    return pa.RecordBatchReader.from_batches(batches[0].schema, batches)




    

    
 