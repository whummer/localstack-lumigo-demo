const { DynamoDB } = require('@aws-sdk/client-dynamodb');
const { SQS } = require('@aws-sdk/client-sqs');

exports.handler = async (event) => {
  console.log(JSON.stringify(event));

  // scan items from DynamoDB table
  const ddb = new DynamoDB();
  const result = await ddb.scan({TableName: "test"});
  console.log("DynamoDB result", result);

  // send a message to the SQS queue
  const sqs = new SQS();
  const message = "Hello from LocalStack!";
  const params = {QueueUrl: "http://localhost:4566/000000000000/test", MessageBody: message};
  const result2 = await sqs.sendMessage(params);
  console.log("SQS result", result2);

  return {result: message};
}
