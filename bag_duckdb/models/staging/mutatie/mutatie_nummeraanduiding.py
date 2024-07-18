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
    # loop through all entities as specified in the yaml
    for entity in yml_dict['models'] :
        if entity['name'] == dbt.this.identifier :   
            nsmap = entity['meta']['namespaces']    
            logging.debug('Entity \'%s\' with %s attributes (%s)' % (entity['name'], \
                    len(entity['columns']), \
                    ', '.join(i['name'] for i in entity['columns'])))

            # loop through all attributes of the entity as specified in the yaml
            # and use the specified path to get the corresponding value
            # set the schema of all attributes to string!
            attributes = {}
            schema = []
            for attribute in entity['columns']:
                attributes[attribute['name']] = []
                schema.append((attribute['name'],pa.string()))
            # x if a > b else y    
            for entity_element in root.xpath(entity['meta']['xpath'], namespaces=nsmap):
                for attribute in entity['columns']:
                    node = entity_element.xpath(attribute['meta']['xpath'] if 'meta' in attribute else attribute['name'], namespaces=nsmap)
                    if node is not None and len(node) > 0:
                        if isinstance(node[0],etree._Element):
                            attributes[attribute['name']].append(node[0].text)
                        else:    
                            attributes[attribute['name']].append(node[0])
                    else:
                        attributes[attribute['name']].append(None)
            
            # write to parquet
            pa_schema = pa.schema(schema)
            pa_table = pa.Table.from_pydict(attributes, schema = pa_schema)
        
    return pa_table

