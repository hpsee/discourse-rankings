# Discouse Rankings

If you have a discourse board and are looking to have some fun initiative to
give points to users or groups based on contributions, this could be a good starting point!
What does this mean?

 - we organize users based on their groups. A user beloning to more than one group will give points to each of his groups.
 - we calculate contributions (for each user, and across groups) for the last month
 - a contribution is a topic post, a reply to an existing one
 - we generate a sorted list of contributions for users and groups
 - data is saved to file (yaml)

That's it! If you want to customize this functionality, feel free to edit the script.

## Setup

### Environment

Whether you are running locally or via a container, you need 
to export your `DISCOURSE_API_TOKEN` and `DISCOURSE_API_USER`
to the environment. The token is expected to be for an admin (with a rate
limit of 60/min) so if you are a user with a lower ratelimit, you'll
need to also export a key (to be anything) for `DISCOURSE_USER_FLAG`.

```bash
export DISCOURSE_API_TOKEN=xxxx
export DISCOURSE_API_USER=myusername
```

### Data Folder

We'll also want to create a folder to save data to, bound to the host.

```bash
$ mkdir -p data
```

## Local Usage

First, install required gems:

```bash
$ bundle install
```

And run the script!

```bash
$ ruby user-counts.rb
```

The output folder will have a set of data files, each with a sorted list of users
or groups, with contributions from the last month.

```bash

```

## Docker

### Build Container

First, build the container with dependencies installed. You can run the same
steps (see [Dockerfile](Dockerfile)) on your host if you prefer.

```bash
$ docker build -t vanessa/discourse-ranking .
```

## Run Container

Next, run the container! Notice how we provide the environment variables, and bind "data" 
as a volume:

```bash
$ docker run -it -e DISCOURSE_API_KEY=${DISCOURSE_API_KEY} -e DISCOURSE_API_USER=${DISCOURSE_API_USER} -v $PWD/data:/code/data vanessa/discourse-ranking


Looking up members by group
Calculating contribution totals for last month...

GROUP: admins
  aculich
  christophernhill
  discourse
  eibrown
...
```

Akin to the local usage, the same data files are written, given that you mounted
the data folder.
