#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

set -e

cat > /tmp/params.yaml << HERE
param_list:
  - id: ...
    input: s3://hca-op-spatial/datasets/gt_annotated_data/Xenium_Prime_Cervical_Cancer_FFPE_Aligned.zarr
    dataset_name: ...
    dataset_url: ...
    dataset_summary: ...
    dataset_description: ...
    dataset_organism: ...

publish_dir: temp
output_dataset: '\$id/dataset.zarr'
output_state: '\$id/state.yaml'
HERE

# convert to zarr
nextflow run . \
  -main-script target/nextflow/datasets/loaders/tenx_xenium_groundtruth/main.nf \
  -profile docker \
  -resume \
  -params-file /tmp/params.yaml

# sync to s3
# aws s3 sync --profile op \
#   "resources_test/datasets/2023_10x_mouse_brain_xenium_rep1" \
#   "s3://openproblems-data/resources_test/common/2023_10x_mouse_brain_xenium_rep1" \
#   --delete --dryrun
