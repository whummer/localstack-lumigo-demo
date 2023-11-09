const { DynamoDB } = require('@aws-sdk/client-dynamodb');
const { SQS } = require('@aws-sdk/client-sqs');

exports.handler = async (event) => {
  console.log(JSON.stringify(event));

  const ddb = new DynamoDB();
  const result = await ddb.scan({TableName: "test"});
  console.log("DynamoDB result", result);

  const sqs = new SQS();
  const params = {QueueUrl: "http://localhost:4566/000000000000/test", MessageBody: "test 123"};
  const result2 = await sqs.sendMessage(params);
  console.log("SQS result", result2);

  return "Hello from LocalStack!";
}
