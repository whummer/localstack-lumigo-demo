# LocalStack Lumigo Demo

Simple demo app showcasing the integration between [LocalStack](https://localstack.cloud) and [Lumigo](https://lumigo.io/).

## Prerequisites

* LocalStack Pro
* Lumigo account and tracer token
* `awslocal` command-line client
* `tflocal` and `terraform` command-line clients

## Running

Simply use the targets in the `Makefile`, which will create the Lambda function and other resources in LocalStack:
```
$ export LUMIGO_TRACER_TOKEN='<your_tracer_token>'
$ make deploy
...
```

You can then trigger a couple of subsequent Lambda invocations, which will then show up in the "Live Tail" view in the Lumigo dashboard.
```
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
$ awslocal lambda invoke --function-name func1 /tmp/tmp.out
...
```

As a next step, you can enable hot reloading for the Lambda function - any changes in the handler will be automatically reflected immediately upon next invocation.
```
$ make hot-reload
...
```

## License

The code in this repository is available under the Apache 2.0 license.
