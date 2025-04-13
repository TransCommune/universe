_default:
    just -l

deploy-ci:
    fly -t ci set-pipeline --team=tc -p universe -c .concourse-ci/pipeline.yaml
