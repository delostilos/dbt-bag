from lxml import etree
import pyarrow as pa
import pyarrow.parquet as pq
import yaml
import time
import logging


def model(dbt, session):
    sourcefile = dbt.config.get('sourcefile')
    modelfile = dbt.config.get('modelfile')
    # read source xml
    xml_fobj = open(sourcefile,"r")
    doc = etree.parse(xml_fobj)
    root = doc.getroot()
    # read config yml
    yml_fobj = open(modelfile,"r")
    yml_dict = yaml.safe_load(yml_fobj)
    
    pa_table = None
    # loop through all tables as specified in the yaml
    for table in yml_dict['models'] :
        # filter on the current table
        if table['name'] == dbt.this.identifier :   
            nsmap = table['meta']['namespaces']    
            # loop through all columns of the table as specified in the yaml
            # and use the specified path to get the corresponding value
            # set the schema of all columns to string!
            columns = {}
            schema = []
            for column in table['columns']:
                columns[column['name']] = []
                schema.append((column['name'],pa.string()))
            # load the dictionairy of columns with array of values (columnar ;-)    
            for table_element in root.xpath(table['meta']['xpath'], namespaces=nsmap):
                for column in table['columns']:
                    # load the xpath of the column, if not defined assume it is the same as the name
                    node = table_element.xpath(column['meta']['xpath'] if 'meta' in column else column['name'], namespaces=nsmap)
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
            
            # write to parquet
            pa_schema = pa.schema(schema)
            pa_table = pa.Table.from_pydict(columns, schema = pa_schema)
        
    return pa_table

