import bentoml
from bentoml.io import JSON
from pydantic import BaseModel

class UserProfile(BaseModel):
    seniority: int
    home: str
    time: int
    age: int
    marital: str
    records: str
    job: str
    expenses: int
    income: float
    assets: float
    debt: float
    amount: int
    price: int

model_ref = bentoml.xgboost.get("credit_risk_model:dtlts7cv4s2nbhht")
dv = model_ref.custom_objects['dictVectorizer']
model_runner = model_ref.to_runner()

svc = bentoml.Service("credit_risk_classifier", runners = [model_runner])

@svc.api(input=JSON(pydantic_model=UserProfile), output=JSON())
def classify(user_profile):
    aplication_data = user_profile.dict()
    vector = dv.transform(aplication_data)
    predictions = model_runner.predict.run(vector)
    print(predictions)
    return { "pred" : predictions[0] }
