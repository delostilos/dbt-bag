import glob
import pyarrow as pa
import tempfile 
from lxml import etree
from datetime import datetime, timezone

# generiek kopieren voor ieder BAG object
def model(dbt, session):
    # ophalen config
    extract_levering = dbt.source('lz_bag','extract_levering').fetchone()
    sourcedir = extract_levering[0]
    mnemonic = extract_levering[1]
    extension = extract_levering[2]
    table = dbt.config.get('table')
    namespaces = dbt.config.get('namespaces')  
    # lijst van te verwerken bestanden
    xml_files =  sorted(glob.glob(f"{sourcedir}Leveringsdocument-{mnemonic}-Extract.{extension}"))
    print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  {len(xml_files)} bestanden te verwerken")
    batches = []
    for i, xml_file in enumerate(xml_files, start=1):
        doc = etree.parse(xml_file)
        root = doc.getroot()
        pa_table = None
        # loop through all columns of the table as specified in the yaml
        # and use the specified path to get the corresponding value
        # set the schema of all columns to string!
        columns = {}
        schema = []
        for column in table['columns']:
            columns[column['name']] = []
            schema.append((column['name'],pa.string()))
        # load the dictionairy of columns with array of values (columnar ;-)   
        for table_element in root.xpath(table['meta']['xpath'], namespaces=namespaces):
            for column in table['columns']:
                # load the xpath of the column, if not defined assume it is the same as the name
                node = table_element.xpath(column['meta']['xpath'] if 'meta' in column else column['name'], namespaces=namespaces)
                # check if the node contains something
                if node is not None and len(node) > 0:
                    # check if the node is an element
                    if isinstance(node[0],etree._Element):
                        # check if we have a single element or a list of elements
                        if len(node) == 1:
                            columns[column['name']].append(node[0].text)
                        # store the list in a comma delimited string    
                        else:
                            text_list = [el.text for el in node]
                            columns[column['name']].append(','.join(text_list))
                    # check if the node is an unicode string        
                    elif isinstance(node, etree._ElementUnicodeResult):
                        columns[column['name']].append(node)  
                    # if not it is the node itself we need, then probably an attribute              
                    else:    
                        columns[column['name']].append(node[0])
                else:
                    columns[column['name']].append(None)
        
        # write to record batch
        pa_schema = pa.schema(schema)  
        pa_table = pa.RecordBatch.from_pydict(columns, schema = pa_schema) 
        batches.append(pa_table)
        print(f"{datetime.now(timezone.utc).strftime('%H:%M:%S')}  Batch {i} met {pa_table.num_rows} rijen toegevoegd")      
    return pa.RecordBatchReader.from_batches(batches[0].schema, batches)




    

    
 