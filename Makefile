FUNC_NAME ?= func1

usage:                 ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/:.*##\s*/##/g' | awk -F'##' '{ printf "%-20s %s\n", $$1, $$2 }'

deploy:        ## Deploy the sample app
	if [ "$$LUMIGO_TRACER_TOKEN" = "" ]; then \
	  echo "Please configure the LUMIGO_TRACER_TOKEN environment variable"; \
	  exit 1; \
	fi

	cp lambdas/handler.* /tmp/
	(cd /tmp; zip testlambda.zip handler.py handler.js)

	tflocal init
	rm -f terraform.tfstate
	TF_VAR_LUMIGO_TRACER_TOKEN=$$LUMIGO_TRACER_TOKEN tflocal apply -auto-approve

invoke:        ## Invoke test Lambda function
	awslocal lambda invoke --function-name $(FUNC_NAME) /tmp/tmp.out

hot-reload:    ## Start Lambda hot reloading session
	awslocal lambda update-function-code --function-name $(FUNC_NAME) --s3-bucket hot-reload --s3-key "$$(pwd)/lambdas"

.PHONY: deploy hot-reload
