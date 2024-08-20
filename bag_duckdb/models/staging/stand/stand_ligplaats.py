import glob
import pyarrow as pa
import tempfile 
from zipfile import ZipFile
from datetime import datetime, timezone
 
# generiek kopieren voor ieder BAG object
def model(dbt, session):
    # tbv van lineage, query met bestandsnaam
    ligplaats_zipped_xml = dbt.source('lz_bag','ligplaats_zipped_xml').fetchall()[0][0]
    ligplaats_inactief_zipped_xml = dbt.source('lz_bag','ligplaats_inactief_zipped_xml').fetchall()[0][0]
    ligplaats_niet_bag_zipped_xml = dbt.source('lz_bag','ligplaats_niet_bag_zipped_xml').fetchall()[0][0]
    # ophalen config
    mnemonic = dbt.config.get('mnemonic')
    # aanmaken tempdir
    temp_dir = tempfile.TemporaryDirectory()
    tmpdirname = temp_dir.name
    # unzip bestanden in tempdir    
    ZipFile(ligplaats_zipped_xml, 'r').extractall(tmpdirname)
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {ligplaats_zipped_xml} uitgepakt")
    # in actief
    ZipFile(ligplaats_inactief_zipped_xml, 'r').extractall(tmpdirname)
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {ligplaats_inactief_zipped_xml} uitgepakt")        
    # niet BAG
    ZipFile(ligplaats_niet_bag_zipped_xml, 'r').extractall(tmpdirname)
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {ligplaats_niet_bag_zipped_xml} uitgepakt") 
    # lijst van te verwerken bestanden
    xml_files =  sorted(glob.glob(f"{tmpdirname}/*{mnemonic}*.xml"))
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {len(xml_files)} bestanden te verwerken")
    batches = []
    for i, xml_file in enumerate(xml_files, start=1):
        df = session.sql(f"from st_read('{xml_file}')").arrow()
        if df.num_rows > 0:
            rb = df.to_batches()[0]          
            batches.append(rb)
            print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  Batch {i} met {df.num_rows} rijen toegevoegd")
        else:
            print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  Batch {i} overgeslagen, leeg")      
    # temp dir opruimen    
    temp_dir.cleanup()    
    return pa.RecordBatchReader.from_batches(batches[0].schema, batches)




    

    
 