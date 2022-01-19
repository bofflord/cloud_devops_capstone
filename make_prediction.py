import requests, sys

IP=sys.argv[1]
PORT=sys.argv[2]

api_url = f'http://{IP}:{PORT}/predict'
print(f"api_url: {api_url}")

headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}

parameters = {  
   "CHAS":{  
      "0":0
   },
   "RM":{  
      "0":6.575
   },
   "TAX":{  
      "0":296.0
   },
   "PTRATIO":{  
      "0":15.3
   },
   "B":{  
      "0":396.9
   },
   "LSTAT":{  
      "0":4.98
   }
}

# sending get request and saving the response as response object
r = requests.post(url = api_url, json = parameters, headers=headers)

data = r.json()

print('prediction')
print(data['prediction'][0])