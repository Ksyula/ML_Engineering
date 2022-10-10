from urllib import response
import requests

host = "card-serving-env.eba-d4hrhyjh.eu-west-1.elasticbeanstalk.com"
remote_url = f"http://{host}/predict"
url = "http://localhost:9696/predict"

customer = {
    "reports": 0,
    "share": 0.245, 
    "expenditure": 3.438, 
    "owner": "yes"
}

response = requests.post(remote_url, json = customer).json()
print(response)