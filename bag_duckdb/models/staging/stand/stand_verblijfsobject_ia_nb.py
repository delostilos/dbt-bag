import glob
import pyarrow as pa
import tempfile 
from zipfile import ZipFile
 
# generiek kopieren voor ieder BAG object - VBO IA NB apart vanwege run problemen
def model(dbt, session):
    # ophalen config
    sourcedir = dbt.config.get('sourcedir')
    mnemonic = dbt.config.get('mnemonic')
    datum = dbt.config.get('date')
    area = dbt.config.get('area')
    # aanmaken tempdir
    temp_dir = tempfile.TemporaryDirectory()
    tmpdirname = temp_dir.name
    #print(f"... temp dir {tmpdirname} aangemaakt")
    # unzip bestanden in tempdir    
    #ZipFile(f"{sourcedir}{area}{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)
    #print('... VBO uitgepakt')
    # in actief
    ZipFile(f"{sourcedir}{area}IA{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)  
    #print('... VBO IA uitgepakt')      
    # niet BAG
    ZipFile(f"{sourcedir}{area}NB{mnemonic}{datum}.zip", 'r').extractall(tmpdirname)
    #print('... VBO NB uitgepakt')
    # lijst van te verwerken bestanden
    xml_files =  sorted(glob.glob(f"{tmpdirname}/*{mnemonic}*.xml"))
    batches = []
    #print(xml_files)
    for xml_file in xml_files:
        df = session.sql(f"from st_read('{xml_file}')").df()
        #print(len(df))
        if not df.empty:
            rb = pa.record_batch(df)
            batches.append(rb)
            #print('... batch toegevoegd')
    # temp dir opruimen    
    temp_dir.cleanup()    
    #print('... temp dir opgeruimd')
    return pa.RecordBatchReader.from_batches(batches[0].schema, batches)




    

    
 