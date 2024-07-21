import glob
import pyarrow as pa
import tempfile 
from zipfile import ZipFile
 
# generiek kopieren voor ieder BAG object
def model(dbt, session):
    # ophalen config
    sourcedir = dbt.config.get('sourcedir')
    mnemonic = dbt.config.get('mnemonic')
    datum = dbt.config.get('date')
    area = dbt.config.get('area')
    # aanmaken tempdir
    temp_dir = tempfile.TemporaryDirectory()
    tmpdirname = temp_dir.name
    # unzip bestanden in tempdir    
    ZipFile(f"{sourcedir}{area}{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)
    print(f"........  {mnemonic} uitgepakt")
    # in actief
    ZipFile(f"{sourcedir}{area}IA{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)
    print(f"........  {mnemonic} IA uitgepakt")        
    # niet BAG
    ZipFile(f"{sourcedir}{area}NB{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)
    print(f"........  {mnemonic} NB uitgepakt") 
    # lijst van te verwerken bestanden
    xml_files =  sorted(glob.glob(f"{tmpdirname}/*{mnemonic}*.xml"))
    print(f"........  {len(xml_files)} bestanden te verwerken")
    batches = []
    for i, xml_file in enumerate(xml_files, start=1):
        df = session.sql(f"from st_read('{xml_file}')").arrow()
        if df.num_rows > 0:
            rb = df.to_batches()[0]          
            batches.append(rb)
            print(f"........  Batch {i} toegevoegd")
        else:
            print(f"........  Batch {i} overgeslagen, leeg")      
    # temp dir opruimen    
    temp_dir.cleanup()    
    return pa.RecordBatchReader.from_batches(batches[0].schema, batches)




    

    
 