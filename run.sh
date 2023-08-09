#!/bin/bash

if [ "$LUMIGO_TRACER_TOKEN" = "" ]; then
  echo "Please configure the LUMIGO_TRACER_TOKEN environment variable"
  exit 1
fi
FUNC_NAME=func1

echo 'def handler(*args, **kwargs):' > /tmp/testlambda.py
echo '  print("Debug output from Lambda function")' >> /tmp/testlambda.py
echo 'exports.handler = async (event) => { console.log(JSON.stringify(event)); return "Hello from LocalStack"; }' > /tmp/testlambda.js
(cd /tmp; zip testlambda.zip testlambda.py testlambda.js)

# Python:
#awslocal lambda create-function --function-name $FUNC_NAME --runtime python3.8 \
#  --role arn:aws:iam::000000000000:role/r1 --handler testlambda.handler \
#  --timeout 30 --zip-file fileb:///tmp/testlambda.zip \
#  --layers arn:aws:lambda:us-east-1:114300393969:layer:lumigo-python-tracer:246 \
#  --environment 'Variables={AWS_LAMBDA_EXEC_WRAPPER=/opt/lumigo_wrapper,LUMIGO_DEBUG=true,LUMIGO_PROPAGATE_W3=true,LUMIGO_TRACER_TOKEN='$LUMIGO_TRACER_TOKEN'}'

# Node.js:
awslocal lambda create-function --function-name $FUNC_NAME --runtime nodejs18.x \
  --role arn:aws:iam::000000000000:role/r1 --handler testlambda.handler \
  --timeout 30 --zip-file fileb:///tmp/testlambda.zip \
  --layers arn:aws:lambda:us-east-1:114300393969:layer:lumigo-node-tracer:246 \
  --environment 'Variables={AWS_LAMBDA_EXEC_WRAPPER=/opt/lumigo_wrapper,LUMIGO_DEBUG=true,LUMIGO_PROPAGATE_W3=true,LUMIGO_TRACER_TOKEN='$LUMIGO_TRACER_TOKEN'}'

awslocal lambda wait function-active-v2 --function-name $FUNC_NAME
awslocal lambda invoke --function-name $FUNC_NAME /tmp/tmp.out
