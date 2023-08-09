# LocalStack Lumigo Demo

Simple demo app showcasing the integration between [LocalStack](https://localstack.cloud) and [Lumigo](https://lumigo.io/).

## Prerequisites

* LocalStack Pro
* Lumigo account and tracer token
* `awslocal` command-line client

## Running

Simply use the `run.sh` script, which will create the Lambda function on LocalStack:
```
$ export LUMIGO_TRACER_TOKEN='<your_tracer_token>'
$ ./run.sh
...
```

You can then trigger a couple of subsequent Lambda invocations, which will then show up in the "Live Tail" view in the Lumigo dashboard.
```
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
...
```

## License

The code in this repository is available under the Apache 2.0 license.
