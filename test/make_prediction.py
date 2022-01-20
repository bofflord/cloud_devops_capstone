import requests, sys

def get_prediction(ip, port, parameters):

    api_url = f'http://{ip}:{port}/predict'
    print(f"api_url: {api_url}")

    headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}



    # sending get request and saving the response as response object
    r = requests.post(url = api_url, json = parameters, headers=headers)

    data = r.json()
    prediction = data['prediction'][0]
    print(f'prediction: {prediction}')
    
    return prediction