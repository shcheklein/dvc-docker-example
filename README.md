## DVC + Docker example

A few different ways to run DVC with Docker.

- `inside` - the whole DVC pipeline runs inside a container.
- `outside` - that we run `docker run` as one or more stages of a DVC
  pipeline while `dvc repro` or `dvc exp run` running outside a container.

> Don't consider this as comprehensive tutorial. It's provided as an example of
different combinations. There are other ways to manage different aspects of this
scenario, reach out to us or read the docs to get the right combination of
commands or the right way to package things into an image.

### `inside/mount`

Mounts a current directory (workspace) as volume to an running image. The
workflow to run it. Suits well if you need to run it locally since it takes the
changes in the workspace, local Git config. Also, it avoid clones, duplicating
data and results to pass them between the container and a host.

1. do any changes to the wokspace, code, data, etc
2. run any DVC commands if needed - `dvc pull`, etc to get data
3. run DVC pipeline with:

```cli
docker run -it \
           -v $(pwd)/../..:/app/workdir \
           -v ~/.gitconfig:/etc/gitconfig \
           dvc-docker-mount
```

> On Mac metal add `--platform linux/amd64` since DVC deb package is not
available at time of writing this.

### `inside/clone`

Suits well for the scenario when we need to run an experiment, or make an ELT
remotely - on demand or on schedule. We do a fresh `git clone`, pull data, run
the pipelein (can be `dvc repro` ro `dvc exp run`) and push results back-
either to be consumed within [Studio](https://studio.iterative.ai/) (it renders
`dvc exp push`-ed experiments), or by `git clone`, `dvc pull`, `dvc exp pull`
commands on any other machine.

To run it:

```cli
docker run -e STUDIO_GIT_TOKEN='*********' \
           -e AWS_ACCESS_KEY_ID='*******' \
           -e AWS_SECRET_ACCESS_KEY='***********' \
           -it dvc-docker-clone
```

Where:

- `STUDIO_GIT_TOKEN` - a secure way to give access to a specific repo for a
  certain period of time. Read more
  [here](https://github.blog/2022-10-18-introducing-fine-grained-personal-access-tokens-for-github/).
  Other platforms might not provide this. In this case you can use SSH key
  and/or create a seprate account with a restricted access to make it secure.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` - an example on how to pass
  AWS credentials to pull / push data if needed. Again, it depends on the
  environment if you need this or not. On an EC2 instance we would recommend to
  setup an IAM role and avoid managing credentials manually.

> On Mac metal add `--platform linux/amd64` since DVC deb package is not
available at time of writing this.

### `outside`

Run with `dvc repro` or `dvc exp run`. It shows a way to package a Dockerized
commands into a DVC pipeline. An additional benefit is that DVC handles the
Docker image update as well.

### Considerations

1. Storage and Git credentials. Since we need to run the pipeline or certain
   commands we need to pass Git credentials and/or storage credentials + Git
   config. See some comments in the ``inside/clone` section that gives a bit
   more color to this.
2. Install DVC. We use the `deb` package and Ubuntu base image in these
   examples. A clear optimization is to create your own image that already
   includes all the basic steps and can be reused in the projects' repos to
   simplify their Dockerfiles.
3. [Iterative Studio](https://studio.iterative.ai/) - gives an excellent way to
   see the results, trigger runs, register and see all the models, and more.

