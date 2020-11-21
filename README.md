# A SNAQL Based Query Engine

This project is a fork of the SNAQL project, with the added ability to pass in an optional function to 
execute the query when the query is called (delivers the data instead of the query string). Also added 
optional caching of results if the passed parameters are unchanged.

## Installation

```sh
# PyPI:
pip install jinjaql
``` 

## Documentation

You always can find the most recent docs with examples for SNAQL on [Snaql GitBook](https://semirook.gitbooks.io/snaql/content/).
Semirook's documents are fantastic, and the SQL templating is still the main knowledge you need.
We will add the requirements for the SQL engine once we have the details worked out.

## Usage

This section outlines where the Jinjaql package deviates from the SNAQL documentation:

Normal usage (to get Jinjaql to function like Snaql):
```python
from jinjaql import factory
import pathlib

query_factory =  factory.JinJAQL(folder_path=pathlib.Path(r'folder_path'))

queries = query_factory.load_queries('sql_templates.sql')

query_str = queries.my_query()

```

Add a query engine to execute the query using pyodbc and Pandas to return a DataFrame and 
add caching for repeated queries:



```python
from jinjaql import factory
import pathlib
import pandas as pd
import pyodbc

#TODO: Add example template file

# Connection string in query templates header block

def sql_engine(query_string, connection_string):

    connection = pyodbc.connect(connection_string)
    try:
        return pd.read_sql_query(query_string, connection)
    except Exception as e:
        print(e)
    finally:
        connection.close()


query_factory =  factory.JinJAQL(
    folder_path=pathlib.Path(r'folder_path'),
    engine=sql_engine,
    cache=True,
    )

queries = query_factory.load_queries('sql_templates.sql')

query_df = queries.my_query()

```