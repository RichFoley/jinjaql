![Run Unittest](https://github.com/RichFoley/jinjaql/workflows/Run%20Unittest/badge.svg)
![GitHub issues](https://img.shields.io/github/issues/RichFoley/jinjaql)

![PyPI](https://img.shields.io/pypi/v/jinjaql)
![PyPI - Downloads](https://img.shields.io/pypi/dm/jinjaql?label=PyPI%20downloads)

# A SNAQL Based Query Engine

This project is a fork of the SNAQL project, where we hope to add the ability to pass in an optional function to 
execute the query when the query is called (delivers the data instead of the query string). 

## Installation

jinjaql is PIP installable:<br>
`$ pip install jinjaql`

## Documentation

You always can find the most recent docs with examples for [SNAQL](https://github.com/semirook/snaql) on [Snaql GitBook](https://semirook.gitbooks.io/snaql/content/).
Semirook's documents are fantastic, and the SQL templating is still the main knowlege you need.
The primary differences between [jinjaql](https://github.com/RichFoley/jinjaql) and [SNAQL](https://github.com/semirook/snaql) is [jinjaql](https://github.com/RichFoley/jinjaql) allows you run, cache, and return the results of the queries. 

### Using jinjaql
To use jinjaql, you create a factory based on the folder that contains the template files, an engine (otional), and a cache (optional). Below is an example if you only want to return a query string:

```
from jinjaql import factory

query_factory = factory.JinJAQL(
  folder_path='/templates,
)

queries = query_factory.load('my_queries.sql')

queries.query_name(name='David') #Returns the query string with 'David' added in place of the name parameter, default behavior of SNAQL

```

To use jinjaql with an engine, you must pass the engine as a function. The engine must have a `query_string` and `connection_string` parameter. The `query_string` is generated from the template and the parameters passed in. The `connection_string` should be added as a parameter in the `sql` tag of the template: <br>
Updated sql tag:`{% sql 'my_query', connection_string='///mydatabase' %}`<br>

```
from jinjaql import factory
import pandas as pd
import pyodbc


def pd_sql(query_string: str, connection_string: str):
  try:
    connection = pyodbc.connect(connection_string)
    return pd.read_sql_query(query_string, connection)
  except Exception as e:
    print(e)
  finally:
    connection.close()

query_factory = factory.JinJAQL(
  folder_path='/templates,
  engine=pd_sql,
)


queries = query_factory.load('my_queries.sql')

queries.query_name(name='David') #Returns a pandas dataframe of the query generated with the parameter 'David' for name.

```
Optionally, you can also passed in a decorator function for caching. A common example may be passing in lru_cache, which will return the result with running a query if the query_string, connection_string, and kwargs match any previous queries. Please be aware that this may create undesirable results if you're pulling new data, but the parameters for the query did not change (a new query will not be executed).

```
import functools

from jinjaql import factory
import pandas as pd
import pyodbc


def pd_sql(query_string: str, connection_string: str):
  try:
    connection = pyodbc.connect(connection_string)
    return pd.read_sql_query(query_string, connection)
  except Exception as e:
    print(e)
  finally:
    connection.close()

query_factory = factory.JinJAQL(
  folder_path='/templates,
  engine=pd_sql,
  cache=functools.lru_cache,
)


queries = query_factory.load('my_queries.sql')

queries.query_name(name='David') #Returns a pandas dataframe of the query generated with the parameter 'David' for name.
queries.query_name(name='David') #Returns the results from the previous query because the arguments did not change

```
