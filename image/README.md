# Linux RDMA Hang: Build the disk images

Most of the variables were configured in Step 1. Those variables are used by the
[Packer][1] script in `image/build.pkr.hcl`, which passes it through to the
playbook in `image/ansible/playbook.yml` run as part of the installation.

However, the following additional variables must be specified:

- `vm_rdma_type`: RDMA type to use; must be `rxe` or `siw`.
- `vm_kernel_deb`: the directory with the built kernel packages, created in Step
  3
- `vm_qcow`: the directory to put the built images in

*Action Items:*

- Build the required images. For example

  ```sh
  packer build \
    --var-file variables.json --var-file password.json \
    --var "vm_rdma_type=rxe" \
    --var "vm_kernel_deb=results/rxe/bad/deb/" \
    --var "vm_qcow=results/rxe/bad/qcow/" \
    image/build.pkr.hcl
  ```

[1]: https://developer.hashicorp.com/packer "Packer | HashiCorp Developer"
