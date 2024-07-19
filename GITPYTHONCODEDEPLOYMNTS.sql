
-- create sample data to support the code in this article
-- use python udf to generate fake data
CREATE OR REPLACE FUNCTION FAKE(locale varchar,
                                provider varchar,
                                PARAMETERS variant) 
RETURNS variant 
LANGUAGE python 
VOLATILE 
runtime_version = '3.8' 
packages = ('faker',,'simplejson')                                                                                                                                                                'simplejson')
HANDLER = 'fake' 
AS 
$$
import simplejson as json
from faker import Faker
def fake(locale,provider,parameters):
  if type(parameters).__name__=='sqlNullWrapper':
    parameters = {}
  fake = Faker(locale=locale)
  return json.loads(json.dumps(fake.format(formatter=provider,**parameters), 
        default=str))
$$;

CREATE OR REPLACE TABLE  customers AS
SELECT 
    ABS(RANDOM()) AS CUSTOMER_ID,
    FAKE('en_US','first_name',null)::varchar AS FIRST_NAME,
    FAKE('en_US','last_name',null)::varchar AS LAST_NAME,
    FAKE('en_US','phone_number',null)::varchar AS PHONE_NO,
    FAKE('en_US','free_email',null)::varchar AS EMAIL,
    FAKE('en_US','state_abbr',null)::varchar AS STATE
FROM TABLE(GENERATOR(ROWCOUNT => 1000));