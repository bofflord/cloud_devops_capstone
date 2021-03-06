
import pytest

def test_make_prediction():
    from make_prediction import get_prediction

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

    result = 20.35373177134412

    assert get_prediction('localhost', '8080', parameters) == (result)

if __name__ == "__main__":
    # load pretrained model as clf
    test_make_prediction()